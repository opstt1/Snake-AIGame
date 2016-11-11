//
//  SnakePiece+Direction.h
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "SnakePiece.h"

@interface SnakePiece (Direction)

- (CGPoint)directionPiont:(SnakeDirection)direction;


/**
 通过前后点来判断蛇块的位置

 @param frontCent 前一个点
 @param backCenter 后一个点
 @return 蛇块移动的方向
 */
- (SnakeDirection)directionWithfrontCent:(CGPoint)frontCent backCenter:(CGPoint)backCenter;


/**
 计算当前蛇块的前方向和后方向，同时更新蛇块的image
 
 @param frontCent 前一个蛇块为位置
 @param beforeCenter 此蛇块之前一步的位置
 @param nowCenter 此蛇块当前的位置
 通过前一蛇块的位置和当前蛇块的位置可以确定 前方向。  通过当前蛇块的位置和当前蛇块之前的位置可以确定 后方向
 */

- (void)calculateWithFrontPieceCenter:(CGPoint)frontCent beforCenter:(CGPoint)beforeCenter nowCenter:(CGPoint)nowCenter;


/**
 通过前一蛇块的位置和此蛇块的移动方向，更新蛇块

 @param frontPiececenter 前一蛇块的位置
 @param goDirection 此蛇块的移动方向
 */
- (void)updateSnakePieceWithFrontPieceCenter:(CGPoint)frontPiececenter goDirection:(SnakeDirection)goDirection;


- (BOOL)isCrossBorderWithDirection:(SnakeDirection)direction;


- (CGPoint)nextCenterWithDirection:(SnakeDirection)direction;

@end
