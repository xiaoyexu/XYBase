//
//  ViewController.m
//  XYBase
//
//  Created by 徐晓烨 on 16/6/16.
//  Copyright © 2016年 XY. All rights reserved.
//

#import "ViewController.h"


@implementation TestOperation {
    NSString* _name;
}
-(id)initWithName:(NSString*)name{
    if (self = [super init]) {
        _name = name;
    }
    return self;
}
-(void)main{
    for(int i = 0; i<10 ; i++ ) {
        NSLog(@"%@ %d",
              _name, i);
        sleep(1);
    }
}

@end

@interface ViewController ()

@end

@implementation ViewController
{
    UIAlertController* ac;
    UIImagePickerController *imagePickerController;
    UIDatePicker* datePicker;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    
//    imagePickerController.allowsEditing = YES;
//
    self.button.backgroundColor = [UIColor greenColor];
    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
//
//    // Initialize core data
//    [[XYCoreDataManager instance] initCoreDataConnectorWithModel:@"XYBase" storeName:@"xybase.sqlite" asAlias:@"xybasedb"];
//    [self deleteDB];
//    [self showDB];
//    [self addRecord];
//    [self showDB];
    
//    XYUISegmentedControl* sc = [[XYUISegmentedControl alloc] initWithItems:@[@"a",@"b",@"c"]];
//    sc.frame = CGRectMake(10, 10, 200, 30);
//    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 30, 5)];
//    v.backgroundColor = [UIColor purpleColor];
//    sc.selectedView = v;
//    sc.selectedTitleFont = [UIFont systemFontOfSize:20];
//    sc.unSelectedTitleFont = [UIFont systemFontOfSize:10];
//    sc.selectedFontColor = [UIColor greenColor];
//    sc.tintColor = [UIColor clearColor];
//    sc.unSelectedFontColor = [UIColor redColor];
//    [sc renderView];
//    [self.view addSubview:sc];
    
//    XYSortUIButton* button = [[XYSortUIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
//    button.ascendingImg = [UIImage imageNamed:@"sort_up_green"];
//    button.descendingImg = [UIImage imageNamed:@"sort_down_green"];
//    button.noneSortImg = [UIImage imageNamed:@"sort_neutral"];
//    [button setTitle:@"Field" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.layer.borderColor = [UIColor redColor].CGColor;
//    button.layer.borderWidth = 1.f;
//    [button addTarget:self action:@selector(sortClicked:) forControlEvents:UIControlEventTouchDown];
////    In case change title and image location
////    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -80, 0, 0)];
////    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
//    [button renderView];
//    [self.view addSubview:button];
    
//    XYSelectUIButton* button2 = [[XYSelectUIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
//    button2.selectedImg = [UIImage imageNamed:@"sort_up_green"];
//    button2.deselectedImg = [UIImage imageNamed:@"sort_down_green"];
//    [button2 addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchDown];
//    [button2 renderView];
//    [self.view addSubview:button2];
    
//    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
//    v.backgroundColor = [UIColor colorWithHex:0xfafafa];
//    [self.view addSubview:v];
    
    
//    XYSearchBuilder* builder = [XYSearchBuilder new];
//    XYFieldSelectOption* fso = [[XYFieldSelectOption alloc] initWithProperty:@"name" andSelectOptionSign:SignTypeInclude option:OptionTypeEQ lowValue:@"a" highValue:@""];
//    [fso addSelectOptionSign:SignTypeInclude option:OptionTypeEQ lowValue:@"b" highValue:@""];
//    [builder addFieldSelectOption:fso];
//    fso = [[XYFieldSelectOption alloc] initWithProperty:@"age" andSelectOptionSign:SignTypeInclude option:OptionTypeBT lowValue:@"19" highValue:@"30"];
////    [fso addSelectOptionSign:SignTypeInclude option:OptionTypeEQ lowValue:@"b" highValue:@""];
//    [builder addFieldSelectOption:fso];
//    builder.orderBy = @[@"age"];
//    builder.sortType = SortTypeAscending;
//    NSDictionary* dic = [builder dictionaryRepresentation];
//
    
    
    
//    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, 200-45)];
//    datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    datePicker.datePickerMode = UIDatePickerModeDate;
//    [datePicker addTarget:self action:@selector(updateDateValue) forControlEvents:UIControlEventValueChanged];
//    UIView* datePickerInputView;
//    
//    datePickerInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
//    datePickerInputView.backgroundColor = [UIColor greenColor];
//    
//    field.inputView = datePickerInputView;
//    UIToolbar* bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
//    UIBarButtonItem* clear = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearValue)];
//    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    //UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(done)];
//    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
//    bar.items = [NSArray arrayWithObjects:clear, space, done, nil];
//    [datePickerInputView addSubview:bar];
//    [datePickerInputView addSubview:datePicker];
//
    
    
//    XYUITextField* field = [[XYUITextField alloc] initWithFrame:CGRectMake(20, 120, 250, 40)];
//    field.insetSize = CGSizeMake(15, 0);
//    field.backgroundColor = [UIColor redColor];
//    [self.view addSubview:field];
    
//    XYDatePickerUITextField* field = [[XYDatePickerUITextField alloc] initWithFrame:CGRectMake(20, 120, 250, 40)];
//    field.insetSize = CGSizeMake(5, 0);
//    field.backgroundColor = [UIColor redColor];
//    field.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//    [self.view addSubview:field];
    
    
//    XYPagedView* pv = [[XYPagedView alloc] initWithFrame:CGRectMake(30, 50, 200, 150)];
//    pv.backgroundColor = [UIColor lightGrayColor];
//    UIView* a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    a.backgroundColor = [UIColor redColor];
//    UIView* b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    b.backgroundColor = [UIColor greenColor];
//    UIView* c = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    c.backgroundColor = [UIColor blueColor];
//    [pv setCovers:@[a,b,c]];
//    pv.pageController.currentPageIndicatorTintColor = [UIColor purpleColor];
//    [self.view addSubview:pv];
    
//    XYImageListView* ilv = [[XYImageListView alloc] initWithFrame:CGRectMake(30, 50, 200, 150)];
//    ilv.paddingSize = CGSizeMake(2, 5);
//    ilv.imageSize = CGSizeMake(30, 20);
//    ilv.backgroundColor = [UIColor lightGrayColor];
//    UIView* a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    a.backgroundColor = [UIColor redColor];
//    UIView* b = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    b.backgroundColor = [UIColor greenColor];
//    UIView* c = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    c.backgroundColor = [UIColor blueColor];
//    UIView* d = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    d.backgroundColor = [UIColor purpleColor];
//    UIView* e = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    e.backgroundColor = [UIColor yellowColor];
//    [ilv setImageList:@[a,b,c,d,e]];
//    [self.view addSubview:ilv];
}

-(void)clearValue{
    
}

-(void)done{
    
}

-(void)updateDateValue{
    
}

-(void)sortClicked:(XYSortUIButton*)sender{
    NSLog(@"%d", sender.sortType);
}

-(void)selectClicked:(XYSelectUIButton*)sender{
    NSLog(@"%d", sender.selectType);
    // Change status on needs
    sender.selectType = SelectTypeSelected;
}

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

-(id)array:(NSArray*)array toObject:(Class)class{
    NSMutableArray* result = [NSMutableArray new];
    for (NSDictionary* dict in array) {
        id obj = [self dict:dict toObject:class];
        [result addObject:obj];
    }
    return result;
}

-(id)dict:(NSDictionary*)dict toObject:(Class)class{
    NSString* className = NSStringFromClass(class);
    id obj = [NSClassFromString(className) new];
    unsigned int ivarsCnt = 0;
    objc_property_t *properties = class_copyPropertyList(class,&ivarsCnt);
    for (int i = 0 ; i < ivarsCnt ; i++) {
        objc_property_t property = properties[i];
        const char* propname = property_getName(property);
        if (!propname) {
            continue;
        }
        const char* type = property_getAttributes(property);
        NSString *attr = [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char* rawPropertyType = [propertyType UTF8String];
        
        if (strcmp(rawPropertyType, @encode(float)) == 0) {
            //it's a float
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            //it's an int
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            //it's some sort of object
        } else {
            // According to Apples Documentation you can determine the corresponding encoding values
        }
        
        if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
            NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
            Class typeClass = NSClassFromString(typeClassName);
            if (typeClass != nil) {
                // Here is the corresponding class even for nil values
              
                
            }
            
            if ([typeClass isSubclassOfClass:[NSDictionary class]]){
                
            } else if ([typeClass isSubclassOfClass:[NSArray class]]) {
                
            }
        }
        NSString* propertyName = [NSString stringWithUTF8String:propname];
        NSString* restName = [propertyName substringFromIndex:1];
        NSString* getName = propertyName;
        if ([dict.allKeys containsObject:getName]) {
            id propertyValue = [dict objectForKey:propertyName];
            //                if ([propertyValue isKindOfClass:[NSArray class]]) {
            //
            //                } else if ([propertyValue isKindOfClass:[NSDictionary class]]) {
            //                    propertyValue = self dict:propertyValue toObject:<#(__unsafe_unretained Class)#>
            //                }
            
            NSString* initLetter = [propertyName substringToIndex:1];
            NSString* setName = [NSString stringWithFormat:@"set%@%@:",[initLetter uppercaseString],restName];
            
            if ([obj respondsToSelector:NSSelectorFromString(setName)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [obj performSelector:NSSelectorFromString(setName) withObject:propertyValue];
#pragma clang diagnostic pop
            }
        }
        
    }
    return obj;
}

-(void)testDictToObject{
    NSDictionary* dict = @{@"name":@"mario",@"age":@(33), @"class":@"aaa"};
    
    Person* p = [self dict:dict toObject:[Person class]];
    NSLog(@"%@, %ld", p.name, [p.age integerValue]);
}

-(void)testArrayToObject{
    NSArray* array =@[@{@"name":@"mario",@"age":@(33), @"class":@"aaa"},@{@"name":@"jack",@"age":@(30), @"class":@"bbb"}];
    NSArray* result = [self array:array toObject:[Person class]];
    for (Person* p in result) {
        NSLog(@"%@, %ld", p.name, [p.age integerValue]);
    }
}

-(void)click:(UIButton*)sender{
    
    TestRequest* request = [TestRequest new];
    request.key = @"abcde";
    request.number = @(2);
    NSDictionary* d = [request toDictionary];
    NSLog(@"%@ %ld",d[@"key"], [d[@"number"] integerValue]);
    TestRequest* request2 = [d toObjectAsClass:[TestRequest class]];
    NSLog(@"%@ %ld", request2.key, [request2.number integerValue]);
    
    
//    [self performBusyProcess:^XYProcessResult *{
//        
////        sleep(5);
////        return [XYProcessResult success];
//        TestRequest* request = [TestRequest new];
//        request.key = @"app";
//        TestResponse* response = (TestResponse*) [[XYMessageEngine instance] send:request];
//        if (response.responseCode == 0) {
//            NSLog(@"response: %@", response.value);
//            return [XYProcessResult success];
//        } else {
//            return [XYProcessResult failureWithError:response.responseDesc];
//        }
//    }];

    
    
//    [self testDictToObject];
//    [self testArrayToObject];
    
    
//    XYNotificationView* nv = [[XYNotificationView alloc] initWithTitle:@"something is wrong" delegate:nil];
//    nv.backgroundColor = [UIColor redColor];
////    nv.title = @"test";
//    [nv showInViewController:self waitUntilDone:YES];
    
//    
////    UIActionSheet *sheet;
//    // 判断是否支持相机
//    UIAlertController* alertController;
//    alertController = [UIAlertController alertControllerWithTitle:LS(@"choose") message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    
//
//    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//        
//    {
//        [alertController addAction:[UIAlertAction actionWithTitle:LS(@"photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        
//            imagePickerController.allowsEditing = YES;
//            
//            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//            
//            [self presentViewController:imagePickerController animated:YES completion:^{}];
//        }]];
//    }
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:LS(@"from album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        [self presentViewController:imagePickerController animated:YES completion:^{}];
//        
//    }]];
//    
//   [self presentViewController:alertController animated:YES completion:nil];
    
//        [self performBusyProcess:^XYProcessResult *{
//    
//        sleep(5);
//        return [XYProcessResult success];
//        TestRequest* request = [TestRequest new];
//        request.key = @"app";
//        TestResponse* response = (TestResponse*) [[XYMessageEngine instance] send:request];
//        if (response.responseCode == 0) {
//            NSLog(@"response: %@", response.value);
//            return [XYProcessResult success];
//        } else {
//            return [XYProcessResult failureWithError:response.responseDesc];
//        }
//  }];
    
//    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*5);
//    
//    dispatch_after(t, dispatch_get_main_queue(), ^{
//        // UI线程逻辑
//        ac = [UIAlertController alertControllerWithTitle:@"Busy2" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [self presentViewController:ac animated:YES completion:nil];
//    });
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        NSLog(@"Done");
//    });
//    dispatch_once(&onceToken, ^{
//        NSLog(@"Done");
//    });

//    dispatch_group_t g = dispatch_group_create();
//    dispatch_queue_t q = dispatch_get_main_queue();
//    dispatch_group_async(g, q, ^{
//        NSLog(@"g1");
//    });
//    dispatch_group_async(g, q, ^{
//        NSLog(@"g2");
//    });
//    dispatch_group_async(g, q, ^{
//        NSLog(@"g3");
//    });
//    dispatch_group_notify(g, q, ^{
//        NSLog(@"All done");
//    });
    
//    NSOperationQueue* queue = [NSOperationQueue mainQueue];
    
//    NSOperationQueue* queue = [NSOperationQueue new];
//    TestOperation* o = [[TestOperation alloc] initWithName:@"t"];
//    TestOperation* o2 = [[TestOperation alloc] initWithName:@"t2"];
//    [o2 addDependency:o];
//    [queue addOperation:o];
//    [queue addOperation:o2];
//    TestOperation* o3 = [[TestOperation alloc] initWithName:@"t3"];
//    [queue addOperation:o3];
    
    
//    NSBlockOperation* op = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"block executed");
//    }];
    
//    [queue addOperation:op];
//    [queue addOperation:[TestOperation new]];
    
}


-(void)turnOnBusyFlag{
    ac = [UIAlertController alertControllerWithTitle:@"Busy" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:ac animated:YES completion:nil];
}

-(void)turnOffBusyFlag{
    [ac dismissViewControllerAnimated:YES completion:nil];
}

-(void)handleCorrectResponse:(XYProcessResult *)result{
    
}

-(void)handleErrorResponse:(XYProcessResult *)result{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"cancelled");
     [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    for (NSString* key in info.keyEnumerator) {
        NSLog(@"%@ %@", key, [info objectForKey:key]);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
//    isFullScreen = NO;
    [self.imageView setImage:savedImage];
    
    self.imageView.tag = 100;
    
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    [picker dismissViewControllerAnimated:YES completion:^{}];
//    
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    /* 此处info 有六个值
//     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
//     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
//     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
//     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
//     * UIImagePickerControllerMediaURL;       // an NSURL
//     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
//     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
//     */
//    // 保存图片至本地，方法见下文
//    [self saveImage:image withName:@"currentImage.png"];
//    
//    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
//    
//    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
//    
//    isFullScreen = NO;
//    [self.imageView setImage:savedImage];
//    
//    self.imageView.tag = 100;
//    
//}
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:^{}];
//}

@end

@implementation Person
@synthesize name;
@synthesize age;
@end
