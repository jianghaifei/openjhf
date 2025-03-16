import 'package:get/get.dart';

import '../../../../model/store/store_pk/store_pk_entity.dart';

class PKDimsBottomSheetState {
  var entity = StorePKEntity().obs;

  //region Tab
  // 业务主题
  var tabs = <String>[].obs;

  // 当前tab下标
  var tabIndex = 0.obs;
  //endregion

  var selectedDim = StorePKCardMetadataCardGroupMetadataDims().obs;

  var selectedGroupCode = "".obs;

  PKDimsBottomSheetState() {
    ///Initialize variables
  }
}
