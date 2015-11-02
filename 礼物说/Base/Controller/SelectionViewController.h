//
//  SubjectDetailViewController.h
//  礼物说
//
//  Created by qianfeng on 14/10/12.
//  Copyright (c) 2014年 zhangying. All rights reserved.
//  分类点击进入的控制器(攻略详情前一个界面)
#import <UIKit/UIKit.h>

@interface SelectionViewController : UIViewController

@property (nonatomic, strong) NSString *collectionID;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, assign) BOOL isCollection;
@end
