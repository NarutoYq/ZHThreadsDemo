//
//  ZHSortTest.m
//  ZHThreadsDemo
//
//  Created by YeQing on 2020/12/14.
//  Copyright © 2020 mengdong. All rights reserved.
//

#import "ZHSortTest.h"


@interface ZHSortTest()

@end

@implementation ZHSortTest

//MARK: - 快排
/// 快排
void quickSort(int* array, int length, int left, int right) {
    if (left >= right)  return;
    if (right >= length) return;
    if (left < 0) return;
    // 挑选基准值
    int cursor = array[left];
    int i = left;
    int j = right;
    while (true) {
        // 从后面往前找小于 cursor 的元素
        while (j>i && array[j]>=cursor) {
            j--;
        }
        // i、j 相遇
        if (i>=j) break;
        // 从前面往后找大于 cursor 的元素
        while (i<j && array[i]<=cursor) {
            i++;
        }
        // i、j相遇
        if (i>=j) break;
        // 交换 i、j
        int iValue = array[i];
        array[i] = array[j];
        array[j] = iValue;
    }
    // 更新 cursor 位置
    if (i != left) {
        int iValue = array[i];
        array[i] = cursor;
        array[left] = iValue;
    }
    // 继续递归
    if (i-1 > left) {
        quickSort(array, length, left, i-1);
    }
    if (right > j+1) {
        quickSort(array, length, j+1, right);
    }
}

//MARK: - 计数排序
/// 计数排序
void countSort(int* array, int length) {
    if (length<=1) return ;
    // 获取最大最小值
    int maxValue = array[0];
    int minValue = array[0];
    for (int i=1; i<length; i++) {
        int tmpValue = array[i];
        maxValue = MAX(tmpValue, maxValue);
        minValue = MIN(tmpValue, minValue);
    }
    // 新建数组
    int newSize = maxValue - minValue + 1;
    int *newArray = malloc(sizeof(int)*newSize);
    for (int i = 0; i<newSize; i++) {
        newArray[i] = 0;
    }
    // 把 源数组元素 对应到 新数组 index中。
    for (int i = 0; i<length; i++) {
        int tmpValue = array[i];
        int valueIndex = tmpValue - minValue;
        int valueCount = newArray[valueIndex];
        newArray[valueIndex] = (valueCount + 1);
    }
    // 更新源数组【可选】
    int oldIndex = -1;
    for (int i = 0; i<newSize; i++) {
        int valueCount = newArray[i];
        if (valueCount == 0) continue;
        int value = minValue + i;
        for (int j=0; j<valueCount; j++) {
            oldIndex ++;
            array[oldIndex] = value;
        }
    }
    free(newArray);
}

//MARK: - 堆排序
/// 从 parentIndex 节点开始，调整二叉树，成为大(小)顶堆。
/// 调整之后，可能会使子节点不满足大(小)顶堆，会继续调整子节点。
void heapSortAdjustHandle(int* array, int length, int index) {
    int parentIndex = index;
    while (true) {
        int parentValue = array[parentIndex];
        int maxValue = parentValue;
        int maxIndex = -1;
        // 1.和左子节点比较大小
        int leftChildIndex = 2*parentIndex + 1;
        if (leftChildIndex > length-1) break;
        int leftValue = array[leftChildIndex];
        if (leftValue > maxValue) {
            maxIndex = leftChildIndex;
            maxValue = leftValue;
        }
        // 2.和右子节点比较大小
        int rightChildIndex = 2*parentIndex + 2;
        if (rightChildIndex <= length-1) {
            int rightValue = array[rightChildIndex];
            if (rightValue > maxValue) {
                maxIndex = rightChildIndex;
                maxValue = rightValue;
            }
        }
        if (maxIndex <= -1) break;
        // 3.交换最大值
        array[parentIndex] = maxValue;
        array[maxIndex] = parentValue;
        // 4.继续调整子节点
        parentIndex = maxIndex;
    }
}
/// 堆排序
void heapSort(int* array, int length) {
    // 1.从第一个非子节点开始，调整节点顺序，构造大（小）顶堆
    for (int i=(length-1-1)/2.0; i>=0; i--) {
        heapSortAdjustHandle(array, length, i);
    }
    // 2.循环列表，依次取出顶部元素（最大、最小元素），并继续调整剩下的元素，满足大（小）顶堆
    for (int i=length-1; i>=0; i--) {
        // 2.1交换首尾元素，剔除顶部元素，即选择最大或最小的元素，放在尾部
        int lastValue = array[i];
        array[i] = array[0];
        array[0] = lastValue;
        // 2.2首部元素改变，在剩下的元素（除length-1之后的元素）内，继续调整首节点，满足大（小）顶堆。
        int rightBoundary = i-1;
        heapSortAdjustHandle(array, rightBoundary, 0);
    }
}

//MARK: - 归并排序
/// 归并排序
void mergeSort(int *array, int length) {
    int *newArray = mergeSortRecursive(array, length, 0, length-1);
    for (int i=0; i<length; i++) {
        printf("%d,",newArray[i]);
    }
    printf("\r\n");
    free(newArray);
}
/// 递归执行划分、合并操作
int* mergeSortRecursive(int *array, int length, int left, int right) {
    int *newArray = (int *)malloc((right-left+1)*sizeof(int));
    memset(newArray, 0, sizeof(int)*(right-left+1));
    if (left >= right) {
        newArray[0] = array[left];
        return newArray;
    }
    int leftEnd = left+(right-left)/2;
    int rightStart = leftEnd+1;
    // 划分左右区间
    int *leftArray = mergeSortRecursive(array, length, left, leftEnd);
    int *rightArray = mergeSortRecursive(array, length, rightStart, right);
    // 合并左右区间
    mergeHandle(newArray, leftArray, leftEnd-left+1, rightArray, right-rightStart+1);
    free(leftArray);
    free(rightArray);
    return newArray;
}
/// 合并左右两侧区域
void mergeHandle(int *newArray, int *leftArray, int leftLength, int *rightArray, int rightLength) {
    int leftIndex = 0;
    int rightIndex = 0;
    int index = 0;
    while (true) {
        // 双指针，对比左右区域
        int leftItem = leftArray[leftIndex];
        int rightItem = rightArray[rightIndex];
        if (leftItem <= rightItem) {
            // left <= right
            newArray[index] = leftItem;
            index++;
            leftIndex++;
        }
        else {
            // right < left
            newArray[index] = rightItem;
            index++;
            rightIndex++;
        }
        // 左侧区域或右侧区域已经遍历完
        if (leftIndex >= leftLength || rightIndex >= rightLength) break;
    }
    // 左侧区域有剩余元素
    if (leftIndex<leftLength) {
        for (int i=leftIndex; i<leftLength; i++) {
            newArray[index] = leftArray[i];
            index++;
        }
    }
    // 右侧区域有剩余元素
    if (rightIndex<rightLength) {
        for (int i=rightIndex; i<rightLength; i++) {
            newArray[index] = rightArray[i];
            index++;
        }
    }
}

//MARK: - top k
/// 分治法分割两数组，返回基准值 pivot index
int partion(int* array, int length, int left, int right) {
    if (left >= right) return left;
    // 挑选基准值
    int i = left;
    int j = right;
    int pivot = array[left];
    while (true) {
        //从后往前找小于 pivot 的元素
        while (j > i && array[j]>= pivot) j--;
        // i、j相遇
        if (i>=j) break;
        //从前往后找大于 pivot 的元素
        while (i < j && array[i]<= pivot) i++;
        // i、j相遇
        if (i>=j) break;
        // 交换 i j
        int tmp = array[i];
        array[i] = array[j];
        array[j] = tmp;
    }
    // 更新 pivot 位置
    array[left] = array[i];
    array[i] = pivot;
    return i;
}
/// 获取top k大的数
int topK(int* array, int length, int top) {
    int top_index = length-top;
    if (top_index<0 || top_index>=length) return -1;
    int topK_value = -1;
    int left = 0;
    int right = length - 1;
    while (true) {
        //获取 pivot 基准值的索引
        int pivot_index = partion(array, length, left, right);
        if (top_index == pivot_index) {
            //刚好是第 top 大元素
            topK_value = array[pivot_index];
            break;
        }
        else if (top_index < pivot_index) {
            //在 pivot 左侧，继续在左区间查找
            right = pivot_index - 1;
        }
        else {
            //在 pivot 右侧，继续在右区间查找
            left = pivot_index + 1;
        }
    }
    return topK_value;
}



//MARK: - test
/// 排序测试
void sortTest() {
    int a[10] = {8,8,6,1,4,6,7,12,22,5};
//    int a[10] = {8,8,6,1};
//    quickSort(a, 10, 0, 10-1);
//    countSort(a, 10);
//    heapSort(a, 10);
    
//    for (int i=0; i<10; i++) {
//        printf("%d,",a[i]);
//    }
//    printf("\r\n");
    
    mergeSort(a, 10);
    
//    printf("%d\r\n", topK(a, 10, 1));
//    printf("%d\r\n", topK(a, 10, 2));
//    printf("%d\r\n", topK(a, 10, 3));
//    printf("%d\r\n", topK(a, 10, 4));
//    printf("%d\r\n", topK(a, 10, 5));
//    printf("%d\r\n", topK(a, 10, 6));
//    printf("%d\r\n", topK(a, 10, 7));
//    printf("%d\r\n", topK(a, 10, 8));
//    printf("%d\r\n", topK(a, 10, 9));
//    printf("%d\r\n", topK(a, 10, 10));
    
}
@end
