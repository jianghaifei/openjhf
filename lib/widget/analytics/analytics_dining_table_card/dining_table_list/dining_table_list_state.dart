import 'package:get/get.dart';

import '../../../../model/analytics_entity_list/analytics_entity_filter_component_entity.dart';
import '../../../../model/dining_table/dining_table_shops_template_entity.dart';
import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../card_load_state_layout.dart';

class DiningTableListState {
  // 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;

  String? errorCode;
  String? errorMessage;

  // 当前时间标题
  var currentTimeTitle = "".obs;

  // 门店id
  var shopId = <String>[].obs;

  // 实时桌台--获取桌台列表模板
  var templateEntity = DiningTableShopsTemplateEntity().obs;

  // 指标筛选组件数据模型
  var filterComponentEntity = AnalyticsEntityFilterComponentEntity().obs;

  // range实体模型
  var rangeFilterEntity = AnalyticsEntityFilterComponentFilters().obs;

  // 店铺PK表格数据
  var storePKTableEntity = StorePKTableEntity().obs;

  // 选中的指标
  var selectedMetrics = <DiningTableShopsTemplateCardMetadataMetrics>[].obs;

  // 选中的维度
  var selectedDims = <DiningTableShopsTemplateCardMetadataDims>[].obs;

  // Filter --- 最大最小值
  var filterMinAndMax = RxList<double?>([]);
  var filterNumericalValueTypeString = ["~"].obs;

  // Filter --- OrderBy
  var selectedOrderByIndex = RxInt(-1);

  // 过滤条件展示名字
  var selectedFilters = <AnalyticsEntityFilterComponentFilters>[].obs;

  // 是否拥有过滤条件
  var isHaveFilterConditions = false.obs;

  DiningTableListState() {
    ///Initialize variables

    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("shopIds") && args["shopIds"] != null) {
        shopId.value = args["shopIds"];
      }
    }
  }
}
