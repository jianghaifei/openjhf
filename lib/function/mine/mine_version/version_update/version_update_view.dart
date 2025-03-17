import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_upgrade/r_upgrade.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../utils/app_info.dart';
import '../../../../widget/bottom_button_widget/rs_bottom_button_widget.dart';
import '../../../../widget/card_load_state_layout.dart';
import '../../../../widget/rs_app_bar.dart';
import 'version_update_logic.dart';

// TODO: 此处修改是否切换app内升级
class VersionUpdatePage extends StatefulWidget {
  const VersionUpdatePage({super.key});

  @override
  State<VersionUpdatePage> createState() => _VersionUpdatePageState();
}

class _VersionUpdatePageState extends State<VersionUpdatePage> {
  final logic = Get.put(VersionUpdateLogic());
  final state = Get.find<VersionUpdateLogic>().state;

  @override
  void dispose() {
    Get.delete<VersionUpdateLogic>();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }

  @override
  void initState() {
    super.initState();

    if (!state.isDialogSource) {
      logic.loadRequest();
    } else {
      // 是否已下载过
      logic.getLastUpgradeId();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(
          title: S.current.rs_version,
          appBarColor: RSColor.color_0xFFFFFFFF,
        ),
        body: Obx(() {
          return CardLoadStateLayout(
            state: state.loadState.value,
            loadingTitle: S.current.rs_update_checking_new_versions,
            successWidget: _buildBodyWidget(),
            reloadCallback: () {
              logic.loadRequest();
            },
            errorCode: state.errorCode,
            errorMessage: state.errorMessage,
          );
        }));
  }

  Widget _buildBodyWidget() {
    if (state.versionEntity.value.version != null && state.versionEntity.value.version!.isNotEmpty) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 36, bottom: 24, left: 24, right: 24),
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: ShapeDecoration(
            color: RSColor.color_0xFFFFFFFF,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Column(
            children: [
              Image.asset(
                Assets.imageAppLogo,
                width: 70,
                height: 70,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  RSAppInfo().appDisplayName,
                  style: const TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Version ${state.versionEntity.value.version}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: RSColor.color_0x90000000,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    state.versionEntity.value.releaseNote ?? '',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: RSColor.color_0x60000000,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              // Container(
              //   color: Colors.green,
              //   width: 1.sw,
              //   height: 300,
              // ),
              if (state.isStartDownload.value) downloadTheProgressBar(),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: RSBottomButtonWidget.buildFixedWidthBottomButton(
                    logic.getCurrentTitle(state.isStartDownload.value, state.downloadStatus.value), (title) {
                  logic.clickAction(state.downloadStatus.value);
                }),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          S.current.rs_update_already_latest_version,
          style: TextStyle(
            color: RSColor.color_0x40000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }
  }

  Widget downloadTheProgressBar() {
    if (state.downloadStatus.value == DownloadStatus.STATUS_SUCCESSFUL && state.downloadMaxLength.value <= 0) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2), // 设置圆角
              child: LinearProgressIndicator(
                value: state.downloadProgress.value, // 进度值，范围在 0.0 到 1.0 之间
                backgroundColor: RSColor.color_0xFF5C57E6.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(RSColor.color_0xFF5C57E6),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '${state.downloadCurrentLength.value.toStringAsFixed(2)}M/${state.downloadMaxLength.value.toStringAsFixed(2)}M',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: RSColor.color_0x40000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}
