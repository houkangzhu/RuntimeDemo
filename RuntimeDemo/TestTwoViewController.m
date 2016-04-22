//
//  TestTwoViewController.m
//  RuntimeDemo
//
//  Created by Company on 16/4/22.
//  Copyright © 2016年 侯康柱. All rights reserved.
//

#import "TestTwoViewController.h"
#import "DemoObj.h"
#import "TableViewController.h"
#include <objc/runtime.h>
@interface TestTwoViewController ()

@end

@implementation TestTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

///动态替换方法
- (IBAction)replaceMethod {
    DemoObj *obj = [DemoObj new];
    
    [obj replaceMethod];
    
    [obj eat];
}


static const char associatedKey;
///动态挂载对象
- (IBAction)addObject {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"我是DemoObj动态挂载的" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    DemoObj *obj = [DemoObj new];
    objc_setAssociatedObject(obj, &associatedKey, alert, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getAssociatedObject:obj];
    });
    
}

- (void)getAssociatedObject:(DemoObj *)obj {
    
    UIAlertView *alert = objc_getAssociatedObject(obj, &associatedKey);
    [alert show];
}


- (IBAction)createCalss:(id)sender {
    
    const char *className = "MyClass";
    
    ///声明类
    Class MyClass = objc_getClass(className);
    if (!MyClass) {
        Class supercls = [NSObject class];
        MyClass = objc_allocateClassPair(supercls, className, 0);
    }

    
    ///添加一个属性
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership = { "C", "" }; // C = copy
    objc_property_attribute_t backingivar  = { "V", "aProperty" };
    objc_property_attribute_t attribute[] = { type, ownership, backingivar };
    class_addIvar(MyClass, "aProperty", sizeof(NSString *), 0, "@");
    class_addProperty(MyClass, "aProperty", attribute, 1);
    class_addMethod(MyClass, @selector(aProperty), (IMP)aProperty, "@@:");
    class_addMethod(MyClass, @selector(setAPriperty:), (IMP)setAPriperty, "v@:@");
    
    
    ///添加一个变量
    class_addIvar(MyClass, "aIvar", sizeof(NSString *), 0, "@");
    
    
    ///添加一个方法
    class_addMethod(MyClass, @selector(aMethod:), (IMP)aMethod, "v@:@");
    objc_registerClassPair(MyClass);
    
    
    //替换方法
    class_replaceMethod(MyClass, @selector(description), (IMP)description, "@@:");
    
    
    //***********类的实例化*************
    
    id myObj = [MyClass new];
    
    Ivar ivar = class_getInstanceVariable(MyClass, "aIvar");
    object_setIvar( myObj, ivar, @"你好我是iVar");
    
    [myObj setAPriperty:@"这是property_____"];
    
    NSLog(@"----%@===",[myObj aProperty]);
    
    [myObj aMethod:100];
    
    
    NSString *des = [myObj description];
//    id instence = getObjectFrom
    NSLog(@"------%@", des);
    
}

//*******************属性的添加***********************
///get方法
NSString *aProperty(id SELF, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable([SELF class], "aProperty");
    return object_getIvar(SELF, ivar);
}

- (NSString *)aProperty {
    return @"";
}
///set方法
void setAPriperty(id SELF, SEL _cmd, NSString *aProperty) {
    Ivar ivar = class_getInstanceVariable([SELF class], "aProperty");
    id oldName = object_getIvar(SELF, ivar);
    if (oldName != aProperty){
        object_setIvar(SELF, ivar, [aProperty copy]);
    }
}

- (void)setAPriperty:(NSString *)aPriperty {
    
}


//*********************方法的添加****************************

void aMethod(id SELF, SEL _cmd, int a) {
    NSLog(@"调用好了方法...\n传入的参数为:%d", a);
    
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"传入值为%d", a] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
}

- (void)aMethod:(int )a {
    
}


//*********************方法的替换**************************

NSString *description(id SELF, SEL _cmd) {
    
    NSString *str1 = getClassAttribute([SELF class]);
    
    NSMutableString *str = [NSMutableString stringWithString:str1];
    
    [str appendFormat:@"\n\n%@",getObjectValue(SELF)];
    
    
    return str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
