import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../model/business_topic/topic_template_entity.dart';
import '../../../utils/network/request.dart';
import '../../../utils/network/request_client.dart';
import '../../../utils/network/server_url.dart';
import '../../../widget/load_state_layout.dart';
import 'single_store_jump_state.dart';

class SingleStoreJumpLogic extends GetxController {
  final SingleStoreJumpState state = SingleStoreJumpState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    // handleData();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  /// 获取用户模板
  Future<void> loadUserTopicTemplate() async {
    return await request(() async {
      TopicTemplateEntity? entity = await requestClient.request(
        RSServerUrl.userTemplate,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          debugPrint('原始 error = ${error.message}');
          state.loadState.value = LoadState.stateError;
          return false;
        },
      );

      if (entity != null) {
        state.topicTemplateEntity.value = entity;

        // 设置tab
        setTopicTabs();

        if (entity.templates?.first.navs != null) {
          state.loadState.value = LoadState.stateSuccess;
        } else {
          state.loadState.value = LoadState.stateEmpty;
        }
      } else {
        state.loadState.value = LoadState.stateEmpty;
      }
    });
  }

  /// 设置tab
  void setTopicTabs() {
    List<String> tmpTabs = [];
    state.topicTemplateEntity.value.templates?.first.navs?.first.tabs?.forEach((element) {
      if (element.tabName != null && !element.ifHidden) {
        tmpTabs.add(element.tabName!);
      }
    });
    state.tabs.value = tmpTabs;
  }
}
