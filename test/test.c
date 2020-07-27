//
//  test.c
//  test
//
//  Created by YeQing on 2020/7/23.
//  Copyright © 2020 laoqingcai. All rights reserved.
//

#include "test.h"
#include <pthread.h>
#include <unistd.h>

pthread_t thread;

void start(void *param) {
    printf("1\n");
    sleep(5);
    printf("2");
    pthread_exit(&thread);
}

int test(void) {
    pthread_create(&thread, NULL, start, NULL);
    pthread_detach(thread);
    return 0;
}
