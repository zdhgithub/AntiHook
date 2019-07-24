//
//  InjectCodeObj.m
//  InjectCode
//
//  Created by dh on 2019/7/22.
//  Copyright © 2019 dh. All rights reserved.
//

#import "InjectCodeObj.h"
#import <UIKit/UIKit.h>
#import "fishhook.h"
#import <objc/message.h>

@implementation InjectCodeObj

+(void)load{
    
    //2.基本防护 Method Swizzle
    struct rebinding bd ;
    bd.name = "method_exchangeImplementations"; //原函数名（字符串） A函数
    bd.replacement = myExchange; //交换后的函数 B函数
    bd.replaced = (void *)&old_exchage; //暂存原函数的地址 中间变量temp函数,
    
    //3.升级防护，用于防护logos （cydia substrate）
    //    method_setImplementation
    struct rebinding bd1 ;
    bd1.name = "method_getImplementation";
    bd1.replacement = myExchange;
    bd1.replaced = (void *)&getImp;
    
    struct rebinding bd2 ;
    bd2.name = "method_setImplementation";
    bd2.replacement = myExchange;
    bd2.replaced = (void *)&setImp;
    
    //fishhook 方法交换
    struct rebinding rebind[] = {bd,bd1,bd2};
    
    /*
     arg1:数组，元素必须是rebinding这个结构体
     arg2:数组个数
     */
    rebind_symbols(rebind, 3);
    
    
#pragma mark 防护代码写在前面才能检测到HOOK Xcode:10.2.1 MacOS:10.14.5
    //1.先交换，防护之前要将所有的交换都写完
    Method oldOne =  class_getInstanceMethod(objc_getClass("ViewController"), @selector(touchesBegan:withEvent:));
    Method newOne =  class_getInstanceMethod(self, @selector(my_touchesBegan:withEvent:));
    method_exchangeImplementations(oldOne, newOne);
}




//用于存放method_getImplementation涵数
IMP _Nonnull(*getImp)(Method _Nonnull m) ;

//用于存放method_setImplementation涵数
IMP _Nonnull(*setImp)(Method _Nonnull m, IMP _Nonnull imp) ;

//用于存放method_exchangeImplementations涵数 也就是Temp函数
void (* old_exchage)(Method _Nonnull m1, Method  _Nonnull m2);
//新的交换函数 B函数
void myExchange(Method _Nonnull m1, Method  _Nonnull m2){
    NSLog(@"检测到hook");
//    exit(1);
}



-(void)my_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"HOOK 成功！！");
}

@end
