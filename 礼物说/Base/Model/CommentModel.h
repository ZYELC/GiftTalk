//
//  commentModel.h
//  礼物说
//
//  Created by qianfeng on 14/10/16.
//  Copyright (c) 2015年 孟璐. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UserModel.h"

@interface CommentModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *created_at;
@property (nonatomic, strong) NSDictionary *user;

@end
