import 'package:get/get.dart';

import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../card_load_state_layout.dart';

class TargetAnalysisDataGridState {
  // 页面加载状态
  var loadState = CardLoadState.stateLoading.obs;

  String? errorCode;
  String? errorMessage;

  // PK模型
  var resultStorePKTableEntity = StorePKTableEntity().obs;

  // 显示最大条目数
  final int showMaxLength = 10;

  TargetAnalysisDataGridState() {
    ///Initialize variables
  }
}
