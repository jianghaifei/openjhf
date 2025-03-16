import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import 'mine_setting_metrics_unit_logic.dart';

class MineSettingMetricsUnitPage extends StatefulWidget {
  const MineSettingMetricsUnitPage({super.key});

  @override
  State<MineSettingMetricsUnitPage> createState() => _MineSettingMetricsUnitPageState();
}

class _MineSettingMetricsUnitPageState extends State<MineSettingMetricsUnitPage> {
  final logic = Get.put(MineSettingMetricsUnitLogic());
  final state = Get.find<MineSettingMetricsUnitLogic>().state;

  @override
  void dispose() {
    Get.delete<MineSettingMetricsUnitLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: RSColor.color_0xFFF3F3F3,
        appBar: RSAppBar(title: state.settingConfig.value.configTypeName),
        body: _createBody(),
      );
    });
  }

  Widget _createBody() {
    return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (BuildContext context, int index) {
          return Obx(() {
            return _createItemWidget(index);
          });
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: 8);
        },
        itemCount: state.settingConfig.value.configOptions?.length ?? 0);
  }

  Widget _createItemWidget(int index) {
    var entity = state.settingConfig.value.configOptions?[index];

    return InkWell(
      onTap: () async {
        logic.switchMetricsUnit(index);
      },
      child: Container(
        color: RSColor.color_0xFFFFFFFF,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entity?.configName ?? '*',
                        style: TextStyle(
                          color: RSColor.color_0x90000000,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Offstage(
                        offstage: entity?.subTitle == null,
                        child: Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            entity?.subTitle ?? '',
                            style: TextStyle(
                              color: RSColor.color_0x40000000,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Image(
                    image:
                        AssetImage((entity?.selected ?? false) ? Assets.imageCheckCircleSel : Assets.imageCheckCircle),
                    gaplessPlayback: true,
                  ),
                ),
              ],
            ),
            Container(
              width: 1.sw - 16 * 2,
              padding: EdgeInsets.only(top: 12),
              child: CachedNetworkImage(
                imageUrl: entity?.imageLink ?? '',
                fit: BoxFit.fitWidth,
              ),
            )
          ],
        ),
      ),
    );
  }
}
