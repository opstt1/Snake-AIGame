//
//  SnakePiece.m
//  LHMAnimationDemo
//
//  Created by LiHaomiao on 2016/11/10.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "SnakePiece.h"
#import "SnakePiece+Direction.h"

@interface SnakePiece()

@property (nonatomic, readwrite, strong) UIView *superView;

@end

@implementation SnakePiece


+ (SnakePiece *)snakeInView:(UIView *)view pieceType:(SnakePieceType)pieceType frontDirection:(SnakeDirection)frontDirection backDirect:(SnakeDirection)backDirect center:(CGPoint)center moveRect:(CGRect)moveRect;

{
    SnakePiece *snakePiece = [[SnakePiece alloc] init];
    UIImageView *snakeLayer = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, snakeSize, snakeSize)];
    snakeLayer.center = center;
    snakePiece.snakeImage = snakeLayer;
    [view addSubview:snakePiece.snakeImage];
    snakePiece.center = center;
    
    [snakePiece setFrontDirection:frontDirection backDirection:backDirect snakePieceType:pieceType];
    snakePiece.superView = view;
    snakePiece.moveRect = moveRect;
    
    return snakePiece;
}

- (void)setFrontDirection:(SnakeDirection)frontDirection backDirection:(SnakeDirection)backDirection snakePieceType:(SnakePieceType)snakePiceType
{
    self.backDirection = backDirection;
    self.frontDirection = frontDirection;
    self.snakePieceType = snakePiceType;
    [self p_snakeHead];
    [self p_snakeBody];
    [self p_snakeTail];
}

#pragma mark - snakePiece config

- (void)p_snakeHead
{
    if ( _snakePieceType != SnakeHead ){
        return;
    }
    self.imageStr = [NSString stringWithFormat:@"snake-head-%d",(int)_backDirection];
}


- (void)p_snakeTail
{
    if ( _snakePieceType != SnakeTail ){
        return;
    }
    self.imageStr = [NSString stringWithFormat:@"snake-tail-%d",(int)_frontDirection];
}


- (void)p_snakeBody
{
    if ( _snakePieceType != SnakeBody ){
        return;
    }
    SnakeDirection smallDirection = _frontDirection;
    SnakeDirection bigDirection = _backDirection;
    if ( smallDirection > bigDirection ){
        smallDirection = bigDirection;
        bigDirection = _frontDirection;
    }
    self.imageStr = [NSString stringWithFormat:@"snake-body-%d-%d",(int)smallDirection,(int)bigDirection];
}


- (void)p_setSnakeImage
{
    if ( !_snakeImage || !_imageStr ){
        return;
    }
    _snakeImage.image = [UIImage imageNamed:_imageStr];
}

#pragma mark - set

- (void)setImageStr:(NSString *)imageStr
{
    _imageStr = imageStr;
    [self p_setSnakeImage];
}

- (void)setCenter:(CGPoint)center
{
    _center = center;
    if( !_snakeImage ){
        return;
    }
    _snakeImage.center = center;
}


@end
