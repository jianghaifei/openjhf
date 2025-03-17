import 'package:flutter_report_project/model/analytics_entity_list/analytics_entity_list_entity.dart';

class AnalyticsEntityListItemState {
  /// 订单角标
  var orderCornerMarkTypes = <AnalyticsEntityListListTags>[];

  /// 订单支付类型
  var orderPayTypes = <AnalyticsEntityListListTags>[];

  /// 其他类型
  var orderOtherTypes = <AnalyticsEntityListListTags>[];

  AnalyticsEntityListItemState() {
    ///Initialize variables
  }
}
