import 'package:get/get.dart';

import '../../../../model/business_topic/edit/metrics_edit_info_entity.dart';

class AnalyticsAddTemplateState {
  List<String> tabs = [];

  var selectIndexList = <int>[].obs;

  String? navId;
  String? tabId;
  String? tabName;
  List<MetricsEditInfoTabTemplate>? tabTemplate;

  AnalyticsAddTemplateState() {
    ///Initialize variables
  }
}
