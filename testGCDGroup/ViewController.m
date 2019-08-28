//
//  ViewController.m
//  testGCDGroup
//
//  Created by Zhang,Hongwei(RM) on 2019/8/28.
//  Copyright © 2019 Zhang,Hongwei(RM). All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self testGroupEnterAndLeave];
    [self testGroupSemphore];
}

-(void)testGroupSemphore{
    dispatch_group_t group = dispatch_group_create();
    //耗时任务1
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        dispatch_semaphore_t semaphore1 = dispatch_semaphore_create(0);
        [self startTask1WithCompletion:^(id response) {
            NSLog(@"任务1完成");
            dispatch_semaphore_signal(semaphore1);
        }];
        dispatch_semaphore_wait(semaphore1, DISPATCH_TIME_FOREVER);
    });
    //耗时任务2
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
        dispatch_semaphore_t semaphore2 = dispatch_semaphore_create(0);
        [self startTask2WithCompletion:^(id response) {
            NSLog(@"任务2完成");
            dispatch_semaphore_signal(semaphore2);
        }];
        dispatch_semaphore_wait(semaphore2, DISPATCH_TIME_FOREVER);
    });
    dispatch_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"全部完成");
    });

}

-(void)testGroupEnterAndLeave{
    dispatch_group_t group = dispatch_group_create();
    //耗时任务1
    dispatch_group_enter(group);
    [self startTask1WithCompletion:^(id response) {
        NSLog(@"任务1完成");
        dispatch_group_leave(group);
    }];
    //耗时任务2
    dispatch_group_enter(group);
    [self startTask2WithCompletion:^(id response) {
        NSLog(@"任务2完成");
        dispatch_group_leave(group);
    }];
    dispatch_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"全部完成");
    });

}


- (void)startTask1WithCompletion:(void (^)(id response))completion {
    //模拟一个网络请求
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"start 1");
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(@1111);
        });
    });
}
- (void)startTask2WithCompletion:(void (^)(id response))completion {
    //模拟一个网络请求
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"start 2");
        sleep(3);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(@1111);
        });
    });
}




@end
