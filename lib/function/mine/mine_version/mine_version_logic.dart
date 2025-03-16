import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../utils/network/models/api_response_entity.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import 'mine_version_state.dart';

class MineVersionLogic extends GetxController {
  final MineVersionState state = MineVersionState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  /// 请求app版本
  void requestCheckAppVersion() async {
    await request(() async {
      await requestClient.request(RSServerUrl.clientUpgrade, method: RequestType.post, data: {}, onError: (e) {
        debugPrint('error = ${e.code}--${e.message}');

        // 当前嵌套请求是否继续执行
        return false;
      }, onResponse: (ApiResponseEntity response) {
        debugPrint('原始 response = $response');

        var tmpResponseData = response.data;
        if (tmpResponseData != null && tmpResponseData is Map<String, dynamic>) {
          Map<String, dynamic> dataDic = response.data;

          // 审核状态 0未审核中 1审核中
          if (dataDic.containsKey("checkStatus")) {}
          // 需要更新到的版本
          if (dataDic.containsKey("updateVersion")) {}

          int updateStatus = 0;
          List<String> updateInfo = [];

          // 更新状态 0不处理  1软更  2强更
          if (dataDic.containsKey("updateStatus")) {
            updateStatus = dataDic["updateStatus"];
          }

          // 更新内容【List<String>】
          if (dataDic.containsKey("updateInfo")) {
            if (dataDic["updateInfo"] != null && dataDic["updateInfo"] is List<dynamic>) {
              List<dynamic> tmpList = dataDic["updateInfo"];
              for (var element in tmpList) {
                updateInfo.add(element);
              }
            }
          }
          if (updateStatus != 0) {
            // Get.dialog(RSAppVersionUpdateDialog(isForce: updateStatus == 2, updateContent: updateInfo),
            //     barrierDismissible: false);
          }
        }
      });
    }, showLoading: false);
  }
}
