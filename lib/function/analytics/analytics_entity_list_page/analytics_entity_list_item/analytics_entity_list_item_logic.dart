import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../model/analytics_entity_list/analytics_entity_list_entity.dart';
import '../../../../model/business_topic/business_topic_type_enum.dart';
import 'analytics_entity_list_item_state.dart';

class AnalyticsEntityListItemLogic extends GetxController {
  final AnalyticsEntityListItemState state = AnalyticsEntityListItemState();

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

  void buildOrderTags(AnalyticsEntityListList entity) {
    state.orderCornerMarkTypes.clear();
    state.orderOtherTypes.clear();
    state.orderPayTypes.clear();
    debugPrint(
        "entity.orderId: ${entity.dims?.first.value}---entity.tags: ${entity.tags?.map((element) => element.tagEnum.toString()).toList()}");
    entity.tags?.forEach((element) {
      if (element.tagEnum == OrderEntityTagType.Order_Refund ||
          element.tagEnum == OrderEntityTagType.Item_Refund ||
          element.tagEnum == OrderEntityTagType.Payment_Refund ||
          element.tagEnum == OrderEntityTagType.Order_Reversal ||
          element.tagEnum == OrderEntityTagType.Order_Reopen) {
        state.orderCornerMarkTypes.add(element);
      } else if (element.tagEnum == OrderEntityTagType.Order_Discount ||
          element.tagEnum == OrderEntityTagType.Order_Promotion ||
          element.tagEnum == OrderEntityTagType.Order_Member) {
        state.orderOtherTypes.add(element);
      } else if (element.tagEnum == OrderEntityTagType.Cash_Payment ||
          element.tagEnum == OrderEntityTagType.Bank_Card_Payment ||
          element.tagEnum == OrderEntityTagType.Online_Payment ||
          element.tagEnum == OrderEntityTagType.Gift_Card) {
        state.orderPayTypes.add(element);
      }
    });
  }
}
