import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_report_project/utils/color_util.dart';
import 'package:flutter_report_project/utils/utils.dart';
import 'package:get/get.dart';
import 'package:info_popup/info_popup.dart';

import '../config/rs_color.dart';
import '../config/rs_locale.dart';
import '../function/login/account_manager/account_manager.dart';
import '../generated/assets.dart';
import '../generated/l10n.dart';
import '../model/business_topic/business_topic_type_enum.dart';
import '../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../router/app_routes.dart';
import 'date_util.dart';
import 'logger/logger_helper.dart';

class AnalyticsTools {
  /// 获取指标值
  static String getMetricsValue(String? metricsValue, MetricOrDimDataType? dataType) {
    if (metricsValue == null) {
      if (dataType == MetricOrDimDataType.CURRENCY) {
        // 货币
        return "${RSAccountManager().getCurrency()?.symbol}*.**";
      } else {
        // 数字
        return "*";
      }
    } else {
      if (dataType == MetricOrDimDataType.CURRENCY) {
        // 货币
        try {
          return "${RSAccountManager().getCurrency()?.symbol}${RSUtils.truncateDoubleToString(double.parse(metricsValue))}";
        } catch (e) {
          logger.e("getMetricsValue.CURRENCY.metricsValue:$metricsValue", StackTrace.current);
          return metricsValue;
        }
      } else if (dataType == MetricOrDimDataType.NUMERIC_INT) {
        try {
          return "${int.tryParse(double.parse(metricsValue).toStringAsFixed(0))}";
        } catch (e) {
          logger.e("getMetricsValue.NUMERIC_INT.metricsValue:$metricsValue", StackTrace.current);
          return metricsValue;
        }
      } else {
        return metricsValue;
      }
    }
  }

  /// 对比视图
  static Widget buildCompareWidget(ModuleMetricsCardCompValue? compValueEntity) {
    List<Widget> widgets = [];
    if (compValueEntity?.dayCompare != null) {
      widgets.add(AnalyticsTools()._buildCompareSubView(CompareDateRangeType.yesterday,
          compValueEntity?.dayCompare?.displayValue, compValueEntity?.dayCompare?.color));
    }
    if (compValueEntity?.weekCompare != null) {
      widgets.add(AnalyticsTools()._buildCompareSubView(CompareDateRangeType.lastWeek,
          compValueEntity?.weekCompare?.displayValue, compValueEntity?.weekCompare?.color));
    }
    if (compValueEntity?.monthCompare != null) {
      widgets.add(AnalyticsTools()._buildCompareSubView(CompareDateRangeType.lastMonth,
          compValueEntity?.monthCompare?.displayValue, compValueEntity?.monthCompare?.color));
    }
    if (compValueEntity?.yearCompare != null) {
      widgets.add(AnalyticsTools()._buildCompareSubView(CompareDateRangeType.lastYear,
          compValueEntity?.yearCompare?.displayValue, compValueEntity?.yearCompare?.color));
    }

    if (widgets.isEmpty) {
      return Container();
    }

    return FittedBox(
      fit: BoxFit.fill,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widgets.length; i++) ...[
            widgets[i],
            if (i < widgets.length) const SizedBox(height: 2),
          ],
        ],
      ),
    );
  }

  Widget _buildCompareSubView(CompareDateRangeType type, String? displayValue, String? colorString) {
    bool ifCn = RSLocale().locale?.languageCode == 'zh';

    String title = "";

    switch (type) {
      case CompareDateRangeType.yesterday:
        title = ifCn ? S.current.rs_date_tool_yesterday : "DoD";
      case CompareDateRangeType.lastWeek:
        title = ifCn ? S.current.rs_date_tool_last_week : "WoW";
      case CompareDateRangeType.lastMonth:
        title = ifCn ? S.current.rs_date_tool_last_month : "MoM";
      case CompareDateRangeType.lastYear:
        title = ifCn ? S.current.rs_date_tool_last_year : "YoY";
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          ifCn ? '${S.current.rs_vs}$title' : title,
          style: const TextStyle(
            color: RSColor.color_0x40000000,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            displayValue ?? '-',
            style: TextStyle(
              color: RSColorUtil.convertStringToColor(colorString),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static Widget buildAmountWidget(
    String? displayValue,
    String? abbrDisplayValue,
    String? abbrDisplayUnit, {
    double abbrDisplayValueFontSize = 24,
    FontWeight abbrDisplayValueFontWeight = FontWeight.w500,
    double abbrDisplayUnitFontSize = 14,
    FontWeight abbrDisplayUnitFontWeight = FontWeight.w400,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Flexible(
          child: AutoSizeText(
            abbrDisplayValue ?? '*',
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: abbrDisplayValueFontSize,
              fontWeight: abbrDisplayValueFontWeight,
            ),
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (abbrDisplayUnit != null && abbrDisplayUnit.isNotEmpty)
          InfoPopupWidget(
            arrowTheme: InfoPopupArrowTheme(color: Colors.black.withOpacity(0.75), arrowDirection: ArrowDirection.down),
            // indicatorOffset: Offset(0, 0),
            customContent: () {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  displayValue ?? '*',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                SizedBox(
                  width: 2,
                ),
                AutoSizeText(
                  abbrDisplayUnit,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: abbrDisplayUnitFontSize,
                    fontWeight: abbrDisplayUnitFontWeight,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          )
      ],
    );
  }

  /// 返回对比时间&类型的Map
  static Map<String, dynamic> returnCompareDateRangeParams(
      List<CompareDateRangeType> rangeTypes, List<List<DateTime>> dateRangeTime) {
    Map<String, dynamic> params = {};

    if (dateRangeTime.isNotEmpty && rangeTypes.isNotEmpty) {
      for (int index = 0; index < rangeTypes.length; index++) {
        var type = rangeTypes[index];
        if (index < dateRangeTime.length) {
          List<DateTime> compareDate = dateRangeTime[index];
          switch (type) {
            case CompareDateRangeType.yesterday:
              params["dayCompareDate"] = RSDateUtil.dateRangeToListString(compareDate);
            case CompareDateRangeType.lastWeek:
              params["weekCompareDate"] = RSDateUtil.dateRangeToListString(compareDate);
            case CompareDateRangeType.lastMonth:
              params["monthCompareDate"] = RSDateUtil.dateRangeToListString(compareDate);
            case CompareDateRangeType.lastYear:
              params["yearCompareDate"] = RSDateUtil.dateRangeToListString(compareDate);
          }
        }
      }
    }

    return params;
  }

  EntityFilterType returnFilterType(String symbolTypeString) {
    switch (symbolTypeString) {
      case "~":
        return EntityFilterType.RANGE;
      case "≥":
        return EntityFilterType.GOE;
      case "≤":
        return EntityFilterType.LOE;
      case ">":
        return EntityFilterType.GT;
      case "<":
        return EntityFilterType.LT;
      case "=":
        return EntityFilterType.EQ;
      case "≠":
        return EntityFilterType.NE;
      default:
        return EntityFilterType.RANGE;
    }
  }

  String returnFilterTypeString(EntityFilterType type) {
    switch (type) {
      case EntityFilterType.RANGE:
        return "~";
      case EntityFilterType.GOE:
        return "≥";
      case EntityFilterType.LOE:
        return "≤";
      case EntityFilterType.GT:
        return ">";
      case EntityFilterType.LT:
        return "<";
      case EntityFilterType.EQ:
        return "=";
      case EntityFilterType.NE:
        return "≠";
      default:
        return "~";
    }
  }

  /// 获取卡片右上角按钮IconName
  String getAnalyticsChartImageName(AddMetricsChartType? code, String defaultImageName) {
    String chartImageName = Assets.imageAnalyticsChartLine;
    switch (code) {
      case AddMetricsChartType.LINE:
        chartImageName = Assets.imageAnalyticsChartLine;
        break;
      case AddMetricsChartType.BAR:
        chartImageName = Assets.imageAnalyticsChartBar;
        break;
      case AddMetricsChartType.LIST:
        chartImageName = Assets.imageAnalyticsChartList;
        break;
      case AddMetricsChartType.PIE:
        chartImageName = Assets.imageAnalyticsChartPie;
        break;
      case null:
        chartImageName = defaultImageName;
        break;
    }

    return chartImageName;
  }

  void jumpEntityListOrSingleStore(ModuleMetricsCardDrillDownInfo? drillDownInfo, Map<String, dynamic>? params) {
    if (drillDownInfo == null) {
      return;
    }
    Map<String, dynamic> arguments = {};

    var copyDrillDownInfo = ModuleMetricsCardDrillDownInfo.fromJson(drillDownInfo.toJson());

    if (params != null) {
      arguments.addAll(Map.from(params));
    }

    switch (copyDrillDownInfo.pageType) {
      case EntityJumpPageType.ENTITY_LIST:
        arguments["entity"] = copyDrillDownInfo.entity;
        arguments["entityTitle"] = copyDrillDownInfo.entityTitle;

        if (copyDrillDownInfo.metricCode != null) {
          arguments["metricCode"] = copyDrillDownInfo.metricCode;
        }

        if (copyDrillDownInfo.dimCode != null) {
          arguments["dimsCode"] = copyDrillDownInfo.dimCode;
        }

        if (copyDrillDownInfo.filter != null && copyDrillDownInfo.filter!.isNotEmpty) {
          arguments["filter"] = copyDrillDownInfo.filter;
        }

        logger.d("跳转至实体列表页 arguments:$arguments", StackTrace.current);

        Get.toNamed(AppRoutes.analyticsEntityListPage, arguments: arguments);
        return;
      case EntityJumpPageType.ENTITY_DETAIL:
      case EntityJumpPageType.ENTITY_OVERVIEW:
        arguments["shopIds"] = copyDrillDownInfo.shopIds;

        logger.d("跳转至单门店首页 arguments:$arguments", StackTrace.current);

        Get.toNamed(AppRoutes.singleStoreJumpPage, arguments: arguments);
        return;
      case EntityJumpPageType.REAL_TIME_TABLE_LIST:
        arguments["shopIds"] = copyDrillDownInfo.shopIds;

        logger.d("跳转至待结账门店页 arguments:$arguments", StackTrace.current);

        Get.toNamed(AppRoutes.diningTableListPage, arguments: arguments);
      case EntityJumpPageType.REAL_TIME_ORDER_DETAIL:
        logger.d("跳转至订单详情页", StackTrace.current);

        Get.toNamed(AppRoutes.analyticsEntityDetailPage, arguments: {"parameters": copyDrillDownInfo.parameters});
      default:
        EasyLoading.showError('pageType null');
    }
  }
}
