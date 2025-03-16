/// 卡片主题类型
enum BusinessTopicCardType {
  KEY_METRICS,
  PERIOD_METRICS,
  GROUP_METRICS,
  RANK_METRICS,
  LOSS_METRICS,
}

/// 卡片类型
enum TopicCardType {
  DATA_KEY_METRICS,
  DATA_KEY_METRICS_2,
  DATA_KEY_METRICS_3,
  DATA_CHART_PERIOD,
  DATA_CHART_GROUP,
  DATA_CHART_RANK,
  DATA_LOSS_METRICS,
  DATA_REAL_TIME_TABLE,
}

/// 指标/维度数据类型
enum MetricOrDimDataType {
  CURRENCY,
  NUMERIC,
  NUMERIC_INT,
  NUMERIC_FLOAT,
  DATE,
  DATE_TIME,
  STRING,
  NUMERIC_PERCENTAGE,
}

/// 排序方式
enum BusinessTopicSortType {
  DIM,
  METRICS,
}

/// 实体跳转页面类型
enum EntityJumpPageType {
  // 列表
  ENTITY_LIST,
  // 详情
  ENTITY_DETAIL,
  // 跳单门店
  ENTITY_OVERVIEW,
  // 实时桌台列表
  REAL_TIME_TABLE_LIST,
  // 实时桌台--门店列表
  REAL_TIME_SHOP_LIST,
  //实时桌台--详情页
  REAL_TIME_ORDER_DETAIL,
}

/// 订单实体标签类型
enum OrderEntityTagType {
  // 退单
  Order_Refund,
  // 退菜
  Item_Refund,
  // 退款
  Payment_Refund,
  // 冲销单
  Order_Reversal,
  // 修改单
  Order_Reopen,
  // 订单折扣
  Order_Discount,
  // 订单优惠
  Order_Promotion,
  // 会员
  Order_Member,
  // 现金支付
  Cash_Payment,
  // 银行卡支付
  Bank_Card_Payment,
  // 线上支付
  Online_Payment,
  // 卡券支付
  Gift_Card,
}

/// 筛选组件类型
enum EntityComponentType {
  // 单选下拉(入参需合并)
  SELECTION,
  // 下拉多选(入参需合并)
  MULTI_SELECTION,
  // 数值筛选（~、>、<、>=、<=、=）(入参需合并)
  NUM_FILTER,
  // 输入框
  INPUT,
}

/// 配合筛选组件类型使用
enum EntityFilterType {
  // 模糊搜索
  LIKE,
  // 包含子条件
  SUB,
  // 包含指定值
  IN,
  // 在某范围内 ~
  RANGE,
  // =
  EQ,
  // !=
  NE,
  // >
  GT,
  // ≥
  GOE,
  // <
  LT,
  // ≤
  LOE,
  // not 包含
  NOT_IN,
}

/// 指标图表类型
enum AddMetricsChartType {
  LINE,
  BAR,
  LIST,
  PIE,
}

/// 指标对比方式
enum AddMetricsCompareType {
  METRICS,
  PREVIOUS,
}

/// 订单详情行类型
enum OrderDetailRowType {
  // 数据
  ROW_DATA,
  // 分割线-实线
  DIVIDER_SOLID,
  // 分割线-虚线
  DIVIDER_DASHED,
  // 子标题
  SUB_TITLE,
  // 带跳转的子标题
  SUB_TITLE_WITH_DRILL_DOWN
}

/// 订单详情内容文本对齐方式
enum OrderDetailContentTextAlign {
  LEFT,
  RIGHT,
  CENTER,
}

/// 设置——配置项
enum SettingConfigEnum {
  // 指标单位
  METRIC_ABBREVIATION,
  // 门店目标管理
  STORE_TARGETS,
  // 我的账号
  MY_ACCOUNT,
  // 多语
  LANGUAGE,
}

/// 门店选择分组类型
enum StoreSelectedGroupType {
  // 全部类型
  allType,
  // 分组类型
  groupType,
}

/// 目标管理-分配方式枚举
enum TargetManageDistributionType {
  // 每天平均分配
  WEEKDAY_OR_WEEKEND,
  // 以周为周期，星期一到星期日分别设置
  EACH_DAY_OF_THE_WEEK,
  // 每天平均分配
  DAILY_AVG,
}
