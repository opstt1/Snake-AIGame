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

- (SnakeDirection)randomGpDirection
{
//    NSLog(@"------");
    SnakeDirection direction = arc4random() % 4;;
    int num = 0;
    
    while ( 1 ) {
        if ( [self snakeCanGoWithDirection:direction]){
            break;
        }
        direction = (direction + 1 ) % 4;
        ++num;
        if ( num > 4 ){
            return SnakeDefault;
            break;
        }
    }
    
    return direction;
}

@end
