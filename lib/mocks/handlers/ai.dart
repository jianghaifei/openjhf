import 'package:dio/dio.dart';
import '../abstract_handler.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';

const card1 = {
  "cardId": 1,
  'cardMetadata': {
    "cardType": "text",
    "text": "你好！有什么需要帮助的吗？",
    "fontSize": 14,
    "textColor": "FFFF0000",
    "fontWeight": 'bold',
    'fontStyle': 'italic',
  }
};

const card2 = {
  "cardId": 2,
  'cardMetadata': {
    "cardType": "image",
    "url": "https://static.restosuite.cn/common/image/bg-cn.jpg"
  }
};
const card3 = {
  "cardId": "1",
  "cardName": "实收金额",
  "templateName": null,
  "cardCode": "M_Order_SUM_netSales",
  "cardMetadata": {
    "cardType": "DATA_KEY_METRICS",
    "groupCode": null,
    "compareInfo": null,
    "chartType": [
      {"code": "LINE"}
    ],
    "metrics": [
      {
        "metricCode": "M_Order_SUM_netSales",
        "metricName": "实收金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": ["D_businessDate"],
        "metricExplanation": [
          {"title": "业务说明", "msg": "账单中排除各项优惠后，商家实际收到的金额"},
          {"title": "计算口径", "msg": "应收金额 - 优惠总金额 - 圆整"}
        ],
        "entity": "ORDER",
        "entityTitle": "销售"
      }
    ],
    "dims": [
      {
        "dimCode": "D_businessDate",
        "dimName": "营业日期",
        "dataType": "DATE",
        "reportId": ["123"],
        "metricOptions": ["M_Order_SUM_netSales"]
      }
    ]
  },
  "queryParams": {
    "displayTime": ['2024-12-01', '2024-12-23'],
    "compareDateRangeTypes": ["lastMonth"], // 可空
    "compareDateTimeRanges": [
      ['2024-11-01', '2024-11-23']
    ], //可空
    "customDateToolEnum": 'day',
  }
};
const card4 = {
  "cardId": "315",
  "cardName": null,
  "templateName": null,
  "cardCode": null,
  "cardMetadata": {
    "cardType": "DATA_KEY_METRICS_2",
    "groupCode": null,
    "compareInfo": null,
    "chartType": null,
    "metrics": [
      {
        "metricCode": "M_Order_AVG_netSalesByOrder",
        "metricName": "单均实收",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": null,
        "metricExplanation": [
          {"title": "业务说明", "msg": "平均每笔账单的实收金额"},
          {"title": "计算口径", "msg": "实收金额 / 账单数"}
        ],
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_AVG_netSalesByGuest",
        "metricName": "人均实收",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": null,
        "metricExplanation": [
          {"title": "业务说明", "msg": "平均每位顾客的实收金额"},
          {"title": "计算口径", "msg": "实收金额 / 用餐人数"}
        ],
        "entity": "ORDER",
        "entityTitle": "销售"
      }
    ],
    "dims": null
  },
  "queryParams": {
    "displayTime": ['2024-12-01', '2024-12-23'],
    "compareDateRangeTypes": ["lastMonth"], // 可空
    "compareDateTimeRanges": [
      ['2024-11-01', '2024-11-23']
    ], //可空
    "customDateToolEnum": 'day',
  }
};
const card5 = {
  "cardId": "413",
  "cardName": null,
  "templateName": null,
  "cardCode": null,
  "cardMetadata": {
    "cardType": "DATA_KEY_METRICS_3",
    "groupCode": null,
    "compareInfo": null,
    "chartType": null,
    "metrics": [
      {
        "metricCode": "M_Order_SUM_totalPromotionAmount",
        "metricName": "优惠总金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": null,
        "metricExplanation": [
          {"title": "业务说明", "msg": "优惠总金额，包含了账单优惠金额和支付方式优惠金额"},
          {"title": "计算口径", "msg": "账单优惠 + 支付优惠"}
        ],
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_totalGrossSales",
        "metricName": "流水金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": null,
        "metricExplanation": [
          {"title": "业务说明", "msg": "账单的应收金额，包含了菜品总价和附加费总金额"},
          {"title": "计算口径", "msg": "菜品总价 + 附加费总计"}
        ],
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_totalRefundAmount",
        "metricName": "总退款金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": null,
        "metricExplanation": [
          {"title": "业务说明", "msg": "账单中包含的退款金额"}
        ],
        "entity": "ORDER",
        "entityTitle": "销售"
      }
    ],
    "dims": null
  },
  "queryParams": {
    "displayTime": ['2024-12-01', '2024-12-23'],
    "compareDateRangeTypes": ["lastMonth"], // 可空
    "compareDateTimeRanges": [
      ['2024-11-01', '2024-11-23']
    ], //可空
    "customDateToolEnum": 'day',
  }
};

const card6 = {
  "cardId": "510",
  "cardName": "销售趋势",
  "templateName": null,
  "cardCode": "Card_Name_Sales_Trend",
  "cardMetadata": {
    "cardType": "DATA_CHART_PERIOD",
    "groupCode": null,
    "compareInfo": {"compareType": "PREVIOUS", "metrics": null},
    "chartType": [
      {"code": "LINE"},
      {"code": "LIST"}
    ],
    "metrics": [
      {
        "metricCode": "M_Order_SUM_netSales",
        "metricName": "实收金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": ["D_hours", "D_businessDate"],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_totalSales",
        "metricName": "支付小计",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": ["D_hours", "D_businessDate"],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_COUNT_Orders",
        "metricName": "账单数",
        "ifHidden": false,
        "dataType": "NUMERIC_INT",
        "reportId": ["123"],
        "dimOptions": ["D_hours", "D_businessDate"],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_guests",
        "metricName": "用餐人数",
        "ifHidden": false,
        "dataType": "NUMERIC_INT",
        "reportId": ["123"],
        "dimOptions": ["D_hours", "D_businessDate"],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_foodOriginAmount",
        "metricName": "菜品总价",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": ["D_hours", "D_businessDate"],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_giftCardNetSales",
        "metricName": "礼品卡预收款",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["125"],
        "dimOptions": ["D_hours", "D_businessDate"],
        "metricExplanation": null,
        "entity": "ORDER_GIFT_CARD",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_memberStoredNetSales",
        "metricName": "会员储值预收款",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["125"],
        "dimOptions": ["D_hours", "D_businessDate"],
        "metricExplanation": null,
        "entity": "ORDER_MEMBER_STORED",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_receivableSales",
        "metricName": "应收金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": ["D_hours", "D_businessDate"],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      }
    ],
    "dims": [
      {
        "dimCode": "D_hours",
        "dimName": "时段",
        "dataType": "NUMERIC",
        "reportId": ["123", "125"],
        "metricOptions": [
          "M_Order_SUM_netSales",
          "M_Order_SUM_totalSales",
          "M_Order_COUNT_Orders",
          "M_Order_SUM_guests",
          "M_Order_SUM_foodOriginAmount",
          "M_Order_SUM_giftCardNetSales",
          "M_Order_SUM_memberStoredNetSales",
          "M_Order_SUM_receivableSales"
        ]
      },
      {
        "dimCode": "D_businessDate",
        "dimName": "营业日期",
        "dataType": "DATE",
        "reportId": ["123", "125"],
        "metricOptions": [
          "M_Order_SUM_netSales",
          "M_Order_SUM_totalSales",
          "M_Order_COUNT_Orders",
          "M_Order_SUM_guests",
          "M_Order_SUM_foodOriginAmount",
          "M_Order_SUM_giftCardNetSales",
          "M_Order_SUM_memberStoredNetSales",
          "M_Order_SUM_receivableSales"
        ]
      }
    ]
  },
  "queryParams": {
    "displayTime": ['2024-12-01', '2024-12-23'],
    "compareDateRangeTypes": ["lastMonth"], // 可空
    "compareDateTimeRanges": [
      ['2024-11-01', '2024-11-23']
    ], //可空
    "customDateToolEnum": 'day',
  }
};

const card7 = {
  "cardId": "601",
  "cardName": "销售组成",
  "templateName": null,
  "cardCode": "Card_Name_Sales_Composition",
  "cardMetadata": {
    "cardType": "DATA_CHART_GROUP",
    "groupCode": null,
    "compareInfo": null,
    "chartType": [
      {"code": "PIE"},
      {"code": "LIST"}
    ],
    "metrics": [
      {
        "metricCode": "M_Order_SUM_netSales",
        "metricName": "实收金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": [
          "D_diningOption",
          "D_source",
          "D_startDiningHours",
          "D_checkoutDiningHours"
        ],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_totalSales",
        "metricName": "支付小计",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": [
          "D_diningOption",
          "D_source",
          "D_startDiningHours",
          "D_checkoutDiningHours"
        ],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_COUNT_Orders",
        "metricName": "账单数",
        "ifHidden": false,
        "dataType": "NUMERIC_INT",
        "reportId": ["123"],
        "dimOptions": [
          "D_diningOption",
          "D_source",
          "D_startDiningHours",
          "D_checkoutDiningHours"
        ],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_guests",
        "metricName": "用餐人数",
        "ifHidden": false,
        "dataType": "NUMERIC_INT",
        "reportId": ["123"],
        "dimOptions": [
          "D_diningOption",
          "D_source",
          "D_startDiningHours",
          "D_checkoutDiningHours"
        ],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_DiscountPromotion_SUM_Amount",
        "metricName": "优惠总金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["100140"],
        "dimOptions": [
          "D_discountPromotionName",
          "D_discountPromotionSubType",
          "D_promotionSubType"
        ],
        "metricExplanation": null,
        "entity": "ORDER_DISCOUNT_PROMOTION",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_totalRefundAmount",
        "metricName": "总退款金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": [
          "D_diningOption",
          "D_source",
          "D_startDiningHours",
          "D_checkoutDiningHours"
        ],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_foodOriginAmount",
        "metricName": "菜品总价",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": [
          "D_diningOption",
          "D_source",
          "D_startDiningHours",
          "D_checkoutDiningHours"
        ],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      }
    ],
    "dims": [
      {
        "dimCode": "D_diningOption",
        "dimName": "就餐方式",
        "dataType": "STRING",
        "reportId": ["123"],
        "metricOptions": [
          "M_Order_SUM_netSales",
          "M_Order_SUM_totalSales",
          "M_Order_COUNT_Orders",
          "M_Order_SUM_guests",
          "M_Order_SUM_totalRefundAmount",
          "M_Order_SUM_foodOriginAmount"
        ]
      },
      {
        "dimCode": "D_source",
        "dimName": "来源",
        "dataType": "STRING",
        "reportId": ["123"],
        "metricOptions": [
          "M_Order_SUM_netSales",
          "M_Order_SUM_totalSales",
          "M_Order_COUNT_Orders",
          "M_Order_SUM_guests",
          "M_Order_SUM_totalRefundAmount",
          "M_Order_SUM_foodOriginAmount"
        ]
      },
      {
        "dimCode": "D_startDiningHours",
        "dimName": "开台营业餐段",
        "dataType": "STRING",
        "reportId": ["123"],
        "metricOptions": [
          "M_Order_SUM_netSales",
          "M_Order_SUM_totalSales",
          "M_Order_COUNT_Orders",
          "M_Order_SUM_guests",
          "M_Order_SUM_totalRefundAmount",
          "M_Order_SUM_foodOriginAmount"
        ]
      },
      {
        "dimCode": "D_checkoutDiningHours",
        "dimName": "结账营业餐段",
        "dataType": "STRING",
        "reportId": ["123"],
        "metricOptions": [
          "M_Order_SUM_netSales",
          "M_Order_SUM_totalSales",
          "M_Order_COUNT_Orders",
          "M_Order_SUM_guests",
          "M_Order_SUM_totalRefundAmount",
          "M_Order_SUM_foodOriginAmount"
        ]
      },
      {
        "dimCode": "D_discountPromotionName",
        "dimName": "优惠名称",
        "dataType": "STRING",
        "reportId": ["100140"],
        "metricOptions": ["M_DiscountPromotion_SUM_Amount"]
      },
      {
        "dimCode": "D_discountPromotionSubType",
        "dimName": "优惠子类型",
        "dataType": "STRING",
        "reportId": ["100140"],
        "metricOptions": ["M_DiscountPromotion_SUM_Amount"]
      },
      {
        "dimCode": "D_promotionSubType",
        "dimName": "优惠子类型",
        "dataType": "STRING",
        "reportId": ["100140"],
        "metricOptions": ["M_DiscountPromotion_SUM_Amount"]
      }
    ]
  },
  "queryParams": {
    "displayTime": ['2024-12-01', '2024-12-23'],
    "compareDateRangeTypes": ["lastMonth"], // 可空
    "compareDateTimeRanges": [
      ['2024-11-01', '2024-11-23']
    ], //可空
    "customDateToolEnum": 'day',
  }
};

const card8 = {
  "cardId": "723",
  "cardName": "排行",
  "templateName": null,
  "cardCode": "Card_Name_Ranking",
  "cardMetadata": {
    "cardType": "DATA_CHART_RANK",
    "groupCode": "Metric_Group_Sales",
    "compareInfo": null,
    "chartType": null,
    "metrics": [
      {
        "metricCode": "M_Order_SUM_totalGrossSales",
        "metricName": "流水金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": ["D_shopName"],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_SUM_netSales",
        "metricName": "实收金额",
        "ifHidden": false,
        "dataType": "CURRENCY",
        "reportId": ["123"],
        "dimOptions": ["D_shopName"],
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      }
    ],
    "dims": [
      {
        "dimCode": "D_shopName",
        "dimName": "门店",
        "dataType": "STRING",
        "reportId": ["123"],
        "metricOptions": ["M_Order_SUM_totalGrossSales", "M_Order_SUM_netSales"]
      }
    ]
  },
  "queryParams": {
    "displayTime": ['2024-12-01', '2024-12-23'],
    "compareDateRangeTypes": ["lastMonth"], // 可空
    "compareDateTimeRanges": [
      ['2024-11-01', '2024-11-23']
    ], //可空
    "customDateToolEnum": 'day',
  }
};

const card9 = {
  "cardId": "801",
  "cardName": "异常账单",
  "templateName": "账单异常管理默认模板",
  "cardCode": "LossMetricsSales",
  "cardMetadata": {
    "cardType": "DATA_LOSS_METRICS",
    "groupCode": null,
    "compareInfo": {"compareType": "PREVIOUS", "metrics": null},
    "chartType": [
      {"code": "BAR"},
      {"code": "LIST"}
    ],
    "metrics": [
      {
        "metricCode": "M_Refund_COUNT_Orders",
        "metricName": "退款单数",
        "ifHidden": false,
        "dataType": "NUMERIC_INT",
        "reportId": ["375"],
        "dimOptions": null,
        "metricExplanation": null,
        "entity": "ORDER_REFUND",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_COUNT_discountPromOrders",
        "metricName": "优惠单数",
        "ifHidden": false,
        "dataType": "NUMERIC_INT",
        "reportId": ["123"],
        "dimOptions": null,
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      },
      {
        "metricCode": "M_Order_COUNT_reversalOrders",
        "metricName": "冲销单数量",
        "ifHidden": false,
        "dataType": "NUMERIC_INT",
        "reportId": ["123"],
        "dimOptions": null,
        "metricExplanation": null,
        "entity": "ORDER",
        "entityTitle": "销售"
      }
    ],
    "dims": null
  },
  "queryParams": {
    "displayTime": ['2024-12-01', '2024-12-23'],
    "compareDateRangeTypes": ["lastMonth"], // 可空
    "compareDateTimeRanges": [
      ['2024-11-01', '2024-11-23']
    ], //可空
    "customDateToolEnum": 'day',
  }
};

const json = {
  "body": [card1, card2, card3, card4, card5, card6, card7, card8, card9],
  'questions': ['few']
};

const json1 = {
  "body": [
    {
      "cardId": 1,
      "cardMetadata": {
        "cardType": "text",
        "text": "2024/12/01 - 2024/12/31 的 实收金额 表现如下："
      }
    },
    {
      "cardId": 3,
      "cardMetadata": {
        "cardType": 'orgChart',
        "paddingTop": 16.0,
        "paddingBottom": 16.0,
        "nodes": [
          {
            "title": {'text':"实收金额", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
            "data": [
              { 'text': '2024/09/17','fontSize':10, 'color': 'FF5D5D66',},
              { 'text': '¥9517.07', 'fontSize':20, 'color': 'FF17171A', 'fontStyle': 'italic', 'fontWeight': 'bold', },
              [
                { 
                  'text': '-8.00%', 'bgColor': 'FF17171A', 'color': 'FFFF564C', 'fontSize': 10,
                  'borderRadius': { 'topLeft': 4,'topRight': 0,  'bottomLeft': 4, 'bottomRight': 0},
                  'padding': {'left': 10, },
                  'margin': {'left':4}
                },
                { 
                  'text': '(¥300.21)','bgColor': 'FF17171A', 'color': 'FFFFFFFF','fontSize': 10,
                  'borderRadius': { 'topLeft': 0, 'topRight': 4, 'bottomLeft': 0, 'bottomRight': 4},
                  'padding': { 'right': 10}
                }
              ]
            ],
            "referenceData": [
              { 'text': '2024/09/16','fontSize':10, 'color': 'FF5D5D66',},
              { 'text': '¥8888.88', 'fontSize':20, 'color': 'FF17171A', 'fontStyle': 'italic', 'fontWeight': 'bold',},
            ],
            "children": [
              {
                "title":  {'text':"堂食", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
                "padding": {"left":4, 'right':4, 'bottom':4, 'top':4},
                "extra": {'text':"TOP 1", 'fontSize':12, 'color':'FFACAAE2', 'fontStyle':'italic',  'fontWeight': 'bold'},
                "data": [
                    { 'text': '-15.9', 'bgColor': 'FFCECCFB', 'color': 'FFFF564C', 'fontSize':12, 'margin':{'left': 4},  'borderRadius': { 'topLeft': 4,'topRight': 4,  'bottomLeft': 4, 'bottomRight': 4},},
                    { 'text': '贡献度: 123.5%','fontSize':10, 'color': 'FF5D5D66'},
                ],
                "children": [{
                  "title":  {'text':"北京", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
                  "padding": {"left":4, 'right':4, 'bottom':4, 'top':4},
                  "data": [
                      { 'text': '-15.9', 'bgColor': 'FFCECCFB', 'color': 'FFFF564C', 'fontSize':12, 'margin':{'left': 4},  'borderRadius': { 'topLeft': 4,'topRight': 4,  'bottomLeft': 4, 'bottomRight': 4},},
                      { 'text': '贡献度: 123.5%','fontSize':10, 'color': 'FF5D5D66'},
                  ]
                  },{
                    "title":  {'text':"天津", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
                    "padding": {"left":4, 'right':4, 'bottom':4, 'top':4},
                    "data": [
                        { 'text': '-15.9', 'bgColor': 'FFCECCFB', 'color': 'FFFF564C', 'fontSize':12, 'margin':{'left': 4},  'borderRadius': { 'topLeft': 4,'topRight': 4,  'bottomLeft': 4, 'bottomRight': 4},},
                        { 'text': '贡献度: 123.5%','fontSize':10, 'color': 'FF5D5D66'},
                    ],
                    "children": [{
                        "title":  {'text':"AA", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
                        "padding": {"left":4, 'right':4, 'bottom':4, 'top':4},
                        "data": [
                            { 'text': '-15.9', 'bgColor': 'FFCECCFB', 'color': 'FFFF564C', 'fontSize':12, 'margin':{'left': 4},  'borderRadius': { 'topLeft': 4,'topRight': 4,  'bottomLeft': 4, 'bottomRight': 4},},
                            { 'text': '贡献度: 123.5%','fontSize':10, 'color': 'FF5D5D66'},
                        ]
                    },{
                        "title":  {'text':"BB", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
                        "padding": {"left":4, 'right':4, 'bottom':4, 'top':4},
                        "data": [
                            { 'text': '-15.9', 'bgColor': 'FFCECCFB', 'color': 'FFFF564C', 'fontSize':12, 'margin':{'left': 4},  'borderRadius': { 'topLeft': 4,'topRight': 4,  'bottomLeft': 4, 'bottomRight': 4},},
                            { 'text': '贡献度: 123.5%','fontSize':10, 'color': 'FF5D5D66'},
                        ]
                    }]
                  }
                ]
              }, {
                'isExpanded': false,
                "title":  {'text':"自提", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
                "padding": {"left":4, 'right':4, 'bottom':4, 'top':4},
                "extra": {'text':"TOP 2", 'fontSize':12, 'color':'FFACAAE2', 'fontStyle':'italic',  'fontWeight': 'bold'},
                "data": [
                    { 'text': '-15.9', 'bgColor': 'FFCECCFB', 'color': 'FFFF564C', 'fontSize':12, 'margin':{'left': 4},  'borderRadius': { 'topLeft': 4,'topRight': 4,  'bottomLeft': 4, 'bottomRight': 4},},
                    { 'text': '贡献度: 123.5%','fontSize':10, 'color': 'FF5D5D66'},
                ],
                "children": [{
                  "title":  {'text':"北京", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
                  "padding": {"left":4, 'right':4, 'bottom':4, 'top':4},
                  "data": [
                      { 'text': '-15.9', 'bgColor': 'FFCECCFB', 'color': 'FFFF564C', 'fontSize':12, 'margin':{'left': 4},  'borderRadius': { 'topLeft': 4,'topRight': 4,  'bottomLeft': 4, 'bottomRight': 4},},
                      { 'text': '贡献度: 123.5%','fontSize':10, 'color': 'FF5D5D66'},
                  ]
                  },{
                    "title":  {'text':"天津", 'fontSize':12, 'fontWeight': 'bold', 'color': 'FF17171A'},
                    "padding": {"left":4, 'right':4, 'bottom':4, 'top':4},
                    "data": [
                        { 'text': '-15.9', 'bgColor': 'FFCECCFB', 'color': 'FFFF564C', 'fontSize':12, 'margin':{'left': 4},  'borderRadius': { 'topLeft': 4,'topRight': 4,  'bottomLeft': 4, 'bottomRight': 4},},
                        { 'text': '贡献度: 123.5%','fontSize':10, 'color': 'FF5D5D66'},
                    ]
                  }
                ]
              },
            ]
          }
        ],
   
      }
    },
    {
      "cardId": 2,
      "cardMetadata": {
        "cardType": "table",
        "columns": [
          {
            "columnStyle": {"fontWeight": 'bold', "sortable": false},
            "title": "指标"
          },
          {
            "columnStyle": {
              "fontWeight": 'bold',
              "align": "right",
              "sortable": true
            },
            "rowStyle": {
              "align": "right",
              "color": "FF000000",
              "fontWeight": "bold",
            },
            "title": "金额"
          },
          {
            "columnStyle": {
              "fontWeight": 'bold',
              "align": "right",
              "sortable": true
            },
            "rowStyle": {
              "align": "right",
            },
            "title": "环比上周"
          }
        ],
        "rows": [
          [
            "实收金额",
            "¥3432.54",
            {"value": '-8.00%', "color": "FFFF0000"}
          ],
          [
            "客流量",
            "120",
            {"value": '-3.20%', "color": "FFFF0000"}
          ],
          [
            "帐单数",
            "95",
            {"value": '+3.53%', "color": "FF32CD32"}
          ],
          [
            "单均实收",
            "44.54",
            {"value": '-2.23%', "color": "FFFF0000"}
          ],
          [
            "人均实收",
            "33.54",
            {"value": '+3.32%', "color": "FF32CD32"}
          ],
        ]
      }
    }
  ],
  "questions": ["解读", "昨天的营业额是多少？"],
  "source_chat": [
    {"content": "12月的堂食营业额是多少", "intents": "data_analysis", "role": "user"},
    {
      "content":
          "{\"tool_name\":\"查询营业额或销售额工具\",\"args\":{\"店铺\":\"\",\"日期\":\"2024-12-01@2024-12-31\",\"度量\":\"营业额\",\"维度\":\"堂食\",\"排序\":\"\",\"数量\":\"\",\"分组\":\"\"}}",
      "intents": "data_analysis",
      "role": "assistant"
    }
  ]
};

const json2 = {
  "body": [
  {
    'cardId': 0, 
    'cardMetadata': {
      'cardType': 'markdown',
      'paddingTop': 16.0,
      'paddingBottom': 0,
      'text': '# h1\n ## h2'
    }
  },
  {
	'cardId': 1,
	'cardMetadata': {
		'cardType': 'orgChart',
		'paddingTop': 16.0,
		'paddingBottom': 0,
		'nodes': [{
			'title': {
				'text': '账单金额',
				'fontSize': 12,
				'fontWeight': 'bold',
				'color': 'FF17171A'
			},
			'data': [{
					'text': '2024/03/05',
					'fontSize': 10,
					'color': 'FF5D5D66'
				}, {
					'text': '¥2481.7',
					'fontSize': 20,
					'color': 'FF173B5D',
					'fontStyle': 'italic',
					'fontWeight': 'bold'
				},
				[{
					'text': '-12.4%',
					'bgColor': 'FF17171A',
					'color': 'FFFF564C',
					'fontSize': 10,
					'borderRadius': {
						'topLeft': 4,
						'topRight': 0,
						'bottomLeft': 4,
						'bottomRight': 0
					},
					'padding': {
						'left': 10
					},
					'margin': {
						'left': 4
					}
				}, {
					'text': '- ¥351.4',
					'bgColor': 'FF17171A',
					'color': 'FFFFFFFF',
					'fontSize': 10,
					'borderRadius': {
						'topLeft': 0,
						'topRight': 4,
						'bottomLeft': 0,
						'bottomRight': 4
					},
					'padding': {
						'right': 10
					}
				}]
			],
			'referenceData': [{
				'text': '2024/03/04',
				'fontSize': 10,
				'color': 'FF5D5D66'
			}, {
				'text': '¥2833.1',
				'fontSize': 20,
				'color': 'FF173B5D',
				'fontStyle': 'italic',
				'fontWeight': 'bold'
			}],
			'children': [{
				'isExpanded': true,
				'title': {
					'text': '是否会员 [维度]',
					'fontSize': 12,
					'fontWeight': 'bold',
					'color': 'FF17171A'
				},
				'padding': {
					'left': 4,
					'right': 4,
					'bottom': 4,
					'top': 4
				},
				'extra': {
					'text': 'TOP 1',
					'fontSize': 12,
					'color': 'FFACAAE2',
					'fontStyle': 'italic',
					'fontWeight': 'bold'
				},
				'data': [{
					'text': '贡献占比：99.21%',
					'color': 'FF5D5D66',
					'fontSize': 10,
					'borderRadius': {
						'topLeft': 4,
						'topRight': 4,
						'bottomLeft': 4,
						'bottomRight': 4
					}
				}],
				'children': [{
					'title': {
						'text': '会员',
						'fontSize': 12,
						'fontWeight': 'bold',
						'color': 'FF17171A'
					},
					'padding': {
						'left': 4,
						'right': 4,
						'bottom': 4,
						'top': 4
					},
					'data': [{
						'text': '- ¥1152.60',
						'bgColor': 'FFCECCFB',
						'color': 'FF00BE70',
						'fontSize': 12,
						'margin': {
							'left': 4
						},
						'borderRadius': {
							'topLeft': 4,
							'topRight': 4,
							'bottomLeft': 4,
							'bottomRight': 4
						}
					}, {
						'text': '-50.20 %',
						'fontSize': 8,
						'color': 'FF00BE70'
					}, {
						'text': '贡献度：328.00 %',
						'fontSize': 10,
						'color': 'FF5D5D66'
					}],
					'children': [{
						'title': {
							'text': '北京',
							'fontSize': 12,
							'fontWeight': 'bold',
							'color': 'FF17171A'
						},
						'padding': {
							'left': 4,
							'right': 4,
							'bottom': 4,
							'top': 4
						},
						'data': [{
							'text': '- ¥1152.60',
							'bgColor': 'FFCECCFB',
							'color': 'FF00BE70',
							'fontSize': 12,
							'margin': {
								'left': 4
							},
							'borderRadius': {
								'topLeft': 4,
								'topRight': 4,
								'bottomLeft': 4,
								'bottomRight': 4
							}
						}, {
							'text': '-50.20 %',
							'fontSize': 8,
							'color': 'FF00BE70'
						}, {
							'text': '贡献度：328.00 %',
							'fontSize': 10,
							'color': 'FF5D5D66'
						}],
						'children': [{
							'title': {
								'text': '中关村店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '- ¥1056.50',
								'bgColor': 'FFCECCFB',
								'color': 'FF00BE70',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '-68.53 %',
								'fontSize': 8,
								'color': 'FF00BE70'
							}, {
								'text': '贡献度：300.65 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}, {
							'title': {
								'text': '西直门店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '- ¥96.10',
								'bgColor': 'FFCECCFB',
								'color': 'FF00BE70',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '-12.74 %',
								'fontSize': 8,
								'color': 'FF00BE70'
							}, {
								'text': '贡献度：27.35 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}]
					}]
				}, {
					'title': {
						'text': '非会员',
						'fontSize': 12,
						'fontWeight': 'bold',
						'color': 'FF17171A'
					},
					'padding': {
						'left': 4,
						'right': 4,
						'bottom': 4,
						'top': 4
					},
					'data': [{
						'text': '+ ¥801.20',
						'bgColor': 'FFCECCFB',
						'color': 'FFFF564C',
						'fontSize': 12,
						'margin': {
							'left': 4
						},
						'borderRadius': {
							'topLeft': 4,
							'topRight': 4,
							'bottomLeft': 4,
							'bottomRight': 4
						}
					}, {
						'text': '149.20 %',
						'fontSize': 8,
						'color': 'FFFF564C'
					}, {
						'text': '贡献度：-228.00 %',
						'fontSize': 10,
						'color': 'FF5D5D66'
					}],
					'children': [{
						'title': {
							'text': '北京',
							'fontSize': 12,
							'fontWeight': 'bold',
							'color': 'FF17171A'
						},
						'padding': {
							'left': 4,
							'right': 4,
							'bottom': 4,
							'top': 4
						},
						'data': [{
							'text': '+ ¥801.20',
							'bgColor': 'FFCECCFB',
							'color': 'FFFF564C',
							'fontSize': 12,
							'margin': {
								'left': 4
							},
							'borderRadius': {
								'topLeft': 4,
								'topRight': 4,
								'bottomLeft': 4,
								'bottomRight': 4
							}
						}, {
							'text': '149.20 %',
							'fontSize': 8,
							'color': 'FFFF564C'
						}, {
							'text': '贡献度：-228.00 %',
							'fontSize': 10,
							'color': 'FF5D5D66'
						}],
						'children': [{
							'title': {
								'text': '中关村店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '+ ¥543.80',
								'bgColor': 'FFCECCFB',
								'color': 'FFFF564C',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '263.98 %',
								'fontSize': 8,
								'color': 'FFFF564C'
							}, {
								'text': '贡献度：-154.75 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}, {
							'title': {
								'text': '西直门店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '+ ¥257.40',
								'bgColor': 'FFCECCFB',
								'color': 'FFFF564C',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '77.76 %',
								'fontSize': 8,
								'color': 'FFFF564C'
							}, {
								'text': '贡献度：-73.25 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}]
					}]
				}]
			}, {
				'isExpanded': false,
				'title': {
					'text': '就餐类型 [维度]',
					'fontSize': 12,
					'fontWeight': 'bold',
					'color': 'FF17171A'
				},
				'padding': {
					'left': 4,
					'right': 4,
					'bottom': 4,
					'top': 4
				},
				'extra': {
					'text': 'TOP 2',
					'fontSize': 12,
					'color': 'FFACAAE2',
					'fontStyle': 'italic',
					'fontWeight': 'bold'
				},
				'data': [{
					'text': '贡献占比：0.79%',
					'color': 'FF5D5D66',
					'fontSize': 10,
					'borderRadius': {
						'topLeft': 4,
						'topRight': 4,
						'bottomLeft': 4,
						'bottomRight': 4
					}
				}],
				'children': [{
					'title': {
						'text': '堂食',
						'fontSize': 12,
						'fontWeight': 'bold',
						'color': 'FF17171A'
					},
					'padding': {
						'left': 4,
						'right': 4,
						'bottom': 4,
						'top': 4
					},
					'data': [{
						'text': '- ¥269.20',
						'bgColor': 'FFCECCFB',
						'color': 'FF00BE70',
						'fontSize': 12,
						'margin': {
							'left': 4
						},
						'borderRadius': {
							'topLeft': 4,
							'topRight': 4,
							'bottomLeft': 4,
							'bottomRight': 4
						}
					}, {
						'text': '-16.23 %',
						'fontSize': 8,
						'color': 'FF00BE70'
					}, {
						'text': '贡献度：76.61 %',
						'fontSize': 10,
						'color': 'FF5D5D66'
					}],
					'children': [{
						'title': {
							'text': '北京',
							'fontSize': 12,
							'fontWeight': 'bold',
							'color': 'FF17171A'
						},
						'padding': {
							'left': 4,
							'right': 4,
							'bottom': 4,
							'top': 4
						},
						'data': [{
							'text': '- ¥269.20',
							'bgColor': 'FFCECCFB',
							'color': 'FF00BE70',
							'fontSize': 12,
							'margin': {
								'left': 4
							},
							'borderRadius': {
								'topLeft': 4,
								'topRight': 4,
								'bottomLeft': 4,
								'bottomRight': 4
							}
						}, {
							'text': '-16.23 %',
							'fontSize': 8,
							'color': 'FF00BE70'
						}, {
							'text': '贡献度：76.61 %',
							'fontSize': 10,
							'color': 'FF5D5D66'
						}],
						'children': [{
							'title': {
								'text': '中关村店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '- ¥289.90',
								'bgColor': 'FFCECCFB',
								'color': 'FF00BE70',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '-27.78 %',
								'fontSize': 8,
								'color': 'FF00BE70'
							}, {
								'text': '贡献度：82.50 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}, {
							'title': {
								'text': '西直门店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '+ ¥20.70',
								'bgColor': 'FFCECCFB',
								'color': 'FFFF564C',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '3.36 %',
								'fontSize': 8,
								'color': 'FFFF564C'
							}, {
								'text': '贡献度：-5.89 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}]
					}]
				}, {
					'title': {
						'text': '外卖',
						'fontSize': 12,
						'fontWeight': 'bold',
						'color': 'FF17171A'
					},
					'padding': {
						'left': 4,
						'right': 4,
						'bottom': 4,
						'top': 4
					},
					'data': [{
						'text': '- ¥93.60',
						'bgColor': 'FFCECCFB',
						'color': 'FF00BE70',
						'fontSize': 12,
						'margin': {
							'left': 4
						},
						'borderRadius': {
							'topLeft': 4,
							'topRight': 4,
							'bottomLeft': 4,
							'bottomRight': 4
						}
					}, {
						'text': '-10.06 %',
						'fontSize': 8,
						'color': 'FF00BE70'
					}, {
						'text': '贡献度：26.64 %',
						'fontSize': 10,
						'color': 'FF5D5D66'
					}],
					'children': [{
						'title': {
							'text': '北京',
							'fontSize': 12,
							'fontWeight': 'bold',
							'color': 'FF17171A'
						},
						'padding': {
							'left': 4,
							'right': 4,
							'bottom': 4,
							'top': 4
						},
						'data': [{
							'text': '- ¥93.60',
							'bgColor': 'FFCECCFB',
							'color': 'FF00BE70',
							'fontSize': 12,
							'margin': {
								'left': 4
							},
							'borderRadius': {
								'topLeft': 4,
								'topRight': 4,
								'bottomLeft': 4,
								'bottomRight': 4
							}
						}, {
							'text': '-10.06 %',
							'fontSize': 8,
							'color': 'FF00BE70'
						}, {
							'text': '贡献度：26.64 %',
							'fontSize': 10,
							'color': 'FF5D5D66'
						}],
						'children': [{
							'title': {
								'text': '中关村店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '- ¥244.00',
								'bgColor': 'FFCECCFB',
								'color': 'FF00BE70',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '-40.79 %',
								'fontSize': 8,
								'color': 'FF00BE70'
							}, {
								'text': '贡献度：69.44 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}, {
							'title': {
								'text': '西直门店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '+ ¥150.40',
								'bgColor': 'FFCECCFB',
								'color': 'FFFF564C',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '45.30 %',
								'fontSize': 8,
								'color': 'FFFF564C'
							}, {
								'text': '贡献度：-42.80 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}]
					}]
				}, {
					'title': {
						'text': '自提',
						'fontSize': 12,
						'fontWeight': 'bold',
						'color': 'FF17171A'
					},
					'padding': {
						'left': 4,
						'right': 4,
						'bottom': 4,
						'top': 4
					},
					'data': [{
						'text': '+ ¥11.40',
						'bgColor': 'FFCECCFB',
						'color': 'FFFF564C',
						'fontSize': 12,
						'margin': {
							'left': 4
						},
						'borderRadius': {
							'topLeft': 4,
							'topRight': 4,
							'bottomLeft': 4,
							'bottomRight': 4
						}
					}, {
						'text': '4.67 %',
						'fontSize': 8,
						'color': 'FFFF564C'
					}, {
						'text': '贡献度：-3.24 %',
						'fontSize': 10,
						'color': 'FF5D5D66'
					}],
					'children': [{
						'title': {
							'text': '北京',
							'fontSize': 12,
							'fontWeight': 'bold',
							'color': 'FF17171A'
						},
						'padding': {
							'left': 4,
							'right': 4,
							'bottom': 4,
							'top': 4
						},
						'data': [{
							'text': '+ ¥11.40',
							'bgColor': 'FFCECCFB',
							'color': 'FFFF564C',
							'fontSize': 12,
							'margin': {
								'left': 4
							},
							'borderRadius': {
								'topLeft': 4,
								'topRight': 4,
								'bottomLeft': 4,
								'bottomRight': 4
							}
						}, {
							'text': '4.67 %',
							'fontSize': 8,
							'color': 'FFFF564C'
						}, {
							'text': '贡献度：-3.24 %',
							'fontSize': 10,
							'color': 'FF5D5D66'
						}],
						'children': [{
							'title': {
								'text': '中关村店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '+ ¥21.20',
								'bgColor': 'FFCECCFB',
								'color': 'FFFF564C',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '20.00 %',
								'fontSize': 8,
								'color': 'FFFF564C'
							}, {
								'text': '贡献度：-6.03 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}, {
							'title': {
								'text': '西直门店',
								'fontSize': 12,
								'fontWeight': 'bold',
								'color': 'FF17171A'
							},
							'padding': {
								'left': 4,
								'right': 4,
								'bottom': 4,
								'top': 4
							},
							'data': [{
								'text': '- ¥9.80',
								'bgColor': 'FFCECCFB',
								'color': 'FF00BE70',
								'fontSize': 12,
								'margin': {
									'left': 4
								},
								'borderRadius': {
									'topLeft': 4,
									'topRight': 4,
									'bottomLeft': 4,
									'bottomRight': 4
								}
							}, {
								'text': '-7.10 %',
								'fontSize': 8,
								'color': 'FF00BE70'
							}, {
								'text': '贡献度：2.79 %',
								'fontSize': 10,
								'color': 'FF5D5D66'
							}]
						}]
					}]
				}]
			}]
		}]
	}
}
  ]
};

class AiReplyMock implements MockHandler {
  @override
  bool canHandle(String url) => url == RSServerUrl.aiReply;

  @override
  Response handle(RequestOptions options) {
    return Response(
        requestOptions: options,
        statusCode: 200,
        data: {'code': '000', 'data': json2});
  }
}

class AiWelcomeMock implements MockHandler {
  @override
  bool canHandle(String url) => url == RSServerUrl.aiWelcome;

  @override
  Response handle(RequestOptions options) {
    return Response(requestOptions: options, statusCode: 200, data: {
      'code': '000',
      'data': {
        "questions": ["查询下最近一周的营业额", "最近的营业额下降了，什么原因导致的？", "上个月的门店排行11"],
        "readme": "我是AI助手餐宝，很高兴为您服务！"
      }
    });
  }
}

class AiFeedback implements MockHandler {
  @override
  bool canHandle(String url) => url == RSServerUrl.aiFeedback;

  @override
  Response handle(RequestOptions options) {
    return Response(
        requestOptions: options,
        statusCode: 200,
        data: {'code': '000', 'msg': 'ok'});
  }
}

List<MockHandler> aiMocks = [
  //AiReplyMock(),
  //AiWelcomeMock(),
  //AiFeedback(),
];
