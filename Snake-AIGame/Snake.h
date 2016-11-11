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

static int const arrayLength = 20 * 20;

typedef NS_ENUM(NSInteger, SnakeIQ)
{
    SnakeRandomGoIQ,
};

@interface Snake : NSObject
{
    BOOL snakeVist[arrayLength];
}

@property (nonatomic, readwrite, strong) NSArray *snakePieces;
@property (nonatomic, readwrite, assign) CGRect moveRect;

+ (Snake *)creatSnakeOnView:(UIView *)superView moveRect:(CGRect)moveRect;

- (void)updateSnake;

- (BOOL)hasSnakePieceInPoint:(CGPoint)point;

@end
