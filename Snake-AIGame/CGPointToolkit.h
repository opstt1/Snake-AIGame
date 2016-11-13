//
//  CGPointToolkit.h
//  Snake-AIGame
//
//  Created by 李浩淼 on 2016/11/12.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Snake.h"

@interface CGPointToolkit : NSObject

+ (int)snakePointHash:(CGPoint)point;// rect:(CGRect)rect;

+ (CGPoint)pointWithSankeHash:(int)snakeHash;// rect:(CGRect)rect;

+ (CGPoint)pnextPointWithDirection:(SnakeDirection)direction currentPoint:(CGPoint)currentPoint;

+ (BOOL)isCrossBorderWithDirection:(SnakeDirection)direction point:(CGPoint)point;

@end
