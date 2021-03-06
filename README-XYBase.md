# XYBase
Simplified version of old MarioLib

> I try to start this new work to simplify my previous work of MarioLib, to make it more easier to use.     
> I'm thinking of having only 1 .h .m file to include all necessory classes.     

Why    

> The purpose is that I don't want to repeat the work when start a new app, there must be something in common like design pattern, functions, features, and I would like to figure them out.

This should be a on-going project.

To use it in your project, just add 
> \#import "XYBase.h"

### XYBaseVc/XYBaseTableVc
Contains a method to execute business logic and show common busy indicator.

```
-(void)performBusyProcess:(XYProcessResult*(^)(void))block;
```

In subclass, you can use it in any action that taking time, logic will be executed in background thread.    

```
-(void)click:(UIButton*)sender{
    [self performBusyProcess:^XYProcessResult *{
        sleep(2);
        return [XYProcessResult success];
    }];
}
```
**Notice that do not call performBusyProcess more than once in same method like below**

```
-(void)click:(UIButton*)sender{
    [self performBusyProcess:^XYProcessResult *{
        // Do something
        return [XYProcessResult success];
    }];
    [self performBusyProcess:^XYProcessResult *{
        // Do something else
        return [XYProcessResult success];
    }];
}
```


The block returns a XYProcessResult for view controller to handle.
In the same class overwrite below method to do anything afterwards on main thread.

```
-(void)handleCorrectResponse:(XYProcessResult *)result{
    
}
```
And

```
-(void)handleErrorResponse:(XYProcessResult *)result{
    
}
```

The result can be success or failure, be handled by method above separately. E.g.

```
if (responseCode == 0) {
    return [XYProcessResult success];
} else {
    return [XYProcessResult failureWithError:@"Error string"];
}
```

Another way is to use a completion block to handle the result. E.g.

```
[self performBusyProcess:^XYProcessResult *{
    sleep(5);
    return [XYProcessResult failure];
    } busyFlag:YES completion:^(XYProcessResult *result) {
    if (result.success) {
        self.view.backgroundColor = [UIColor greenColor];
    } else {
        self.view.backgroundColor = [UIColor grayColor];
}}];

```

Or without completion block

```
[self performBusyProcess:^XYProcessResult *{
    sleep(3);
    return [XYProcessResult success];
} busyFlag:NO completion:nil];
```

Parameter busyFlag indicates whether to freeze the screen or not, see below 2 methods.


What and how activity indicator is displayed controlled by method below:

```
-(void)turnOnBusyFlag;
```
```
-(void)turnOffBusyFlag;
```
A practical way is to implement the logic in base class in order to have consistent behavior across the app.
E.g. You can have an UIAlertController field ac in base class and implementation like below:

```
-(void)turnOnBusyFlag{
    ac = [UIAlertController alertControllerWithTitle:@"Busy" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
}

-(void)turnOffBusyFlag{
    [ac dismissViewControllerAnimated:YES completion:nil];
}
```
Or use third party classes like:

```
-(void)turnOnBusyFlag{
    if (self.navigationController != nil) {
        hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    } else {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];

    // Disable all interaction
    self.view.userInteractionEnabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
```
```
-(void)turnOffBusyFlag{
    [hud hideAnimated:YES];
    
    // Enable interaction
    self.view.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
```

### BaseTableVc
#### Table data
To add different style of table view cell in a table is not so convenient sometimes.
You have to implement common method like ``numberOfSectionsInTableView:(UITableView *)tableView``, 
``tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section`` and 
``tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath``
in most cases. And for a new table view controller, repeat it again.    

Therefore I tried to setup a mechanism in MarioLib, like Field, TableCell, TableSection, TableContainer class, put Field into TableCell, put TableCell into TableSection, put TableSection into TableContainer, then use an implemented delegate class to draw the data.
In such case, to create a table view with limited cells is quite convenient, like:

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    inputField = [XYTableCellFactory cellOfInputField:@"input" label:@"Input" ratio:0.3 placeHolder:@"Keyboard numpad" keyboardType:UIKeyboardTypeDecimalPad];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfTextViewField:@"textView" label:@"Text View" ratio:0.3 placeHolder:@"with heigh changing" keyboardType:UIKeyboardTypeAlphabet minHeight:100 maxHeigh:300];
    [self.tableDelegate.container addXYTableCell:inputField];
    
    inputField = [XYTableCellFactory cellOfPicker:@"picker1" label:@"Pick" ratio:0.3 options:@"Option 1",@"value1",@"Option 2",@"value2",nil];
    [self.tableDelegate.container addXYTableCell:inputField];
   ...
   [self.tableView reloadData];
}
```
This allow me to focus on the main function of the app rather than how detail should be implemented, modulized each component, reduce duplicated code and of course make app easier to be changed.

> One kind of logic should be appear only once in code, you should not found 2 pieces of code that looks similar, functioning similar, resulting similar. For any similarity, break it into different essences.

But this version is still too complex, I need a one more lightweighted version.

**Below solution is suitable for displaying a limited list. E.g for detail screen, settings screen etc.**

XYBaseTableVc has a protected 2 dimensions NSArray field name ``sections`` to represent section and cells. 
The item each each row is represented by class ``XYBaseTvcItem``.
Each item should has the same identifier name as the one you defined in storyboard for table view cell, e.g.

```
-(void)viewDidLoad {
    [super viewDidLoad]; 
       
    XYBaseTvcItem* usernameItem = [[XYBaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT];
    
    XYBaseTvcItem* passwordItem = [[XYBaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT];
    
    XYBaseTvcItem* buttonItem = [[XYBaseTvcItem alloc] initWithIdentifer:@"ButtonTvc" view:nil height:BUTTON_ROW_HEIGHT];
    
    sections = @[
      @[usernameItem, passwordItem, buttonItem]
    ];
}
```
After you finished UI design in storyboard, now it's much easy to add them in code.     

**Where CellForRowAtIndexPath method goes?**
As you may guess, the item itself has a block to fulfill the logic which usually be done in CellForRowAtIndexPath(**I love blocks**), the usage is like:

```
item.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
	return baseCell;
}
```
You should render the cell here, one reason of such design is I put logic of creating cell and rendering cell in one place so that no need to seeking in some other place in the context.

The complete version of above sample would be:

```
-(void)viewDidLoad {
    [super viewDidLoad]; 
       
    XYBaseTvcItem* usernameItem = [[XYBaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT]
    usernameItem.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        InputTvc* cell = (InputTvc*)baseCell;
        cell.label.text = NSLocalizedString(@"username", @"username");
        cell.label.textColor = [UIColor blackColor];
        cell.textField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:NSLocalizedString(@"plsEnterUsername", @"plsEnterUsername") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        [cell.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        usernameTf = cell.textField;
        cell.separatorLine.backgroundColor = [UIColor blackColor];
        return cell;
    };
    
    XYBaseTvcItem* passwordItem = [[XYBaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT];
    passwordItem.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        InputTvc* cell = (InputTvc*)baseCell;
        cell.label.text = NSLocalizedString(@"password", @"password");
        cell.label.textColor = [UIColor blackColor];
        cell.textField.secureTextEntry = YES;
        cell.textField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:NSLocalizedString(@"plsEnterPassword", @"plsEnterPassword") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        [cell.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        passwordTf = cell.textField;
        cell.separatorLine.backgroundColor = [UIColor blackColor];
        return cell;
    };
    
    XYBaseTvcItem* buttonItem = [[XYBaseTvcItem alloc] initWithIdentifer:@"ButtonTvc" view:nil height:BUTTON_ROW_HEIGHT];
    buttonItem.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        ButtonTvc* cell = (ButtonTvc*) baseCell;
        cell.button.backgroundColor = [UIColor blackColor];
        [cell.button setTintColor:[UIColor whiteColor]];
        [cell.button setTitle:NSLocalizedString(@"login", @"login") forState:UIControlStateNormal];
        [cell.button addTarget:self action:@selector(loginBtnClicked:) forControlEvents:UIControlEventTouchDown];
        cell.button.layer.cornerRadius = BUTTON_CORNER_RADIUS;
        loginBtn = cell.button;
        return cell;
    };
    
    sections = @[
      @[
       usernameItem,
       passwordItem,
       buttonItem
       ]
              ];
}
```

Smarty you may also realized that I have created subclass of UITableViewCell for each row(InputTvc, ButtonTvc), and UITextField instance usernameTf, passwordTf, UIButton instance loginBtn as a reference in this view controller.

Since the table view cell will be released when it's out of screen, you need to rebind it to a local object in order not to lose user inputs.

For example, inputTf is a UITextField reference in view controller, if it's not binded, bind it and assign initial value, if it's binded, use local object instead.

```
if (inputTf) {
    cell.textField = inputTf;
} else {
    cell.textField.text = <initial value>
    inputTf = cell.textField;
}
```


**XYOptionTvcItem**
XYOptionTvcItem is a subclass of XYBaseTvcItem, where you can addTarget for clicking event. E.g.

```
XYOptionTvcItem* option1 = [[XYOptionTvcItem alloc] initWithIdentifer:@"OptionTvc" view:nil height:ROW_HEIGHT];
    option1.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        OptionTvc* cell = (OptionTvc*)baseCell;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.optionIv setImage:[UIImage imageNamed:@"key"]];
        cell.optionLb.text = NSLocalizedString(@"changePassword", @"changePassword");
        cell.optionTextLb.text = @"";
        return cell;
    };
    [option1 addTarget:self action:@selector(toChangePwd)];
```

The toChangePwd selector will be called when cell clicked.


#### Pull down refreshing
For refreshing data, put the logic in method below in view controller

```
-(void)refresh:(UIRefreshControl*)refreshControl;
```

You may customized to use apple refresh control by creating it in XYBaseTableVc viewDidLoad method

```
self.refreshControl = [UIRefreshControl new];
[self.refreshControl addTarget:self action:@selector(baseRefresh:) forControlEvents:UIControlEventValueChanged];
```

or use a third party solution. E.g.

```
-(void)setEnableRefresh:(BOOL)enableRefresh{
    /* enable refresh here */
    _enableRefresh = enableRefresh;
    if (self.enableRefresh){
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self baseRefresh:self.refreshControl];
        }];
    } else {
        self.tableView.mj_header = nil;
    }
}
```

####No data view
XYBaseTableVc has an IBOutlet UIView* noDataView to display anything if no data is available based on business needs.

For example, in subclass, override noDataView method to return a customized view, and if no records return from server side(message sending logic omitted here), show this view

```
-(UIView*)noDataView{
    if (_noDataView == nil) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        view.backgroundColor = [UIColor lightGrayColor];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 40)];
        view.autoresizingMask = label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.text = NSLocalizedString(@"noData", @"noData");
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        _noDataView = view;
    }
    return _noDataView;
}

-(void)handleCorrectResponse:(XYProcessResult *)result{
    NSArray* records = [result.params objectForKey:@"records"];
    [self setNoDataViewHidden:records != 0];
    [self.tableView reloadData];
}
```


### XYCoreDataConnector/XYCoreDataManager
These classes are used for accessing coredata.
To initialize the connection, for example

```
[[XYCoreDataManager instance] initCoreDataConnectorWithModel:@"XYBase" storeName:@"xybase.sqlite" asAlias:@"xybasedb"];
```
Here, ``XYBase`` is the name of xcdatamodelId, that's to say you have a XYBase.xcdatamodelId file available.
Store name ``xybase.sqlite`` refer to the file that will be created, and alias name ``xybasedb`` is used as a reference to the connector.
**Notice even you call this method twice, it will not recreate sqlite file to cause any data loss**

Anytime you need to access coredata, use ``XYCoreDataConnect`` instance, E.g.

```
XYCoreDataConnector* dc = [[XYCoreDataManager instance] connectorByAlias:@"xybasedb"];
```
Below are the methods to manipulate data(insert, delete, select). Assuming you already have a mangedObject class named Worker with name and title fields and defined in coredata model.

```
-(void)addRecord{
    XYCoreDataConnector* dc = [[XYCoreDataManager instance] connectorByAlias:@"xybasedb"];
    Worker* worker = (Worker*)[dc getSingleObjectFromDatabase:[Worker class] WithPredicate:@"(name = %@)" AndParameter:@"Mario"];
    if (worker == nil) {
        worker = (Worker*)[dc getNewObjectForInsertByClass:[Worker class]];
    }
    NSLog(@"before saving %@ %@", worker.name, worker.title);
    worker.name = @"Mario";
    worker.title = @"Developer";
    [dc saveContext];
    NSLog(@"after saving %@ %@", worker.name, worker.title);
    
}

-(void)deleteDB{
    XYCoreDataConnector* dc = [[XYCoreDataManager instance] connectorByAlias:@"xybasedb"];
    NSArray* records = [dc getObjectsFromDatabase:[Worker class] WithPredicate:nil AndParameter:nil];
    for (Worker* worker in records) {
        [dc.managedObjectContext deleteObject:worker];
    }
    [dc saveContext];
}

-(void)showDB{
    XYCoreDataConnector* dc = [[XYCoreDataManager instance] connectorByAlias:@"xybasedb"];
    NSArray* result = [dc getObjectsFromDatabase:[Worker class] WithPredicate:nil AndParameter:nil];
    for (Worker* worker in result) {
        NSLog(@">%@ %@", worker.name, worker.title);
    }
}
```

If you have below code in viewDidLoad:

```
// Initialize core data
[[XYCoreDataManager instance] initCoreDataConnectorWithModel:@"XYBase" storeName:@"xybase.sqlite" asAlias:@"xybasedb"];
    
[self deleteDB];
[self showDB];
[self addRecord];
[self showDB];
```
The output will be:

```
2016-06-21 11:20:13.387 XYBase[51919:8487271] before saving (null) (null)
2016-06-21 11:20:13.390 XYBase[51919:8487271] after saving Mario Developer
2016-06-21 11:20:13.392 XYBase[51919:8487271] >Mario Developer
```

### Messaging
The design may be poor, but it works somehow.
Assuming you are sending request and getting response in json format like:

Request:

```
{
 'key': 'some key'
}
```

Response:

```
{
 'code': 0,
 'desc': 'ok',
 'value': 'some value'
}
```
**Notice code and desc are required among all backend responses**

Now,

* To create a mesage, you first define the name, for example ``Test``
* Then create class TestRequest, TestResponse, TestMessageAgent, naming convention as
	* \<MessageName>Request
	* \<MessageName>Response
	* \<MessageName>MessageAgent
* Register url information when app started up
* Use XYMessageEngine instance to send mssage

A detail example as below:

TestRequest.h

```
#import "XYBase.h"

@interface TestRequest : XYRequest
@property(nonatomic, strong) NSString* key;
@end
```
TestRequest.m

```
#import "TestRequest.h"

@implementation TestRequest
@synthesize key;
@end
```

TestResponse.h

```
#import "XYBase.h"

@interface TestResponse : XYResponse
@property(nonatomic, strong) NSString* value;
@end
```

TestResponse.m

```
#import "TestResponse.h"

@implementation TestResponse
@synthesize value;
@end
```

TestMessageAgent.h

```
#import "XYBase.h"
#import "TestRequest.h"
#import "TestResponse.h"

@interface TestMessageAgent : XYMessageAgent

@end
```


TestMessageAgent.m

```
#import "TestMessageAgent.h"

@implementation TestMessageAgent
-(void)normalize:(XYRequest*)request to:(XYHTTPRequestObject*) requestObj{
    TestRequest* req = (TestRequest*)request;
    [super normalize:req to:requestObj];
    NSDictionary* dict = @{
                           @"key":req.key
                           };
    [request.bodyDict addEntriesFromDictionary:dict];
    NSError* error;
    NSData *str = [NSJSONSerialization dataWithJSONObject:request.bodyDict options:kNilOptions error:&error];
    NSString* json = [[NSString alloc]initWithData:str encoding:NSUTF8StringEncoding];
    requestObj.body = [json dataUsingEncoding:NSUTF8StringEncoding];
}

-(void)deNormalize:(XYHTTPResponseObject*)responseObj to:(XYResponse**)response{
    TestResponse* res = [TestResponse new];
    NSDictionary* repObj = [NSJSONSerialization JSONObjectWithData:responseObj.data options:NSJSONReadingMutableContainers error:nil];
    res.value = [repObj objectForKey:@"value"];
    *response = (XYResponse*)res;
    [super deNormalize:responseObj to:&res];
}

-(XYResponse*)demoResponse{
    TestResponse* res = [TestResponse new];
    res.value = @"It's demo";
    return res;
}
```

In the ``normalize`` method, you reformat data to json string, and in ``deNormalize`` method, you convert json string into response object.
In another word, if you are not sending json data, you should implement logic here. 

Method ``demoResponse`` will be explained short after.

Demo backend logic in Python Django like:

```
@csrf_exempt
def test(request):
    body = json.loads(request.body)
    return HttpResponse(json.dumps({'code' : 0, 'desc':'ok', 'value': "%s's value" % body.get('key', 'No key')}))

```

Register messages in didFinishLaunching method like

```
...
// Connect represent one backend connection
XYConnector* connector = [[XYConnector alloc] initWithURL:@"http://127.0.0.1:8001/mytest"];

// Connection is more low level 
// Implements how data should be sent and received
connector.connection = [XYConnection new];

// A Manager to hold all connectors
XYConnectorManager* cm = [XYConnectorManager instance];
    [cm addConnector:connector asAlias:@"backend"];
    
// Message engine can have multiple connectors. 
// I.e. for different stage(dev, testing, production)
[[XYMessageEngine instance] setConnector:connector forStage:MessageStageDevelopment];
    
// Register message configuration
XYMessageConfig* mc = [XYMessageConfig new];
mc.relativePath = @"test";
mc.httpMethod = @"POST";
[[XYMessageEngine instance] setConfig:mc forMessage:[TestRequest class]];

// Alternative registration
//[[XYMessageEngine instance] setConfigPath:@"test" method:@"POST" forMessage:[TestRequest class]];

// Set current running stage
// You can shift between different stage on needs
[XYMessageEngine instance].runningStage = MessageStageDevelopment;
...
```

If you set runningStage to MessageStageDemo, the demoResponse method will be called in MessageAgent, which cause all your messaging part to be working offline. This is mainly for you to demo the application when backend system is not ready or the product itself is in prototype stage.

To trigger the sending, try do it in background thread like

```
-(void)click:(UIButton*)sender{
    [self performBusyProcess:^XYProcessResult *{
        TestRequest* request = [TestRequest new];
        request.key = @"app";
        TestResponse* response = (TestResponse*) [[XYMessageEngine instance] send:request];
        if (response.responseCode == 0) {
            NSLog(@"response: %@", response.value);
            return [XYProcessResult success];
        } else {
            return [XYProcessResult failureWithError:response.responseDesc];
        }
  }];
}
```

### NSString Category
Provide methods to get sha1, md5 string. E.g.

```
-(NSString*)md5;
-(NSString*)sha1;
-(NSString*)sha1_base64; // Need GTMBase64.h 
-(NSString*)md5_base64;  // Need GTMBase64.h 
-(NSString*)base64;      // Need GTMBase64.h 
-(NSString*)trim;
```

### NSObject Category
To convert a NSObject into NSDictionary object. 

***Currently only support property NSString and NSNumber.***

```
-(NSDictionary*)toDictionary;
```

### NSDictionary Category
To convert a NSDictionary object into other class object.

```
-(id)toObjectAsClass:(Class)clazz;
```

E.g. A TestRequest class contains property key and number

```
@interface TestRequest : XYRequest
@property(nonatomic, strong) NSString* key;
@property(nonatomic, strong) NSNumber* number;
@end

@implementation TestRequest
@synthesize key;
@synthesize number;
@end
```
To convert it into NSDictionary and back, use

```
TestRequest* request = [TestRequest new];
request.key = @"abcde";
request.number = @(2);
NSDictionary* d = [request toDictionary];
NSLog(@"%@ %ld",d[@"key"], [d[@"number"] integerValue]);
TestRequest* request2 = [d toObjectAsClass:[TestRequest class]];
NSLog(@"%@ %ld", request2.key, [request2.number integerValue]);
```





### XYUISegmentedControl
This is a sub class of UISegmentedControl, provide feature to customized the font size, color of the each item.

An example as follows:

```
XYUISegmentedControl* sc = [[XYUISegmentedControl alloc] initWithItems:@[@"a",@"b",@"c"]];
    sc.frame = CGRectMake(10, 10, 200, 30);
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 30, 5)];
    v.backgroundColor = [UIColor purpleColor];
    sc.selectedView = v;
    sc.selectedTitleFont = [UIFont systemFontOfSize:20];
    sc.unSelectedTitleFont = [UIFont systemFontOfSize:10];
    sc.selectedFontColor = [UIColor greenColor];
    sc.tintColor = [UIColor clearColor];
    sc.unSelectedFontColor = [UIColor redColor];
    [sc renderView];
    [self.view addSubview:sc];
```

### XYSortUIButton
A subclass of UIButton, it provides 3 status ``SortTypeAscending``,``SortTypeDescending`` and ``SortTypeNone``.

According to the status, 3 images can be added ``ascendingImg``,``descendingImg``,``noneSortImg``. 

Each time the button is clicked, the status changed in such sequence SortTypeAscending-> SortTypeDescending->SortTypeNone-> SortTypeAscending.

An example as follows:

```
- (void)viewDidLoad {
    [super viewDidLoad];
    XYSortUIButton* button = [[XYSortUIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    button.ascendingImg = [UIImage imageNamed:@"sort_up_green"];
    button.descendingImg = [UIImage imageNamed:@"sort_down_green"];
    button.noneSortImg = [UIImage imageNamed:@"sort_neutral"];
    [button setTitle:@"Field" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 1.f;
    [button addTarget:self action:@selector(sortClicked:) forControlEvents:UIControlEventTouchDown];
//    In case change title and image location
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
//    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [button renderView];
    [self.view addSubview:button];
}

-(void)sortClicked:(XYSortUIButton*)sender{
    NSLog(@"%d", sender.sortType);
}
```


### XYSelectUIButton
A subclass of UIButton, provides 2 status, ``SelectTypeSelected``, ``SelectTypeDeselected``

An example as follows:

```
- (void)viewDidLoad {
    [super viewDidLoad];
    XYSelectUIButton* button2 = [[XYSelectUIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    button2.selectedImg = [UIImage imageNamed:@"sort_up_green"];
    button2.deselectedImg = [UIImage imageNamed:@"sort_down_green"];
    [button2 addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchDown];
    [button2 renderView];
    [self.view addSubview:button2];
}

-(void)selectClicked:(XYSelectUIButton*)sender{
    NSLog(@"%d", sender.selectType);
    // Change status on needs
    sender.selectType = SelectTypeSelected;
}
```

### XYImageUIButton
A button extends from UIButton whicch contains an image view and a label. The image view is located above the label like a tab item.

Example

```
-(void)viewDidLoad {
    XYImageUIButton* btn = [[XYImageUIButton alloc] initWithFrame:CGRectMake(10, 300, 200, 100)];
    btn.buttonImageView.image = [UIImage imageNamed:@"icon"];
    btn.buttonImageViewSize = CGSizeMake(40, 40);
    btn.buttonLabel.text = @"Test";
    btn.buttonLabel.textAlignment = NSTextAlignmentCenter;
    btn.buttonLabel.font = [UIFont systemFontOfSize:12];
    
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}

-(void)btnClicked:(UIButton*)sender{
    NSLog(@"clicked");
}
```

### XYUITextField
Subclass of UITextField, provides content inset. E.g.

```
XYUITextField* field = [[XYUITextField alloc] initWithFrame:CGRectMake(20, 120, 250, 40)];
field.insetSize = CGSizeMake(15, 0);
field.backgroundColor = [UIColor redColor];
[self.view addSubview:field];
```

### XYDatePickerUITextField
Subclass of XYUITextField, provides datepicker as input view.

For date, format as yyyy-MM-dd
For time, format as HH:mm:ss
For datetime, format as yyyy-MM-dd HH:mm:ss

E.g.

```
XYDatePickerUITextField* field = [[XYDatePickerUITextField alloc] initWithFrame:CGRectMake(20, 120, 250, 40)];
field.insetSize = CGSizeMake(5, 0);
field.backgroundColor = [UIColor redColor];
field.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
[self.view addSubview:field];
```

### XYPickerUITextField
Subclass of XYUITextField, priveds a picker view as input view.

Each option is a object of XYLabelValue.

E.g.

```
pickerTf = [[XYPickerUITextField alloc] initWithFrame:CGRectMake(20, 20, 100, 40)];
pickerTf.options = @[
    [XYLabelValue label:@"1 day" value:@(1)],
    [XYLabelValue label:@"2 days" value:@(2)],
    [XYLabelValue label:@"3 days" value:@(3)],
];
[self.view addSubview:pickerTf];
```

To get the selected index and value use

```
NSInteger i = pickerTf.selectedIndex
XYLabelValue* lv = pickerTf.selectedLabelValue
```

Negative number (-1) is used as selectedIndex when nothing selected, selectedLabelValue will be set to nil as well.


### XYPagedView
Display multiple views with page controller.
E.g.

```
XYPagedView* pv = [[XYPagedView alloc] initWithFrame:CGRectMake(30, 50, 200, 150)];
pv.backgroundColor = [UIColor lightGrayColor];

UIView* a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
a.backgroundColor = [UIColor redColor];

UIView* b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
b.backgroundColor = [UIColor greenColor];

UIView* c = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
c.backgroundColor = [UIColor blueColor];

[pv setCovers:@[a,b,c]];  pv.pageController.currentPageIndicatorTintColor = [UIColor purpleColor];
[self.view addSubview:pv];
```

### XYImageListView
Arrange and display multiple subviews. E.g.

```
XYImageListView* ilv = [[XYImageListView alloc] initWithFrame:CGRectMake(30, 50, 200, 150)];
ilv.paddingSize = CGSizeMake(2, 5);
ilv.imageSize = CGSizeMake(30, 20);
ilv.backgroundColor = [UIColor lightGrayColor];

UIView* a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
a.backgroundColor = [UIColor redColor];

UIView* b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
b.backgroundColor = [UIColor greenColor];

UIView* c = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
c.backgroundColor = [UIColor blueColor];

UIView* d = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
d.backgroundColor = [UIColor purpleColor];

UIView* e = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
e.backgroundColor = [UIColor yellowColor];

[ilv setImageList:@[a,b,c,d,e]];
[self.view addSubview:ilv];
```

### XYStarRatingView
Used to show a star rating bar.
 
Example

```
-(void)viewDidLoad {
    [super viewDidLoad];
    XYStarRatingView* ratingView = [[XYStarRatingView alloc] initWithFrame:CGRectMake(20, 50, 200, 40)];
    ratingView.selectedImage = [UIImage imageNamed:@"yellowStar"];
    ratingView.unSelectedImage = [UIImage imageNamed:@"grayStar"];
    ratingView.imageSize = CGSizeMake(40, 40);
    ratingView.totalNumber = 4;
    ratingView.currentNumber = 3;
    [ratingView renderView];
    [self.view addSubview:ratingView];
}
``` 

### XYRotatingView
Rotating view can be used as a loading indicator.

Example

```
-(void)viewDidLoad {
    [super viewDidLoad];
    XYRotatingView* rv = [[XYRotatingView alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    rv.rotateDuration = 1.0f;
    UIImageView* v = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loadingIcon"]];
    v.frame = CGRectMake(5, 5, 40, 40);
    [rv.spinningView addSubview:v];
    [self.view addSubview:rv];
    [rv startAnimating];
}
```


###XYSelectOption/XYFieldSelectOption/XYSearchBuilder
These classes are used to add search criteria in message sending to host who will parse the dicationary(json string) for SQL selection.

**A parsing version in django is provided at the end of this section**

XYSelectOption contains 4 properties ``sign``, ``option``, ``low``, ``high`` to describe search option for a single field.
 
XYFieldSelectOption provides the field name and a list of XYSelectOption as a completed search criteria. For example, a criteria for name equals "Mario" is represented in:

```
XYFieldSelectOption* fso = [[XYFieldSelectOption alloc] initWithProperty:@"name" andSelectOptionSign:SignTypeInclude option:OptionTypeEQ lowValue:@"Mario" highValue:@""];
```

Adding another XYSelectOption for same field, logically means they are in relationship "Or".
For example, name equals "Mario" or "Luigi" is represented in:

```
XYFieldSelectOption* fso = [[XYFieldSelectOption alloc] initWithProperty:@"name" andSelectOptionSign:SignTypeInclude option:OptionTypeEQ lowValue:@"Mario" highValue:@""];
[fso addSelectOptionSign:SignTypeInclude option:OptionTypeEQ lowValue:@"Luigi" highValue:@""];
```

XYSearchBuilder is used to build whole search criteria by adding more XYFieldSelectOption objects with relationship "And". 

Addtional property ``orderBy``, ``sortType`` are also provided.

For example, criteria
 
```
name eqauls "Mario" or "Luigi" and age between 20 and 30 order by age descendingly
```

can be represented in:

```
XYSearchBuilder* builder = [XYSearchBuilder new];
XYFieldSelectOption* fso = [[XYFieldSelectOption alloc] initWithProperty:@"name" andSelectOptionSign:SignTypeInclude option:OptionTypeEQ lowValue:@"Mario" highValue:@""];
[fso addSelectOptionSign:SignTypeInclude option:OptionTypeEQ lowValue:@"Luigi" highValue:@""];
[builder addFieldSelectOption:fso];
fso = [[XYFieldSelectOption alloc] initWithProperty:@"age" andSelectOptionSign:SignTypeInclude option:OptionTypeBT lowValue:@"20" highValue:@"30"];
[builder addFieldSelectOption:fso];
builder.orderBy = @[@"age"];
builder.sortType = SortTypeDescending;
NSDictionary* dictionary = [builder dictionaryRepresentation];
```

The final dictionary in json format is as follows:

```
{
  "and":[
    {
      "field":"name",
      "options":[
        {
          "sign":"I",
          "option":"eq",
          "low":"Mario",
          "high":""
        },{
          "sign":"I",
          "option":"eq",
          "low":"Luigi",
          "high":""
        }
      ]
    },
    {
      "field":"age",
      "options":[
        {
          "sign":"I",
          "option":"bt",
          "low":"20",
          "high":"30"
        }
      ]
    }
  ],
  "orderBy":["age"],
  "order":"asc"
}
```

#### Django parsing code
The logic is quite simple here. For multiple entries in field options, using Q.OR, between different fields using Q.AND

```
def buildQobject(q, fieldname, opt, low, high, ao):
    if opt == 'eq' and not low and not high:
        return
    conKey = fieldname
    # Operator mapping
    if opt == 'cs':
        conKey = ''.join([fieldname, '__icontains'])
        q.add(Q(**{conKey: low}), ao)
    elif opt == 'nc':
        conKey = ''.join([fieldname, '__icontains'])
        q.add(~Q(**{conKey: low}), ao)
    elif opt == 'eq':
        q.add(Q(**{conKey: low}), ao)
    elif opt == 'ne':
        if low:
            q.add(~Q(**{conKey: low}), ao)
        else:
            # For value '', check whether it's not None and not ''
            innerQ = Q()
            innerQ.add(~Q(**{conKey: None}), Q.AND)
            innerQ.add(~Q(**{conKey: low}), Q.AND)
            q.add(innerQ, ao)
    elif opt == 'lt':
        conKey = ''.join([fieldname, '__lt'])
        q.add(Q(**{conKey: low}), ao)
    elif opt == 'le':
        conKey = ''.join([fieldname, '__lte'])
        q.add(Q(**{conKey: low}), ao)
    elif opt == 'gt':
        conKey = ''.join([fieldname, '__gt'])
        q.add(Q(**{conKey: low}), ao)
    elif opt == 'ge':
        conKey = ''.join([fieldname, '__gte'])
        q.add(Q(**{conKey: low}), ao)
    elif opt == 'bt':
        conKey = ''.join([fieldname, '__gte'])
        rq = Q()
        q1 = Q(**{conKey: low})
        conKey = ''.join([fieldname, '__lte'])
        q2 = Q(**{conKey: high})
        rq.add(q1, Q.AND)
        rq.add(q2, Q.AND)
        q.add(rq, ao)
        
        
def getSomeList(request):
    searchCriteria = body.get('searchCriteria', None)
    ...
    if searchCriteria:
        andCriteria = searchCriteria.get('and', None)
        if andCriteria:
            q = Q()
            for fieldCriteria in andCriteria:
                fieldQ = Q()
                fieldName = fieldCriteria.get('field')
                for option in fieldCriteria.get('options', None):
                    buildQobject(fieldQ, fieldName, option['option'], option['low'], option['high'], Q.OR)
                q.add(fieldQ, Q.AND)
        records = Table.objects.filter(q)
```


