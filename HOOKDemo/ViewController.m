//
//  ViewController.m
//  HOOKDemo
//
//  Created by dh on 2019/7/22.
//  Copyright © 2019 dh. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "fishhook.h"

@interface ViewController ()

@end

@implementation ViewController

//更改系统NSLog函数
//函数指针，用来保存原始的函数地址
static void(*sys_nslog)(NSString *format,...);

//定义新的NSLog
void myNSLog(NSString * format, ...){
    format = [format stringByAppendingString:@"勾上了！！"];
    sys_nslog(format);
}


//+ (void)load{
//    //基本防护
//    struct rebinding bd;
//    bd.name = "method_exchangeImplementations";
//    bd.replacement = myExchange;
//    bd.replaced = (void *)&exchangeP;
//    
//    struct rebinding rebds[] = {bd};
//    rebind_symbols(rebds, 1);
//}
//
//void (*exchangeP)(Method _Nonnull m1, Method  _Nonnull m2);
//void   myExchange(Method _Nonnull m1, Method  _Nonnull m2){
//    NSLog(@"检测到HOOK！");
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    rebinding结构体
    struct rebinding nslog;
    nslog.name = "NSLog";
    nslog.replacement = myNSLog;
    nslog.replaced = (void *)&sys_nslog;
    
//    定义数组
    struct rebinding rebs[1] = {nslog};
    /*
     arg1 存放rebinding结构体的数组
     arg2 数组的长度
     */
    rebind_symbols(rebs, 1);
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了屏幕!");
}

@end
