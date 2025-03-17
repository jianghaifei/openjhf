import 'package:get/get.dart';

import '../../../function/login/account_manager/account_manager.dart';
import '../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../model/business_topic/topic_template_entity.dart';
import '../../../model/store/store_pk/store_pk_entity.dart';
import '../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';

enum PKPageType {
  // 门店PK页面
  storePKPage,
  // pk页面
  pkPage,
  // 异常管理页面
  lossMetricsPage,
}

class StoresPKState {
  var pageType = PKPageType.storePKPage.obs;

  /// ----------自定义时间模块----------

  // 传入的自定义门店id
  List<String>? shopIds;

  // 自定义日期组件的枚举值：日/月
  var customDateToolEnum = CustomDateToolEnum.DAY;

  // 当前页面自定义时间范围
  var currentCustomDateTime = <DateTime>[];

  // 对比时间范围类型——Enum
  var compareDateRangeTypes = <CompareDateRangeType>[];

  // 对比时间范围——DateTime
  List<List<DateTime>> compareDateTimeRanges = [];

  /// ----------Card Params----------

  // 卡片元数据
  var cardMetadata = TopicTemplateTemplatesNavsTabsCardsCardMetadata().obs;

  /// ----------tab----------

  // 业务主题
  var tabs = <String>[].obs;

  // 当前tab下标
  var tabIndex = 0.obs;
  var recordTabIndex = 0;

  /// ----------request----------

  // 店铺PK模板
  var resultStorePKEntity = StorePKEntity().obs;

  // 入参
  var selectedMetrics = <StorePKCardMetadataCardGroupMetadataMetrics>[].obs;
  var selectedDims = <StorePKCardMetadataCardGroupMetadataDims>[].obs;

  // 查找主题下标使用
  var selectedGroupCode = "".obs;

  // 店铺PK表格数据
  var resultStorePKTableEntity = StorePKTableEntity().obs;

  // 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;

  String? errorCode;
  String? errorMessage;

  /// Filters

  // 根据指标code查询过滤器数据的实体
  var filterComponentEntity = AnalyticsEntityFilterComponentEntity().obs;

  // 过滤条件展示名字
  var selectedFilters = <AnalyticsEntityFilterComponentFilters>[].obs;

  // 是否拥有过滤条件
  var isHaveFilterConditions = false.obs;

  /// range实体模型
  var rangeFilterEntity = AnalyticsEntityFilterComponentFilters().obs;

  // Filter --- 最大最小值
  var filterMinAndMax = RxList<double?>([]);
  var filterNumericalValueTypeString = ["~"].obs;

  StoresPKState() {
    ///Initialize variables
    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("shopIds") && args["shopIds"] != null) {
        shopIds = args["shopIds"];
      }

      if (args.containsKey("customDateToolEnum") && args["customDateToolEnum"] != null) {
        customDateToolEnum = args["customDateToolEnum"];
      }

      if (args.containsKey("compareDateRangeTypes") && args["compareDateRangeTypes"] != null) {
        compareDateRangeTypes = args["compareDateRangeTypes"];
      }

      if (args.containsKey("pkTemplate") && args["pkTemplate"] != null) {
        resultStorePKEntity.value = args["pkTemplate"];
      }

      if (args.containsKey("PKPageType") && args["PKPageType"] != null) {
        pageType.value = args["PKPageType"];
      }

      if (args.containsKey("cardMetadata") && args["cardMetadata"] != null) {
        cardMetadata.value = args["cardMetadata"];
      }
    }
  }
}
