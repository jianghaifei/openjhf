import 'package:get/get.dart';

import '../../../../model/analytics_entity_list/order_detail_entity.dart';
import '../../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../../widget/load_state_layout.dart';

class AnalyticsEntityDetailState {
  var orderDetailEntity = OrderDetailEntity().obs;

  String dimId = '';
  String dimIdCode = '';
  String entity = '';

  bool isShowMore = false;
  var isExpand = false.obs;

  /// 页面加载状态
  var loadState = LoadState.stateLoading.obs;
  String? errorCode;
  String? errorMessage;

  var parameters = <ModuleMetricsCardDrillDownInfoParameters>[].obs;

  // 页面是否关闭
  bool isClosed = false;

  AnalyticsEntityDetailState() {
    ///Initialize variables
  }
}
