import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/model/login/login_area_code_entity.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../rs_custom_text_field.dart';
import 'login_switch_area_code_logic.dart';

class LoginSwitchAreaCodePage extends StatefulWidget {
  const LoginSwitchAreaCodePage({
    super.key,
    required this.entity,
    required this.selectedEntity,
    required this.currentArea,
  });

  final LoginAreaCodeEntity entity;
  final LoginAreaCodeAreaCodeList currentArea;
  final Function(LoginAreaCodeAreaCodeList entity) selectedEntity;

  @override
  State<LoginSwitchAreaCodePage> createState() => _LoginSwitchAreaCodePageState();
}

class _LoginSwitchAreaCodePageState extends State<LoginSwitchAreaCodePage> {
  final logic = Get.put(LoginSwitchAreaCodeLogic());
  final state = Get.find<LoginSwitchAreaCodeLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.entity.areaCodeList != null) {
      state.originalAreaCodeList = widget.entity.areaCodeList!;
      state.displayedAreaCodeList.value =
          state.originalAreaCodeList.map((e) => LoginAreaCodeAreaCodeList.fromJson(e.toJson())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return RSBottomSheetWidget(title: S.current.rs_select_country_region, children: [
        _createSearchWidget(),
        _createBody(),
      ]);
    });
  }

  Widget _createSearchWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: RSCustomTextField(
        textFieldController: state.searchTextFieldController,
        hintText: S.current.rs_mobile_area_code_tip,
        onChanged: logic.performSearch,
      ),
    );
  }

  Widget _createBody() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: state.displayedAreaCodeList.length,
        itemBuilder: (context, index) {
          return Obx(() {
            return _buildItemWidget(index);
          });
        },
      ),
    );
  }

  Widget _buildItemWidget(int index) {
    var area = state.displayedAreaCodeList[index];

    return InkWell(
      onTap: () => _clickAction('selEntity', params: {"entity": area}),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                if (area.banner != null)
                  SvgPicture.network(
                    area.banner!,
                    width: 18,
                    height: 18,
                  ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 50,
                  child: AutoSizeText(
                    "+${area.areaCode ?? '0'}",
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    area.area ?? '-',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Image(
                  image: AssetImage(
                      (widget.currentArea.areaCode == area.areaCode && widget.currentArea.area == area.area)
                          ? Assets.imageCheckCircleSel
                          : Assets.imageCheckCircle),
                  gaplessPlayback: true,
                  // color: RSColor.color_0xFF5C57E6,
                )
              ],
            ),
          ),
          Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 1,
            indent: 16,
          ),
        ],
      ),
    );
  }

  _clickAction(String action, {Map<String, dynamic>? params}) {
    if (action == "selEntity") {
      LoginAreaCodeAreaCodeList entity = params?["entity"];
      widget.selectedEntity.call(entity);
      Get.back();
    } else {
      EasyLoading.showError("Not Found Method");
    }
  }
}
