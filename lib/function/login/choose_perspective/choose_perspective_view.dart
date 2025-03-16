import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';
import '../../../utils/app_info.dart';
import 'choose_perspective_logic.dart';

/// 多组织选择
class ChoosePerspectivePage extends StatelessWidget {
  ChoosePerspectivePage({super.key});

  final double topWidgetHeight = 200;

  final logic = Get.put(ChoosePerspectiveLogic());
  final state = Get.find<ChoosePerspectiveLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration:
            const BoxDecoration(image: DecorationImage(image: AssetImage(Assets.imageLoginBg), fit: BoxFit.cover)),
        child: SafeArea(child: _createBody()),
      ),
    );
  }

  Widget _createBody() {
    return Column(
      children: [
        _createAppBarWidget(),
        Image.asset(
          Assets.imageLoginLogo,
          width: 70,
          height: 70,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            RSAppInfo().appDisplayName,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 90, left: 20, right: 20, bottom: 80),
            child: Obx(() {
              return Scrollbar(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: state.corporationList.length,
                  itemBuilder: (context, index) {
                    return _createItem(index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 12,
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _createAppBarWidget() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: 1.sw,
      child: Stack(
        children: [
          Positioned(
              child: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Get.back();
            },
          )),
        ],
      ),
    );
  }

  Widget _createItem(int index) {
    return InkWell(
      onTap: () {
        // 获取Token
        logic.getAccessToken(state.corporationList[index]);
      },
      child: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: RSColor.color_0xFFF3F3F3),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AutoSizeText(
                state.corporationList[index].corporationName ?? "-",
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: RSColor.color_0x90000000,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: RSColor.color_0x40000000,
              size: 24,
            )
          ],
        ),
      ),
    );
  }
}
