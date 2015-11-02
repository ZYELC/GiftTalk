//
//  PaserHTML.m
//  礼物说
//
//  Created by qianfeng on 14/10/16.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//

#import "PaserHTML.h"

@implementation PaserHTML

+ (NSArray *)paserWithString:(NSString *)html
{
    NSRange range1 = [html rangeOfString:@"<body>"];
    NSRange range2 = [html rangeOfString:@"</body>"];
    NSString *body = [html substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - range1.length - range1.location)];
//    NSLog(@"%@",body);
    NSArray *arr = [body componentsSeparatedByString:@"src="];
//    NSLog(@"%@",arr);
    NSMutableArray *imgs = [NSMutableArray arrayWithCapacity:0];
    for (NSString *str in arr) {
        if (([str rangeOfString:@"http://"].location != NSNotFound) && ![str isEqualToString:arr[0]] && ([str rangeOfString:@".jpg\""].location != NSNotFound)) {
            NSRange range3 = [str rangeOfString:@".jpg\""];
            NSString *s = [[str substringToIndex:range3.location + 4] substringFromIndex:1];
            [imgs addObject:s];
        }
    }
    return imgs;
}
@end
