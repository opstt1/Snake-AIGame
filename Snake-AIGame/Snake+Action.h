//
//  Snake+Action.h
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Snake.h"

@interface Snake (Action)

- (BOOL)snakeCanGoWithDirection:(SnakeDirection)direction;

@end
