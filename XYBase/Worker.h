//
//  Worker.h
//  XYBase
//
//  Created by 徐晓烨 on 16/6/21.
//  Copyright © 2016年 XY. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Worker : NSManagedObject
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* title;

@end
