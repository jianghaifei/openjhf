import 'package:get/get.dart';

import '../../../model/user/user_info_entity.dart';
import '../login_state.dart';

class ChoosePerspectiveState {
  var corporationList = <UserInfoEmployeeList>[].obs;

  var loginType = LoginType.phone;

  String? phoneAreaCode;
  String? account;
  String? verifyCode;

  ChoosePerspectiveState() {
    ///Initialize variables
  }
}
