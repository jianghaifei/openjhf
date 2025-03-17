import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../function/login/account_manager/account_manager.dart';

class StoresDataGridSubviewState {
  final DataGridController gridController = DataGridController();

  // 排序类型索引
  var sortTypeIndex = 0.obs;

  // 记录当前对比类型
  CompareDateRangeType? currentCompareDateRangeType;

  StoresDataGridSubviewState() {
    ///Initialize variables
  }
}
