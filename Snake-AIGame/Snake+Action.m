//
//  Snake+Action.m
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "Snake+Action.h"
#import "SnakePiece+Direction.h"
#import "CGPointToolkit.h"

@implementation Snake (Action)

- (BOOL)snakeCanGoWithDirection:(SnakeDirection)direction
{
    SnakePiece *snakeHead = self.snakePieces[0];
    CGPoint headCenter = snakeHead.center;
    CGPoint bodyCenter = ((SnakePiece *)self.snakePieces[1]).center;
    
    SnakeDirection cannotGoDirection;
    
    if ( headCenter.x == bodyCenter.x){
        if ( headCenter.y > bodyCenter.y ){
            cannotGoDirection = SnakeUp;
        }else{
            cannotGoDirection = SnakeDown;
        }
    }else{
        if( headCenter.x > bodyCenter.x ){
            cannotGoDirection = SnakeLeft;
        }else{
            cannotGoDirection = SnakeRight;
        }
    }
//    NSLog(@"duref: %d",direction);
    if ( direction == cannotGoDirection ) {
//        NSLog(@"cannot");
        return NO;
    }
    
    if ( [snakeHead isCrossBorderWithDirection:direction] ){
//        NSLog(@"border");
        return NO;
    }
    
    if ( [self hasSnakePieceInPoint:[snakeHead nextCenterWithDirection:direction] snakeGo:YES] ){
//        NSLog(@"body");
        return NO;
    }
    return YES;
}

- (BOOL)snakeCanGoWithDirection:(SnakeDirection)direction point:(CGPoint)point
{
    
    return [self snakeCanGoWithDirection:direction cannotGoDirection:SnakeDefault point:point];
}

- (BOOL)snakeCanGoWithDirection:(SnakeDirection)direction cannotGoDirection:(SnakeDirection)cannotGoDirection point:(CGPoint)pint
{
    if ( direction == cannotGoDirection ) {
//        NSLog(@"cannot");
        return NO;
    }
    
    if ( [CGPointToolkit isCrossBorderWithDirection:direction point:pint] ){
//        NSLog(@"border");
        return NO;
    }
    
    if ( [self hasSnakePieceInPoint:[CGPointToolkit pnextPointWithDirection:direction currentPoint:pint] snakeGo:YES] ){
//        NSLog(@"body");
        return NO;
    }
    return YES;
}


- (void)goWithDirection:(SnakeDirection)direction
{
    SnakePiece *snakeHeadd = self.snakePieces[0];
    SnakeDirection backDirection = snakeHeadd.backDirection;
    [snakeHeadd updateSnakePieceWithFrontPieceCenter:CGPointMake(0, 0) goDirection:direction];
    CGPoint frontCenter = snakeHeadd.center;
    
    for ( int i = 1; i < self.snakePieces.count; ++i ){
        SnakePiece *snake = self.snakePieces[i];
        SnakeDirection goDirection = ( backDirection + 2 ) % 4;
        backDirection = snake.backDirection;
        [snake updateSnakePieceWithFrontPieceCenter:frontCenter goDirection:goDirection];
        frontCenter = snake.center;
    }
    [self updateSnake];
}

- (BOOL)nextDirectionIsFood:(SnakeDirection)direction
{
    CGPoint nextPoint = [((SnakePiece *)self.snakePieces[0]) nextCenterWithDirection:direction];
    if ( nextPoint.x == self.foodCenter.x && nextPoint.y == self.foodCenter.y ){
        return YES;
    }
    return NO;
}
@end
