//
//  ZHObjcRuntimeTest.m
//  ZHThreadsDemo
//
//  Created by YeQing on 2020/12/23.
//  Copyright © 2020 mengdong. All rights reserved.
//

#import "ZHObjcRuntimeTest.h"
#import <objc/runtime.h>


/// 交换Method
void exchangeMethod(Class aClass, SEL oldSEL, SEL newSEL) {
    Method oldMethod = class_getInstanceMethod(aClass, oldSEL);
    Method newMethod = class_getInstanceMethod(aClass, newSEL);
    method_exchangeImplementations(oldMethod, newMethod);
}
/// 替换Method
void replaceMethod(Class hoolClass, SEL oldSEL, Class newClass, SEL newSEL, IMP *oldImp) {
    Method oldMethod = class_getInstanceMethod(hoolClass, oldSEL);
    IMP newImp = class_getMethodImplementation(newClass, newSEL);
    if (oldImp != NULL) {
        *oldImp = method_setImplementation(oldMethod, newImp);
    }
    else {
        method_setImplementation(oldMethod, newImp);
    }
}

@interface Father : NSObject
@end
@implementation Father
@end
@interface Son : Father
@property (nonatomic, strong) NSString *name;
@end
@implementation Son
static NSString *nickname = @"";
- (void)eta {}
+ (void)clothe {}
@end


extern void _objc_autoreleasePoolPrint(void);

@interface ZHObjcRuntimeTest()
@property (nonatomic, strong) NSString *name;
@end

@implementation ZHObjcRuntimeTest
+ (void)load {
//    //方案1：交换
//    exchangeMethod([NSObject class], @selector(description), @selector(hook_description));
//    //方案2：替换
//    IMP *old_description_ = &(old_description);
//    replaceMethod([NSObject class], @selector(description), [self class], @selector(hook_description), old_description_);
//
}
- (void)dealloc {
    
}
///打印变量
- (void)printIvars:(NSObject *)obj {
    Class cls = obj.class;
    unsigned int count = 0;
    Ivar *members = class_copyIvarList(cls, &count);
    for(int i = 0; i < count; i++) {
        Ivar ivar = members[i];
        const char *memberName = ivar_getName(ivar);
        NSLog(@"%@,%p,%@", cls, cls,  [NSString stringWithCString:memberName encoding:NSUTF8StringEncoding]);
    }
    free(members);
}
///打印方法
- (void)printMethods:(Class )cls {
    unsigned int methodCount;
    Method *methodList = class_copyMethodList(cls, &methodCount);
    unsigned int i = 0;
    for (; i < methodCount; i++) {
      NSLog(@"%@,%p,%@", cls, cls, [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding]);
    }
    free(methodList);
}

static NSOperationQueue *queue = NULL;

- (void)testss {
    NSLog(@"5");
}

- (void)test {
//    printf("\r\ntest1");
    
//    NSLog(@"1");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"3");
//        [self performSelector:@selector(testss) withObject:nil afterDelay:0.0f];
//        [[NSRunLoop currentRunLoop] run];
//        NSLog(@"4");
//    });
//    NSLog(@"2");
    
//    if (!queue) {
//        queue = [[NSOperationQueue alloc] init];
//    }
//    for (int i = 0; i<500; i++) {
//        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
//            NSLog(@"%d",i);
//            sleep(5000);
//        }];
//        [queue addOperation:operation];
//    }
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        NSLog(@"task1 begin");
//        sleep(5);
//        NSLog(@"task1 done");
//        dispatch_group_leave(group);
//    });
//    dispatch_group_enter(group);
//    dispatch_async(queue, ^{
//        NSLog(@"task2 begin");
//        sleep(2);
//        NSLog(@"task2 done");
//        dispatch_group_leave(group);
//    });
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"all task done");
//    });
    
    
//    NSLog(@"1:%@", object_getClass(self));
//    [self addObserver:self forKeyPath:@"_name" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
//    NSLog(@"2:%@", object_getClass(self));
//    [self removeObserver:self forKeyPath:@"_name"];
//    NSLog(@"3:%@", object_getClass(self));
    
//    //无autoreleasepool版本
//    @autoreleasepool {
//        NSString *str1 = [NSString stringWithFormat:@"你"];
//        @autoreleasepool {
//            NSString *str2 = [NSString stringWithFormat:@"好"];
//            @autoreleasepool {
//                NSString *str3 = [NSString stringWithFormat:@"啊"];
//                _objc_autoreleasePoolPrint();
//            }
//            _objc_autoreleasePoolPrint();
//        }
//    }
//
//    [self performSelector:@selector(description) withObject:nil afterDelay:10];
    
//    //有autoreleasepool版本
//    for (int i = 0;  i < 100000/1000; i++) {
//        //每1000次，生成一个autoreleasepool
//        @autoreleasepool {
//            for (int j = 0;  j < 1000; j++) {
//                NSArray *users = [NSArray array];
//            }
//        }
//    }
    
//    NSLog([self description]);
//    Son *obj1 = [[Son alloc] init];
//    [self printIvars:obj1.class];
//    [self printMethods:obj1.class];
//    NSLog(@"==");
//    [self printIvars:object_getClass(obj1.class)];
//    [self printMethods:object_getClass(obj1.class)];
////    //对象的isa
////    NSLog(@"%@,%p,%p,%d,%d", obj1.class, obj1.class, Son.class, obj1.class == Son.class, class_isMetaClass(obj1.class));
////    //class的isa = meta
////    Class class1Isa = object_getClass(obj1.class);
////    NSLog(@"%@,%p,%d", class1Isa, class1Isa, class_isMetaClass(class1Isa));
////    //class的isa的isa = meta的isa = NSObject meta
////    Class meta1Isa = object_getClass(class1Isa);
////    NSLog(@"%@,%p,%d", meta1Isa, meta1Isa, class_isMetaClass(meta1Isa));
////
////    Father *obj2 = [[Father alloc] init];
////    //对象的isa
////    NSLog(@"%@,%p,%p,%d,%d", obj2.class, obj2.class, Father.class, obj2.class == Father.class, class_isMetaClass(obj1.class));
////    //class的isa = meta
////    Class class2Isa = object_getClass(obj2.class);
////    NSLog(@"%@,%p,%d", class2Isa, class2Isa, class_isMetaClass(class2Isa));
////    //class的isa的isa = meta的isa = NSObject meta
////    Class meta2Isa = object_getClass(class2Isa);
////    NSLog(@"%@,%p,%d", meta2Isa, meta2Isa, class_isMetaClass(meta2Isa));
//    printf("\r\ntest2");
}



///// 有返回值的IMP
//typedef id (*BCIMP)(id, SEL, ...);
///// 无返回值的IMP
//typedef void (*BCVIMP)(id, SEL, ...);
//
//static IMP old_description = NULL;
//- (NSString *)hook_description {
//    NSLog(self);
//    NSString *result = nil;
//    if (old_description != NULL) {
//        result = ((BCIMP)old_description)(self, @selector(description));
//    }
//    return result;
//}

@end
