//
//  CGPointToolkit.m
//  Snake-AIGame
//
//  Created by 李浩淼 on 2016/11/12.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "CGPointToolkit.h"
#import "Snake.h"

@implementation CGPointToolkit

+ (int)snakePointHash:(CGPoint)point// rect:(CGRect)rect
{
    return (((int)point.y + 10) / (int)snakeSize) * ((int)moveRectWidth/(int)snakeSize) + ((int)point.x + 10) / (int)snakeSize;
    
}


+ (CGPoint)pointWithSankeHash:(int)snakeHash// rect:(CGRect)rect
{
    int x =( snakeHash % ((int)moveRectWidth/(int)snakeSize)) * (int)snakeSize - 10;
    if( x <= -10 ){
        x = moveRectWidth + x;
    }
    int y = ( snakeHash - (x + 10) /(int)snakeSize)  /  ((int)moveRectWidth / (int)snakeSize)* (int)snakeSize - 10;
    if ( y <= -10 ){
        y = 10;
    }
    return CGPointMake(x, y);
}


+ (CGPoint)directionPiont:(SnakeDirection)direction
{
    switch (direction) {
        case SnakeUp:{
            return CGPointMake(0, -1);
        }
        case SnakeLeft:{
            return CGPointMake(-1, 0);
        }
        case SnakeDown:{
            return CGPointMake(0, 1);
        }
        case SnakeRight:{
            return CGPointMake(1, 0);
        }
        default:{
            return CGPointMake(0, 0);
        }
    }
}

+ (CGPoint)pnextPointWithDirection:(SnakeDirection)direction currentPoint:(CGPoint)currentPoint
{
    CGPoint nextCenter = [self directionPiont:direction];
    return CGPointMake(currentPoint.x+snakeSize*nextCenter.x, currentPoint.y+snakeSize*nextCenter.y);
}


+ (BOOL)isCrossBorderWithDirection:(SnakeDirection)direction point:(CGPoint)point
{
    CGPoint nextPoint = [self directionPiont:direction];
    CGFloat pointX = nextPoint.x * snakeSize + point.x;
    CGFloat pointY = nextPoint.y * snakeSize + point.y;
    
    if ( pointX < 0 || pointY < 0 || pointY > moveRectWidth || pointX > moveRectWidth ){
        return YES;
    }
    
    return NO;
}
@end
