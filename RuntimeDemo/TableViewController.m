//
//  TableViewController.m
//  PrivateAPITest
//
//  Created by Company on 16/4/22.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import "TableViewController.h"
#include <objc/runtime.h>
@interface TableViewController ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"UITextField";
    
    NSString *atrriStr = getClassAttribute([UITextField class]);
    
    self.dataArr = [atrriStr componentsSeparatedByString:@"\n"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reusedID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedID];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        
        cell.textLabel.textColor = [UIColor blueColor];
    }
    // Configure the cell...
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}




#pragma mark --- runtime -----

extern NSString * getClassAttribute(Class cls) {
    
    NSString *className = NSStringFromClass(cls);
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@解析\n\n\tproperty_list(属性列表):", className];
    
    unsigned int property_count ;
    objc_property_t *property_list = class_copyPropertyList(cls, &property_count);
    for (int i = 0; i<property_count; i++) {
        
        objc_property_t property = property_list[i];
        const char *name = property_getName(property);
        NSString *nameString = [NSString stringWithUTF8String:name];
        [str appendFormat:@"\n%@",nameString];
        
    }
    free(property_list);
    
    
    [str appendFormat:@"\n\n\tmethod_list(方法列表):"];
    
    unsigned int method_count;
    Method *method_list = class_copyMethodList(cls, &method_count);
    for (int i = 0; i<method_count; i++) {
        
        Method method = method_list[i];
        SEL methodSEL = method_getName(method);
        const char *selName = sel_getName(methodSEL);
        NSString *nameString = [NSString stringWithUTF8String:selName];
        [str appendFormat:@"\n%@",nameString];
    }
    free(method_list);
    
    
    [str appendFormat:@"\n\n\tivar_list(变量列表):"];
    unsigned int ivar_count;
    Ivar *ivar_list = class_copyIvarList(cls, &ivar_count);
    for (int i = 0; i<ivar_count; i++) {
        
        Ivar ivar = ivar_list[i];
        const char *ivarName = ivar_getName(ivar);
        NSString *nameString = [NSString stringWithUTF8String:ivarName];
        [str appendFormat:@"\n%@",nameString];
    }
    free(ivar_list);
    //    unsigned int protocol_count ;
    //    Protocol *protocol_list = class_copyProtocolList([UITextField class], &property_count);
    return str;
}



extern NSString *getObjectValue(id object) {
    
    Class objClass = [object class];
    NSString *className = [NSString stringWithUTF8String:class_getName(objClass)];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@__值.....\n\n\tproperty_list(属性):", className];
    
    unsigned int property_count ;
    objc_property_t *property_list = class_copyPropertyList(objClass, &property_count);
    for (int i = 0; i<property_count; i++) {
        
        objc_property_t property = property_list[i];
        const char *name = property_getName(property);
        NSString *nameString = [NSString stringWithUTF8String:name];
        
        
        Ivar ivar = class_getInstanceVariable(objClass, name);
        id value = object_getIvar(object, ivar);

        
        [str appendFormat:@"\n%@  =  %@",nameString, value];
        
    }
    free(property_list);

    
    
    [str appendFormat:@"\n\n\tivar_list(变量):"];
    unsigned int ivar_count;
    Ivar *ivar_list = class_copyIvarList(objClass, &ivar_count);
    for (int i = 0; i<ivar_count; i++) {
        
        Ivar ivar = ivar_list[i];
        const char *ivarName = ivar_getName(ivar);
        NSString *nameString = [NSString stringWithUTF8String:ivarName];
        
        id value = object_getIvar(object, ivar);
        
        [str appendFormat:@"\n%@  =  %@",nameString, value];
    }
    free(ivar_list);
    
    return str;
}

@end
