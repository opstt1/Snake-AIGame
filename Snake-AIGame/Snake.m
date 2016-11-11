//
//  Snake.m
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "Snake.h"
#import "SnakePiece.h"

@interface Snake()


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
    
    CGPoint centerPoint = CGPointMake(moveRect.size.width/2+moveRect.origin.x, moveRect.size.height/2+moveRect.origin.y);
    SnakePiece *snakeHead = [SnakePiece snakeInView:superView pieceType:SnakeHead frontDirection:SnakeDefault backDirect:SnakeDown center:centerPoint moveRect:moveRect];
    
    SnakePiece *snakeBody = [SnakePiece snakeInView:superView pieceType:SnakeBody frontDirection:SnakeUp backDirect:SnakeDown center:CGPointMake(centerPoint.x, centerPoint.y+snakeSize) moveRect:moveRect];
    SnakePiece *snakeTail = [SnakePiece snakeInView:superView pieceType:SnakeTail frontDirection:SnakeUp backDirect:SnakeDefault center:CGPointMake(centerPoint.x, centerPoint.y+snakeSize*2) moveRect:moveRect];
    
    snake.snakePieces = @[snakeHead,snakeBody,snakeTail];
    snake.moveRect = moveRect;
    [snake updateSnake];
    return snake;
}


-(void)updateSnake
{
    memset(snakeVist, NO, sizeof(snakeVist));
    for ( SnakePiece *snakePiece in _snakePieces ){
        int point = [self pointHash:snakePiece.center];
        if ( point < arrayLength){
            snakeVist[point] = YES;
        }
    }
}

- (BOOL)hasSnakePieceInPoint:(CGPoint)point
{
    int pointInt = [self pointHash:point];
    if ( pointInt < arrayLength ){
        return snakeVist[pointInt];
    }
    return NO;
}


- (int)pointHash:(CGPoint)point
{
    return ((int)point.y / (int)snakeSize) * ((int)self.moveRect.size.width/(int)snakeSize) + (int)point.x / (int)snakeSize;
}

@end
