//
//  Food.h
//  Snake-AIGame
//
//  Created by 李浩淼 on 2016/11/12.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Snake.h"

@class Snake;

@interface Food : NSObject

@property (nonatomic, readwrite, assign) CGPoint center;
@property (nonatomic, readwrite, assign) CGRect moveRect;

+ (Food *)creatFoodOnView:(UIView *)superView moveRect:(CGRect)moveRect;

- (void)putFoodWithSnake:(Snake *)snake;

@end
