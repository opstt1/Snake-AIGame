//
//  Food.m
//  Snake-AIGame
//
//  Created by 李浩淼 on 2016/11/12.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "Food.h"
#import "CGPointToolkit.h"

@interface Food()

@property (nonatomic, readwrite, strong) UIImageView *foodImage;

@end

@implementation Food

+ (Food *)creatFoodOnView:(UIView *)superView moveRect:(CGRect)moveRect
{
    Food *food = [[Food alloc] init];
    food.foodImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, snakeSize, snakeSize)];
    food.foodImage.image = [UIImage imageNamed:@"snake-food"];
    food.moveRect = moveRect;
    food.center = CGPointMake(0, 0);
    [superView addSubview:food.foodImage];
    return food;
}

- (void)putFoodWithSnake:(Snake *)snake
{
    int sie = (int)snakeSize;
    NSMutableArray *array = [NSMutableArray array];
    
    for ( int i = 10; i < moveRectWidth; i +=sie )
        for (int j = 10; j < moveRectWidth; j += sie ) {
            CGPoint point = CGPointMake(i, j);
            if ( [snake hasSnakePieceInPoint:point snakeGo:NO]){
                continue;
            }
            [array addObject:[NSValue valueWithCGPoint:point]];
        }
    int cout = (int)array.count;
    if ( cout == 0 ){
        return;
    }
    int index = arc4random() % cout;
    CGPoint point = [array[index] CGPointValue];
    self.center = point;
    self.foodImage.center = point;
    snake.foodCenter = point;
}
@end
