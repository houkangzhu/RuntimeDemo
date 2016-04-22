//
//  TableViewController.h
//  PrivateAPITest
//
//  Created by Company on 16/4/22.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

///获得传入类的属性/方法/变量
extern NSString * getClassAttribute(Class cls);

///获得传入对象的属性/变量的值
extern NSString *getObjectValue(id object);

@end
