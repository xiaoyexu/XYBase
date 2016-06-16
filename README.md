# XYBase
Simplified version of old MarioLib

> I try to start this new work to simplify my previous work of MarioLib, to make it more easier to use.     
> I'm thinking of to have only .h .m file to include all necessory classes.     

> The purpose is that I don't want to do repeat work when start a new app, there must be something in common like design pattern, functions, features, and I would like to figure them out.

### BaseVc/BaseTableVc
Contains a method to show common busy indicator

```
-(void)performBusyProcess:(XYProcessResult*(^)(void))block;
```
In subclass, you can use it in any action that taking time, logic will be executed in background thread
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
What and how activity indicator is displayed controlled by method below
```
-(void)turnOnBusyFlag;
```
```
-(void)turnOffBusyFlag;
```
A practical way is to implement the logic in base class in order to have consistent behavior across the app.
E.g. You can have UIAlertController field ac in base class and
```
-(void)turnOnBusyFlag{
    ac = [UIAlertController alertControllerWithTitle:@"Busy" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
}
```
```
-(void)turnOffBusyFlag{
    [ac dismissViewControllerAnimated:YES completion:nil];
}
```
Or use third party classes like
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



