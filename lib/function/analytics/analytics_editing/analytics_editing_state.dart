import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/business_topic/topic_template_entity.dart';

class AnalyticsEditingState {
  var topicTemplateEntity = TopicTemplateEntity().obs;

  /// 选中主题下标
  var topicIndex = 0;

  /// 业务主题
  var tabs = <String>[].obs;

  List<Widget> recordTabData = [];

  /// 用来记录已添加未保存的metric code
  var keyMetricsAddedMetricCodes = <String?>[];

  AnalyticsEditingState() {
    ///Initialize variables
  }
}
