//
//  Snake+Action.m
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "Snake+Action.h"
#import "SnakePiece+Direction.h"

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
    NSLog(@"duref: %d",direction);
    if ( direction == cannotGoDirection ) {
        NSLog(@"cannot");
        return NO;
    }
    
    if ( [snakeHead isCrossBorderWithDirection:direction] ){
        NSLog(@"border");
        return NO;
    }
    
    if ( [self hasSnakePieceInPoint:[snakeHead nextCenterWithDirection:direction]] ){
        NSLog(@"body");
        return NO;
    }
    return YES;
}

@end
