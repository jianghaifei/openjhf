import 'package:flutter_report_project/model/setting/setting_user_config_entity.dart';
import 'package:flutter_report_project/utils/network/request.dart';
import 'package:flutter_report_project/utils/network/request_client.dart';
import 'package:flutter_report_project/utils/network/server_url.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import 'mine_setting_state.dart';

class MineSettingLogic extends GetxController {
  final MineSettingState state = MineSettingState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    loadUserConfig();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void loadUserConfig() async {
    await request(() async {
      SettingUserConfigEntity? entity = await requestClient.request(
        RSServerUrl.getUserConfig,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          setListTitle();
          return false;
        },
      );

      if (entity != null) {
        state.userConfigEntity.value = entity;
        setListTitle();
      }
    }, showLoading: true);
  }

  // String getCurrencyTypesSubtitle() {
  //   var currencyString = "";
  //   RSAccountManager().userInfoEntity?.currencies?.forEach((element) {
  //     if (element.value == RSAccountManager().getCurrency()?.value) {
  //       currencyString = "${element.symbol}(${element.name})";
  //     }
  //   });
  //
  //   return currencyString;
  // }

  void setListTitle() {
    var titles = state.userConfigEntity.value.userConfig?.map((element) => element.configTypeName ?? '').toList();
    if (titles != null) {
      state.listTitle.value = titles;
    } else {
      state.listTitle.value = [
        S.current.rs_my_account,
        // S.current.rs_theme,
        S.current.rs_languages,
        // S.current.rs_currency_types,
      ];
    }
  }
}
