//
//  Snake.m
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "Snake.h"
#import "SnakePiece.h"
#import "CGPointToolkit.h"
#import "SnakePiece+Direction.h"


@interface Snake()

@property (nonatomic, readwrite, strong) UIView *superView;

@end

@implementation Snake

- (instancetype)init
{
    self = [super init];
    if( self ){
        _snakePieces = [NSArray array];
    }
    return self;
}

+ (Snake *)creatSnakeOnView:(UIView *)superView moveRect:(CGRect)moveRect
{
    Snake *snake = [[Snake alloc] init];
    
//    int x = moveRectWidth / 2;
//    int y= moveRectWidth / 2;
//    if( x % 20 != 0 ){
//        x + 10;
//    }
    
    CGPoint centerPoint = CGPointMake(moveRect.size.width/2+moveRect.origin.x, moveRect.size.height/2+moveRect.origin.y);
    SnakePiece *snakeHead = [SnakePiece snakeInView:superView pieceType:SnakeHead frontDirection:SnakeDefault backDirect:SnakeDown center:centerPoint];
    
    SnakePiece *snakeBody = [SnakePiece snakeInView:superView pieceType:SnakeBody frontDirection:SnakeUp backDirect:SnakeDown center:CGPointMake(centerPoint.x, centerPoint.y+snakeSize)];
    SnakePiece *snakeTail = [SnakePiece snakeInView:superView pieceType:SnakeTail frontDirection:SnakeUp backDirect:SnakeDefault center:CGPointMake(centerPoint.x, centerPoint.y+snakeSize*2)];
    
    snake.snakePieces = @[snakeHead,snakeBody,snakeTail];
    snake.superView = superView;
    [snake updateSnake];
    return snake;
}

- (Snake *)makeVirtualSnake
{
    Snake *snake = [[Snake alloc] init];
//    snake.snakePieces = [self.snakePieces mutableCopy];
    NSMutableArray *array = [NSMutableArray array];
    snake.foodCenter = self.foodCenter;
    snake.canPutFood = [self.canPutFood mutableCopy];
    for ( SnakePiece *piece in self.snakePieces ){
//        [piece.snakeImage removeFromSuperview];
        SnakePiece *temp = [[SnakePiece alloc] init];
        temp.center = piece.center;
        temp.backDirection = piece.backDirection;
        temp.frontDirection = piece.frontDirection;
        temp.snakePieceType = piece.snakePieceType;
        [array addObject:temp];
    }
    snake.snakePieces = [NSArray arrayWithArray:array];
    [snake updateSnake];
    return snake;
}
-(void)updateSnake
{
    memset(snakeVist, NO, sizeof(snakeVist));
    for ( SnakePiece *snakePiece in _snakePieces ){
        int point = [CGPointToolkit snakePointHash:snakePiece.center];// rect:_moveRect];
        if ( point < arrayLength){
            snakeVist[point] = YES;
        }
    }
}

- (BOOL)hasSnakePieceInPoint:(CGPoint)point snakeGo:(BOOL)snakeGo
{
    int pointInt = [CGPointToolkit snakePointHash:point];// rect:_moveRect];
    CGPoint tailPoint = ((SnakePiece *)[_snakePieces lastObject]).center;
    if ( tailPoint.x == point.x && tailPoint.y == point.y && snakeGo){
        return NO;
    }
    if ( pointInt < arrayLength ){
        return snakeVist[pointInt];
    }
    return NO;
}

- (void)addSnakePieceWithDirection:(SnakeDirection)direction
{
    CGPoint nextCenter = [((SnakePiece *)_snakePieces[0]) nextCenterWithDirection:direction];
    SnakePiece *snakeHeadPiece = [SnakePiece snakeInView:_superView pieceType:SnakeHead frontDirection:direction backDirect:(direction+2)%4 center:nextCenter]; //moveRect:_moveRect];
    SnakePiece *snakePiece = _snakePieces[0];
    snakePiece.frontDirection = direction;
    
    snakePiece.snakePieceType = SnakeBody;
    [snakePiece update];
    NSMutableArray *arrary = [NSMutableArray arrayWithObject:snakeHeadPiece];
    [arrary addObjectsFromArray:_snakePieces];
    _snakePieces = [NSArray arrayWithArray:arrary];
    [self updateSnake];
}

@end
