//
//  XYBaseFW.m
//  XYBase
//
//  Created by 徐晓烨 on 16/7/18.
//  Copyright © 2016年 XY. All rights reserved.
//

#import "XYBaseFW.h"

@implementation XYBaseFW

@end

#pragma mark category
@implementation UIColor (xyPredefine)

+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+(UIColor*)xyGreenColor{
    return [UIColor colorWithRed:46/255.0 green:204/255.0 blue:104/255.0 alpha:1];
}

+(UIColor*)xyBlueColor{
    return [UIColor colorWithHex:0x34A1F8];
    //    return [UIColor colorWithRed:63/255.0 green:117/255.0 blue:1 alpha:1];
}


+(UIColor*)xyTableCellSeparatorLineColor{
    return [UIColor colorWithRed:227/255.0 green:228/255.0 blue:229/255.0 alpha:1];
}

+(UIColor*)xyTableViewBackgroundColor{
    return [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1];
}

+(UIColor*)xyTextLightGreyColor{
    return [UIColor colorWithHex:0xAAAAAA];
}

+(UIColor*)xyTextGreyColor{
    return [UIColor colorWithHex:0x999999];
}

+(UIColor*)xyTextDarkGreyColor{
    return [UIColor colorWithHex:0x666666];
}
@end

@implementation XYUtility (xyPredefine)
+(void)enableButton:(UIButton*)button{
    button.enabled = YES;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
+(void)disableButton:(UIButton*)button{
    button.enabled = NO;
    [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
}
@end

#pragma mark table view cell
@implementation XYInputTvc

@end

@implementation XYButtonTvc

@end

@implementation XYImageViewTvc

@end

#pragma mark model classes
#pragma mark XYUser
@implementation XYUser
@synthesize userId;
@synthesize name;
@synthesize loginName;
@synthesize status;
@synthesize statusText;
@synthesize mobile;
@synthesize email;
@end

@implementation XYAppDelegate

-(NSString*)backendUrl{
    return @"http://127.0.0.1:8000";
}

-(void)initializeApp{
    NSString* url = [self backendUrl];
    XYConnector* connector = [[XYConnector alloc] initWithURL:url];
    connector.connection = [XYConnection new];
    
    XYConnectorManager* cm = [XYConnectorManager instance];
    [cm addConnector:connector asAlias:@"backend"];
    
    // Message engine manage multiple connectors
    [[XYMessageEngine instance] setConnector:connector forStage:MessageStageDevelopment];
    [XYMessageEngine instance].runningStage = MessageStageDevelopment;
    
    // Message engine delegate
    [XYMessageEngine instance].delegate = self;
    
    // Register message configuration
    XYMessageConfig* mc = [XYMessageConfig new];
    mc.relativePath = @"login";
    mc.httpMethod = @"POST";
    [[XYMessageEngine instance] setConfig:mc forMessage:[XYLoginRequest class]];
    
}

-(void)toHome{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"homeView"];
    XYBaseNavigationVc* rootView = [[XYBaseNavigationVc alloc] initWithRootViewController:myView];
    self.window.rootViewController = rootView;
}

-(void)checkAndAutoLogin{
    // Check if password saved
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* username = [userDefault stringForKey:@"username"];
    NSString* password = [userDefault stringForKey:@"password"];
    BOOL offlineLogin = [userDefault boolForKey:@"offlineLogin"];
    if (offlineLogin && ![XYUtility isConnectedToNetwork]) {
        // If not connect to network and login once before, use cached data
        XYUser* user = [XYUser new];
        user.userId = [userDefault objectForKey:@"userId"];
        user.name = [userDefault objectForKey:@"name"];
        user.loginName = [userDefault objectForKey:@"loginName"];
        user.status = [userDefault objectForKey:@"status"];
        user.statusText = [userDefault objectForKey:@"statusText"];
        user.mobile = [userDefault objectForKey:@"mobile"];
        user.email = [userDefault objectForKey:@"email"];
        self.user = user;
        [self toHome];
    } else {
        // Connected to network
        if (!([XYUtility isBlank:username] || [XYUtility isBlank:password])) {
            // Password saved, try login
            XYLoginRequest* request = [XYLoginRequest new];
            request.username = username;
            request.password = password;
            XYLoginResponse* response = (XYLoginResponse*)[[XYMessageEngine instance] send:request];
            NSString* errorDesc = @"";
            errorDesc = response.responseDesc;
            if (response.responseCode == 0) {
                [self toHome];
            }
        }
    }
}

-(void)log:(NSString *)logString{
    // Message log, for debug use
    NSLog(@"%@",logString);
}

@end

#pragma mark messagign classes
#pragma mark XYLogin
@implementation XYLoginRequest
@synthesize username;
@synthesize password;
-(id)init{
    if (self = [super init]){
        self.username = @"";
        self.password = @"";
    }
    return self;
}
@end

@implementation XYLoginResponse
@synthesize token;
@synthesize userId;
@end

@implementation XYLoginMessageAgent
-(void)normalize:(XYRequest*)request to:(XYHTTPRequestObject*) requestObj{
    XYLoginRequest* req = (XYLoginRequest*)request;
    [super normalize:req to:requestObj];
    [request.bodyDict addEntriesFromDictionary:@{
          @"username": req.username,
          @"password": req.password
        }];
//    NSString* json = [request.bodyDict JSONRepresentation];
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:request.bodyDict options:kNilOptions error:&error];
    NSString* json = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    requestObj.body = [json dataUsingEncoding:NSUTF8StringEncoding];
}
-(void)deNormalize:(XYHTTPResponseObject*)responseObj to:(XYResponse**)response{
    NSDictionary* repObj = [NSJSONSerialization JSONObjectWithData:responseObj.data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary* data = [repObj objectForKey:@"data"];
    XYLoginResponse* res = [XYLoginResponse new];
    if (data != nil) {
        res.token = [data objectForKey:@"token"];
        res.userId = [data objectForKey:@"userId"];
    }
    *response = (XYResponse*)res;
    [super deNormalize:responseObj to:&res];
}
@end

#pragma mark view controllers
@implementation XYLoginVc
{
    UITextField* usernameTf;
    UITextField* passwordTf;
    UIButton* loginBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableRefresh = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView = [UIView new];
    
    XYBaseTvcItem* view1 = [[XYBaseTvcItem alloc] initWithIdentifer:@"XYImageViewTvc" view:nil height:200];
    
    XYBaseTvcItem* view2 = [[XYBaseTvcItem alloc] initWithIdentifer:@"XYInputTvc" view:nil height:ROW_HEIGHT];
    view2.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        XYInputTvc* cell = (XYInputTvc*)baseCell;
        cell.label.text = LS(@"username");
        cell.label.textColor = [UIColor xyTextDarkGreyColor];
        cell.textField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:LS(@"plsEnterUsername") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        cell.textField.text = @"xxy";
        [cell.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        usernameTf = cell.textField;
        cell.separatorLine.backgroundColor = [UIColor xyTableCellSeparatorLineColor];
        return cell;
    };
    
    XYBaseTvcItem* view3 = [[XYBaseTvcItem alloc] initWithIdentifer:@"XYInputTvc" view:nil height:ROW_HEIGHT];
    view3.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        XYInputTvc* cell = (XYInputTvc*)baseCell;
        cell.label.text = LS(@"password");
        cell.label.textColor = [UIColor xyTextDarkGreyColor];
        cell.textField.secureTextEntry = YES;
        cell.textField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:LS(@"plsEnterPassword") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        cell.textField.text = @"123";
        [cell.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        passwordTf = cell.textField;
        cell.separatorLine.backgroundColor = [UIColor xyTableCellSeparatorLineColor];
        return cell;
    };
    
    XYBaseTvcItem* view4 = [[XYBaseTvcItem alloc] initWithIdentifer:@"XYButtonTvc" view:nil height:BUTTON_ROW_HEIGHT];
    view4.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        XYButtonTvc* cell = (XYButtonTvc*) baseCell;
        cell.button.backgroundColor = [UIColor xyBlueColor];
        [cell.button setTintColor:[UIColor whiteColor]];
        [cell.button setTitle:LS(@"login") forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchDown];
        cell.button.layer.cornerRadius = BUTTON_CORNER_RADIUS;
        loginBtn = cell.button;
        return cell;
    };
    
    XYBaseTvcItem* view5 = [[XYBaseTvcItem alloc] initWithIdentifer:@"ForgotPwdButtonTvc" view:nil height:30];
    view5.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        XYButtonTvc* cell = (XYButtonTvc*) baseCell;
        cell.button.backgroundColor = [UIColor clearColor];
        [cell.button setTintColor:[UIColor blackColor]];
        [cell.button setTitle:LS(@"forgotPassword?") forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(forgotPwdBtnClicked:) forControlEvents:UIControlEventTouchDown];
        cell.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        return cell;
    };
    
    sections = @[
                 @[
                     view1,
                     view2,
                     view3,
                     view4
                     //       view5
                     ]
                 ];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [usernameTf resignFirstResponder];
    [passwordTf resignFirstResponder];
}

-(void)loginBtnClicked:(id)sender {
    self.busyProcessTitle = LS(@"isLogining");
    [self performBusyProcess:^XYProcessResult *{
        XYLoginRequest* request = [XYLoginRequest new];
        request.username = [usernameTf.text trim];
        request.password = [passwordTf.text sha1];
        XYProcessResult* result;
        XYLoginResponse* response = (XYLoginResponse*)[[XYMessageEngine instance] send:request];
        NSString* errorDesc = @"";
        errorDesc = response.responseDesc;
        if (response.responseCode == 0) {
            XYUser * user = [XYUser new];
            ((XYAppDelegate*)[UIApplication sharedApplication].delegate).user = user;
            user.userId = response.userId;
            result = [XYProcessResult success];
            result.forwardSegueIdentifer = @"toHome";
            return result;
        }
        result = [XYProcessResult failure];
        [result.params setValue:errorDesc forKey:@"error"];
        return result;
    }];
}

-(void)forgotPwdBtnClicked:(id)sender{
    [self performSegueWithIdentifier:@"toForgotPwd" sender:self];
}

-(void)handleCorrectResponse:(XYProcessResult *)result{
    // Login success, save login credentials
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSString* username = [userDefault stringForKey:@"username"];
    NSString* password = [userDefault stringForKey:@"password"];
    username = usernameTf.text;
    password = [passwordTf.text sha1];
    [userDefault setObject:username forKey:@"username"];
    [userDefault setObject:password forKey:@"password"];
    [userDefault synchronize];
    
    // Change the root view controller
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"homeView"];
    XYBaseNavigationVc* rootView = [[XYBaseNavigationVc alloc] initWithRootViewController:myView];
    [UIApplication sharedApplication].delegate.window.rootViewController = rootView;
}

-(void)valueChanged:(id)sender{
    if ([XYUtility isBlank:usernameTf.text]|| [XYUtility isBlank:passwordTf.text]) {
        [XYUtility disableButton:loginBtn];
    } else {
        [XYUtility enableButton:loginBtn];
    }
}
@end