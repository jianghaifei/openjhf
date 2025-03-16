import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/function/analytics/analytics_entity_list_page/analytics_entity_detail/analytics_entity_detail_state.dart';
import 'package:flutter_report_project/function/analytics/analytics_entity_list_page/analytics_entity_detail/order_detail_drill_down_bottom_sheet/order_detail_drill_down_bottom_sheet_view.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_report_project/utils/color_util.dart';
import 'package:flutter_report_project/widget/analytics/order_detail/rs_dashed_line_view.dart';
import 'package:flutter_report_project/widget/analytics/order_detail/rs_double_line_view.dart';
import 'package:flutter_report_project/widget/rs_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/analytics_entity_list/order_detail_entity.dart';
import '../../../../widget/load_state_layout.dart';
import 'analytics_entity_detail_logic.dart';

class AnalyticsEntityDetailPage extends StatefulWidget {
  const AnalyticsEntityDetailPage({super.key});

  @override
  State<AnalyticsEntityDetailPage> createState() => _AnalyticsEntityDetailPageState();
}

class _AnalyticsEntityDetailPageState extends State<AnalyticsEntityDetailPage> {
  final String tag = '${DateTime.now().millisecondsSinceEpoch}';

  AnalyticsEntityDetailLogic get logic => Get.find<AnalyticsEntityDetailLogic>(tag: tag);

  AnalyticsEntityDetailState get state => Get.find<AnalyticsEntityDetailLogic>(tag: tag).state;

  @override
  void dispose() {
    Get.delete<AnalyticsEntityDetailLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AnalyticsEntityDetailLogic(), tag: tag);

    return Obx(() {
      return Scaffold(
        appBar: RSAppBar(
            title: state.orderDetailEntity.value.title,
            showDivider: true,
            actions: state.parameters.isEmpty
                ? [
                    IconButton(
                        onPressed: () {
                          logic.loadOrderDetailBaseOptions();
                        },
                        icon: Image.asset(
                          Assets.imageOrderDetailSetting,
                          width: 24,
                          height: 24,
                        ))
                  ]
                : null),
        backgroundColor: RSColor.color_0xFFF3F3F3,
        body: LoadStateLayout(
          state: state.loadState.value,
          successWidget: _createBodyWidget(),
          reloadCallback: () {
            // 加载订单详细信息
            logic.loadDetailPageData();
          },
          errorCode: state.errorCode,
          errorMessage: state.errorMessage,
        ),
      );
    });
  }

  Widget _createBodyWidget() {
    List<Widget> listWidget = [];

    state.orderDetailEntity.value.divs?.forEach((div) {
      // title
      listWidget.add(_createTitleWidget(
        div.title?.text ?? '*',
        font: div.title?.font,
        lineColor: div.title?.lineColor,
        padding: div.title?.padding,
      ));

      int showRowLimit = 0;
      if (state.isExpand.value) {
        showRowLimit = div.rows?.length ?? 0;
      } else {
        showRowLimit = div.rowLimit ?? 0;
      }
      int rowIndex = 1;

      int divRowLimit = div.rowLimit ?? -1;

      if (div.rows != null) {
        for (var rowData in div.rows!) {
          if (rowData.rowType == OrderDetailRowType.DIVIDER_DASHED ||
              rowData.rowType == OrderDetailRowType.DIVIDER_SOLID) {
            // 虚线 || 实线
            listWidget.add(_createDividerWidget(
              rowData.lineColor,
              rowData.lineHeight,
              rowData.rowType,
              rowData.padding,
            ));
          } else if (rowData.rowType == OrderDetailRowType.ROW_DATA) {
            if (showRowLimit > 0) {
              if (rowIndex <= showRowLimit) {
                // 行数据
                listWidget.add(_createItemWidget(
                  rowData.columns,
                  padding: rowData.padding,
                ));
                if (state.isShowMore && divRowLimit > 0 && rowIndex == showRowLimit) {
                  listWidget.add(_createMoreWidget());
                  break;
                }
              } else {
                if (state.isShowMore && divRowLimit > 0) {
                  listWidget.add(_createMoreWidget());
                  break;
                }
              }
              rowIndex++;
            } else {
              // 行数据
              listWidget.add(_createItemWidget(
                rowData.columns,
                padding: rowData.padding,
              ));
            }
          } else if (rowData.rowType == OrderDetailRowType.SUB_TITLE_WITH_DRILL_DOWN) {
            rowData.drillDownRows?.forEach((element) {
              List<Widget> drillDownRowsWidgets = [];

              drillDownRowsWidgets.addAll(_returnDrillDownRowsWidgets(element.rows));

              // 标题带按钮
              listWidget.add(_createTitleAndButtonWidget(
                rowData.title ?? '*',
                element.title?.text ?? '*',
                drillDownRowsWidgets,
                font: rowData.font,
                lineColor: rowData.lineColor,
                padding: rowData.padding,
              ));
            });
          } else if (rowData.rowType == OrderDetailRowType.SUB_TITLE) {
            // 单横线带标题
            listWidget.add(_createSubtitleWidget(
              rowData.title ?? '*',
              font: rowData.font,
              lineColor: rowData.lineColor,
              padding: rowData.padding,
            ));
          }
        }
      }
    });

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(top: 8, bottom: 20),
            color: RSColor.color_0xFFFFFFFF,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listWidget,
            ),
            // child: ,
          ),
          _createFooterEmptyWidget(),
          SizedBox(height: ScreenUtil().bottomBarHeight),
        ],
      ),
    );
  }

  List<Widget> _returnDrillDownRowsWidgets(List<OrderDetailDivsRows>? rows) {
    List<Widget> listWidget = [];

    if (rows != null) {
      for (var rowData in rows) {
        if (rowData.rowType == OrderDetailRowType.DIVIDER_DASHED ||
            rowData.rowType == OrderDetailRowType.DIVIDER_SOLID) {
          // 虚线 || 实线
          listWidget.add(_createDividerWidget(
            rowData.lineColor,
            rowData.lineHeight,
            rowData.rowType,
            rowData.padding,
          ));
        } else if (rowData.rowType == OrderDetailRowType.ROW_DATA) {
          // 行数据
          listWidget.add(_createItemWidget(
            rowData.columns,
            padding: rowData.padding,
          ));
        }
      }
    }
    return listWidget;
  }

  Widget _createMoreWidget() {
    return InkWell(
      onTap: () {
        state.isExpand.value = !state.isExpand.value;
      },
      child: Container(
        margin: EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.isExpand.value ? S.current.rs_collapse : S.current.rs_expand,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RSColor.color_0xFF5C57E6,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              state.isExpand.value ? Icons.expand_less : Icons.expand_more,
              color: RSColor.color_0xFF5C57E6,
            ),
          ],
        ),
      ),
    );
  }

  /// 双横线带标题
  Widget _createTitleWidget(
    String title, {
    OrderDetailDivsRowsColumnsFont? font,
    String? lineColor,
    OrderDetailDivsRowsColumnsPadding? padding,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: padding?.left ?? 0,
        top: padding?.top ?? 0,
        right: padding?.right ?? 0,
        bottom: padding?.bottom ?? 0,
      ),
      child: Row(
        children: [
          Flexible(
            child: RSDoubleLineView(
              lineColor: RSColorUtil.convertStringToColor(lineColor),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            constraints: BoxConstraints(maxWidth: 1.sw - 16 * 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RSColorUtil.convertStringToColor(font?.color),
                fontSize: font?.size,
                fontWeight: FontWeight.values[font?.weightIndex ?? 5],
              ),
            ),
          ),
          Flexible(
            child: RSDoubleLineView(
              lineColor: RSColorUtil.convertStringToColor(lineColor),
            ),
          ),
        ],
      ),
    );
  }

  /// 单横线带标题
  Widget _createSubtitleWidget(
    String title, {
    OrderDetailDivsRowsColumnsFont? font,
    String? lineColor,
    OrderDetailDivsRowsColumnsPadding? padding,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: padding?.left ?? 0,
        top: padding?.top ?? 0,
        right: padding?.right ?? 0,
        bottom: padding?.bottom ?? 0,
      ),
      child: Row(
        children: [
          Flexible(
            child: RSCustomLineView(
              lineColor: RSColorUtil.convertStringToColor(lineColor),
              height: 1,
              lineType: RSLineType.solidLine,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            constraints: BoxConstraints(maxWidth: 1.sw - 16 * 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: RSColorUtil.convertStringToColor(font?.color),
                fontSize: font?.size,
                fontWeight: FontWeight.values[font?.weightIndex ?? 5],
              ),
            ),
          ),
          Flexible(
            child: RSCustomLineView(
              lineColor: RSColorUtil.convertStringToColor(lineColor),
              height: 1,
              lineType: RSLineType.solidLine,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createTitleAndButtonWidget(
    String title,
    String drillDownTitle,
    List<Widget> listWidget, {
    OrderDetailDivsRowsColumnsFont? font,
    String? lineColor,
    OrderDetailDivsRowsColumnsPadding? padding,
  }) {
    return Container(
      padding: EdgeInsets.only(
        left: padding?.left ?? 0,
        top: padding?.top ?? 0,
        right: padding?.right ?? 0,
        bottom: padding?.bottom ?? 0,
      ),
      child: Row(
        children: [
          Flexible(
            child: RSCustomLineView(
              lineColor: RSColorUtil.convertStringToColor(lineColor),
              height: 1,
              lineType: RSLineType.solidLine,
            ),
          ),
          InkWell(
            onTap: () {
              Get.bottomSheet(
                OrderDetailDrillDownBottomSheetPage(
                  title: drillDownTitle,
                  backgroundColor: RSColor.color_0xFFF3F3F3,
                  listItemWidget: listWidget,
                ),
                isScrollControlled: true,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: RSColorUtil.convertStringToColor(font?.color),
                      fontSize: font?.size,
                      fontWeight: FontWeight.values[font?.weightIndex ?? 5],
                    ),
                  ),
                  SizedBox(width: 4),
                  const Image(
                    image: AssetImage(Assets.imageChevronRightCircle),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: RSCustomLineView(
              lineColor: RSColorUtil.convertStringToColor(lineColor),
              height: 1,
              lineType: RSLineType.solidLine,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createDividerWidget(
    String? lineColor,
    double lineHeight,
    OrderDetailRowType? rowType,
    OrderDetailDivsRowsColumnsPadding? padding,
  ) {
    return Container(
      padding: EdgeInsets.only(
        left: padding?.left ?? 0,
        top: padding?.top ?? 0,
        right: padding?.right ?? 0,
        bottom: padding?.bottom ?? 0,
      ),
      child: RSCustomLineView(
        lineColor: RSColorUtil.convertStringToColor(lineColor),
        height: lineHeight,
        lineType: rowType == OrderDetailRowType.DIVIDER_DASHED ? RSLineType.dashedLine : RSLineType.solidLine,
      ),
    );
  }

  Widget _createItemWidget(
    List<OrderDetailDivsRowsColumns>? columns, {
    OrderDetailDivsRowsColumnsPadding? padding,
  }) {
    List<Widget> listWidget = [];

    int index = 0;

    columns?.forEach((element) {
      if (index > 0) {
        listWidget.add(SizedBox(
          width: 8,
        ));
      }
      listWidget.add(_createItemSubview(
        element.content?.text,
        element.content?.flex,
        element.content?.textAlign,
        element.content?.font,
        showTag: element.tag != null,
        tagText: element.tag?.text,
        tagBackground: element.tag?.background?.color,
        tagFont: element.tag?.font,
        relatedInfo: element.relatedInfo,
      ));

      index++;
    });

    return Container(
      padding: EdgeInsets.only(
        left: padding?.left ?? 0,
        top: padding?.top ?? 0,
        right: padding?.right ?? 0,
        bottom: padding?.bottom ?? 0,
      ),
      width: 1.sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: listWidget,
      ),
    );
  }

  Widget _createItemSubview(
    String? title,
    int? flex,
    OrderDetailContentTextAlign? textAlign,
    OrderDetailDivsRowsColumnsFont? titleFont, {
    bool showTag = false,
    String? tagText,
    String? tagBackground,
    OrderDetailDivsRowsColumnsFont? tagFont,
    OrderDetailDivsRowsColumnsRelatedInfo? relatedInfo,
  }) {
    return Flexible(
      flex: flex ?? 1,
      child: InkWell(
        onTap: () {
          if (relatedInfo != null) {
            logic.jumpNewDetailPage(relatedInfo);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                title ?? '*',
                textAlign: logic.convertStringToTextAlign(textAlign),
                style: TextStyle(
                  color: RSColorUtil.convertStringToColor(titleFont?.color),
                  fontSize: titleFont?.size,
                  fontWeight: titleFont?.weightIndex != null ? FontWeight.values[titleFont!.weightIndex!] : null,
                ),
              ),
            ),
            if (showTag)
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                  decoration: BoxDecoration(
                    color: RSColorUtil.convertStringToColor(tagBackground),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: Text(
                    tagText ?? '*',
                    style: TextStyle(
                      color: RSColorUtil.convertStringToColor(tagFont?.color),
                      fontSize: tagFont?.size,
                      fontWeight: tagFont?.weightIndex != null ? FontWeight.values[tagFont!.weightIndex!] : null,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _createFooterEmptyWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 68),
        Expanded(
          child: Container(
            height: 0.5,
            color: RSColor.color_0x26000000,
          ),
        ),
        SizedBox(width: 16),
        Image.asset(
          Assets.imageLogoSmallGrey,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsets.only(left: 6),
          child: Text(
            'RS Insight',
            style: TextStyle(
              color: RSColor.color_0x40000000,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 0.5,
            color: RSColor.color_0x26000000,
          ),
        ),
        SizedBox(width: 68),
      ],
    );
  }
}
