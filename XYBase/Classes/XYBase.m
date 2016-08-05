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

+(BOOL)isNumber:(NSString*)field{
    return [[NSNumberFormatter new] numberFromString:field] != nil;
}

+(UIView*)mainWindowView{
    UIWindow* w = [[UIApplication sharedApplication] keyWindow];
    if (w.subviews.count > 0) {
        return [w.subviews objectAtIndex:0];
    } else {
        return w;
    }
}

+(CGSize)sizeOfText:(NSString*)text withFont:(UIFont*) font constrainedSize:(CGSize)constrainedSize{
    
    if (text == nil || font == nil) {
        return CGSizeZero;
    }
    
    CTFontRef ref = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    
    NSMutableDictionary *attrDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge id)ref, (NSString *)kCTFontAttributeName, nil];
    
    NSAttributedString* s = [[NSAttributedString alloc] initWithString:text attributes:attrDictionary];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)s);
    
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [text length]), NULL, constrainedSize, NULL);
    
    textSize.height = ceil(textSize.height);
    textSize.width = ceil(textSize.width);
    
    return textSize;
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
//    NSString *result = [GTMBase64 stringByEncodingData:myData];
//    return result;
//}
//
//
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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LS(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
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
    [self performBusyProcess:block busyFlag:YES completion:nil];
}

-(void)performBusyProcess:(XYProcessResult*(^)(void))block busyFlag:(BOOL)flag completion:(void (^)(XYProcessResult* result))completion{
    
    if (showActivityIndicatorView == YES && flag) {
        isStatusUpdaterEnabled = NO;
        [self turnOnBusyFlag];
    }
    // Run callback in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (block == nil) {
            return;
        }
        XYProcessResult* (^progressBlock)() = block;
        XYProcessResult* processResult;
        @try {
            processResult = progressBlock();
            if (processResult == nil) {
                // If no process result return, end immediately
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (flag) {
                        [self turnOffBusyFlag];
                    }
                });
            }
            if (processResult.success == YES) {
                // For success result, call handleNormalCorrectResponse:
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (flag) {
                        [self turnOffBusyFlag];
                    }
                    if (completion==nil) {
                        [self handleCorrectResponse:processResult];
                    } else {
                        completion(processResult);
                    }
                });
            } else {
                // For error result, call handleNormalErrorResponse:
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (flag) {
                        [self turnOffBusyFlag];
                    }
                    if (completion==nil) {
                        [self handleErrorResponse:processResult];
                    } else {
                        completion(processResult);
                    }
                });
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
            dispatch_async(dispatch_get_main_queue(), ^{
                if (flag) {
                    [self turnOffBusyFlag];
                }
                if (completion==nil) {
                    [self handleErrorResponse:processResult];
                } else {
                    completion(processResult);
                }
            });
        }
    });
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
@synthesize noDataView = _noDataView;
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
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LS(@"back") style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self.view addSubview:self.noDataView];
    [self setNoDataViewHidden:YES];
}

-(void)setNoDataViewHidden:(BOOL)hidden{
    self.noDataView.hidden = hidden;
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
    if (item.onClickSelector != nil) {
        [item.onClickSelector performSelector];
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
    [self performBusyProcess:block busyFlag:YES completion:nil];
}

-(void)performBusyProcess:(XYProcessResult*(^)(void))block busyFlag:(BOOL)flag completion:(void (^)(XYProcessResult* result))completion{
    
    if (showActivityIndicatorView == YES && flag) {
        isStatusUpdaterEnabled = NO;
        [self turnOnBusyFlag];
    }
    // Run callback in background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (block == nil) {
            return;
        }
        XYProcessResult* (^progressBlock)() = block;
        XYProcessResult* processResult;
        @try {
            processResult = progressBlock();
            if (processResult == nil) {
                // If no process result return, end immediately
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (flag) {
                        [self turnOffBusyFlag];
                    }
                });
            }
            if (processResult.success == YES) {
                // For success result, call handleNormalCorrectResponse:
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (flag) {
                        [self turnOffBusyFlag];
                    }
                    if (completion==nil) {
                        [self handleCorrectResponse:processResult];
                    } else {
                        completion(processResult);
                    }
                });
            } else {
                // For error result, call handleNormalErrorResponse:
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (flag) {
                        [self turnOffBusyFlag];
                    }
                    if (completion==nil) {
                        [self handleErrorResponse:processResult];
                    } else {
                        completion(processResult);
                    }
                });
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
            dispatch_async(dispatch_get_main_queue(), ^{
                if (flag) {
                    [self turnOffBusyFlag];
                }
                if (completion==nil) {
                    [self handleErrorResponse:processResult];
                } else {
                    completion(processResult);
                }
            });
        }
    });
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
@synthesize enableEncryptionBy3DES;
@synthesize key24;
@synthesize vector8;

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
    
    if (enableEncryptionBy3DES) {
//        dataStr = [XYUtility encrypt:dataStr key:key24 initVect:vector8];
    }
    
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

-(id)initWithPath:(NSString*)path method:(NSString*)method{
    if (self = [super init]){
        self.relativePath = path;
        self.httpMethod = method;
    }
    return self;
}
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

-(void)setConfigPath:(NSString*)path method:(NSString*)method forMessage:(Class)messageClass{
    XYMessageConfig* config = [[XYMessageConfig alloc] initWithPath:path method:method];
    [self setConfig:config forMessage:messageClass];
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
        response.responseDesc = LS(@"nilResponse");
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

@implementation UIColor (Hex)
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
@end

@implementation XYUISegmentedControl
@synthesize selectedView = _selectedView;
@synthesize separateView = _separateView;
@synthesize selectedFontColor = _selectedFontColor;
@synthesize unSelectedFontColor = _unSelectedFontColor;
@synthesize selectedTitleFont = _selectedTitleFont;
@synthesize unSelectedTitleFont = _unSelectedTitleFont;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
-(id)initWithItems:(NSArray *)items{
    if (self = [super initWithItems:items]) {
        
    }
    return self;
}

-(void)renderView{
    //    NSBackgroundColorAttributeName
    //    [self setTintColor:[UIColor clearColor]];
    
    NSMutableDictionary* attributes = [NSMutableDictionary new];
    if (_selectedTitleFont != nil) {
        [attributes setObject:_selectedTitleFont forKey:NSFontAttributeName];
    }
    if (_selectedFontColor != nil) {
        [attributes setObject:_selectedFontColor forKey:NSForegroundColorAttributeName];
    }
    [self setTitleTextAttributes:attributes forState:UIControlStateSelected];
    
    attributes = [NSMutableDictionary new];
    if (_unSelectedTitleFont != nil) {
        [attributes setObject:_unSelectedTitleFont forKey:NSFontAttributeName];
    }
    if (_unSelectedFontColor != nil) {
        [attributes setObject:_unSelectedFontColor forKey:NSForegroundColorAttributeName];
    }
    [self setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (_separateView != nil) {
        CGFloat width = self.bounds.size.width / self.numberOfSegments;
        NSUInteger count = self.numberOfSegments - 1;
        for (int i = 1; i <= count; i++) {
            UIView* v = [self duplicateView:_separateView];
            CGRect f = CGRectMake(i * width - (_separateView.bounds.size.width/2.0), (self.bounds.size.height - _separateView.bounds.size.height)/2.0 , _separateView.bounds.size.width,_separateView.bounds.size.height);
            v.frame = f;
            [self addSubview:v];
            
        }
    }
}

-(void)valueChanged:(XYUISegmentedControl*)segmentCtrl{
    if (_selectedView != nil) {
        CGRect f = _selectedView.frame;
        f.size.width = self.bounds.size.width / self.numberOfSegments;
        f.origin.x = segmentCtrl.selectedSegmentIndex * f.size.width;
        _selectedView.frame = f;
        [self addSubview:_selectedView];
    }
}

-(UIView*)duplicateView:(UIView*)view{
    NSData* viewData = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:viewData];
}
@end

@implementation XYSortUIButton
@synthesize sortType = _sortType;
@synthesize ascendingImg;
@synthesize descendingImg;
@synthesize noneSortImg;

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        _sortType = SortTypeNone;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        _sortType = SortTypeNone;
    }
    return self;
}

-(void)renderView{
    if (_sortType == SortTypeNone) {
        [self setImage:self.noneSortImg forState:UIControlStateNormal];
    } else if (_sortType == SortTypeAscending) {
        [self setImage:self.ascendingImg forState:UIControlStateNormal];
    } else if (_sortType == SortTypeDescending) {
        [self setImage:self.descendingImg forState:UIControlStateNormal];
    }
}

-(void)setSortType:(SortType)sortType{
    _sortType = sortType;
    [self renderView];
}

-(void)btnClicked:(XYSortUIButton*)sender{
    if (_sortType == SortTypeNone) {
        _sortType = SortTypeAscending;
    } else if (_sortType == SortTypeAscending) {
        _sortType = SortTypeDescending;
    } else if (_sortType == SortTypeDescending) {
        _sortType = SortTypeNone;
    }
    [self renderView];
}
@end

@implementation XYSelectUIButton
@synthesize selectType = _selectType;
@synthesize selectedImg;
@synthesize deselectedImg;

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
//        [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
        _selectType = SelectTypeDeselected;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _selectType = SelectTypeDeselected;
    }
    return self;
}

-(void)renderView{
    if (_selectType == SelectTypeSelected) {
        [self setImage:self.selectedImg forState:UIControlStateNormal];
    } else if (_selectType == SelectTypeDeselected) {
        [self setImage:self.deselectedImg forState:UIControlStateNormal];
    }
}

-(void)setSelectType:(SelectType)selectType{
    _selectType = selectType;
    [self renderView];
}
@end

@implementation XYImageUIButton
{
    UIImageView* _buttonImageView;
    UILabel* _buttonLabel;
}
@synthesize buttonImageView = _buttonImageView;
@synthesize buttonLabel = _buttonLabel;

-(id)init{
    if (self = [super init]) {
        [self renderView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self renderView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self renderView];
    }
    return self;
}

-(void)renderView{
    _buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 20)/2.0, 30, 20, 20)];
    _buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 40, self.frame.size.width, 30)];
    _buttonLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:_buttonImageView];
    [self addSubview:_buttonLabel];
}

-(void)setButtonImageViewSize:(CGSize)buttonImageViewSize{
    CGRect f = CGRectMake((self.frame.size.width - buttonImageViewSize.width)/2.0, 30, buttonImageViewSize.width, buttonImageViewSize.height);
    _buttonImageView.frame = f;
}

-(CGSize)buttonImageViewSize{
    return _buttonImageView.bounds.size;
}
@end

@implementation XYUITextField
@synthesize insetSize;

-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, insetSize.width, insetSize.height);
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, insetSize.width, insetSize.height);
}
@end

@implementation XYDatePickerUITextField
{
    UIView* _inputView;
    UIDatePicker* _datePicker;
    UIToolbar* _toolBar;
}
@synthesize datePicker = _datePicker;
-(id)init{
    if (self = [super init]) {
        [self renderView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self renderView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self renderView];
    }
    return self;
}

-(void)renderView{
    if (_inputView == nil) {
        _inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 250)];
    }
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 250-40)];
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [_datePicker addTarget:self action:@selector(updateDateValue) forControlEvents:UIControlEventValueChanged];
        _datePicker.backgroundColor = [UIColor whiteColor];
    }
    if (_toolBar == nil) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _toolBar.backgroundColor = [UIColor whiteColor];
        UIBarButtonItem* clear = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(clearValue)];
        UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
        _toolBar.items = [NSArray arrayWithObjects:clear, space, done, nil];
        [_inputView addSubview:_toolBar];
        [_inputView addSubview:_datePicker];
    }
    self.inputView = _inputView;
}

-(void)updateDateValue{
    NSDateFormatter* nsdf = [NSDateFormatter new];
    NSString* now = @"";
    if (_datePicker.datePickerMode == UIDatePickerModeDate) {
        [nsdf setDateStyle:NSDateFormatterShortStyle];
        [nsdf setDateFormat:@"yyyy-MM-dd"];
        now = [nsdf stringFromDate:_datePicker.date];
    }  else if (_datePicker.datePickerMode == UIDatePickerModeTime) {
        [nsdf setDateStyle:NSDateFormatterShortStyle];
        [nsdf setDateFormat:@"HH:mm:ss"];
        now = [nsdf stringFromDate:_datePicker.date];
    } else if (_datePicker.datePickerMode == UIDatePickerModeDateAndTime) {
        [nsdf setDateStyle:NSDateFormatterShortStyle];
        [nsdf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        now = [nsdf stringFromDate:_datePicker.date];
    }
    self.text = now;
}

-(void)clearValue{
    self.text = @"";
    _datePicker.date = [NSDate dateWithTimeIntervalSinceNow:0];
    [self resignFirstResponder];
}

-(void)done{
    [self resignFirstResponder];
}
@end

@implementation XYStarRatingView
@synthesize imageSize;
@synthesize selectedImage;
@synthesize unSelectedImage;
@synthesize totalNumber;
@synthesize currentNumber;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}


-(void)renderView{
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
    CGPoint p = CGPointZero;
    for (int i = 0 ; i<self.totalNumber; i++) {
        UIImageView* imageView;
        if (i < self.currentNumber) {
            imageView = [[UIImageView alloc] initWithImage:self.selectedImage];
        } else {
            imageView = [[UIImageView alloc] initWithImage:self.unSelectedImage];
        }
        imageView.frame = CGRectMake(p.x, p.y, self.imageSize.width, imageSize.height);
        [self addSubview:imageView];
        p.x+=self.imageSize.width;
    }
}
@end

@implementation XYRotatingView
@synthesize animating = _animating;
@synthesize spinningView = _spinningView;
@synthesize rotateDuration = _rotateDuration;

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _spinningView = [[UIView alloc] initWithFrame:frame];
        _rotateDuration = 0.3f;
        [self addSubview:_spinningView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        _spinningView = [[UIView alloc] initWithFrame:self.frame];
        _rotateDuration = 0.3f;
        [self addSubview:_spinningView];
    }
    return self;
}
-(void)updateView{
    
}

-(void)rotateSpinningView{
    
    [UIView animateKeyframesWithDuration:_rotateDuration delay:0 options:
     //UIViewAnimationOptionRepeat |
     UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowAnimatedContent animations:^{
         _spinningView.transform = CGAffineTransformRotate(_spinningView.transform, M_PI_2);
     } completion:^(BOOL finished) {
         if (_animating) {
             [self rotateSpinningView];
         }
     }];
}

-(void)startAnimating{
    _animating = YES;
    [self rotateSpinningView];
}

-(void)stopAnimating{
    _animating = NO;
}
@end


@implementation XYAnimationView
@synthesize animationDelegate = _animationDelegate;
@synthesize name = _name;
@synthesize animating = _animating;
@synthesize showAnimationDuration = _showAnimationDuration;
@synthesize delayAnimationDuration = _delayAnimationDuration;
@synthesize dismissAnimationDuration = _dismissAnimationDuration;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)show{
    UIView* screenView = [XYUtility mainWindowView];
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
    [screenView addSubview:self];
}

-(void)showInView:(UIView*)view{
    // If view is displayed remove it first
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
    
    // Animation block
    [view addSubview:self];
}

-(void)showInViewController:(UIViewController *)controller{
    [self showInView:controller.view];
}

-(void)dismiss{
    
    // Animation block
    
    [self removeFromSuperview];
}

// De-alloc the object and remove it from super view
-(void)dealloc{
    [self removeFromSuperview];
}
@end

@implementation XYNotificationView
{
    UILabel* titleLabel;
    UITextView* detailText;
}

@synthesize title = _title;
@synthesize message = _message;

-(id)init{
    if (self = [super init]) {
        float width = [UIScreen mainScreen].bounds.size.width;
        CGRect f = CGRectMake(0, 0, width, 44);
        self.frame = f;
        [self renderNotificationView];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect f = frame;
        f.size.height = 20;
        [self renderNotificationView];
    }
    return self;
}


-(id)initWithTitle:(NSString *)title delegate:(id<XYAnimationViewDelegate>)delegate{
    float width;
    // Check the width by screen width
    // The notification view always display on the top of screen
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        width = [UIScreen mainScreen].bounds.size.height;
    } else {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    CGRect f = CGRectMake(0, 0, width, 40);
    if (self = [super initWithFrame:f]) {
        [self renderNotificationView];
        self.title = title;
        self.animationDelegate = delegate;
    }
    return self;
}

-(void)renderNotificationView{
    // Define the look & feel
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor lightGrayColor];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width - 40, self.frame.size.height)];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLabel.alpha = 1;
    [self addSubview:titleLabel];
    
    // Set default animation duration
    self.showAnimationDuration = 0.5;
    self.delayAnimationDuration = 1;
    self.dismissAnimationDuration = 0.5;
    
    self.startAlpha = 0.6;
    self.endAlpha = 0;
}

-(void)show{
    [self showInView:[XYUtility mainWindowView]];
}

-(void)showInViewController:(UIViewController*)controller{
    [self showInViewController:controller waitUntilDone:YES];
}

-(void)showInViewController:(UIViewController*)controller waitUntilDone:(BOOL) b{
    if (b && _animating) {
        return;
    }
    
    UIView* view = controller.view;
    
    if ([controller isKindOfClass:[UITableViewController class]]) {
        // If view controller is UITableViewController, add self to it's super view so that view will still there when scrolling
        
        // For ios7 above, use table view frame origin
        if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
            CGRect tableViewFrame = view.frame;
            CGRect f = self.frame;
            f.origin.x = tableViewFrame.origin.x;
            f.origin.y = tableViewFrame.origin.y;
            self.frame = f;
        }
        view.superview.clipsToBounds = YES;
        [view.superview addSubview:self];
        
    } else {
        if (self.superview == nil) {
            view.clipsToBounds = YES;
            [view addSubview:self];
        }
    }
    
    [self drawView];
}

-(void)showInView:(UIView *)view{
    [self showInView:view waitUntilDone:YES];
}

-(void)showInView:(UIView*)view waitUntilDone:(BOOL)b{
    if (b && _animating) {
        return;
    }
    if (self.superview == nil) {
        view.clipsToBounds = YES;
        [view addSubview:self];
    }
    [self drawView];
}

/**
 Logic for drawing view on screen
 */
-(void)drawView{
    titleLabel.text = _title;
    
    // Set animation start location from top
    CGRect startFrame = self.frame;
    CGRect endFrame = self.frame;
    startFrame.origin.y = -startFrame.size.height;
    self.frame = startFrame;
    if (_animationDelegate != nil) {
        [_animationDelegate animationViewWillAppear:self];
    }
    _animating = YES;
    
    // Animation start
    [UIView animateWithDuration:_showAnimationDuration animations:^{
        self.frame = endFrame;
        self.alpha = _startAlpha;
        
    } completion:^(BOOL finished) {
        if (_animationDelegate != nil) {
            [_animationDelegate animationViewDidAppear:self];
        }
        if (_delayAnimationDuration != 0) {
            [NSTimer scheduledTimerWithTimeInterval:_delayAnimationDuration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
        }
    }];
}

-(void)dismiss{
    // Set animation start location from top
    CGRect oldFrame = self.frame;
    CGRect startFrame = self.frame;
    startFrame.origin.y = -startFrame.size.height;
    
    if (_animationDelegate != nil) {
        [_animationDelegate animationViewWillDisappear:self];
    }
    [UIView animateWithDuration:_dismissAnimationDuration animations:^{
        self.frame = startFrame;
        self.alpha = _endAlpha;
    } completion:^(BOOL finished) {
        self.frame = oldFrame;
        _animating = NO;
        if (_animationDelegate != nil) {
            [_animationDelegate animationViewDidDisappear:self];
        }
        [self removeFromSuperview];
    }];
}

-(void)log:(NSString *)status{
    _title = status;
    titleLabel.text = _title;
    CGRect titleFrame = titleLabel.frame;
    CGSize s = [XYUtility sizeOfText:titleLabel.text withFont:titleLabel.font constrainedSize:self.bounds.size];
    titleFrame.size.width = MAX(s.width,titleFrame.size.width);
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7.0) {
        titleFrame.size.width += 10;
    } else {
        titleFrame.size.width += 5;
    }
    titleLabel.frame = titleFrame;
}

-(void)progress:(NSNumber *)progress{
    
}
@end

@implementation XYSelectOption
@synthesize sign = _sign;
@synthesize option = _option;
@synthesize lowValue = _lowValue;
@synthesize highValue = _highValue;
-(id)initWithSign:(SignType)sign option:(OptionType) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue{
    if (self = [super init]) {
        _sign = sign;
        _option = option;
        _lowValue = lowValue;
        _highValue = highValue;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.sign = [[aDecoder decodeObjectForKey:@"sign"] intValue];
        self.option = [[aDecoder decodeObjectForKey:@"option"] intValue];
        self.lowValue = [aDecoder decodeObjectForKey:@"lowValue"];
        self.highValue = [aDecoder decodeObjectForKey:@"highValue"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(self.sign) forKey:@"sign"];
    [aCoder encodeObject:@(self.option) forKey:@"option"];
    [aCoder encodeObject:self.lowValue forKey:@"lowValue"];
    [aCoder encodeObject:self.highValue forKey:@"highValue"];
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[XYSelectOption class]]) {
        XYSelectOption* so = (XYSelectOption*)object;
        if (self.sign == so.sign && self.option == so.option && [self.lowValue isEqualToString:so.lowValue] && [self.highValue isEqualToString:so.highValue] ) {
            return YES;
        } else {
            return NO;
        }
    }
    return [self isEqual:object];
}

-(NSUInteger)hash{
    return self.sign + self.option * 2 + self.lowValue.hash * 3 + self.highValue.hash * 4;
}
@end

@implementation XYFieldSelectOption
@synthesize property = _property;
@synthesize selectOptions = _selectOptions;

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithProperty:(NSString*) property andSelectOption:(XYSelectOption*)option{
    if (self = [super init]) {
        _property = property;
        _selectOptions = [NSMutableSet setWithObject:option];
    }
    return self;
}

-(id)initWithProperty:(NSString*) property andSelectOptionSign:(SignType)sign option:(OptionType) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue{
    if (self = [super init]) {
        _property = property;
        XYSelectOption* so = [[XYSelectOption alloc] initWithSign:sign option:option lowValue:lowValue highValue:highValue];
        _selectOptions = [NSMutableSet setWithObject:so];
    }
    return self;
}

-(id)initWithProperty:(NSString*) property andSelectOptionSet:(NSSet*)options{
    if (self = [super init]) {
        _property = property;
        _selectOptions = [NSMutableSet setWithSet:options];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.property = [aDecoder decodeObjectForKey:@"property"];
        self.selectOptions = [aDecoder decodeObjectForKey:@"selectOptions"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.property forKey:@"property"];
    [aCoder encodeObject:self.selectOptions forKey:@"selectOptions"];
}

-(void)addSelectOption:(XYSelectOption*)so{
    if (_selectOptions == nil) {
        _selectOptions = [NSMutableSet new];
    }
    [_selectOptions addObject:so];
}

-(void)addSelectOptionSign:(SignType)sign option:(OptionType) option lowValue:(NSString*)lowValue highValue:(NSString*)highValue{
    XYSelectOption* so = [[XYSelectOption alloc] initWithSign:sign option:option lowValue:lowValue highValue:highValue];
    [_selectOptions addObject:so];
}

-(void)setSingleSelectOption:(XYSelectOption*)so{
    _selectOptions = [NSMutableSet setWithObject:so];
}

-(void)removeSelectOption:(XYSelectOption*)so{
    [_selectOptions removeObject:so];
}

-(void)clearSelectOption{
    [_selectOptions removeAllObjects];
}

-(NSDictionary*)dictionaryRepresentation{
    NSMutableArray* soArr = [NSMutableArray new];
    for (XYSelectOption* so in _selectOptions) {
        NSDictionary* soDict = @{
           @"sign":[self parseSignType:so.sign],
           @"option":[self parseOptionType:so.option],
           @"low":so.lowValue,
           @"high":so.highValue
           };
        [soArr addObject:soDict];
    }
    return @{
            @"field":self.property,
            @"options":soArr
            };
}

-(NSString*)parseSignType:(SignType)st{
    NSString* result = @"I";
    switch (st) {
        case SignTypeExclude:
            result = @"E";
            break;
        case SignTypeInclude:
            result = @"I";
        default:
            break;
    }
    return result;
}

-(NSString*)parseOptionType:(OptionType)ot{
    NSString* result = @"eq";
    switch (ot) {
        case OptionTypeEQ:
            result = @"eq";
            break;
        case OptionTypeNE:
            result = @"ne";
            break;
        case OptionTypeCS:
            result = @"cs";
            break;
        case OptionTypeNC:
            result = @"nc";
            break;
        case OptionTypeGT:
            result = @"gt";
            break;
        case OptionTypeGE:
            result = @"ge";
            break;
        case OptionTypeLT:
            result = @"lt";
            break;
        case OptionTypeLE:
            result = @"le";
            break;
        case OptionTypeBT:
            result = @"bt";
            break;
        default:
            break;
    }
    return result;
}
@end


@implementation XYSearchBuilder
{
    NSMutableArray* fieldSelectOptions;
}
-(id)init{
    if (self = [super init]) {
        fieldSelectOptions = [NSMutableArray new];
    }
    return self;
}
-(void)addFieldSelectOption:(XYFieldSelectOption*)so{
    [fieldSelectOptions addObject:so];
}

-(NSDictionary*)dictionaryRepresentation{
    NSMutableArray* result = [NSMutableArray new];
    for (XYFieldSelectOption* fso in fieldSelectOptions) {
        [result addObject:[fso dictionaryRepresentation]];
    }
    
    return @{
             @"and":result,
             @"orderBy":self.orderBy,
             @"order":[self parseSortType:self.sortType]
             };
}

-(NSString*)parseSortType:(SortType)SortType{
    NSString* result = @"";
    switch (SortType) {
        case SortTypeNone:
            result = @"";
            break;
        case SortTypeAscending:
            result = @"asc";
            break;
        case SortTypeDescending:
            result = @"desc";
            break;
        default:
            break;
    }
    return result;
}
@end

