# XYBase
Simplified version of old MarioLib

> I try to start this new work to simplify my previous work of MarioLib, to make it more easier to use.     
> I'm thinking of having only 1 .h .m file to include all necessory classes.     

Why    

> The purpose is that I don't want to repeat the work when start a new app, there must be something in common like design pattern, functions, features, and I would like to figure them out.

This should be a on-going project.

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

What and how activity indicator is displayed controlled by method below:

```
-(void)turnOnBusyFlag;
```
```
-(void)turnOffBusyFlag;
```
A practical way is to implement the logic in base class in order to have consistent behavior across the app.
E.g. You can have an UIAlertController field ac in base class and implement like below:

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

> Any logic should be appear only once in code, you should not found 2 pieces of code that looks similar, functioning similar, resulting similar. For any similarity, break it into different essences.

But this version is still too complex, I need a one more lightweighted version.

BaseTableVc has a protected 2 dimensions NSArray field name ``sections`` to represent section and cells. 
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
        cell.label.textColor = [UIColor whLabelColor];
        cell.textField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:NSLocalizedString(@"plsEnterUsername", @"plsEnterUsername") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        [cell.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        usernameTf = cell.textField;
        cell.separatorLine.backgroundColor = [UIColor whTableCellSeparatorLineColor];
        return cell;
    };
    
    XYBaseTvcItem* passwordItem = [[XYBaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT];
    passwordItem.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        InputTvc* cell = (InputTvc*)baseCell;
        cell.label.text = NSLocalizedString(@"password", @"password");
        cell.label.textColor = [UIColor whLabelColor];
        cell.textField.secureTextEntry = YES;
        cell.textField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:NSLocalizedString(@"plsEnterPassword", @"plsEnterPassword") attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        [cell.textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
        passwordTf = cell.textField;
        cell.separatorLine.backgroundColor = [UIColor whTableCellSeparatorLineColor];
        return cell;
    };
    
    XYBaseTvcItem* buttonItem = [[XYBaseTvcItem alloc] initWithIdentifer:@"ButtonTvc" view:nil height:BUTTON_ROW_HEIGHT];
    buttonItem.tableViewCellForRowAtIndexPath = ^(UITableView* tableView, UITableViewCell* baseCell, NSIndexPath* indexPath){
        ButtonTvc* cell = (ButtonTvc*) baseCell;
        cell.button.backgroundColor = [UIColor whButtonColor];
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


