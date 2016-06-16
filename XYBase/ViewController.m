//
//  ViewController.m
//  XYBase
//
//  Created by 徐晓烨 on 16/6/16.
//  Copyright © 2016年 XY. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
}

-(void)click:(UIButton*)sender{
    [self performBusyProcess:^XYProcessResult *{
        sleep(2);
        return [XYProcessResult success];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
