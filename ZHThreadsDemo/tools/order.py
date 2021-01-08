# coding:utf-8
# author:yeqing

import sys
import os
import pandas
from pandas import DataFrame


#清洗物流单号数据
def clean_logistics(value):
    if value is None:
        return value
    if value is "":
        return value
    for keyword in logistics_keywords:
        if keyword in value:
            value = value.replace(keyword,'')
    if ':' in value:
        print("未识别的物流公司："+value)
    return value

#清洗订单货品数据
def clean_product(value):
    value = ""
    return value


#入口
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("请指定excel文件！")
        exit()

    file = sys.argv[1]
    if file is None:
        print("请指定excel文件！")
        exit()
    if not os.path.exists(file):
        print(file+"，文件不存在，请检查路径是否正确！")
        exit()
        
    print("开始处理excel，"+file)
    #保留的列
    holds = ["收货人姓名", "联系手机", "货品标题", "物流公司运单号"]
    #物流公司前缀
    logistics_keywords = ["圆通速递(YTO):", "百世快递:", "韵达快递:", "中通快递(ZTO):", "申通快递(STO):", "天天快递:", "邮政国内小包:", "邮政快递:", "顺丰速运:", "极兔速递:", "优速快递:", "龙邦速递:","其他:"]
    #打开文件
    data = pandas.read_excel(r""+file,header=0,usecols=holds,keep_default_na=False)
    #清洗物流单号前缀
    data["物流公司运单号"] = data["物流公司运单号"].apply(clean_logistics)
    #清洗产品信息
    data["货品标题"] = data["货品标题"].apply(clean_product)
    data.rename(columns={'货品标题': '内容'}, inplace=True)
    #保存新文件
    new_path = '~/Downloads/新单号.xlsx'
    DataFrame(data).to_excel(new_path, sheet_name='Sheet1', index=False)
    print("单号已保存，"+new_path)

