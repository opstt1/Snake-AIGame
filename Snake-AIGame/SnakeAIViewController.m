//
//  SnakeAIViewController.m
//  Snake-AIGame
//
//  Created by LiHaomiao on 2016/11/11.
//  Copyright © 2016年 Li Haomiao. All rights reserved.
//

#import "SnakeAIViewController.h"
#import "Snake.h"
#import "Snake+randomAction.h"

@interface SnakeAIViewController ()


@property (nonatomic, readwrite, strong) NSTimer *timer;
@property (nonatomic, readwrite, assign) BOOL hasGo;
@property (nonatomic, readwrite, strong) Snake *snake;
@end

@implementation SnakeAIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 300, 300)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    _snake = [Snake creatSnakeOnView:view moveRect:CGRectMake(0, 0, 300, 300)];
    
    _hasGo = NO;
    [self snakeStartGo];
}


- (void)snakeStartGo
{
    _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0/10.0 target:self selector:@selector(letGo:) userInfo:nil repeats:YES];
}

#pragma mark - letGo

- (void)letGo:(NSTimer *)timer
{
    if ( _hasGo ){
        return;
    }
    _hasGo = YES;
    if ( [_snake randomDirectionGo]){
        _hasGo = NO;
    }
}
@end
