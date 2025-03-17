import 'package:get/get.dart';

import '../../function/login/account_manager/account_manager.dart';
import '../../model/store/store_pk/store_pk_entity.dart';
import '../../router/app_routes.dart';
import '../../utils/network/request.dart';
import '../../utils/network/request_client.dart';
import '../../utils/network/server_url.dart';
import 'custom_app_bar_state.dart';

class CustomAppBarLogic extends GetxController {
  final CustomAppBarState state = CustomAppBarState();

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

  Future<void> jumpStoresPKPage() async {
    await request(() async {
      StorePKEntity? entity = await requestClient.request(
        RSServerUrl.storesPKTemplate,
        method: RequestType.post,
        data: {},
        onResponse: (response) {},
        onError: (error) {
          return false;
        },
      );

      if (entity != null) {
        Get.toNamed(AppRoutes.storesPKPage, arguments: {
          "customDateToolEnum": state.customDateToolEnum,
          "compareDateRangeTypes": RSAccountManager().getCompareDateRangeTypeStrings(),
          "pkTemplate": entity,
        });
      }
    }, showLoading: true);
  }
}
