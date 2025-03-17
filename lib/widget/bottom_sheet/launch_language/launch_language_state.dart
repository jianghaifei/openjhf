import 'package:get/get.dart';

import '../../../../config/rs_locale.dart';

class LaunchLanguageState {
  var selectedIndex = 0.obs;

  List<String> listTitle = [];

  LaunchLanguageState() {
    ///Initialize variables

    selectedIndex.value = RSLocale().localeIndex;
  }
}
