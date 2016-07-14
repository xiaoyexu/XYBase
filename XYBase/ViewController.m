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
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    imagePickerController = [[UIImagePickerController alloc] init];
//    imagePickerController.delegate = self;
//    
//    imagePickerController.allowsEditing = YES;
//    
//    [self.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
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
    
    XYSelectUIButton* button2 = [[XYSelectUIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 25)];
    button2.selectedImg = [UIImage imageNamed:@"sort_up_green"];
    button2.deselectedImg = [UIImage imageNamed:@"sort_down_green"];
    [button2 addTarget:self action:@selector(selectClicked:) forControlEvents:UIControlEventTouchDown];
    [button2 renderView];
    [self.view addSubview:button2];
    
//    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
//    v.backgroundColor = [UIColor colorWithHex:0xfafafa];
//    [self.view addSubview:v];
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


-(void)click:(UIButton*)sender{
    
    
//    UIActionSheet *sheet;
    // 判断是否支持相机
    UIAlertController* alertController;
    alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"choose", @"choose") message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"photo", @"photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        
            imagePickerController.allowsEditing = YES;
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePickerController animated:YES completion:^{}];
            
            
            
        }]];
        
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"from album", @"album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
        
    }]];
    
   [self presentViewController:alertController animated:YES completion:nil];
    
    //    [self performBusyProcess:^XYProcessResult *{
    
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


