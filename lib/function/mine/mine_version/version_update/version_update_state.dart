import 'package:get/get.dart';
import 'package:r_upgrade/r_upgrade.dart';

import '../../../../utils/version_check/rs_app_version_entity.dart';
import '../../../../widget/card_load_state_layout.dart';

class VersionUpdateState {
  /// Page Load State
  var loadState = CardLoadState.stateLoading.obs;
  String? errorCode;
  String? errorMessage;

  var versionEntity = RSAppVersionVersions().obs;

  var isStartDownload = false.obs;

  // TODO: 此处修改是否切换app内升级
  // 下载状态
  var downloadStatus = DownloadStatus.STATUS_PENDING.obs;

  var downloadId = 0.obs;

  // 下载进度
  var downloadProgress = 0.0.obs;
  var downloadMaxLength = 0.0.obs;
  var downloadCurrentLength = 0.0.obs;

  // 是否通过dialog进入
  bool isDialogSource = false;

  VersionUpdateState() {
    ///Initialize variables
    dynamic args = Get.arguments;
    if (args != null || args is Map<String, dynamic>) {
      if (args.containsKey("isDialogSource")) {
        isDialogSource = args["isDialogSource"];
      }
      if (args.containsKey("entity") && args["entity"] != null) {
        versionEntity.value = args["entity"];

        loadState.value = CardLoadState.stateSuccess;
      }
    }
  }
}
