//
//  XYBase.m
//  XYBase
//
//  Created by 徐晓烨 on 16/6/16.
//  Copyright © 2016年 XY. All rights reserved.
//

#import "XYBase.h"

@implementation XYBase

@end

#pragma mark XYUtility
@implementation XYUtility

+(BOOL)isConnectedToNetwork{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

+(BOOL)isBlank:(NSString*)field{
    return field == nil ? YES : field.length == 0 ? YES : NO;
}

+(NSArray*)matchStringListOfString:(NSString*)str matchRegularExpression:(NSString*)regStr{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray* matchResult = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    NSMutableArray* strList = [NSMutableArray new];
    NSString* subStr;
    for (NSTextCheckingResult* cr in matchResult) {
        subStr = [str substringWithRange:cr.range];
        NSRange r1 = [cr rangeAtIndex:1];
        if (!NSEqualRanges(r1, NSMakeRange(NSNotFound, 0))) {
            subStr = [str substringWithRange:r1];
        }
        [strList addObject:subStr];
    }
    return strList;
}

+(void)setTitle:(NSString *)title inNavigationItem:(UINavigationItem*)navigationItem{
    UIView* titleView = navigationItem.titleView;
    UILabel* titleLabel;
    if (titleView != nil && [titleView isKindOfClass:[UILabel class]]) {
        titleLabel = (UILabel*)titleView;
    } else {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        navigationItem.titleView = titleLabel;
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
}

+(NSString*)convertDateFormatter:(NSString*)sourceFormatter targetFormatter:(NSString*)targetFormatter dateString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:sourceFormatter];
    NSDate *date = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:targetFormatter];
    return[dateFormatter stringFromDate:date];
}

+(NSString*)dateToString:(NSString *)formatter date:(NSDate *)date{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)stringToDate:(NSString*)formatter dateString:(NSString*)dateStr{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateStr];
}

//+(NSString*)encrypt:(NSString*)plainText key:(NSString *)key initVect:(NSString *)iv{
//    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
//    size_t plainTextBufferSize = [data length];
//    const void *vplainText = (const void *)[data bytes];
//    
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    
//    const void *vkey = (const void *) [key UTF8String];
//    const void *vinitVec = (const void *) [iv UTF8String];
//    
//    ccStatus = CCCrypt(kCCEncrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding,
//                       //                       kCCOptionPKCS7Padding | kCCOptionECBMode,
//                       //                       kCCOptionPKCS,
//                       vkey,
//                       kCCKeySize3DES,
//                       vinitVec,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    
//    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
//    
//    //    NSString* tmp = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
//    //NSLog(@"--> %@ enrypted string[%@]",myData, tmp);
//    
////    NSString *result = [GTMBase64 stringByEncodingData:myData];
//    return result;
//}


//+(NSString*)decrypt:(NSString*)encryptText key:(NSString *)key initVect:(NSString *)iv{
//    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSString* tmp = [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@ base64 string[%@]",encryptData, tmp);
//    
//    size_t plainTextBufferSize = [encryptData length];
//    const void *vplainText = [encryptData bytes];
//    
//    CCCryptorStatus ccStatus;
//    uint8_t *bufferPtr = NULL;
//    size_t bufferPtrSize = 0;
//    size_t movedBytes = 0;
//    
//    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
//    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
//    memset((void *)bufferPtr, 0x0, bufferPtrSize);
//    
//    const void *vkey = (const void *) [key UTF8String];
//    const void *vinitVec = (const void *) [iv UTF8String];
//    
//    ccStatus = CCCrypt(kCCDecrypt,
//                       kCCAlgorithm3DES,
//                       kCCOptionPKCS7Padding,
//                       //                       kCCOptionECBMode,
//                       vkey,
//                       kCCKeySize3DES,
//                       vinitVec,
//                       vplainText,
//                       plainTextBufferSize,
//                       (void *)bufferPtr,
//                       bufferPtrSize,
//                       &movedBytes);
//    
//    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
//                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
//    return result;
//}

+(void)drawDashedLineOnView:(UIView *)view from:(CGPoint)from to:(CGPoint)to{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:view.bounds];
    [shapeLayer setPosition:view.center];
    [shapeLayer setFillColor:[[UIColor blackColor] CGColor]];
    
    [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:3],
      [NSNumber numberWithInt:1],nil]];
    
    // Setup the path
    CGMutablePathRef path = CGPathCreateMutable();
    // 0,10代表初始坐标的x，y
    // 320,10代表初始坐标的x，y
    CGPathMoveToPoint(path, NULL, from.x, from.y);
    CGPathAddLineToPoint(path, NULL, to.x,to.y);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    for (CALayer* layer in view.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    [view.layer addSublayer:shapeLayer];
}

+(NSString*)maskPhoneNumber:(NSString*)phoneNumber{
    if (phoneNumber.length < 11) {
        return phoneNumber;
    }
    NSString* result = [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return result;
}

+(BOOL)isString:(NSString*) str matchRegularExpression:(NSString*)regStr{
    if ([XYUtility isBlank:str] || [XYUtility isBlank:regStr]) {
        return NO;
    }
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSInteger n = [regex numberOfMatchesInString:str options:0 range:NSMakeRange(0, str.length)];
    return n != 0;
}
@end

#pragma mark XYProcessResult
@implementation XYProcessResult
@synthesize type = _type;
@synthesize success = _success;
@synthesize params = _params;
@synthesize forwardSegueIdentifer = _forwardSegueIdentifer;

-(id)init{
    self = [super init];
    if (self) {
        _params = [NSMutableDictionary new];
    }
    return self;
}
+(XYProcessResult*)success{
    XYProcessResult* result = [XYProcessResult new];
    result.success = YES;
    return result;
}

+(XYProcessResult*)successWithType:(NSString*)type{
    XYProcessResult* result = [XYProcessResult new];
    result.success = YES;
    result.type = type;
    return result;
}

+(XYProcessResult*)failure{
    XYProcessResult* result = [XYProcessResult new];
    result.success = NO;
    return result;
}

+(XYProcessResult*)failureWithType:(NSString*)type{
    XYProcessResult* result = [XYProcessResult new];
    result.success = NO;
    result.type = type;
    return result;
}

+(XYProcessResult*)failureWithError:(NSString*) error{
    XYProcessResult* result = [XYProcessResult new];
    result.success = NO;
    [result.params setValue:error forKey:@"error"];
    return result;
}

+(XYProcessResult*)failureWithType:(NSString*)type andError:(NSString*)error{
    XYProcessResult* result = [XYProcessResult new];
    result.success = NO;
    result.type = type;
    [result.params setValue:error forKey:@"error"];
    return result;
}
@end


#pragma mark XYBaseVc
@implementation XYBaseVc
{
    BOOL isStatusUpdaterEnabled;
//    MBProgressHUD* hud;
}
@synthesize busyProcessTitle;
@synthesize showActivityIndicatorView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // By default the alert view will be shown
    self.showActivityIndicatorView = YES;
    
    //    [self.navigationController.navigationBar setTranslucent:YES];
    //    UIImage* image = [UIImage imageNamed:@"darkBlueDot.png"];
    //    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIImage* image = [UIImage imageNamed:@"whiteDot.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", @"back") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)turnOnBusyFlag{
    /* show activity indicator here */
//    if (self.navigationController != nil) {
//        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    } else {
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    }
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = [UIColor clearColor];
    
    // Disable all interaction
    self.view.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)turnOffBusyFlag{
    /* hide activity indicator here */
//    [hud hideAnimated:YES];
    
    // Enable interaction
    self.view.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

/*
 Method of executing a callback block
 */
-(void)performBusyProcess:(XYProcessResult*(^)(void))block{
    if (showActivityIndicatorView == YES) {
        isStatusUpdaterEnabled = NO;
        [self turnOnBusyFlag];
    }
    // Rune callback in background
    [NSThread detachNewThreadSelector:@selector(performBusyProcessInBackground:) toTarget:self withObject:block];
}

/*
 Method of executing a callback block in background
 */
-(void)performBusyProcessInBackground:(XYProcessResult*(^)(void))block{
    if (block == nil) {
        return;
    }
    XYProcessResult* (^progressBlock)() = block;
    XYProcessResult* processResult;
    @try {
        processResult = progressBlock();
        if (processResult == nil) {
            // If no process result return, end immediately
            [self performSelectorOnMainThread:@selector(turnOffBusyFlag) withObject:nil waitUntilDone:YES];
            return;
        }
        if (processResult.success == YES) {
            // For success result, call handleNormalCorrectResponse:
            [self performSelectorOnMainThread:@selector(handleNormalCorrectResponse:) withObject:processResult waitUntilDone:NO];
        } else {
            // For error result, call handleNormalErrorResponse:
            [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
        }
    }
    @catch (NSException *exception) {
        // Populating any exception reason into dictionary with key "error" and call handleNormalErrorResponse:
        NSString* errorStr;
        errorStr = exception.reason;
        if (processResult == nil) {
            processResult = [XYProcessResult new];
        }
        [processResult.params setValue:errorStr forKey:@"error"];
        [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
    }
}

/*
 Method to handle correct response.
 Do not overwrite it in subclasses, use handleCorrectResponse: instead
 */
-(void)handleNormalCorrectResponse:(XYProcessResult*) result{
    [self turnOffBusyFlag];
    [self handleCorrectResponse:result];
}

/*
 Method to handle error response
 Do not overwrite it in subclasses, use handleErrorResponse: instead
 */
-(void)handleNormalErrorResponse:(XYProcessResult*) result{
    [self turnOffBusyFlag];
    [self handleErrorResponse:result];
}

/*
 Customizing method for correct response returned
 */
-(void)handleCorrectResponse:(XYProcessResult*) result{
}

/*
 Customizing method for error response returned
 */
-(void)handleErrorResponse:(XYProcessResult*) result{
    NSString* error = [result.params objectForKey:@"error"];
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:error message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* otherAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:otherAction];
    [self presentViewController:ac animated:YES completion:nil];
}
@end

#pragma mark XYSelectorObject
@implementation XYSelectorObject
@synthesize object;
-(id)initWithSEL:(SEL)selector target:(id)target{
    if (self = [super init]) {
        _selectorValue = [NSValue valueWithBytes:&selector objCType:@encode(SEL)];
        _target = target;
    }
    return self;
}

-(void)performSelector{
    if (_selectorValue != NULL && [_target respondsToSelector:_selectorValue.pointerValue]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_selectorValue.pointerValue withObject:self.object];
#pragma clang diagnostic pop
    }
}
@end


#pragma mark XYBaseTvcItem
@implementation XYBaseTvcItem
{
@protected
    XYSelectorObject* _onClickSelector;
}
@synthesize identifier = _identifier;
@synthesize view = _view;
@synthesize height = _height;
@synthesize onClickSelector = _onClickSelector;
-(id)initWithIdentifer:(NSString*)identifier{
    if (self = [super init]){
        _identifier = identifier;
    }
    return self;
}
-(id)initWithIdentifer:(NSString*)identifier view:(UIView*)view{
    if (self = [super init]){
        _identifier = identifier;
        _view = view;
    }
    return self;
}
-(id)initWithIdentifer:(NSString*)identifier view:(UIView*)view height:(CGFloat) height{
    if (self = [super init]){
        _identifier = identifier;
        _view = view;
        _height = height;
    }
    return self;
}
-(void)addTarget:(id)target action:(SEL) selector{
    _onClickSelector = [[XYSelectorObject alloc] initWithSEL:selector target:target];
}
@end

#pragma mark XYOptionTvcItem
@implementation XYOptionTvcItem
@synthesize imgName;
@synthesize optionName;
@synthesize optionText;
@end

#pragma mark XYBaseTableVc
@implementation XYBaseTableVc
{
    BOOL isStatusUpdaterEnabled;
//    MBProgressHUD* hud;
    BOOL _enableRefresh;
}
@synthesize busyProcessTitle;
@synthesize showActivityIndicatorView;
@synthesize enableRefresh = _enableRefresh;
- (void)viewDidLoad {
    [super viewDidLoad];
    // By default the alert view will be shown
    self.showActivityIndicatorView = YES;
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    UIImage* image = [UIImage imageNamed:@"whiteDot.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    //    If native refresh controller needed, uncomment below
    //    self.refreshControl = [UIRefreshControl new];
    //    [self.refreshControl addTarget:self action:@selector(baseRefresh:) forControlEvents:UIControlEventValueChanged];
    
    self.enableRefresh = YES;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", @"back") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}

-(void)setEnableRefresh:(BOOL)enableRefresh{
    /* enable refresh here */
    _enableRefresh = enableRefresh;
    if (self.enableRefresh){
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self baseRefresh:self.refreshControl];
//        }];
    } else {
//        self.tableView.mj_header = nil;
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)baseRefresh:(UIRefreshControl*)refreshControl{
    [refreshControl beginRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self refresh:refreshControl];
    [refreshControl endRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [self.tableView.mj_header endRefreshing];
}

// To be implemented by subclass
-(void)refresh:(UIRefreshControl*)refreshControl{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* viewInSections = [sections objectAtIndex:section];
    return viewInSections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* viewInSections = [sections objectAtIndex:indexPath.section];
    XYBaseTvcItem* item = [viewInSections objectAtIndex:indexPath.row];
    NSString* identifier = item.identifier;
    UITableViewCell* baseCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (item.tableViewCellForRowAtIndexPath != nil) {
        return item.tableViewCellForRowAtIndexPath(tableView, baseCell, indexPath);
    } else {
        return baseCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray* viewInSections = [sections objectAtIndex:indexPath.section];
    XYBaseTvcItem* item = [viewInSections objectAtIndex:indexPath.row];
    return item.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray* views = [sections objectAtIndex:indexPath.section];
    XYBaseTvcItem* item = [views objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[XYOptionTvcItem class]]){
        XYOptionTvcItem* opt = (XYOptionTvcItem*)item;
        if (opt.onClickSelector != nil) {
            [opt.onClickSelector performSelector];
        }
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)turnOnBusyFlag{
    /* show activity indicator here */
//    if (self.navigationController != nil) {
//        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//    } else {
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    }
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = [UIColor clearColor];
    
    // Disable all interaction
    self.view.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)turnOffBusyFlag{
    /* hide activity indicator here */
//    [hud hideAnimated:YES];
    
    // Enable interaction
    self.view.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

/*
 Method of executing a callback block
 */
-(void)performBusyProcess:(XYProcessResult*(^)(void))block{
    if (showActivityIndicatorView == YES) {
        isStatusUpdaterEnabled = NO;
        [self turnOnBusyFlag];
    }
    // Rune callback in background
    [NSThread detachNewThreadSelector:@selector(performBusyProcessInBackground:) toTarget:self withObject:block];
}

/*
 Method of executing a callback block in background
 */
-(void)performBusyProcessInBackground:(XYProcessResult*(^)(void))block{
    if (block == nil) {
        return;
    }
    XYProcessResult* (^progressBlock)() = block;
    XYProcessResult* processResult;
    @try {
        processResult = progressBlock();
        if (processResult == nil) {
            // If no process result return, end immediately
            [self performSelectorOnMainThread:@selector(turnOffBusyFlag) withObject:nil waitUntilDone:YES];
            return;
        }
        if (processResult.success == YES) {
            // For success result, call handleNormalCorrectResponse:
            [self performSelectorOnMainThread:@selector(handleNormalCorrectResponse:) withObject:processResult waitUntilDone:NO];
        } else {
            // For error result, call handleNormalErrorResponse:
            [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
        }
    }
    @catch (NSException *exception) {
        // Populating any exception reason into dictionary with key "error" and call handleNormalErrorResponse:
        NSString* errorStr;
        errorStr = exception.reason;
        if (processResult == nil) {
            processResult = [XYProcessResult new];
        }
        [processResult.params setValue:errorStr forKey:@"error"];
        [self performSelectorOnMainThread:@selector(handleNormalErrorResponse:) withObject:processResult waitUntilDone:NO];
    }
}

/*
 Method to handle correct response.
 Do not overwrite it in subclasses, use handleCorrectResponse: instead
 */
-(void)handleNormalCorrectResponse:(XYProcessResult*) result{
    [self turnOffBusyFlag];
    [self handleCorrectResponse:result];
}

/*
 Method to handle error response
 Do not overwrite it in subclasses, use handleErrorResponse: instead
 */
-(void)handleNormalErrorResponse:(XYProcessResult*) result{
    [self turnOffBusyFlag];
    [self handleErrorResponse:result];
}

/*
 Customizing method for correct response returned
 */
-(void)handleCorrectResponse:(XYProcessResult*) result{
}

/*
 Customizing method for error response returned
 */
-(void)handleErrorResponse:(XYProcessResult*) result{
    NSString* error = [result.params objectForKey:@"error"];
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:error message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* otherAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:otherAction];
    [self presentViewController:ac animated:YES completion:nil];
}
@end

#pragma mark XYBaseNavigationVc
@implementation XYBaseNavigationVc

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}
@end

#pragma mark XYBaseTabBarVc
@implementation XYBaseTabBarVc

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark XYCoreDataConnector
@implementation XYCoreDataConnector
@synthesize storeName = _storeName;
@synthesize modelName = _modelName;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(id)initWithModelName:(NSString*)model storeName:(NSString*) name{
    if (self = [super init]) {
        @try {
            NSURL* modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
            if (modelURL == nil) {
                @throw [NSException exceptionWithName:@"ModelNotFound" reason:@"Model file not found!" userInfo:nil];
            }
            _modelName = model;
            _storeName = name;
            
            // Initialize Model
            _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            
            // Initialize Store Coordinator
            NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:_storeName];
            
            _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
            
            // Automatic migration
            NSDictionary* optionsDictionary =
            [NSDictionary dictionaryWithObjectsAndKeys:
             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
             NSFileProtectionComplete, NSFileProtectionKey,
             nil];
            
            NSError* error = nil;
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
                @throw [NSException exceptionWithName:@"addPersistentStoreWithTypeError" reason:error.description userInfo:nil];
            }
            
            // Initialize Context
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
        }
        @catch (NSException *exception) {
            
            //            [[XYBaseErrorCenter instance] recordErrorWithTitle:@"XYCoreDataConnector Error" detail:exception.reason level:XYErrorLevelFatal];
            @throw exception;
        }
    }
    return self;
}

-(NSURL*)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    @try {
        if (managedObjectContext != nil) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.debugDescription);
        //        [[XYBaseErrorCenter instance] recordErrorWithTitle:@"XYCoreDataConnector Error saveContext" detail:[NSString stringWithFormat:@"Reason:%@ Callstack:%@",exception.reason,exception.callStackSymbols] level:XYErrorLevelFatal];
    }
}

-(void)resetPersistentStore{
    //Erase the persistent store from coordinator and also file manager.
    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
    if (store == nil) {
        return;
    }
    NSError *error = nil;
    NSURL *storeURL = store.URL;
    [self.persistentStoreCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    [self persistentStoreCoordinator];
}

-(NSArray*)getObjectsFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameter: (NSString *) predicateParameter{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    
    entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Form the Predicate
    NSPredicate *predicate = nil;
    if(![predicateString isEqualToString:@""] && predicateParameter!=nil)
    {
        predicate = [NSPredicate predicateWithFormat:
                     predicateString, predicateParameter];
        [fetchRequest setPredicate:predicate];
    }
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

-(NSManagedObject*)getSingleObjectFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameter: (NSString *) predicateParameter{
    NSArray* result = [self getObjectsFromDatabase:className WithPredicate:predicateString AndParameter:predicateParameter];
    if (result != nil && result.count > 0) {
        return [result objectAtIndex:0];
    } else {
        return nil;
    }
}

-(NSArray*)getObjectsFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameterArray: (NSArray *) predicateParameterArr{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity;
    
    entity = [NSEntityDescription entityForName:NSStringFromClass(className) inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Form the Predicate
    NSPredicate *predicate = nil;
    if(![predicateString isEqualToString:@""] && predicateParameterArr!=nil)
    {
        predicate = [NSPredicate predicateWithFormat:predicateString argumentArray:predicateParameterArr];
        [fetchRequest setPredicate:predicate];
    }
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
}

-(NSManagedObject*)getSingleObjectFromDatabase: (Class) className WithPredicate: (NSString *) predicateString AndParameterArray: (NSArray *) predicateParameterArr{
    NSArray* result = [self getObjectsFromDatabase:className WithPredicate:predicateString AndParameterArray:predicateParameterArr];
    if (result != nil && result.count > 0) {
        return [result objectAtIndex:0];
    } else {
        return nil;
    }
}

-(NSManagedObject*)getNewObjectForInsertByClass:(Class)className{
    return [NSEntityDescription insertNewObjectForEntityForName:[className description] inManagedObjectContext:self.managedObjectContext];
}
@end

#pragma mark XYCoreDataManager
static XYCoreDataManager* dminstance;

@implementation XYCoreDataManager
{
    NSMutableDictionary* coreDataCache;
}
+(XYCoreDataManager*)instance{
    if (dminstance == nil) {
        dminstance = [XYCoreDataManager new];
    }
    return dminstance;
}

-(void)initCoreDataConnectorWithModel:(NSString*) model storeName:(NSString *)name asAlias:(NSString*)alias{
    if (coreDataCache == nil) {
        coreDataCache = [NSMutableDictionary new];
    }
    
    if ([coreDataCache objectForKey:alias] == nil) {
        XYCoreDataConnector* connector = [[XYCoreDataConnector alloc] initWithModelName:model storeName:name];
        [coreDataCache setObject:connector forKey:alias];
    }
}

// Get CoreDataConnector by alias name
-(XYCoreDataConnector*)connectorByAlias:(NSString*)alias{
    return [self connectorByAlias:alias newContext:YES];
}

// Get CoreDataConnector by alias name
-(XYCoreDataConnector*)connectorByAlias:(NSString*)alias newContext:(BOOL) newContext{
    XYCoreDataConnector* connector = [coreDataCache objectForKey:alias];
    if (connector == nil) {
        //        [[XYBaseErrorCenter instance] recordErrorWithTitle:@"XYCoreDataConnector Error" detail:@"connectorByAlias return nil"];
        return nil;
        //@throw [NSException exceptionWithName:@"NilXYCoreDataConnector" reason:@"connectorByAlias got nil connect" userInfo:nil];
    }
    if (newContext) {
        return [[XYCoreDataConnector alloc] initWithModelName:connector.modelName storeName:connector.storeName];
    }
    
    return connector;
}

// Remove connector
-(void)removeConnectorByAlias:(NSString*)alias{
    [coreDataCache removeObjectForKey:alias];
}

-(void)removeAllConnectors{
    [coreDataCache removeAllObjects];
}
@end

#pragma mark XYRequest
@implementation XYRequest
@synthesize userId;
@synthesize requestTime;
@synthesize bodyDict;
-(id)init{
    if (self = [super init]){
        self.bodyDict = [NSMutableDictionary new];
    }
    return self;
}
@end

#pragma mark Response
@implementation XYResponse
@synthesize responseCode;
@synthesize responseDesc;
@end

#pragma mark XYHTTPRequestObject
@implementation XYHTTPRequestObject
@synthesize requestURL = _requestURL;
@synthesize policy = _policy;
@synthesize timeout = _timeout;
@synthesize httpMethod = _httpMethod;
@synthesize headers = _headers;
@synthesize body = _body;
@end

#pragma mark XYHTTPResponseObject
@implementation XYHTTPResponseObject
@synthesize data = _data;
@synthesize response = _response;
-(id)initWithData:(NSData*)data urlResponse:(NSURLResponse*)response{
    if (self = [super init]) {
        _data = data;
        _response = response;
    }
    return self;
}
@end

#pragma mark XYConnection
@implementation XYConnection
{
    NSURLResponse* _urlresponse;
    NSMutableData* _data;
    BOOL _finished;
}
-(id)init{
    if (self = [super init]) {
        _data = [NSMutableData new];
    }
    return self;
}

-(XYHTTPResponseObject*)sendRequest:(XYHTTPRequestObject *)reqObj{
    
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:reqObj.requestURL cachePolicy:reqObj.policy timeoutInterval:reqObj.timeout];
    urlRequest.HTTPMethod = reqObj.httpMethod;
    // Header data
    for (NSString* header in [reqObj.headers allKeys]) {
        [urlRequest setValue:[reqObj.headers valueForKey:header] forHTTPHeaderField:header];
    }
    // Request data
    // Encrypt body
    NSString* dataStr = [[NSString alloc] initWithData:reqObj.body encoding:NSUTF8StringEncoding];
//    dataStr = [Utility encrypt:dataStr key:APP_KEY initVect:APP_IV];
    NSData* encryptedData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:encryptedData];
    
    // Here should set cache policy
    //    urlRequest.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    NSURLResponse* uresponse;
    __block NSData* responseData;
    @try {
        
        dispatch_semaphore_t semaphore =dispatch_semaphore_create(0);
        NSURLSession* session = [NSURLSession sharedSession];
        NSURLSessionDataTask* task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            responseData = data;
            dispatch_semaphore_signal(semaphore);
        }];
        [task resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    dataStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    XYHTTPResponseObject* response = [[XYHTTPResponseObject alloc] initWithData:responseData urlResponse:uresponse];
    return response;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _urlresponse = response;
    [_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _finished = NO;
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    _finished = YES;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _finished = YES;
}

-(void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    } else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodClientCertificate]) {
        if (challenge.previousFailureCount == 0) {
            
        } else {
            [challenge.sender rejectProtectionSpaceAndContinueWithChallenge:challenge];
        }
    } else if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault]) {
        [challenge.sender rejectProtectionSpaceAndContinueWithChallenge:challenge];
    } else {
        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
    }
    if (challenge.previousFailureCount > 2) {
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}
@end

#pragma mark XYConnector
@implementation XYConnector
{
    NSURL* _url;
    NSString* _urlString;
}
@synthesize url = _url;
@synthesize connection = _connection;
-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithConnector:(XYConnector *)connector{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithURL:(NSString *)url{
    if (self = [super init]) {
        _urlString = url;
        _url = [NSURL URLWithString:_urlString];
    }
    return self;
}

-(void)refreshWithURL:(NSString *)url{
    _urlString = url;
    _url = [NSURL URLWithString:_urlString];
}

-(void)connectNow{
    
}
@end

static XYConnectorManager* cminstance;

#pragma mark XYConnectorManager
@implementation XYConnectorManager
{
    // For cache the connector
    NSMutableDictionary* _gatewayCache;
}
+(XYConnectorManager*)instance{
    if (cminstance == nil) {
        cminstance = [XYConnectorManager new];
    }
    return cminstance;
}

-(id)init{
    if (self = [super init]) {
        _gatewayCache = [NSMutableDictionary new];
    }
    return self;
}

-(void)initConnectorWithURL:(NSString *)url asAlias:(NSString*)alias{
    if ([_gatewayCache objectForKey:alias] != nil) {
        [_gatewayCache removeObjectForKey:alias];
    }
    XYConnector* connector = [[XYConnector alloc] initWithURL:url];
    [_gatewayCache setObject:connector forKey:alias];
}

-(void)refreshConnectorWithURL:(NSString *)url forAlias:(NSString *)alias{
    XYConnector* connector = [_gatewayCache objectForKey:alias];
    if (connector != nil) {
        [connector refreshWithURL:url];
    } else {
        connector = [[XYConnector alloc] initWithURL:url];
        [_gatewayCache setObject:connector forKey:alias];
    }
}


-(XYConnector*)connectorByAlias:(NSString*)alias{
    XYConnector* connector = [_gatewayCache objectForKey:alias];
    return connector;
}

-(XYConnector*)newConnectorByAlias:(NSString *)alias{
    XYConnector* connector = [_gatewayCache objectForKey:alias];
    XYConnector* newConnector = [[XYConnector alloc] initWithConnector:connector];
    return newConnector;
}

-(void)addConnector:(XYConnector*) connector asAlias:(NSString*) alias{
    [_gatewayCache setObject:connector forKey:alias];
}

-(void)removeConnectorByAlias:(NSString*)alias{
    [_gatewayCache removeObjectForKey:alias];
}

-(void)removeAllConnectors{
    [_gatewayCache removeAllObjects];
}
@end

#pragma mark XYMessageAgent
@implementation XYMessageAgent
-(void)normalize:(XYRequest*)request to:(XYHTTPRequestObject*) requestObj{
    if (request.userId != nil) {
        [request.bodyDict setObject:request.userId forKey:@"userId"];
    }
}
-(void)deNormalize:(XYHTTPResponseObject*)responseObj to:(XYResponse**)response{
    NSDictionary* repObj = [NSJSONSerialization JSONObjectWithData:responseObj.data options:NSJSONReadingMutableContainers error:nil];
    NSString* code = [repObj objectForKey:@"code"];
    NSString* desc = [repObj objectForKey:@"desc"];
    (*response).responseDesc = desc;
    (*response).responseCode = code.integerValue;
}
@end


#pragma mark XYMessageConfig
@implementation XYMessageConfig
@synthesize relativePath;
@synthesize httpMethod;
@end

#pragma mark XYMessageEngine
static XYMessageEngine* meinstance;

@implementation XYMessageEngine
{
    NSMutableDictionary* _messageStage;
    NSMutableDictionary* _messageConfigMapping;
}
@synthesize runningStage = _runningStage;
@synthesize messageStage = _messageStage;
@synthesize messageConfigMapping = _messageConfigMapping;
@synthesize delegate = _delegate;

+(XYMessageEngine*)instance{
    if (meinstance == nil) {
        meinstance = [XYMessageEngine new];
    }
    return meinstance;
}

-(id)init{
    if (self = [super init]) {
        _messageStage = [NSMutableDictionary new];
        _messageConfigMapping = [NSMutableDictionary new];
    }
    return self;
}

-(void)setConnector:(XYConnector *)connector forStage:(MessageStage)stage{
    [_messageStage setObject:connector forKey:[NSNumber numberWithInteger:stage]];
}

-(void)removeConnectorOfStage:(MessageStage)stage{
    [_messageStage removeObjectForKey:[NSNumber numberWithInteger:stage]];
}

-(void)setConfig:(XYMessageConfig*)config forMessage:(Class)messageClass{
    [_messageConfigMapping setObject:config forKey:NSStringFromClass(messageClass)];
}

-(void)removeConfigOfMessage:(Class)messageClass{
    [_messageConfigMapping removeObjectForKey:NSStringFromClass(messageClass)];
}

/**
 
 */
-(XYResponse*)send:(XYRequest *)request{
    
    // Get message name from request class
    NSString* messageClassName = NSStringFromClass(request.class);
    NSString* messageName = [XYMessageEngine getMessageNameFrom:messageClassName];
    
    if (_runningStage == MessageStageDemo) {
        // If demo mode, return pre-defined response
        id<XYMessageAgent> agent = (id<XYMessageAgent>)[XYMessageEngine getMessageFormatterByName:messageName];
        return [agent demoResponse];
    }
    
    // Request/Response object
    XYResponse* response;
    XYHTTPRequestObject* req = [XYHTTPRequestObject new];
    XYHTTPResponseObject* res = [XYHTTPResponseObject new];
    
    XYConnector* connector = [_messageStage objectForKey:[NSNumber numberWithInt:_runningStage]];
    
    if (connector == nil) {
        // No connector available
        return nil;
    }
    
    XYMessageConfig* mc = [_messageConfigMapping objectForKey:messageClassName];
    NSString* url = [connector.url absoluteString];
    
    // Get URL configuration
    if (mc.relativePath != nil) {
        url = [NSString stringWithFormat:@"%@/%@",url,mc.relativePath];
    }
    
    req.requestURL = [NSURL URLWithString:url];
    
    // Default timeout
    req.timeout = 5;
    
    // Default method
    req.httpMethod = mc.httpMethod == nil ? @"GET" : mc.httpMethod;
    
    // Default header
    NSDictionary* header = @{@"Content-Type":@"application/json"};
    req.headers = header;
    
    @try {
        id<XYMessageAgent> agent = (id<XYMessageAgent>)[XYMessageEngine getMessageFormatterByName:messageName];
        if (agent != nil) {
            [agent normalize:request to:req];
        }
        
        if (self.delegate != nil) {
            NSString* reqStr = [[NSString alloc] initWithData:req.body encoding:NSUTF8StringEncoding];
            [self.delegate log:[NSString stringWithFormat:@"Request:%@\n Heads:%@\nBody:%@",url, header, reqStr]];
        }
        
        res = [connector.connection sendRequest:req];
        
        NSString* resStr = [[NSString alloc] initWithData:res.data encoding:NSUTF8StringEncoding];
        
        if (self.delegate != nil) {
            [self.delegate log:[NSString stringWithFormat:@"Response:%@",resStr]];
        }
        
        if ([res.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse* response = (NSHTTPURLResponse*)res.response;
            if (response.statusCode != 200) {
                @throw [NSException exceptionWithName:@"HTTP response error" reason:[NSString stringWithFormat:@"HTTP response:%ld",(long)response.statusCode] userInfo:nil];
            }
        }
        if (agent != nil) {
            [agent deNormalize:res to:&response];
        }
    }
    @catch (NSException *exception) {
        if (self.delegate != nil) {
            [self.delegate log:[NSString stringWithFormat:@"Error:%@",exception.description]];
        }
    }
    if (response == nil) {
        response = [XYResponse new];
        response.responseCode = 101;
        response.responseDesc = NSLocalizedString(@"nilResponse", @"nilResponse");
    }
    return response;
}

+(id<XYMessageAgent>)getMessageFormatterByName:(NSString*)name{
    NSString* request_class_name =  [self getMessageFormatterClassNameByName:name];
    id request_class = [[NSClassFromString(request_class_name) alloc] init];
    return request_class;
    
}

+(NSString*)getMessageFormatterClassNameByName:(NSString*)name{
    if (name == nil || [name isEqualToString:@""]) {
        name = @"";
    }
    NSString* request_class_name = @"##_TYPE_##MessageAgent";
    request_class_name = [request_class_name stringByReplacingOccurrencesOfString:@"##_TYPE_##" withString:name];
    return request_class_name;
}

+(NSString*)getMessageNameFrom:(NSString*)className{
    NSArray* result = [XYUtility matchStringListOfString:className matchRegularExpression:@"(.*)(Request|Response)"];
    if (result.count > 0) {
        return [result objectAtIndex:0];
    }
    return @"";
}
@end

#pragma mark NSString+category
@implementation NSString(category)
-(NSString*)sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

-(NSString*)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

// Uncomment below if GTMBase64.h imported

//-(NSString*)sha1_base64 {
//    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
//    NSData *data = [NSData dataWithBytes:cstr length:self.length];
//    
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//    
//    CC_SHA1(data.bytes, data.length, digest);
//    
//    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
//    base64 = [GTMBase64 encodeData:base64];
//    
//    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
//    return output;
//}

//-(NSString*)md5_base64 {
//    const char *cStr = [self UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, strlen(cStr), digest );
//    
//    NSData * base64 = [[NSData alloc]initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
//    base64 = [GTMBase64 encodeData:base64];
//    
//    NSString * output = [[NSString alloc] initWithData:base64 encoding:NSUTF8StringEncoding];
//    return output;
//}

//-(NSString*)base64 {
//    NSData * data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    data = [GTMBase64 encodeData:data];
//    NSString * output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return output;
//}

-(NSString*)trim{
    NSString *cleanString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return cleanString;
}
@end