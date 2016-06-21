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
static XYCoreDataManager* instance;

@implementation XYCoreDataManager
{
    NSMutableDictionary* coreDataCache;
}
+(XYCoreDataManager*)instance{
    if (instance == nil) {
        instance = [XYCoreDataManager new];
    }
    return instance;
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



