//
//  SnakePiece+Direction.m
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "SnakePiece+Direction.h"

@implementation SnakePiece (Direction)


- (CGPoint)directionPiont:(SnakeDirection)direction
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

- (SnakeDirection)directionWithfrontCent:(CGPoint)frontCent backCenter:(CGPoint)backCenter
{
    if ( (int)frontCent.x == (int)backCenter.x){
        if ( frontCent.y > backCenter.y ){
            return SnakeDown;
        }else{
            return SnakeUp;
        }
    }else{
        if( frontCent.x > backCenter.x ){
            return SnakeRight;
        }else{
            return SnakeLeft;
        }
    }
}

- (void)calculateWithFrontPieceCenter:(CGPoint)frontCent beforCenter:(CGPoint)beforeCenter nowCenter:(CGPoint)nowCenter
{
    SnakeDirection frontDirection = [self directionWithfrontCent:frontCent backCenter:nowCenter];
    SnakeDirection backDirection = [self directionWithfrontCent:beforeCenter backCenter:nowCenter];
    [self setFrontDirection:frontDirection backDirection:backDirection snakePieceType:self.snakePieceType];
}

- (void)updateSnakePieceWithFrontPieceCenter:(CGPoint)frontPiececenter goDirection:(SnakeDirection)goDirection
{
    CGPoint nextCenter = [self directionPiont:goDirection];
    CGPoint nowCenter = self.center;
    
    self.center = CGPointMake(self.center.x+snakeSize*nextCenter.x, self.center.y+snakeSize*nextCenter.y);
    
    [self calculateWithFrontPieceCenter:frontPiececenter beforCenter:nowCenter nowCenter:self.center];
}

- (BOOL)isCrossBorderWithDirection:(SnakeDirection)direction
{
    CGPoint point = self.center;
    CGPoint nextPoint = [self directionPiont:direction];
    CGFloat pointX = nextPoint.x * snakeSize + point.x;
    CGFloat pointY = nextPoint.y * snakeSize + point.y;
    
    if ( pointX < 0 || pointY < 0 || pointY > self.moveRect.size.height || pointX > self.moveRect.size.width ){
        return YES;
    }
    
    return NO;
}

- (CGPoint)nextCenterWithDirection:(SnakeDirection)direction
{
    CGPoint nextCenter = [self directionPiont:direction];
    return CGPointMake(self.center.x+snakeSize*nextCenter.x, self.center.y+snakeSize*nextCenter.y);
}

@end
