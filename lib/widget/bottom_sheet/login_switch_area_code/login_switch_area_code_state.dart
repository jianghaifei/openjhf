import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../model/login/login_area_code_entity.dart';

class LoginSwitchAreaCodeState {
  final searchTextFieldController = TextEditingController();

  List<LoginAreaCodeAreaCodeList> originalAreaCodeList = [];

  var displayedAreaCodeList = <LoginAreaCodeAreaCodeList>[].obs;

  LoginSwitchAreaCodeState() {
    ///Initialize variables
  }
}
