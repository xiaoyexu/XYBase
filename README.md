# XYBase
Simplified version of old MarioLib

> I try to start this new work to simplify my previous work of MarioLib, to make it more easier to use.     
> I'm thinking of having only 1 .h .m file to include all necessory classes.     

Why    

> The purpose is that I don't want to repeat the work when start a new app, there must be something in common like design pattern, functions, features, and I would like to figure them out.

This should be a on-going project.

### BaseVc/BaseTableVc
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
    return [ProcessResult success];
} else {
    return [ProcessResult failureWithError:@"Error string"];
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
       
    BaseTvcItem* usernameItem = [[BaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT];
    
    BaseTvcItem* passwordItem = [[BaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT];
    
    BaseTvcItem* buttonItem = [[BaseTvcItem alloc] initWithIdentifer:@"ButtonTvc" view:nil height:BUTTON_ROW_HEIGHT];
    
    sections = @[
      @[usernameItem, passwordItem, buttonItem]
    ];
}
```
After you finished UI design in storyboard, now it's much easy to add them in code.
##### Where CellForRowAtIndexPath method goes?
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
       
    BaseTvcItem* usernameItem = [[BaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT]
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
    
    BaseTvcItem* passwordItem = [[BaseTvcItem alloc] initWithIdentifer:@"InputTvc" view:nil height:ROW_HEIGHT];
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
    
    BaseTvcItem* buttonItem = [[BaseTvcItem alloc] initWithIdentifer:@"ButtonTvc" view:nil height:BUTTON_ROW_HEIGHT];
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

Smart you may also realized that I have created subclass of UITableViewCell for each row(InputTvc, ButtonTvc), and UITextField instance usernameTf, passwordTf, UIButton instance loginBtn as a reference in this view controller.







