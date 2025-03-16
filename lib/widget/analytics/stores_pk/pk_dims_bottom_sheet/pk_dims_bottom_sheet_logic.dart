import 'package:get/get.dart';

import '../../../../model/store/store_pk/store_pk_entity.dart';
import 'pk_dims_bottom_sheet_state.dart';

class PKDimsBottomSheetLogic extends GetxController {
  final PKDimsBottomSheetState state = PKDimsBottomSheetState();

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

  void setUIData(StorePKEntity entity, StorePKCardMetadataCardGroupMetadataDims selectedDim, String cardGroupCode) {
    state.entity.value = entity;
    state.selectedDim.value = selectedDim;
    state.selectedGroupCode.value = cardGroupCode;

    // 设置tab
    List<String> tmpTabs = [];
    state.entity.value.cardMetadata?.cardGroup?.forEach((element) {
      if (element.groupCode != null && element.groupName != null) {
        tmpTabs.add(element.groupName!);
      }
    });
    state.tabs.value = tmpTabs;

    // 查找对应主题下标
    var index = entity.cardMetadata?.cardGroup?.indexWhere((group) => group.groupCode == cardGroupCode);
    if (index != null && index != -1) {
      state.tabIndex.value = index;
    }
  }
}
