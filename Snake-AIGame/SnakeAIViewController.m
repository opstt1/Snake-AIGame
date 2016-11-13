//
//  SnakeAIViewController.m
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "SnakeAIViewController.h"
#import "Snake.h"
#import "Snake+randomAction.h"
#import "Snake+Action.h"
#import "CGPointToolkit.h"
#import "SnakePiece+Direction.h"

static int const INF = 99999999;

@interface SnakeAIViewController ()
{
    int distance[arrayLength];
}

@property (nonatomic, readwrite, strong) NSTimer *timer;
@property (nonatomic, readwrite, assign) BOOL hasGo;
@property (nonatomic, readwrite, strong) Snake *snake;
@property (nonatomic, readwrite, strong) Food *food;
@property (nonatomic, readwrite, assign) NSInteger goCount;

@end

@implementation SnakeAIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, moveRectWidth, moveRectWidth)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    int origin = 0;
    if (( moveRectWidth / 2 ) % 20 == 0){
        origin = 10;
    }
    _snake = [Snake creatSnakeOnView:view moveRect:CGRectMake(origin, origin, moveRectWidth, moveRectWidth)];
    _food = [Food creatFoodOnView:view moveRect:CGRectMake(origin, origin,moveRectWidth, moveRectWidth)];
    [_food putFoodWithSnake:_snake];
    _snake.foodCenter = _food.center;
    _hasGo = NO;
    _goCount = 0;
    [self snakeStartGo];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ( _timer ){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)snakeStartGo
{
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0/20.0 target:self selector:@selector(letGo:) userInfo:nil repeats:YES];
}

#pragma mark - letGo

- (void)letGo:(NSTimer *)timer
{
    if ( _hasGo ){
        return;
    }
    _hasGo = YES;
    
    NSInteger totalSnakePiece = (moveRectWidth / snakeSize ) * (moveRectWidth / snakeSize ) - 1;
    SnakeDirection direction = SnakeDefault;
    BOOL canGo = NO;
    
    if ( _snake.snakePieces.count >= totalSnakePiece ){
        [_timer invalidate];
        _timer = nil;
    }
    if( _goCount < totalSnakePiece )  {
        if ( _snake.snakePieces.count >= totalSnakePiece / 10 * 6 ){
            Snake *vSnake = [self.snake makeVirtualSnake];
            if ( [self canGoToTail:vSnake] ){
                _goCount++;
                direction = [self tryGoMaxDistance:_snake];
                canGo = YES;
            }
            if ( !canGo ){
                direction = [_snake randomGpDirection];
                canGo = YES;
            }
            
        }
    }
    
    if ( [self BFSWithSnake:_snake food:_food] && !canGo ){
        Snake *vSnake = [self.snake makeVirtualSnake];
        [self virtualSnakeGoToFood:vSnake];
        if ( [self canGoToTail:vSnake] ){
            [self BFSWithSnake:_snake food:_food];
            direction = [self tryGoMinDistance:_snake];
            canGo = YES;
        }
    }
    
    if ( !canGo ){
        Snake *vSnake = [self.snake makeVirtualSnake];
        if ( [self canGoToTail:vSnake] ){
            direction = [self tryGoMaxDistance:_snake];
            canGo = YES;
        }
    }
    
    if ( !canGo ){
        direction = [_snake randomGpDirection];
    }
    if ( direction == SnakeDefault ){
        return;
    }
    if ( [self eatFoodWithFood:_food snake:_snake direction:direction] ){
        _goCount = 0;
        [_snake addSnakePieceWithDirection:direction];
        [_food putFoodWithSnake:_snake];
    }else{
        [_snake goWithDirection:direction];
    }
    
    _hasGo = NO;
}

- (BOOL)BFSWithSnake:(Snake *)snake food:(Food *)food
{
    BOOL findFood = NO;
    int vist[arrayLength];
    memset(vist, 0, sizeof(vist));
    memset(distance, -1, sizeof(distance));
    NSMutableArray *queue = [NSMutableArray array];
    
    CGPoint headPoint = ((SnakePiece *)snake.snakePieces[0]).center;
    int headX = (int)headPoint.x;
    int headY = (int)headPoint.y;
    
    for ( SnakePiece *piece in snake.snakePieces ){
        int pieceInt = [CGPointToolkit snakePointHash:piece.center];
        vist[pieceInt] = 2;
        distance[pieceInt] = INF;
    }
    
    int foodInt = [CGPointToolkit snakePointHash:food.center];
    vist[foodInt] = 0;
    distance[foodInt] = 0;
    [queue addObject:@(foodInt)];
    
    while (queue.count > 0 ) {
        int index = (int)[queue[0] integerValue];
        CGPoint currectPoint = [CGPointToolkit pointWithSankeHash:index];
        [queue removeObjectAtIndex:0];
        if ( vist[index] == 1 || vist[index] == 2 ){
            continue;
        }
        vist[index] = 1;
        
        for ( int i = 0; i < 4; ++i ){
            SnakeDirection direction = (SnakeUp + i ) % 4;
            CGPoint point = [CGPointToolkit pnextPointWithDirection:direction currentPoint:currectPoint];
            int pointInt = [CGPointToolkit snakePointHash:point];
            int dx = (int)point.x;
            int dy = (int)point.y;
            if ( dx == headX && dy == headY ){
                findFood = YES;
            }
            if ( dx > 0 && dy <= moveRectWidth && dy > 0 && dx <= moveRectWidth && [snake snakeCanGoWithDirection:direction point:currectPoint] && vist[pointInt] != 2 ){
                if ( distance[pointInt] == -1 || distance[pointInt] > distance[index] + 1 ){
                    distance[pointInt] = distance[index] + 1;
                }
                if ( vist[pointInt] == 0 ){
                    [queue addObject:@(pointInt)];
                }
                
            }
        }
    }
    return findFood;
}

- (void)virtualSnakeGoToFood:(Snake *)snake
{
    BOOL findFood = NO;
    while (!findFood) {
        [self BFSWithSnake:snake food:_food];
        SnakeDirection direction = [self tryGoMinDistance:snake];
        
        SnakePiece *head = snake.snakePieces[0];
        CGPoint nextPoint = [head nextCenterWithDirection:direction];
        if ( nextPoint.x == _food.center.x && nextPoint.y == _food.center.y ){
            [snake addSnakePieceWithDirection:direction];
            findFood = YES;
        }else{
            [snake goWithDirection:direction];
        }
        
    }
}
- (SnakeDirection)tryGoMinDistance:(Snake *)snake
{
    int min = INF -2;
    CGPoint headPoint = ((SnakePiece *)snake.snakePieces[0]).center;
    int direction = 4;
    for  ( int i = 0; i < 4; ++i ){
        if ( [snake snakeCanGoWithDirection:i point:headPoint] ){
            CGPoint point = [CGPointToolkit pnextPointWithDirection:i currentPoint:headPoint];
            int nextPointInt = [CGPointToolkit snakePointHash:point];
            
            if ( min >  distance[nextPointInt] && distance[nextPointInt] != -1 ){
                direction = i;
                min = distance[nextPointInt];
                
            }
        }
    }
    if ( min != INF - 2 ){
        return direction;
    }
    return SnakeDefault;
}

- (SnakeDirection)tryGoMaxDistance:(Snake *)snake
{
    int max = -100;
    CGPoint headPoint = ((SnakePiece *)snake.snakePieces[0]).center;
    int direction = 4;
    for  ( int i = 0; i < 4; ++i ){
        if ( [snake snakeCanGoWithDirection:i point:headPoint] ){
            CGPoint point = [CGPointToolkit pnextPointWithDirection:i currentPoint:headPoint];
            int nextPointInt = [CGPointToolkit snakePointHash:point];
            
            if ( max <  distance[nextPointInt] && distance[nextPointInt] != -1 && distance[nextPointInt] != INF ){
                direction = i;
                max = distance[nextPointInt];
                
            }
        }
    }
    if ( max != -100 ){
        
        return direction;
    }
    return SnakeDefault;
}

- (BOOL)canGoToTail:(Snake *)snake
{
    SnakePiece *head = [snake.snakePieces lastObject];
    NSMutableArray *array = [NSMutableArray arrayWithArray:snake.snakePieces];
    [array removeLastObject];
    snake.snakePieces = [NSArray arrayWithArray:array];
    [snake updateSnake];
    Food *food = [[Food alloc] init];
    food.center = head.center;
    if ( [self BFSWithSnake:snake food:food] ){
        return YES;
    }
    return NO;
}

- (BOOL)eatFoodWithFood:(Food *)food snake:(Snake *)snake direction:(SnakeDirection)direction
{
    SnakePiece *head = [snake.snakePieces firstObject];
    
    CGPoint point = [head nextPointWithDirection:direction currentPoint:head.center];
    if ( point.x == food.center.x && point.y == food.center.y ){
        return YES;
    }
    return NO;
}
@end
