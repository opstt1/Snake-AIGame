//
//  UIView+IBInspect.h
//  Snake
//
//  Created by LiHaomiao on 16/9/8.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (IBInspect)

@property (nonatomic) IBInspectable CGFloat layerCornerRadius;
@property (nonatomic) IBInspectable UIColor *layerBorderColor;
@property (nonatomic) IBInspectable CGFloat layerBorderWidth;
@property (nonatomic) IBInspectable UIColor *layerShadowColor;
@property (nonatomic) IBInspectable CGFloat layerShadowOpacity;
@property (nonatomic) IBInspectable CGSize layerShadowOffset;
@property (nonatomic) IBInspectable CGFloat layerShadowRadius;


@end
