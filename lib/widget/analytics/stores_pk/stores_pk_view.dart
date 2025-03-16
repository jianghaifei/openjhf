import 'package:flustars/flustars.dart' as flustars;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/analytics_tools.dart';
import 'package:flutter_report_project/widget/analytics/stores_pk/pk_dims_bottom_sheet/pk_dims_bottom_sheet_view.dart';
import 'package:flutter_report_project/widget/analytics/stores_pk/stores_data_grid_subview/stores_data_grid_subview_view.dart';
import 'package:flutter_report_project/widget/analytics/stores_pk/stores_pk_state.dart';
import 'package:flutter_report_project/widget/expandable_text_button/expandable_text_button_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../config/rs_color.dart';
import '../../../config/rs_locale.dart';
import '../../../function/login/account_manager/account_manager.dart';
import '../../../generated/assets.dart';
import '../../../generated/l10n.dart';
import '../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../model/store/store_pk/store_pk_entity.dart';
import '../../../utils/date_util.dart';
import '../../card_load_state_layout.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../../custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_view.dart';
import '../../popup_widget/drop_down_popup/rs_custom_drop_down_view.dart';
import '../../popup_widget/drop_down_popup/rs_popup.dart';
import '../../popup_widget/general_drop_down_view/general_drop_down_view.dart';
import '../../rs_app_bar.dart';
import 'stores_pk_logic.dart';

/// PK页
class StoresPKPage extends StatefulWidget {
  const StoresPKPage({super.key});

  @override
  State<StoresPKPage> createState() => _StoresPKPageState();
}

class _StoresPKPageState extends State<StoresPKPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final String tag = '${DateTime.now().microsecondsSinceEpoch}';

  StoresPKLogic get logic => Get.find<StoresPKLogic>(tag: tag);

  StoresPKState get state => Get.find<StoresPKLogic>(tag: tag).state;

  /// 用来标记控件
  final GlobalKey globalKeyHeadWidget = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<StoresPKLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Get.lazyPut(() => StoresPKLogic(), tag: tag);

    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state.pageType.value == PKPageType.storePKPage) {
          // 设置tab
          List<String> tmpTabs = [];
          state.resultStorePKEntity.value.cardMetadata?.cardGroup?.forEach((element) {
            if (element.groupCode != null && element.groupName != null) {
              tmpTabs.add(element.groupName!);
            }
          });
          state.tabs.value = tmpTabs;
        } else {
          logic.firstFindMetricsAndDims();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    String title = 'PK';
    if (state.pageType.value == PKPageType.storePKPage) {
      title = RSLocale().locale?.languageCode == 'zh' ? '${S.current.rs_store}PK' : '${S.current.rs_store} PK';
    } else {
      if (state.pageType.value == PKPageType.lossMetricsPage) {
        title = state.resultStorePKEntity.value.cardName ?? '*';
      } else {
        title = 'PK';
      }
    }
    return Scaffold(
      backgroundColor: RSColor.color_0xFFF3F3F3,
      appBar: RSAppBar(
        title: title,
      ),
      body: Obx(() {
        return _createBody();
      }),
    );
  }

  Widget _createBody() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          color: RSColor.color_0xFFFFFFFF,
          child: CustomDateToolWidgetPage(
            key: const ObjectKey(StoresPKPage),
            displayTime:
                state.currentCustomDateTime.isEmpty ? RSAccountManager().timeRange : state.currentCustomDateTime,
            customDateToolEnum: state.customDateToolEnum,
            compareDateRangeTypes: state.compareDateRangeTypes,
            dateTimeRangesCallback: (List<CompareDateRangeType>? compareDateRangeTypes,
                List<List<DateTime>>? compareDateTimeRanges,
                List<DateTime> displayTime,
                CustomDateToolEnum customDateToolEnum) async {
              state.currentCustomDateTime = displayTime;

              if (compareDateRangeTypes != null) {
                state.compareDateRangeTypes = compareDateRangeTypes;
              } else {
                state.compareDateRangeTypes.clear();
              }
              if (compareDateTimeRanges != null) {
                state.compareDateTimeRanges = compareDateTimeRanges;
              } else {
                state.compareDateTimeRanges.clear();
              }
              state.customDateToolEnum = customDateToolEnum;

              debugPrint("StoresPKPage——displayTime: $displayTime");
              debugPrint("StoresPKPage——compareDateRangeTypes: $compareDateRangeTypes");
              debugPrint("StoresPKPage——compareDateTimeRanges: $compareDateTimeRanges");

              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await logic.loadShopPKTableQuery();
              });
            },
          ),
        ),
        _buildCustomTabWidget(),
        Expanded(
          child: CardLoadStateLayout(
            state: state.loadState.value,
            successWidget: Container(
              padding: EdgeInsets.only(top: 8),
              color: RSColor.color_0xFFF3F3F3,
              child: StoresDataGridSubviewPage(
                compareTypesLength: state.compareDateRangeTypes.length,
                storePKTableEntity: state.resultStorePKTableEntity.value,
                refreshCallback: () {
                  logic.loadShopPKTableQuery();
                },
                jumpCallback: (ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode) {
                  if (drillDownInfo == null) {
                    return;
                  }

                  Map<String, dynamic> arguments = {
                    "displayTime": state.currentCustomDateTime,
                    "customDateToolEnum": state.customDateToolEnum,
                    "compareDateRangeTypes": state.compareDateRangeTypes,
                    "filterMetricCode": filterMetricCode,
                  };

                  if (state.currentCustomDateTime.isNotEmpty) {
                    arguments["timeRange"] = RSDateUtil.dateRangeToListString(state.currentCustomDateTime);
                    arguments["customDateToolEnum"] = state.customDateToolEnum;
                  }

                  AnalyticsTools().jumpEntityListOrSingleStore(drillDownInfo, arguments);
                },
              ),
            ),
            reloadCallback: () async {
              await logic.loadShopPKTableQuery();
            },
            errorCode: state.errorCode,
            errorMessage: state.errorMessage,
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTabWidget() {
    return Container(
      key: globalKeyHeadWidget,
      color: RSColor.color_0xFFFFFFFF,
      child: Column(
        children: [
          if (state.pageType.value == PKPageType.storePKPage)
            Container(
              margin: EdgeInsets.only(top: 2, bottom: 6),
              height: 32,
              width: 1.sw,
              child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Obx(() {
                      return InkWell(
                        onTap: () {
                          state.tabIndex.value = index;
                          logic.loadShopPKTableQuery();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: ShapeDecoration(
                            color: state.tabIndex.value == index
                                ? RSColor.color_0xFF5C57E6.withOpacity(0.1)
                                : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            state.tabs[index],
                            style: TextStyle(
                              color:
                                  state.tabIndex.value == index ? RSColor.color_0xFF5C57E6 : RSColor.color_0x60000000,
                              fontSize: 14,
                              fontWeight: state.tabIndex.value == index ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: 4);
                  },
                  itemCount: state.tabs.length),
            ),
          if (state.pageType.value == PKPageType.pkPage || state.pageType.value == PKPageType.lossMetricsPage)
            _buildDimsSwitchWidget(),
          _buildTabSubviewWidget(),
        ],
      ),
    );
  }

  Widget _buildDimsSwitchWidget() {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 8, right: 4),
      margin: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 8),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: ExpandableTextButtonPage(
        textWidget: Expanded(
          child: Text(
            state.selectedDims.map((dim) => dim.dimName).toList().join(""),
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        iconWidget: const Icon(
          Icons.keyboard_arrow_down,
        ),
        onPressed: () async {
          await Get.bottomSheet(
            PKDimsBottomSheetPage(
                entity: state.resultStorePKEntity.value,
                cardGroupCode: state.selectedGroupCode.value,
                selectedDim: state.selectedDims.first,
                callback: (StorePKCardMetadataCardGroupMetadataDims selectedDim, String cardGroupCode) async {
                  state.selectedDims.value = [selectedDim];
                  state.selectedGroupCode.value = cardGroupCode;

                  logic.getMetricsIfDefaultTrueIndexList();
                  await logic.loadShopPKTableQuery();
                }),
            isScrollControlled: true,
          );
        },
      ),
    );
  }

  Widget _buildTabSubviewWidget() {
    return Container(
        height: 32,
        padding: EdgeInsets.symmetric(horizontal: 4),
        margin: EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 12),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: RSColor.color_0xFFDCDCDC),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: ExpandableTextButtonPage(
          textWidget: Expanded(
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.only(left: 8, right: 4),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: ShapeDecoration(
                        color: RSColor.color_0xFFF3F3F3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.selectedMetrics[index].metricName ?? '',
                            style: TextStyle(
                              color: RSColor.color_0x90000000,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          InkWell(
                              onTap: () async {
                                if (state.selectedMetrics.length > 1) {
                                  await logic.changeMetricsIfDefaultTrueIndex(index);
                                  await logic.loadShopPKTableQuery();
                                } else {
                                  EasyLoading.showToast(S.current.rs_please_select_at_least_one_metric);
                                }
                              },
                              child: const Image(
                                image: AssetImage(Assets.imageCloseSmall),
                                width: 16,
                                height: 16,
                              )),
                        ],
                      ));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 4,
                  );
                },
                itemCount: state.selectedMetrics.length),
          ),
          iconWidget: const Icon(
            Icons.keyboard_arrow_down,
          ),
          onPressed: () async {
            if (globalKeyHeadWidget.currentContext != null) {
              // widget在屏幕上的坐标。
              Offset offset = flustars.WidgetUtil.getWidgetLocalToGlobal(globalKeyHeadWidget.currentContext!);
              // widget宽高。
              Rect rect = flustars.WidgetUtil.getWidgetBounds(globalKeyHeadWidget.currentContext!);

              var metrics = logic.getCurrentMetrics();

              var metricsTitleList = metrics?.map((metric) => metric.metricName ?? '').toList();

              var trueIndices = logic.getMetricsIfDefaultTrueIndexList(isChangeMetricsValue: false);

              return await RSPopup.show(
                  Get.context!,
                  RSCustomDropDownPage(
                    paddingTop: offset.dy + rect.height,
                    maxHeight: 1.sh * 0.4,
                    customWidget: GeneralDropDownView(
                        contextText: metricsTitleList ?? [],
                        defaultIndexList: trueIndices,
                        applyCallback: (List<int> selectedIndexList) async {
                          debugPrint("selectedIndexList = $selectedIndexList");
                          await logic.changeMetricsIfDefaultTrueIndexList(selectedIndexList);
                          await logic.loadShopPKTableQuery();
                        }),
                  ),
                  offsetLT: Offset(0, offset.dy + rect.height),
                  cancelable: false);
            }
          },
        ));
  }
}
