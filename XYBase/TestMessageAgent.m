//
//  TestMessageAgent.m
//  XYBase
//
//  Created by 徐晓烨 on 16/6/23.
//  Copyright © 2016年 XY. All rights reserved.
//

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
    NSLog(@"Result: %@", json);
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
@end
