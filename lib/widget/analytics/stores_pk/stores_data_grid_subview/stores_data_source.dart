import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../function/login/account_manager/account_manager.dart';
import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import '../../../../utils/analytics_tools.dart';

typedef RefreshCallback = VoidCallback;

enum DataGridStyle {
  // 排名类型
  rankType,
  // 桌台类型
  diningTableType,
  // 门店目标类型
  storeTargetType,
}

class StoresDataSource extends DataGridSource {
  StoresDataSource({
    required StorePKTableEntity storePKTableEntity,
    required RefreshCallback refreshCallback,
    required bool ifCardStyle,
    required DataGridStyle dataGridStyle,
  }) {
    myStorePKTableEntity = storePKTableEntity;
    useCardStyle = ifCardStyle;
    myDataGridStyle = dataGridStyle;

    if (storePKTableEntity.table?.header != null) {
      firstHeaderElement = storePKTableEntity.table?.header?.first.code ?? '';
    }

    dataGridRows = storePKTableEntity.table?.rows?.map<DataGridRow>((element) {
          List<DataGridCell> dataGridCellList = [];

          if (element != null && element is Map<String, dynamic>) {
            Map<String, dynamic> rowsData = element;

            storePKTableEntity.table?.header?.forEach((headerElement) {
              if (rowsData.containsKey(headerElement.code)) {
                StorePKTableEntityTableRows? tableRow =
                    StorePKTableEntityTableRows.fromJson(rowsData[headerElement.code]);
                dataGridCellList.add(DataGridCell(columnName: headerElement.code ?? '', value: tableRow));
              } else {
                StorePKTableEntityTableRows? tableRow = StorePKTableEntityTableRows();
                dataGridCellList.add(DataGridCell(columnName: headerElement.code ?? '', value: tableRow));
              }
            });
          }
          return DataGridRow(cells: dataGridCellList);
        }).toList() ??
        [];

    myRefreshCallback = refreshCallback;
  }

  StorePKTableEntity? myStorePKTableEntity;

  List<DataGridRow> dataGridRows = [];

  String firstHeaderElement = '';

  RefreshCallback? myRefreshCallback;

  @override
  List<DataGridRow> get rows => dataGridRows;

  /// 数据表格样式
  DataGridStyle myDataGridStyle = DataGridStyle.rankType;

  /// 是否显示对比
  bool showComparison = false;

  /// 当前对比类型
  CompareDateRangeType? currentCompareDateRangeType;

  /// 当前对比的ColumnName
  String currentColumnName = '';

  /// 排序方式
  bool isSortAscending = false;

  /// 是否卡片风格
  bool useCardStyle = false;

  /// 进度
  // double progressValue = 0.3;

  @override
  Future<void> handleRefresh() async {
    myRefreshCallback?.call();
  }

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    StorePKTableEntityTableRows aRow =
        a?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value;
    StorePKTableEntityTableRows bRow =
        b?.getCells().firstWhereOrNull((element) => element.columnName == sortColumn.name)?.value;

    double value1 = double.tryParse(aRow.value ?? '0') ?? 0.00;
    double value2 = double.tryParse(bRow.value ?? '0') ?? 0.00;

    if (currentCompareDateRangeType != null) {
      if (currentCompareDateRangeType == CompareDateRangeType.yesterday) {
        value1 = double.tryParse(aRow.compValue?.dayCompare?.value ?? '0') ?? 0.00;
        value2 = double.tryParse(bRow.compValue?.dayCompare?.value ?? '0') ?? 0.00;
      } else if (currentCompareDateRangeType == CompareDateRangeType.lastWeek) {
        value1 = double.tryParse(aRow.compValue?.weekCompare?.value ?? '0') ?? 0.00;
        value2 = double.tryParse(bRow.compValue?.weekCompare?.value ?? '0') ?? 0.00;
      } else if (currentCompareDateRangeType == CompareDateRangeType.lastMonth) {
        value1 = double.tryParse(aRow.compValue?.monthCompare?.value ?? '0') ?? 0.00;
        value2 = double.tryParse(bRow.compValue?.monthCompare?.value ?? '0') ?? 0.00;
      } else if (currentCompareDateRangeType == CompareDateRangeType.lastYear) {
        value1 = double.tryParse(aRow.compValue?.yearCompare?.value ?? '0') ?? 0.00;
        value2 = double.tryParse(bRow.compValue?.yearCompare?.value ?? '0') ?? 0.00;
      }
    }

    if (sortColumn.sortDirection == DataGridSortDirection.ascending) {
      // debugPrint("sortColumn.sortDirection: ${sortColumn.sortDirection} --- ${value1.compareTo(value2)}");
      return value1.compareTo(value2);
    } else {
      // debugPrint("sortColumn.sortDirection: ${sortColumn.sortDirection} --- ${value2.compareTo(value1)}");
      return value2.compareTo(value1);
    }
  }

  /// 合计行
  @override
  Widget? buildTableSummaryCellWidget(GridTableSummaryRow summaryRow, GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex, String summaryValue) {
    // total赋值
    var totalData = myStorePKTableEntity?.table?.total;
    if (totalData != null && totalData is Map<String, dynamic>) {
      var headerCode = summaryColumn?.columnName;
      if (totalData.containsKey(headerCode)) {
        StorePKTableEntityTableTotal? tableTotal = StorePKTableEntityTableTotal.fromJson(totalData[headerCode]);
        return Container(
          padding: EdgeInsets.only(left: rowColumnIndex.columnIndex == 0 ? 16 : 8),
          color: RSColor.dataGridFooterCellColor,
          alignment: Alignment.centerLeft,
          child: Text(
            tableTotal.displayValue ?? '-',
            style: TextStyle(
              color: rowColumnIndex.columnIndex == 0 ? RSColor.color_0x60000000 : RSColor.color_0x90000000,
              fontSize: 12,
              fontWeight: rowColumnIndex.columnIndex == 0 ? FontWeight.w400 : FontWeight.w600,
            ),
          ),
        );
      }
    }

    return Container();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    Color getRowBackgroundColor() {
      final int index = effectiveRows.indexOf(row);
      // 间隔背景色
      if (index % 2 == (useCardStyle ? 1 : 0)) {
        return RSColor.color_0xFFF9F9F9;
      }
      // 默认背景色
      return RSColor.color_0xFFFFFFFF;
    }

    return DataGridRowAdapter(
        color: getRowBackgroundColor(),
        cells: row.getCells().map((dataGridCell) {
          // if (myDataGridStyle == DataGridStyle.storeTargetType) {
          //   if (dataGridCell.value.code == firstHeaderElement) {
          //     return Stack(
          //       alignment: Alignment.bottomCenter,
          //       children: [
          //         Container(
          //           padding: const EdgeInsets.all(8.0),
          //           alignment: Alignment.centerLeft,
          //           child: getRowCellWidget(dataGridCell.value, dataGridCell.columnName, row),
          //         ),
          //         SizedBox(
          //           height: 2,
          //           child: LinearProgressIndicator(
          //             value: 0.3, // 进度值，范围在 0.0 到 1.0 之间
          //             backgroundColor: RSColor.color_0xFF5C57E6.withOpacity(0.1),
          //             valueColor: const AlwaysStoppedAnimation(RSColor.color_0xFF5C57E6),
          //           ),
          //         )
          //       ],
          //     );
          //   }
          // }
          return Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            child: getRowCellWidget(dataGridCell.value, dataGridCell.columnName, row),
          );
        }).toList());
  }

  Widget getRowCellWidget(StorePKTableEntityTableRows tableRow, String columnName, DataGridRow row) {
    if (tableRow.code == firstHeaderElement) {
      // 首列

      final int index = effectiveRows.indexOf(row);

      if (myDataGridStyle == DataGridStyle.rankType) {
        // 排名样式
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            const SizedBox(width: 8.0),
            Text(
              "${index + 1}",
              style: TextStyle(
                color: getRankingColor(index + 1),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8.0),
            Flexible(
              child: Text(
                tableRow.displayValue ?? '-',
                maxLines: 3,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
          ],
        );
      } else {
        if (myDataGridStyle == DataGridStyle.diningTableType) {
          // 桌台样式
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 8.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        tableRow.displayValue ?? '-',
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: RSColor.color_0x60000000,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    if (tableRow.extras != null && tableRow.extras!.isNotEmpty)
                      Text(
                        tableRow.extras?.first.displayValue ?? '-',
                        style: const TextStyle(
                          color: RSColor.color_0x40000000,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                  ],
                ),
              ),
            ],
          );
        } else {
          // 门店目标样式
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  tableRow.displayValue ?? '-',
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          );
        }
      }
    } else {
      // 其他列
      if (myDataGridStyle == DataGridStyle.rankType) {
        // 排名样式
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 4.0),
            Flexible(
              child: FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      tableRow.displayValue ?? '-',
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: RSColor.color_0x90000000,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (columnName == currentColumnName &&
                        showComparison &&
                        myDataGridStyle != DataGridStyle.diningTableType)
                      const SizedBox(height: 4),
                    if (columnName == currentColumnName &&
                        showComparison &&
                        myDataGridStyle != DataGridStyle.diningTableType)
                      AnalyticsTools.buildCompareWidget(tableRow.compValue)
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        // 桌台样式 && 门店目标样式
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 4.0),
            Flexible(
              child: Text(
                tableRow.displayValue ?? '-',
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: RSColor.color_0x90000000,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      }
    }
  }

  Color getRankingColor(int index) {
    if (index == 1) {
      return Color(0xFFFFDC01);
    } else if (index == 2) {
      return Color(0xFFBBD2D5);
    } else if (index == 3) {
      return Color(0xFFE7AD4C);
    } else {
      return RSColor.color_0x26000000;
    }
  }
}
