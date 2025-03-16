import 'package:flutter_report_project/model/setting/setting_user_config_entity.dart';
import 'package:get/get.dart';

class MineSettingState {
  /// 设置页的配置项模型
  var userConfigEntity = SettingUserConfigEntity().obs;

  var listTitle = <String>[].obs;

  MineSettingState() {
    ///Initialize variables
  }
}
