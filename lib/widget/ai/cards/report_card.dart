import 'base_card.dart';
import '../../../function/login/account_manager/account_manager.dart';
import 'package:flutter_report_project/widget/custom_app_bar/custom_date_tool_widget/custom_date_tool_widget_logic.dart';
import '../utils/help.dart';

class AIChatReportCard extends AIChatBaseCard {
  const AIChatReportCard({
    super.key,
    required super.data,
  });

  Map<String, dynamic> get queryParams => data['queryParams'] ?? {};

  List<String> get shopIds {
    List<String> shopIdsValue =  (queryParams['shopIds'] as List<dynamic>?)
        ?.map((e) => e.toString())
        .toList() ?? [];
        
    return shopIdsValue.isNotEmpty
        ? shopIdsValue
        : RSAccountManager().selectedShops.map((e) => e.shopId ?? "").toList();
  }

  List<DateTime>? get displayTime =>
      stringToDateTimeList(queryParams['displayTime']);

  List<List<DateTime>>? get compareDateTimeRanges =>
      stringToDateTimeListList(queryParams['compareDateTimeRanges']);

  List<CompareDateRangeType>? get compareDateRangeTypes =>
      stringToEnumList<CompareDateRangeType>(
        queryParams['compareDateRangeTypes'] ?? ['lastMonth'],
        CompareDateRangeType.values,
      );

  CustomDateToolEnum? get customDateToolEnum =>
      stringToEnum<CustomDateToolEnum>(
        queryParams['customDateToolEnum'],
        CustomDateToolEnum.values,
        defaultValue: CustomDateToolEnum.DAY,
      );
}
