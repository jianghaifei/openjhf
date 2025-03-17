import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/rs_color.dart';
import '../../generated/assets.dart';
import '../../generated/l10n.dart';

class RSAppVersionUpdateDialog extends StatelessWidget {
  const RSAppVersionUpdateDialog(
      {super.key, required this.isForce, required this.updateContent, required this.updateCallback});

  // 是否强制
  final bool isForce;

  // 更新内容
  final List<String> updateContent;

  // 更新回调
  final VoidCallback updateCallback;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imageVersionUpdateTop,
              fit: BoxFit.cover,
              width: 300,
            ),
            Container(
              width: 300,
              height: 280,
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
              ),
              child: _createBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createBody() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: AutoSizeText(
              S.current.rs_update_new_version,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RSColor.color_0x90000000,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 8),
          _createListWidget(),
          SizedBox(height: 24),
          _createUpdateButtonWidget(),
        ],
      ),
    );
  }

  Widget _createListWidget() {
    List<Widget> list = [];

    for (var element in updateContent) {
      list.add(Text(
        element,
        style: TextStyle(
          color: RSColor.color_0x60000000,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
      ));
    }

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: list,
          ),
        ),
      ),
    );
  }

  Widget _createUpdateButtonWidget() {
    return Row(
      children: [
        if (!isForce)
          Expanded(
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                margin: EdgeInsets.only(bottom: 12),
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: RSColor.color_0xFF5C57E6.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: AutoSizeText(
                  S.current.rs_update_update_later,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: RSColor.color_0xFF5C57E6,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        if (!isForce)
          SizedBox(
            width: 10,
          ),
        Expanded(
          child: InkWell(
            onTap: updateCallback,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              margin: EdgeInsets.only(bottom: 12),
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: RSColor.color_0xFF5C57E6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: AutoSizeText(
                S.current.rs_update_update_now,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: RSColor.color_0xFFFFFFFF,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

// Future<void> upgradeFromAndroidStore(AndroidStore store) async {
//   bool isSuccess = await RUpgrade.upgradeFromAndroidStore(store) ?? false;
//   debugPrint('跳转${store.packageName} ${isSuccess ? '成功' : '失败'}');
//   if (!isSuccess) {
//     EasyLoading.showToast(S.current.rs_update_tip);
//   }
// }

// void getAndroidStores() async {
// final stores = await RUpgrade.androidStores;
// List<String> storeNames = [];
// List<AndroidStore> androidStores = [];
//
// stores?.forEach((element) {
//   switch (element.packageName) {
//     case 'com.android.vending':
//       storeNames.add("Google Play");
//       androidStores.add(AndroidStore.GOOGLE_PLAY);
//       break;
//     case 'com.tencent.android.qqdownloader':
//       storeNames.add("应用宝");
//       androidStores.add(AndroidStore.TENCENT);
//       break;
//     case 'com.qihoo.appstore':
//       storeNames.add("360手机助手");
//       androidStores.add(AndroidStore.QIHOO);
//       break;
//     case 'com.baidu.appsearch':
//       storeNames.add("百度手机助手");
//       androidStores.add(AndroidStore.BAIDU);
//       break;
//     case 'com.xiaomi.market':
//       storeNames.add("小米应用商店");
//       androidStores.add(AndroidStore.XIAOMI);
//       break;
//     case 'com.wandoujia.phoenix2':
//       storeNames.add("豌豆荚");
//       androidStores.add(AndroidStore.WANDOU);
//       break;
//     case 'com.huawei.appmarket':
//       storeNames.add("华为应用市场");
//       androidStores.add(AndroidStore.HUAWEI);
//       break;
//     case 'com.hiapk.marketpho':
//       storeNames.add("安卓市场");
//       androidStores.add(AndroidStore.HIAPK);
//       break;
//     case 'com.coolapk.market':
//       storeNames.add("酷安");
//       androidStores.add(AndroidStore.COOLAPK);
//       break;
//     case 'com.bbk.appstore':
//       storeNames.add("vivo");
//       androidStores.add(const AndroidStore.internal("com.bbk.appstore"));
//       break;
//     case 'com.oppo.market':
//       storeNames.add("OPPO");
//       androidStores.add(const AndroidStore.internal("com.oppo.market"));
//       break;
//   }
// });
//
// if (storeNames.isNotEmpty && androidStores.isNotEmpty) {
//   buildBottomSheetPopup(storeNames, androidStores);
// } else {
//   EasyLoading.showToast(S.current.rs_update_tip);
// }
// }

// void buildBottomSheetPopup(List<String> storeNames, List<AndroidStore> stores) {
//   List<Widget> widgets = [];
//   debugPrint("stores $stores");
//   debugPrint("storeNames $storeNames");
//
//   for (int index = 0; index < storeNames.length; index++) {
//     widgets.add(InkWell(
//         onTap: () async {
//           await upgradeFromAndroidStore(stores[index]);
//         },
//         child: _createItemWidget(storeNames[index])));
//   }
//
//   Get.bottomSheet(
//     RSBottomSheetWidget(children: [
//       Flexible(
//         child: SingleChildScrollView(
//           child: Column(
//             children: widgets,
//           ),
//         ),
//       ),
//       Container(
//         color: RSColor.color_0xFFF3F3F3,
//         height: 8,
//       ),
//       InkWell(
//         onTap: () {
//           Get.back();
//         },
//         child: _createItemWidget(S.current.rs_cancel, showDivider: false),
//       )
//     ]),
//     isScrollControlled: true,
//     isDismissible: false,
//     enableDrag: false,
//   );
// }

// Widget _createItemWidget(String title, {bool showDivider = true}) {
//   return Column(
//     children: [
//       Container(
//         padding: EdgeInsets.symmetric(vertical: 16),
//         width: 1.sw,
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: RSColor.color_0x90000000,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ),
//       if (showDivider)
//         const Divider(
//           color: RSColor.color_0xFFE7E7E7,
//           thickness: 1,
//           height: 1,
//         ),
//     ],
//   );
// }
}
