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
{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.logoffBtn addTarget:self action:@selector(logoffClicked:) forControlEvents:UIControlEventTouchDown];
    
    XYImageUIButton* btn = [[XYImageUIButton alloc] initWithFrame:CGRectMake(10, 300, 200, 100)];
    btn.backgroundColor = [UIColor grayColor];
    btn.buttonImageView.image = [UIImage imageNamed:@"sort_up_green"];
    btn.buttonLabel.text = @"Test";
    btn.buttonLabel.textAlignment = NSTextAlignmentCenter;
    btn.buttonLabel.font = [UIFont systemFontOfSize:12];
    btn.buttonImageViewSize = CGSizeMake(20, 20);
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    self.srv.selectedImage = [UIImage imageNamed:@"sort_down_green"];
    self.srv.unSelectedImage = [UIImage imageNamed:@"sort_up_green"];
    self.srv.imageSize = CGSizeMake(40, 40);
    self.srv.totalNumber=4;
    self.srv.currentNumber = 3;
    self.srv.backgroundColor = [UIColor redColor];
    [self.srv renderView];
    
    [self performBusyProcess:^XYProcessResult *{
        sleep(5);
        return [XYProcessResult success];
    } busyFlag:YES completion:^(XYProcessResult *result) {
        self.srv.backgroundColor = [UIColor greenColor];
    }];
    [self performBusyProcess:^XYProcessResult *{
        sleep(3);
        return [XYProcessResult success];
    } busyFlag:YES completion:^(XYProcessResult *result) {
        self.srv.backgroundColor = [UIColor blueColor];
    }];

//    [self performBusyProcess:nil busyFlag:YES completion:nil];
    
}

-(void)btnClicked:(UIButton*)sender{
    NSLog(@"clicked");
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
