//
//  SnakePiece.h
//  LHMAnimationDemo
//
//  Created by LiHaomiao on 2016/11/10.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static CGFloat const snakeSize = 20.0f;

//方向
typedef NS_ENUM(NSInteger, SnakeDirection){
    SnakeUp,
    SnakeRight,
    SnakeDown,
    SnakeLeft,
    SnakeDefault
};

//蛇块的种类
typedef NS_ENUM(NSInteger, SnakePieceType){
    SnakeHead,
    SnakeBody,
    SnakeTail
};

@interface SnakePiece : NSObject


/**
 蛇块朝前的方向
 */
@property (nonatomic, readwrite, assign) SnakeDirection frontDirection;


/**
 蛇块朝后的方向
 */
@property (nonatomic, readwrite, assign) SnakeDirection backDirection;


/**
 蛇块的种类
 */
@property (nonatomic, readwrite, assign) SnakePieceType snakePieceType;


@property (nonatomic, readwrite, strong) NSString *imageStr;
@property (nonatomic, readwrite, assign) CGPoint center;
@property (nonatomic, readwrite, strong) UIImageView *snakeImage;
@property (nonatomic, readwrite, assign) CGRect moveRect;

+ (SnakePiece *)snakeInView:(UIView *)view pieceType:(SnakePieceType)pieceType frontDirection:(SnakeDirection)frontDirection backDirect:(SnakeDirection)backDirect center:(CGPoint)center;// moveRect:(CGRect)moveRect;


- (void)setFrontDirection:(SnakeDirection)frontDirection backDirection:(SnakeDirection)backDirection snakePieceType:(SnakePieceType)snakePiceType;

- (void)update;

@end
