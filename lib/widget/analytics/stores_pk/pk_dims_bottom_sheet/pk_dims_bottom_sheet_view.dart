import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/bottom_sheet/rs_bottom_sheet_widget.dart';
import 'package:flutter_report_project/widget/rs_form_widget/rs_form_common_type_widget.dart';
import 'package:flutter_report_project/widget/rs_tab_controller_widget/rs_tab_controller_widget_view.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../model/store/store_pk/store_pk_entity.dart';
import 'pk_dims_bottom_sheet_logic.dart';

typedef ApplyCallback = Function(
    StorePKCardMetadataCardGroupMetadataDims selectedDim, String cardGroupCode, int tabIndex);

class PKDimsBottomSheetPage extends StatefulWidget {
  const PKDimsBottomSheetPage({
    super.key,
    required this.entity,
    required this.cardGroupCode,
    required this.selectedDim,
    required this.callback,
  });

  final StorePKEntity entity;
  final String cardGroupCode;
  final StorePKCardMetadataCardGroupMetadataDims selectedDim;
  final ApplyCallback callback;

  @override
  State<PKDimsBottomSheetPage> createState() => _PKDimsBottomSheetPageState();
}

class _PKDimsBottomSheetPageState extends State<PKDimsBottomSheetPage> {
  final logic = Get.put(PKDimsBottomSheetLogic());
  final state = Get.find<PKDimsBottomSheetLogic>().state;

  @override
  void dispose() {
    Get.delete<PKDimsBottomSheetLogic>();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    logic.setUIData(widget.entity, widget.selectedDim, widget.cardGroupCode);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return RSBottomSheetWidget(
        title: S.current.rs_dim,
        maxHeight: 0.7,
        children: [
          RSTabControllerWidgetPage(
            tabs: state.tabs,
            initialIndex: state.tabIndex.value,
            tabBarViews: List.generate(
              state.tabs.length,
              (index) {
                return _createBodyWidget(index);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _createBodyWidget(int tabIndex) {
    var cardGroup = state.entity.value.cardMetadata?.cardGroup?[tabIndex];
    var dims = cardGroup?.metadata?.first.dims;
    return ListView.builder(
        itemCount: dims?.length ?? 0,
        itemBuilder: (context, index) {
          bool ifSelected = state.selectedDim.value.dimCode == dims?[index].dimCode &&
              state.selectedGroupCode.value == cardGroup?.groupCode;

          return RSFormCommonTypeWidget.buildRadioFormWidget(dims?[index].dimName ?? '', ifSelected, (check) {
            if (dims?[index] != null) {
              setState(() {
                state.selectedDim.value = dims![index];

                widget.callback(state.selectedDim.value,
                    state.entity.value.cardMetadata?.cardGroup?[tabIndex].groupCode ?? '', index);
              });

              Get.back();
            }
          });
          return Text(
            dims?[index].dimName ?? '-',
            style: TextStyle(
              color: Colors.black.withOpacity(0.8999999761581421),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          );
        });
  }
}
