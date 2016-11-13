//
//  FinalSnakeViewController.m
//  SnakeAI
//
//  Created by papaya on 16/5/9.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "FinalSnakeViewController.h"

#include <stdio.h>

//棋盘的边长
#define WIDTH 240

//蛇身体块边长长
#define SNAKE_PIECE 20

//方向
#define UP -(240*20)
#define DOWN (240*20)
#define LEFT -20
#define RIGHT  20
#define NODIRECTION  100000
#define INF (300*300*300+11)
#define SNAKE_BODY 300 * 300 + 3
#define SNAKE_HEAD 300 * 300 + 1
#define SNAKE_TAIL 300 * 300 + 2



@interface FinalSnakeViewController ()
{
    int fourDirection[5];
    int distance[WIDTH*WIDTH+11];
    int tempDistance[WIDTH*WIDTH+11];
    int vist[WIDTH*WIDTH+1];
    int count;
    int perx;
    int pery;
    BOOL hasGo;
    int goCount;
}

@property (nonatomic) NSMutableArray *snake;
@property (nonatomic) NSMutableArray *tempSnake;
@property (nonatomic) NSMutableArray *board;
@property (nonatomic) NSMutableArray *tempBoard;
@property (nonatomic) NSInteger food;
@property (nonatomic) NSMutableArray *queue;
@property (nonatomic) BOOL isSuspend;
@property (nonatomic) UIButton *suspendButton;
@property (nonatomic) UILabel *usetimeLabel;

@property (nonatomic) UIView *mapView;

@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;
@end

@implementation FinalSnakeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __block int val = 10;
    void (^blk)(void) = ^{printf("val=%d\n",val);};
    val = 2;
    blk();
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, WIDTH, WIDTH)];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2-30, WIDTH+120, 100, 20)];
    [button setBackgroundColor:[UIColor redColor]];
    [button setTitle:@"重新开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(reStart) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/2-30, WIDTH+120+25, 100, 20)];
    [button1 setBackgroundColor:[UIColor redColor]];
    [button1 setTitle:@"暂停" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(suspend) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-30, WIDTH+120+25+25, 200, 20)];
    label.text = @"";
    _usetimeLabel = label;
    _suspendButton = button1;
    [self.view addSubview:label];
    [self.view addSubview:button];
    [self.view addSubview:button1];
    
    [view setBackgroundColor:[UIColor greenColor]];
    _mapView =view;
    [self.view addSubview:view];
    
    [self start];
}

- (void)start
{
    _snake = [NSMutableArray array];
    _board = [NSMutableArray array];
    _tempBoard = [NSMutableArray array];
    _tempSnake = [NSMutableArray array];
    fourDirection[0] = UP;
    fourDirection[1] = DOWN;
    fourDirection[2] = LEFT;
    fourDirection[3] = RIGHT;
    hasGo = YES;
    count = 3;
    goCount = 0;
    _isSuspend = NO;
    goCount = 0;
    [_snake addObject:[NSNumber numberWithInteger:0]];
    [_snake addObject:[NSNumber numberWithInteger:20]];
    [self initBoard:_board snake:_snake];
    [self randomFood];
    [self drawSnake];
    [self snakeStarGo];
}

- (void)snakeStarGo
{
    _startDate = [NSDate date];
    [NSTimer scheduledTimerWithTimeInterval:1.0/20.0 target:self selector:@selector(letGo:) userInfo:nil repeats:YES];
}

// 0:上  1:下 2:左 3:右
- (void)letGo:(NSTimer *)timer
{
    
    if ( count == 3 && hasGo == YES && _isSuspend == NO ){
        hasGo = NO;
        
        
        //－－－－－－－－－－－－－－完美的决策－－－－－－－－－－－－－－－－－－－－－－－－／／
        if ( [_snake count] >= (WIDTH / SNAKE_PIECE) * (WIDTH / SNAKE_PIECE) -1  ){
            _endDate = [NSDate date];
            [timer invalidate];
//            NSLog(@"Date %@  %@ %lf",_startDate,_endDate);
            [self calculateUseTime];
            timer = nil;
        }
        if ( goCount < (WIDTH / SNAKE_PIECE) * (WIDTH / SNAKE_PIECE) + 1 ){
            if ( [_snake count] >= ((WIDTH / SNAKE_PIECE) * (WIDTH / SNAKE_PIECE) -1 ) / 10 * 6 ){
                _tempSnake = [_snake mutableCopy];
                if ( [self canGotoTail:_tempSnake] ){
                    goCount ++;
                    [self TryGoOnMaxPiece:_snake isTruth:YES];
                    [self drawSnake];
                    hasGo = YES;
                    count = 3;
                }
                if ( !hasGo ){
                    count=3;
                    if( [self radmoGo:_snake] ){
                        [self drawSnake];
                        hasGo = YES;
                        count = 3;
                    }
                }
                return;
            }
        }
        //－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－／／
        
        count = 0;
        if ( [self BFS:_board snake:_snake food:_food] ){
            
            //派出虚拟蛇！！走到食物上之后，看头和尾之间是否还有路程
            _tempSnake = [_snake mutableCopy];
            [self virtualGotoFood:_tempSnake];
            
            if ( [self canTryGoto:_tempSnake] ){
                
                //如果走了下一步之后，头尾有路，则gogogo
                //memcpy(tempDistance, distance, sizeof(distance));
                [self BFS:_board snake:_snake food:_food];
                [self TryGoOnMinPiece:_snake isTruth:YES];
                [self drawSnake];
                hasGo = YES;
                goCount = 0;
                count = 3;
            }else{
                count++;
            }
        }
        
        if ( !hasGo ){
            _tempSnake = [_snake mutableCopy];
            if ( [self canGotoTail:_tempSnake] ){
                [self TryGoOnMaxPiece:_snake isTruth:YES];
                [self drawSnake];
                hasGo = YES;
                count = 3;
            }else{
                count++;
            }
            
        }
        if ( !hasGo ){
            count=3;
            if( [self radmoGo:_snake] ){
                [self drawSnake];
                hasGo = YES;
                count = 3;
            }else{
                count ++;
                _endDate = [NSDate date];
                [timer invalidate];
//                NSLog(@"Date %@  %@",_startDate,_endDate);
                [self calculateUseTime];
                timer = nil;
            }
        }
        
    }
}

- (void)virtualGotoFood:(NSMutableArray *)snake
{
    BOOL findFood = NO;
    while (!findFood) {
        [self BFS:_board snake:snake food:_food];
        [self TryGoOnMinPiece:snake isTruth:NO];
        if ( [[snake lastObject] integerValue] == _food ){
            findFood = YES;
        }
    }
}

//随机走一步
- (BOOL)radmoGo:(NSMutableArray *)snake
{
    int head = (int)[[snake lastObject] integerValue];
    for ( int i = 0; i < 4; ++i ){
        int dir = head + fourDirection[i];
        if ( dir >= 0 && dir < WIDTH * WIDTH && [self canTryGo:head direction:fourDirection[i]] && ![self isSnakeBody:dir snake:snake] ){
            _tempSnake = [snake mutableCopy];
            [self goOneStep:dir snake:_tempSnake isTruth:NO];
            if ( [self BFS:_board snake:_tempSnake food:_food] ){
                [self goOneStep:dir snake:_snake isTruth:YES];
                return YES;
            }
        }
    }
    
    for ( int i = 0; i < 4; ++i ){
        int dir = head + fourDirection[i];
        if ( dir >= 0 && dir < WIDTH * WIDTH && [self canTryGo:head direction:fourDirection[i]] && ![self isSnakeBody:dir snake:snake] ){
            [self goOneStep:dir snake:_snake isTruth:YES];
            return YES;
        }
    }
    return NO;
}

- (BOOL)isSnakeBody:(NSInteger)index snake:(NSMutableArray *)snake
{
    for  ( int i = 0; i < [snake count]; ++i ){
        if ( (int)[[snake objectAtIndex:i] integerValue] == index ){
            return YES;
        }
    }
    return NO;
}

//
- (BOOL)canTryGoto:(NSMutableArray *)snake
{
    //    if ( [self TryGoOnMinPiece:snake isTruth:NO] ){
    //        return [self canGotoTail:snake];
    //    }else{
    //        return NO;
    //    }
    return [self canGotoTail:snake];
}

- (BOOL)canGotoTail:(NSMutableArray *)snake
{
    NSInteger food = [[snake firstObject] integerValue];
    //    [snake replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:_food]];
    if( [self BFS:_board snake:snake food:food]){
        return YES;
    }else{
        return NO;
    }
    
}

//寻找最短的路走～～～
- (BOOL)TryGoOnMinPiece:(NSMutableArray *)snake isTruth:(BOOL)isTruth
{
    int min = INF -2 ;
    int head = (int)[[snake lastObject] integerValue];
    int direction = 0;
    for ( int i = 0; i < 4; ++i ){
        int nextPoint = head + fourDirection[i];
        if ( nextPoint >= 0 && nextPoint < WIDTH * WIDTH && [self canTryGo:head direction:fourDirection[i]]){
            
            if ( min > tempDistance[nextPoint] && tempDistance[nextPoint] != -1  ){
                direction = nextPoint;
                min = tempDistance[nextPoint];
            }
        }
    }
    if ( min != INF - 2 ){
        [self goOneStep:direction snake:snake isTruth:isTruth];
        return YES;
    }
    return NO;
}

//寻找最长的路走～～～
- (BOOL)TryGoOnMaxPiece:(NSMutableArray *)snake isTruth:(BOOL)isTruth
{
    int max = -100 ;
    int head = (int)[[snake lastObject] integerValue];
    int direction = 0;
    for ( int i = 0; i < 4; ++i ){
        int nextPoint = head + fourDirection[i];
        if ( nextPoint >= 0 && nextPoint < WIDTH * WIDTH && [self canTryGo:head direction:fourDirection[i]]){
            
            if ( max < tempDistance[nextPoint] && tempDistance[nextPoint] != -1 && tempDistance[nextPoint] != INF ){
                direction = nextPoint;
                max = tempDistance[nextPoint];
            }
        }
    }
    if ( max != -100 ){
        [self goOneStep:direction snake:snake isTruth:isTruth];
        return YES;
    }
    return NO;
}

//查看下一步是否越界
- (BOOL)canTryGo:(int)point direction:(int)direction
{
    BOOL canGo = YES;
    // NSLog(@"ppp:   %d  %d",point % WIDTH, point / WIDTH);
    switch (direction) {
            
        case UP:
            if ( point / WIDTH == 0 ) canGo = NO;  //不能再往上走
            break;
        case DOWN:
            if ( point / WIDTH >= WIDTH - SNAKE_PIECE ) canGo = NO; //不能再往下走
            break;
        case LEFT:
            if ( point % WIDTH == 0 ) canGo = NO; //不能再往左走啦
            break;
        default:
            if (point % WIDTH >= WIDTH - SNAKE_PIECE) canGo = NO;
            break;
    }
    return canGo;
}

//BFS找到蛇吃到食物的最短距离
- (BOOL)BFS:(NSMutableArray *)board snake:(NSMutableArray *)snake food:(NSInteger)food
{
    memset(tempDistance, -1, sizeof(tempDistance));
    _queue = [NSMutableArray array];
    BOOL findFood = NO;
    int head = (int)[[snake lastObject] integerValue];
    int headX = head % WIDTH;
    int headY = head / WIDTH;
    memset(vist, 0, sizeof(vist));
    for ( int i = 0; i < [snake count]; ++i ){
        int snakeBody = (int)[snake[i] integerValue];
        vist[snakeBody] = 2;
        tempDistance[snakeBody] = INF;
    }
    
    vist[food] = 0;
    tempDistance[food] = 0;
    [_queue addObject:[NSNumber numberWithInteger:food]];
    
    while ([_queue count] > 0 ) {
        int index = (int)[[_queue firstObject] integerValue];
        [_queue removeObjectAtIndex:0];
        if( vist[index] == 1 || vist[index] == 2 ) continue;
        vist[index] = 1;
        
        for ( int i = 0; i < 4; ++i ){
            int point  = fourDirection[i] + index;
            int dX = point % WIDTH;
            int dY = point / WIDTH;
            if ( headX == dX && headY == dY ){
                findFood = YES;
            }
            if ( dX >= 0 && dX < WIDTH && dY >= 0 && dY < WIDTH && vist[point] != 2 && [self canTryGo:index direction:fourDirection[i]] ){
                if ( tempDistance[point] == -1 || tempDistance[point] > tempDistance[index] + 1  ){
                    tempDistance[point] = tempDistance[index]+1;
                    //NSLog(@"----  %d %d %d",tempDistance[point], point % WIDTH, point / WIDTH);
                }
                if ( vist[point] == 0 ){
                    // vist[point] = 1;
                    [_queue addObject:[NSNumber numberWithInteger:point]];
                }
            }
        }
    }
    //    for (int i = 0; i < WIDTH; i += SNAKE_PIECE ) {
    //        printf("\n");
    //        for ( int j = 0; j < WIDTH; j += SNAKE_PIECE ){
    //            printf("%d ",tempDistance[i+j*WIDTH]);
    //        }
    //    }
    //    printf("\n-------------------------\n");
    return findFood;
}















//网格的布局，非蛇的地方为0，有蛇的地方为SNAKE_BODY
- (void)initBoard:(NSMutableArray *)board snake:(NSMutableArray *)snak
{
    [board removeAllObjects];
    for ( int i = 0; i < WIDTH; i += SNAKE_PIECE ){
        for ( int j = 0; j < WIDTH; j += SNAKE_PIECE ){
            [board addObject:[NSNumber numberWithInteger:j*WIDTH+i]];
        }
    }
    for ( int i = 0; i < [snak count]; ++i ){
        NSInteger index = [snak[i] integerValue];
        [board replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger:SNAKE_BODY]];
    }
}


//蛇走一步
- (void)goOneStep:(int)direction snake:(NSMutableArray *)snake isTruth:(BOOL)isTruth
{
    [snake addObject:[NSNumber numberWithInteger:direction]];
    if ( isTruth ){
        BOOL ii = NO;
        int x = direction % WIDTH;
        int y = direction / WIDTH;
        if ( (perx == x && abs(pery - y) == 20 ) || (pery == y && abs(perx-x) == 20 )){
            ii = YES;
        }
        //        printf("------ %d  %d            %d\n",x,y,ii?1:0);
        perx = x;
        pery = y;
    }
    if ( direction != _food ){
        [snake removeObjectAtIndex:0];
    }else if( isTruth ){
        [self randomFood];
    }
}

- (void)drawSnake
{
    int perDirection = NODIRECTION;
    [_mapView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for ( int i = 0; i < [_snake count]; ++i ){
        NSNumber *point = [_snake objectAtIndex:i];
        if ( perDirection != NODIRECTION ){
            switch (perDirection) {
                case UP:
                    perDirection = DOWN;
                    break;
                case DOWN:
                    perDirection = UP;
                    break;
                case LEFT:
                    perDirection = RIGHT;
                    break;
                default:
                    perDirection = LEFT;
                    break;
            }
        }
        int snakDirection = NODIRECTION;
        if( i != [_snake count] - 1 ){
            snakDirection = [self snakPieceDirection:[point integerValue] nextPoint:[[_snake objectAtIndex:i+1] integerValue]];
            // NSLog(@"--- : %d",snakDirection);
        }
        [self drawSnakePiece:[point integerValue] index:i sankePieceDirection:snakDirection perSankePieceDirection:perDirection ];
        perDirection = snakDirection;
        
    }
    
    [self drawFood];
}

//绘画给个蛇的单元格，使得蛇看上去更好看
- (void)drawSnakePiece:(NSInteger)point index:(NSInteger)index sankePieceDirection:(int)snakePieceDirection perSankePieceDirection:(int)perSnakePieceDirection
{
    //printf("%d %d \n",310/300, index);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((int)point%WIDTH, (int)point/WIDTH, SNAKE_PIECE, SNAKE_PIECE)];
    [view setBackgroundColor:[UIColor greenColor]];
    UIView *inView = [[UIView alloc] initWithFrame:CGRectMake(2,2, SNAKE_PIECE-4, SNAKE_PIECE-4)];
    int num = (int)index;
    float alpha = 225.0 - num;
    if ( alpha < 100 ){
        alpha = 100.0 - num / 30;
    }
    [inView setBackgroundColor:[UIColor colorWithRed:alpha/225.0 green:0 blue:0 alpha:1]];
    [view addSubview:inView];
    if ( index != [_snake count] - 1 ){
        for ( int i = 0; i < 4; ++i ){
            int x = 0, y = 0, width = 0, height = 0;
            int dir = fourDirection[i];
            switch (dir) {
                case UP:
                    x = 2; y = 0; width = SNAKE_PIECE-4; height = 2;
                    break;
                case DOWN:
                    x = 2; y = SNAKE_PIECE - 2; width = SNAKE_PIECE-4; height = 2;
                    break;
                case LEFT:
                    x = 0; y = 2; width = 2; height = SNAKE_PIECE-4;
                    break;
                default:
                    x = SNAKE_PIECE - 2; y = 2; width = 2; height = SNAKE_PIECE-4;
                    break;
            }
            
            if( fourDirection[i] == snakePieceDirection || fourDirection[i] == perSnakePieceDirection ){
                UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
                [subView setBackgroundColor:[UIColor colorWithRed:alpha/225.0 green:0 blue:0 alpha:1]];
                [view addSubview:subView];
            }
            
        }
    }
    if ( index == [_snake count] -1 ){
        [view setBackgroundColor:[UIColor blackColor]];
    }
    [_mapView addSubview:view];
}

//从脚到尾巴，下一块在当前快的哪里
- (int)snakPieceDirection:(NSInteger) point nextPoint:(NSInteger)nextPoint
{
    int pointx = (int)point % WIDTH;
    int pointy = (int)point / WIDTH;
    int nextPointx = (int)nextPoint % WIDTH;
    int nextPointy = (int)nextPoint / WIDTH;
    if ( nextPointx > pointx ){
        return RIGHT;
    }
    if ( nextPointx < pointx ){
        return LEFT;
    }
    if ( nextPointy > pointy ){
        return DOWN;
    }
    return UP;
}

//随机食物，从空余地方进行随机，防止后期大量的随机也不一定能找到空余地方
- (void)randomFood
{
    goCount = 0;
    if ( [_snake count] >= (WIDTH / SNAKE_PIECE) * (WIDTH / SNAKE_PIECE)   ){
        return;
    }
    int hash[WIDTH*WIDTH+111];
    memset(hash, 0, sizeof(hash));
    for ( int i = 0; i < [_snake count]; ++i ){
        hash[(int)[_snake[i] integerValue]] = 1;
    }
    NSMutableArray *array = [NSMutableArray array];
    
    for ( int i = 0; i < WIDTH; i += SNAKE_PIECE ){
        for ( int j = 0; j < WIDTH; j += SNAKE_PIECE ){
            if ( hash[i+j*WIDTH] == 0 ){
                [array addObject:[NSNumber numberWithInteger:i+j*WIDTH]];
            }
        }
    }
    BOOL getfood = YES;
    if( _snake.count > (WIDTH / SNAKE_PIECE) * (WIDTH / SNAKE_PIECE) - 10 )
    {
        getfood = NO;
    }else{
        NSInteger randomFood = arc4random() % [array count];
        _food = [array[randomFood] integerValue];
    }
    while ( !getfood) {
        getfood = YES;
        NSInteger randomFood = arc4random() % [array count];
        int food = (int)[array[randomFood] integerValue];
        if ( [array count] == 1 ){
            _food = [array[randomFood] integerValue];
            getfood = YES;break;
        }
        for ( int i = 0; i < 4; ++i ){
            int dir = food + fourDirection[i];
            if ( dir >= 0 && dir < WIDTH * WIDTH  && ![self isSnakeBody:dir snake:_snake] ){
                getfood = NO;
            }
        }
        if ( getfood == NO ){
            [array removeObjectAtIndex:randomFood];
        }else{
            _food = [array[randomFood] integerValue];
            break;
        }
        
    }
}

- (void)drawFood
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_food%WIDTH, _food/WIDTH, SNAKE_PIECE, SNAKE_PIECE)];
    [view setBackgroundColor:[UIColor purpleColor]];
    [view.layer setCornerRadius:SNAKE_PIECE/2];
    [_mapView addSubview:view];
}


#pragma mark - action
- (void)suspend
{
    if ( _isSuspend){
        [_suspendButton setTitle:@"暂停" forState:UIControlStateNormal];
        _isSuspend = NO;
    }else{
        [_suspendButton setTitle:@"开始" forState:UIControlStateNormal];
        _isSuspend = YES;
    }
}

- (void)reStart
{
    [self start];
}


- (void)calculateUseTime
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *startcomponents = [cal components:NSCalendarUnitHour fromDate:_startDate];
    NSInteger startHour = [startcomponents hour];
    NSLog(@"use time : %d",(int)startHour);
    startcomponents = [cal components:NSCalendarUnitMinute fromDate:_startDate];
    NSInteger startMinute = [startcomponents minute];
    
    NSLog(@"startMinute : %d",(int)startMinute);
    startcomponents = [cal components:NSCalendarUnitSecond fromDate:_startDate];
    NSInteger startSecond = [startcomponents second];
    NSLog(@"startSecond : %d",(int)startSecond);
    NSInteger StartTime = ( startHour * 60 + startMinute ) * 60 + startSecond;
    
    NSCalendar *cal1 = [NSCalendar currentCalendar];
    NSDateComponents *endcomponents = [cal1 components:NSCalendarUnitHour fromDate:_endDate];
    NSInteger endHour = [endcomponents hour];
    NSLog(@"use time : %d",(int)endHour);
    endcomponents = [cal1 components:NSCalendarUnitMinute fromDate:_endDate];
    NSInteger endMinute = [endcomponents minute];
     NSLog(@"endMinute : %d",(int)endMinute);
    endcomponents = [cal1 components:NSCalendarUnitSecond fromDate:_endDate];
    NSInteger endSecond = [endcomponents second];
    NSLog(@"endSecond : %d",(int)endSecond);
    NSInteger endTime = ( endHour * 60 + endMinute ) * 60 + endSecond;
    
    NSLog(@"use time : %d %d",(int)endTime,(int) StartTime);
    [_usetimeLabel setText:[NSString stringWithFormat:@"%d 秒",(int)(endTime-StartTime)]];
    
}
@end
