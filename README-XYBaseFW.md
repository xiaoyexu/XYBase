# XYBaseFW
A framework based on XYBase classes.

### XYInputTvc/XYButtonTvc/XYImageViewTvc
These are predefined table view cell classes, you can connect it to your table view cell in storyboard for reuse. Alternatively, you may create your own classes.

### XYUser
This is an object to store user data, like, user id, user name, status etc.

### XYAppDelegate
This class provides a basic auto login logic. 

### XYLoginRequest/XYLoginResponse/XYLoginMessageAgent
Login message based on XYBase.

### XYLoginVc
Basic login view controller.

## A basic login pattern
1. Define workflow in your storyboard. A typical logic workflow involves 2 view controllers, let's naming them loginVc and homeVc.

	First, you create a table view controller (loginVc) in storyboard, and wrap it by a navigation view controller, the loginVc has a segue to another view controller(homeVc) named "toHome", the navigation controller has storyboardID "initView", the homeVc has storyboardID "homeView".
 
2. Change your appDelegate class inherit from XYAppDelegate

	From
	
	```
	@interface AppDelegate : UIResponder <UIApplicationDelegate>
	```
	
	to
	
	```
	@interface AppDelegate : XYAppDelegate
	```

3. Override below methods on your needs

	The one to provide backend url
	
	```
	-(NSString*)backendUrl{
	    return @"http://127.0.0.1/mobile";
	}
	```

	The one to return your storyboard name, if it's not "Main"
	
	```
	-(NSString*)mainStoryboardName{
	    return @"Main";
	}
	```
	
	The one to return your start view storyboardID if it's not "initView"
	
	```
	-(NSString*)startViewName{
	    return @"initView";
	}
	```

	The one to return your home view storyboardID if it's not "homeView"
	
	```
	-(NSString*)homeViewName{
	    return @"homeView";
	}
	```

4. Make sure backend service works fine, in above example, 127.0.0.1/test provides a login api. Full url "http://127.0.0.1/mobile/login"
	
	You may find django code sample [here](https://github.com/xiaoyexu/xCRM/blob/master/mobile/views.py)

5. Create your own login view controller, or use XYLoginVc for short, bind table view cell components to XYInputTvc, XYButtonTvc etc.

6. Build and run, once login succeeded, username and password(sha1 processed) will be stored for automatical login next time.

## Display introduction view for first time

XYAppDelegate also provide you the feature to display a introduction view for the first time app is installed.

Create the view controller in storyborad and return the storyboardID of it, and enable it.

```
-(NSString*)introViewName{
    return @"introView";
}

-(BOOL)isIntroViewEnabled{
    return YES;
}
```

An example XYIntroVc is provided, or you can create your own view controller.

To dismiss the view controller, post a INTROVIEW_DISMISSED notification. E.g.

```
-(void)tryNowClicked:(UIButton*)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:INTROVIEW_DISMISSED object:nil];
}
```

