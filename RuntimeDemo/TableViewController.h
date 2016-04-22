//
//  TableViewController.h
//  PrivateAPITest
//
//  Created by Company on 16/4/22.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController

extern NSString * getClassAttribute(Class cls);


extern NSString *getObjectValue(id object);

@end
