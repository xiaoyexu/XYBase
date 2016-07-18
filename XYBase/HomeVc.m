//
//  HomeVc.m
//  XYBase
//
//  Created by 徐晓烨 on 16/7/18.
//  Copyright © 2016年 XY. All rights reserved.
//

#import "HomeVc.h"

@interface HomeVc ()

@end

@implementation HomeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.logoffBtn addTarget:self action:@selector(logoffClicked:) forControlEvents:UIControlEventTouchDown];

}

-(void)logoffClicked:(UIButton*)sender{
    [((XYAppDelegate*)[UIApplication sharedApplication].delegate) logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
