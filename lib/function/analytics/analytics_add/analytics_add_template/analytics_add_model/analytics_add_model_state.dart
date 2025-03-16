import 'package:get/get.dart';

import '../../../../../model/business_topic/topic_template_entity.dart';

class AnalyticsAddModelState {
  List<String> tabs = [];

  var selectIndexList = <int>[].obs;

  String? tabName;
  String? navId;
  String? tabId;
  TopicTemplateTemplatesNavsTabs? tabsData;
  List<TopicTemplateTemplatesNavsTabsCards>? customCardTemplate;

  AnalyticsAddModelState() {
    ///Initialize variables
  }
}
