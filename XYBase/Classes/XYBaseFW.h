//
//  XYBaseFW.h
//  XYBase
//
//  Created by 徐晓烨 on 16/7/18.
//  Copyright © 2016年 XY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYBase.h"

#define ROW_HEIGHT 44
#define BUTTON_ROW_HEIGHT 60
#define BUTTON_CORNER_RADIUS 5
#define INTROVIEW_DISMISSED @"IntroViewDismissed"
#define ISINTROVIEWDISPLAYED_KEY @"isIntroViewDisplayed"

@interface XYBaseFW : NSObject

@end

#pragma mark category
@interface UIColor (xyPredefine)
+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+(UIColor*)xyGreenColor;
+(UIColor*)xyBlueColor;
+(UIColor*)xyTableCellSeparatorLineColor;
+(UIColor*)xyTableViewBackgroundColor;
+(UIColor*)xyTextLightGreyColor;
+(UIColor*)xyTextGreyColor;
+(UIColor*)xyTextDarkGreyColor;
@end

@interface XYUtility(xyPredefine)
+(void)enableButton:(UIButton*)button;
+(void)disableButton:(UIButton*)button;
@end

#pragma mark table view cell
@interface XYInputTvc : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@interface XYButtonTvc : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@interface XYImageViewTvc : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *custImageView;
@end

#pragma mark model classes
#pragma mark XYUser
@interface XYUser : NSObject
// User ID
@property(nonatomic, strong) NSString* userId;
// User real name
@property(nonatomic, strong) NSString* name;
// Login username
@property(nonatomic, strong) NSString* loginName;
// Status
@property(nonatomic, strong) NSString* status;
// Status text
@property(nonatomic, strong) NSString* statusText;
// User mobile
@property(nonatomic, strong) NSString* mobile;
// User email
@property(nonatomic, strong) NSString* email;
@end

#pragma mark base appllication delegate
@interface XYAppDelegate : UIResponder <UIApplicationDelegate, XYMessageEngineDelegate>
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) XYUser* user;
-(NSString*)backendUrl;
-(NSString*)mainStoryboardName;
-(NSString*)startViewName;
-(NSString*)homeViewName;
-(NSString*)introViewName;
-(BOOL)isIntroViewEnabled;
-(void)initializeApp;
-(void)checkAndAutoLogin;
-(void)toHome;
-(void)log:(NSString *)logString;
-(void)logout;
@end

#pragma mark messaging classes
#pragma mark XYLogin
@interface XYLoginRequest : XYRequest
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@end

@interface XYLoginResponse : XYResponse
@property(nonatomic, strong) NSString* token;
@property(nonatomic, strong) NSString* userId;
@end

@interface XYLoginMessageAgent : XYMessageAgent
@end

#pragma mark view controllers

@interface XYLoginVc : XYBaseTableVc
@end

@interface XYIntroVc : XYBaseVc
@end