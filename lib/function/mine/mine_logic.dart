import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../utils/logger/logger_helper.dart';
import 'mine_state.dart';

class MineLogic extends GetxController {
  final MineState state = MineState();

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

  void setListTitle() {
    state.listTitle = [
      // S.current.rs_report,
      S.current.rs_setting,
      // S.current.rs_give_feedback,
      // S.current.rs_help_center,
      S.current.rs_version
    ];
  }
}
