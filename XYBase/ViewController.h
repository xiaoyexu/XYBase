//
//  ViewController.h
//  XYBase
//
//  Created by 徐晓烨 on 16/6/16.
//  Copyright © 2016年 XY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Classes/XYBase.h"
#import "Worker.h"
#import "TestRequest.h"
#import "TestResponse.h"

@interface ViewController : XYBaseVc<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@interface TestOperation : NSOperation
-(id)initWithName:(NSString*)name;
@end

@interface Person : NSObject
@property(nonatomic, strong) NSString* name;
@property(nonatomic) NSNumber* age;
@end
