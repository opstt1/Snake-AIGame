//
//  Snake+randomAction.m
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "Snake+randomAction.h"
#import "SnakePiece+Direction.h"
#import "Snake+Action.h"

@implementation Snake (randomAction)

- (BOOL)randomDirectionGo
{
    CGPoint headCenter = ((SnakePiece *)self.snakePieces[0]).center;
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

    NSLog(@"------");
    SnakeDirection direction = arc4random() % 4;;
    int num = 0;
    
    while ( 1 ) {
        if ( [self snakeCanGoWithDirection:direction]){
            break;
        }
        direction = (direction + 1 ) % 4;
        ++num;
        if ( num > 4 ){
            return NO;
            break;
        }
    }
    
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
    return YES;
}

@end
