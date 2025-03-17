import 'package:get/get.dart';

import '../../../model/business_topic/topic_template_entity.dart';
import '../../../widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../../widget/load_state_layout.dart';
import '../../login/account_manager/account_manager.dart';

class SingleStoreJumpState {
  /// ----------自定义时间模块----------

  // 自定义日期组件的枚举值：日/月
  var customDateToolEnum = CustomDateToolEnum.DAY;

  // 当前页面自定义时间范围
  var currentCustomDateTime = <DateTime>[];

  // 对比时间范围类型——Enum
  var compareDateRangeTypes = <CompareDateRangeType>[];

  // 对比时间范围——DateTime
  List<List<DateTime>> compareDateTimeRanges = [];

  /// ----------页面----------

  /// 页面加载状态
  var loadState = LoadState.stateLoading.obs;

  /// 主题下标
  var topicIndex = 0;

  /// 业务主题
  var tabs = <String>[].obs;

  /// 模板实体
  var topicTemplateEntity = TopicTemplateEntity().obs;

  var shopId = <String>[].obs;

  SingleStoreJumpState() {
    ///Initialize variables

    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("shopIds") && args["shopIds"] != null) {
        shopId.value = args["shopIds"];
      }

      if (args.containsKey("customDateToolEnum") && args["customDateToolEnum"] != null) {
        final CustomDateToolEnum tmpEnum = args["customDateToolEnum"];
        customDateToolEnum = CustomDateToolEnum.values[tmpEnum.index];
      }

      if (args.containsKey("displayTime") && args["displayTime"] != null) {
        currentCustomDateTime = List.from(args["displayTime"]);
      }

      if (args.containsKey("compareDateRangeTypes") && args["compareDateRangeTypes"] != null) {
        compareDateRangeTypes = List.from(args["compareDateRangeTypes"]);
      }
    }
  }
}
