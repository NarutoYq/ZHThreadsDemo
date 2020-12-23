//
//  ZHMutableArrayTest.m
//  ZHThreadsDemo
//
//  Created by YeQing on 2020/12/11.
//  Copyright © 2020 mengdong. All rights reserved.
//

#import "ZHMutableArrayTest.h"
#import <objc/runtime.h>

//MARK: - ZHMutableArray
typedef struct {
    void **list;
    //首元素的位置
    unsigned int offset;
    //总大小
    unsigned int size;
    union {
        unsigned long long mutations;
        struct {
            unsigned int muts;
            //使用的大小
            unsigned int used;
        } ;
    } state;
} CDStruct_a6934631;

@interface ZHMutableArray : NSObject  {
    @public void *cow;
    @public CDStruct_a6934631 storage;
}
@end

@implementation ZHMutableArray
@end


//MARK: - ZHMutableArrayTest
@implementation ZHMutableArrayTest

/// 数组测试
+ (void)testCircle {
//    id objA = [NSObject new];
//    id objB = [NSObject new];
//    id objC = [NSObject new];
//    id objD = [NSObject new];
    id objA = @"A";
    id objB = @"B";
    id objC = @"C";
    id objD = @"D";
    id objE = @"E";
    // 1.初始化，容量设置为1
    NSMutableArray *list2 = [[NSMutableArray alloc] initWithCapacity:1];
    printf("1.init\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    // 2.尾部追加 objA、objB
    [list2 addObject:objA];
    [list2 addObject:objB];
    printf("\r\n\r\n2.add object:\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    // 3.首位置插入 objC
    [list2 insertObject:objC atIndex:0];
    printf("\r\n\r\n3.insert object at 0:\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    // 4.删除首位置元素
    [list2 removeObjectAtIndex:0];
    printf("\r\n\r\n4.remove object at 0:\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    // 5.在第2个位置上插入 objD
    [list2 insertObject:objD atIndex:1];
    printf("\r\n\r\n5.insert object at 1:\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    // 6.在第2个位置上插入 objE
    [list2 insertObject:objE atIndex:1];
    printf("\r\n\r\n6.insert object at 1:\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    // 7.移除第3个元素
    [list2 removeObjectAtIndex:2];
    printf("\r\n\r\n7.remove object at 2:\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    // 8.移除尾部元素
    [list2 removeLastObject];
    printf("\r\n\r\n8.remove last object:\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    // 9.移除所有元素
    [list2 removeAllObjects];
    printf("\r\n\r\n9.remove all object:\r\n%s", [[ZHMutableArrayTest getDesc:list2] UTF8String]);
    
}

/// 获取 arrayM 描述信息
+(NSString *) getDesc:(NSMutableArray *)list {
    assert([NSStringFromClass([list class]) isEqualToString:@"__NSArrayM"]);
    ZHMutableArray *array = (ZHMutableArray *)list;
    NSMutableString *description = [[NSMutableString alloc] init];
    int offset = array->storage.offset;
    int size = array->storage.size;
//    [description appendFormat:@"cow:%@", array->cow];
    [description appendFormat:@"offset:%d", offset];
    [description appendFormat:@",size:%d", size];
    [description appendFormat:@",used:%u", array->storage.state.used];
    [description appendFormat:@",mutations:%llu", array->storage.state.mutations];
    [description appendFormat:@",muts:%u", array->storage.state.muts];
    for (int i = 0; i < size; i++) {
        if (i==0) {
            [description appendString:@"\r\n"];
        }
        [description appendFormat:@"[%d]%@,%p  |  ", i, array->storage.list[i], array->storage.list[i]];
    }
    return description;
}

///打印变量
+ (void)printIvars:(NSObject *)obj {
    Class cls = obj.class;
    unsigned int count = 0;
    Ivar *members = class_copyIvarList(cls, &count);
    for(int i = 0; i < count; i++) {
        Ivar ivar = members[i];
        const char *memberName = ivar_getName(ivar);
//        id value = object_getIvar(obj, ivar);
        NSLog(@"%@,%p,%@", cls, cls,  [NSString stringWithCString:memberName encoding:NSUTF8StringEncoding]);
    }
    free(members);
}

@end
