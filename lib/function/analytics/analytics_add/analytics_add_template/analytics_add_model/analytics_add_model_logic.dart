import 'package:get/get.dart';

import '../../../../../router/app_routes.dart';
import '../../../../../utils/logger/logger_helper.dart';
import '../../../analytics_editing/analytics_editing_logic.dart';
import 'analytics_add_model_state.dart';

class AnalyticsAddModelLogic extends GetxController {
  final AnalyticsAddModelState state = AnalyticsAddModelState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    logger.d("onReady", StackTrace.current);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    logger.d("onClose", StackTrace.current);
  }

  List<int> findAddedTemplate() {
    List<int> list = [];
    state.tabsData?.cards?.forEach((element) {
      int index = 0;
      state.customCardTemplate?.forEach((templateElement) {
        if (element.cardId == templateElement.cardId) {
          list.add(index);
        }
        index++;
      });
    });
    return list;
  }

  void backEditingPage() {
    final AnalyticsEditingLogic logic = Get.find<AnalyticsEditingLogic>();

    if (state.customCardTemplate != null && state.customCardTemplate!.isNotEmpty) {
      for (var index in state.selectIndexList) {
        if (index < state.customCardTemplate!.length) {
          logic.addCardData(state.customCardTemplate![index]);
        }
      }
    }

    Get.until((route) => Get.currentRoute == AppRoutes.analyticsEditingPage);
  }
}
