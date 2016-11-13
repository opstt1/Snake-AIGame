//
//  Snake.h
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SnakePiece.h"
#import "Food.h"

static int const arrayLength = 20 * 200;
static NSInteger const moveRectWidth = 240;

typedef NS_ENUM(NSInteger, SnakeIQ)
{
    SnakeRandomGoIQ,
};

@interface Snake : NSObject
{
    BOOL snakeVist[arrayLength];
}

@property (nonatomic, readwrite, strong) NSArray *snakePieces;
@property (nonatomic, readwrite, strong) NSMutableArray *canPutFood;
@property (nonatomic, readwrite, assign) CGPoint foodCenter;

+ (Snake *)creatSnakeOnView:(UIView *)superView moveRect:(CGRect)moveRect;

- (void)updateSnake;

- (Snake *)makeVirtualSnake;

/**
 指定点是否有蛇块

 @param point 指定点

 @return 是否有蛇块
 */
- (BOOL)hasSnakePieceInPoint:(CGPoint)point snakeGo:(BOOL)snakeGo;


/**
 吃到食物后增加一个蛇块

 @param direction 蛇前进的方向
 */
- (void)addSnakePieceWithDirection:(SnakeDirection)direction;

@end
