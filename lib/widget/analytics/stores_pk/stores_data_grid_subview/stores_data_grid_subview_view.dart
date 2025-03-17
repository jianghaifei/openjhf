import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/generated/assets.dart';
import 'package:flutter_report_project/widget/analytics/stores_pk/stores_data_grid_subview/stores_data_source.dart';
import 'package:flutter_report_project/widget/popup_widget/rs_bubble_popup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../config/rs_color.dart';
import '../../../../config/rs_locale.dart';
import '../../../../function/login/account_manager/account_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/business_topic/metrics_card/module_metrics_card_entity.dart';
import '../../../../model/store/store_pk/store_pk_table_entity.dart';
import 'stores_data_grid_subview_logic.dart';

typedef RefreshCallback = VoidCallback;
typedef JumpCallback = Function(ModuleMetricsCardDrillDownInfo? drillDownInfo, String? filterMetricCode);

class StoresDataGridSubviewPage extends StatefulWidget {
  const StoresDataGridSubviewPage({
    super.key,
    required this.compareTypesLength,
    required this.storePKTableEntity,
    required this.refreshCallback,
    required this.jumpCallback,
    this.ifDisplayTableSummary = true,
    this.ifUseBottomSpacing = true,
    this.allowPullToRefresh = true,
    this.maxHeight = double.infinity,
    this.physics,
    this.ifCardStyle = false,
    this.dataGridStyle = DataGridStyle.rankType,
    this.compareTypes,
  });

  // 数据模型
  final StorePKTableEntity storePKTableEntity;

  final List<CompareDateRangeType>? compareTypes;

  // 刷新回调
  final RefreshCallback refreshCallback;

  // 跳转回调
  final JumpCallback jumpCallback;

  // 对比类型数量长度
  final int compareTypesLength;

  // 是否显示底部合计
  final bool ifDisplayTableSummary;

  // 是否使用底部间距
  final bool ifUseBottomSpacing;

  // 启用刷新
  final bool allowPullToRefresh;

  // 最大高度
  final double maxHeight;

  // 滚动物理特性对象
  final ScrollPhysics? physics;

  // 是否是卡片样式
  final bool ifCardStyle;

  // 数据表格样式
  final DataGridStyle dataGridStyle;

  @override
  State<StoresDataGridSubviewPage> createState() => _StoresDataGridSubviewPageState();
}

class _StoresDataGridSubviewPageState extends State<StoresDataGridSubviewPage> {
  final logic = Get.put(StoresDataGridSubviewLogic());
  final state = Get.find<StoresDataGridSubviewLogic>().state;

  late StoresDataSource _storeDataSource;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    state.sortTypeIndex.value = 0;

    _storeDataSource = StoresDataSource(
        storePKTableEntity: widget.storePKTableEntity,
        refreshCallback: widget.refreshCallback,
        ifCardStyle: widget.ifCardStyle,
        dataGridStyle: widget.dataGridStyle);
    state.gridController.refreshRow(0, recalculateRowHeight: true);

    return Container(
      padding: widget.ifUseBottomSpacing
          ? EdgeInsets.only(bottom: ScreenUtil().bottomBarHeight == 0 ? 20 : ScreenUtil().bottomBarHeight)
          : EdgeInsets.zero,
      color: RSColor.color_0xFFFFFFFF,
      constraints: BoxConstraints(
        maxHeight: widget.maxHeight,
      ),
      child: _createDataGrid(),
    );
  }

  @override
  void dispose() {
    Get.delete<StoresDataGridSubviewLogic>();
    super.dispose();
  }

  Widget _createDataGrid() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: Theme(
        data: ThemeData(
          canvasColor: Colors.white,
          colorScheme: const ColorScheme.light(primary: RSColor.color_0xFF5C57E6),
        ),
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
            gridLineStrokeWidth: 0,
            gridLineColor: Colors.transparent,
            frozenPaneLineWidth: 1,
            headerColor: widget.ifCardStyle ? RSColor.color_0xFFF9F9F9 : null,
            frozenPaneLineColor: RSColor.color_0xFFF3F3F3,
            sortIcon: Builder(
              builder: (BuildContext context) {
                Widget? icon;
                String columnName = '';
                context.visitAncestorElements((element) {
                  if (element is GridHeaderCellElement) {
                    columnName = element.column.columnName;
                  }
                  return true;
                });
                var column = _storeDataSource.sortedColumns.where((element) => element.name == columnName).firstOrNull;
                if (column != null) {
                  if (column.sortDirection == DataGridSortDirection.ascending) {
                    icon = Image.asset(Assets.imageSortUpIcon);
                  } else if (column.sortDirection == DataGridSortDirection.descending) {
                    icon = Image.asset(Assets.imageSortDownIcon);
                  }
                }
                return icon ?? Image.asset(Assets.imageSortDefaultIcon);
              },
            ),
          ),
          child: SfDataGrid(
            verticalScrollPhysics: widget.physics ?? const ClampingScrollPhysics(),
            controller: state.gridController,
            allowPullToRefresh: widget.allowPullToRefresh,
            source: _storeDataSource,
            columnWidthMode: ColumnWidthMode.auto,
            // footerFrozenRowsCount: 1,
            // headerRowHeight: 36,
            frozenColumnsCount: 1,
            // 滚动条
            isScrollbarAlwaysShown: false,
            showVerticalScrollbar: true,
            showHorizontalScrollbar: true,
            allowSorting: true,
            // 行高
            onQueryRowHeight: (details) {
              if (details.rowIndex == 0) {
                return 36;
              } else if (details.rowIndex == _storeDataSource.rows.length + 1) {
                return 30;
              } else {
                if (!_storeDataSource.showComparison) {
                  return 60;
                }
                switch (widget.compareTypesLength) {
                  case 0:
                    return 65;
                  case 1:
                    return 65;
                  case 2:
                    return 85;
                  case 3:
                    return 95;
                  case 4:
                    return 110;
                  default:
                    return 110;
                }

                // return details.getIntrinsicRowHeight(details.rowIndex);
              }
            },
            onCellTap: (DataGridCellTapDetails details) {
              debugPrint("${details.rowColumnIndex.columnIndex}");

              if (details.rowColumnIndex.columnIndex != 0 && details.rowColumnIndex.rowIndex == 0) {
                // 排序
                setGridColumnSort(details.column.columnName, sortCompareType: state.currentCompareDateRangeType);
              } else if (details.rowColumnIndex.rowIndex != 0) {
                // 点击事件-跳转

                int rowIndex = details.rowColumnIndex.rowIndex - 1;
                int columnIndex = details.rowColumnIndex.columnIndex;

                if (_storeDataSource.effectiveRows.length > rowIndex) {
                  var rowDataList = _storeDataSource.effectiveRows[rowIndex];
                  if (rowDataList.getCells().length > columnIndex) {
                    var columnData = rowDataList.getCells()[columnIndex];
                    if (columnData.value != null && columnData.value is StorePKTableEntityTableRows) {
                      StorePKTableEntityTableRows entity = columnData.value;
                      if (entity.drillDownInfo != null) {
                        // 此处使用深拷贝机制，避免元数据被修改
                        widget.jumpCallback
                            .call(ModuleMetricsCardDrillDownInfo.fromJson(entity.drillDownInfo!.toJson()), entity.code);
                      }
                    }
                  }
                }
              }
            },
            columns: _buildTitlesWidget().toList(),
            tableSummaryRows: widget.ifDisplayTableSummary
                ? [
                    GridTableSummaryRow(
                      showSummaryInRow: false,
                      columns: returnSummaryRow(),
                      position: GridTableSummaryRowPosition.bottom,
                    )
                  ]
                : <GridTableSummaryRow>[],
          ),
        ),
      ),
    );
  }

  List<GridSummaryColumn> returnSummaryRow() {
    var titleCodes = widget.storePKTableEntity.table?.header?.map((headerElement) => headerElement.code).toList();

    List<GridSummaryColumn> list = [];
    titleCodes?.forEach((element) {
      list.add(GridSummaryColumn(name: element ?? '', columnName: element ?? '', summaryType: GridSummaryType.sum));
    });

    return list;
  }

  List<GridColumn> _buildTitlesWidget() {
    var titles = widget.storePKTableEntity.table?.header?.map((headerElement) => headerElement.name).toList();
    var titleCodes = widget.storePKTableEntity.table?.header?.map((headerElement) => headerElement.code).toList();

    List<GridColumn> listWidgets = [];

    double firstWidth = 140;
    double otherWidth = 180;

    // if (widget.dataGridStyle == DataGridStyle.diningTableType) {
    //   firstWidth = 130;
    //   otherWidth = 160;
    // }

    // 显示标题
    titlesSubWidget(int index, String title) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: index == 0 ? 16 : 0),
        child: AutoSizeText(
          title,
          maxFontSize: 12,
          minFontSize: 10,
          maxLines: 2,
          style: const TextStyle(
            color: RSColor.color_0x90000000,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    }

    int index = 0;
    titles?.forEach((element) {
      var columnName = titleCodes?[index] ?? '$index';
      var tmpGridColumn = GridColumn(
          sortIconPosition: ColumnHeaderIconPosition.start,
          columnName: columnName,
          allowSorting: index == 0 ? false : true,
          width: index == 0 ? firstWidth : otherWidth,
          columnWidthMode: ColumnWidthMode.auto,
          label: (index == 0 || getComparisonTimeOptions(columnName).isEmpty)
              ? titlesSubWidget(index, titles[index] ?? '$index')
              : RSBubblePopup(
                  barrierColor: Colors.transparent,
                  content: _createTipSubviewWidget(columnName),
                  child: titlesSubWidget(index, titles[index] ?? '$index'),
                ));
      listWidgets.add(tmpGridColumn);

      if (index == 1) {
        setGridColumnSort(tmpGridColumn.columnName);
      }

      index++;
    });

    return listWidgets;
  }

  /// 查看弹出视图子视图
  Widget _createTipSubviewWidget(String columnName) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeRight: true,
      child: Container(
        constraints: BoxConstraints(
          // 最大高度为十行文本高度
          maxHeight: 38 * 5.0,
          maxWidth: 1.sw - 16 * 2,
        ),
        child: Scrollbar(
          trackVisibility: true,
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: getComparisonTimeOptions(columnName)),
          ),
        ),
      ),
    );
  }

  // 获取当前页面对比时间选项
  List<Widget> getComparisonTimeOptions(String columnName) {
    List<Map<String, CompareDateRangeType?>> listTitles = [];
    List<Widget> listWidgets = [];

    widget.compareTypes?.forEach((element) {
      if (element == CompareDateRangeType.yesterday) {
        if (RSLocale().locale?.languageCode == 'zh') {
          listTitles.add({'${S.current.rs_by} ${S.current.rs_compare}${S.current.rs_date_tool_yesterday}': element});
        } else {
          listTitles.add({'${S.current.rs_by} ${S.current.rs_compare} DoD': element});
        }
      } else if (element == CompareDateRangeType.lastWeek) {
        if (RSLocale().locale?.languageCode == 'zh') {
          listTitles.add({'${S.current.rs_by}${S.current.rs_compare}${S.current.rs_date_tool_last_week}': element});
        } else {
          listTitles.add({'${S.current.rs_by} ${S.current.rs_compare} WoW': element});
        }
      } else if (element == CompareDateRangeType.lastMonth) {
        if (RSLocale().locale?.languageCode == 'zh') {
          listTitles.add({'${S.current.rs_by}${S.current.rs_compare}${S.current.rs_date_tool_last_month}': element});
        } else {
          listTitles.add({'${S.current.rs_by} ${S.current.rs_compare} MoM': element});
        }
      } else if (element == CompareDateRangeType.lastYear) {
        if (RSLocale().locale?.languageCode == 'zh') {
          listTitles.add({'${S.current.rs_by}${S.current.rs_compare}${S.current.rs_date_tool_last_year}': element});
        } else {
          listTitles.add({'${S.current.rs_by} ${S.current.rs_compare} YoY': element});
        }
      }
    });

    // 如果不为空，则在第一个位置添加文字
    if (listTitles.isNotEmpty) {
      if (RSLocale().locale?.languageCode == 'zh') {
        listTitles.insert(0, {'${S.current.rs_by}${S.current.rs_metric}': null});
      } else {
        listTitles.insert(0, {'${S.current.rs_by} ${S.current.rs_metric}': null});
      }
    }

    listWidgets = listTitles.map((element) {
      return InkWell(
        onTap: () {
          state.sortTypeIndex.value = listTitles.indexOf(element);
          // 排序
          setGridColumnSort(columnName, sortCompareType: element.values.first);
          Get.back();
        },
        child: Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(
              element.keys.first,
              style: TextStyle(
                color:
                    state.sortTypeIndex.value == listTitles.indexOf(element) ? RSColor.color_0xFF5C57E6 : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }),
      );
    }).toList();

    return listWidgets;
  }

  void setGridColumnSort(String columnName, {CompareDateRangeType? sortCompareType}) {
    // 排序类型
    _storeDataSource.currentCompareDateRangeType = sortCompareType;
    state.currentCompareDateRangeType = sortCompareType;

    if (!_storeDataSource.showComparison) {
      _storeDataSource.showComparison = true;
    }

    if (_storeDataSource.currentColumnName != columnName) {
      _storeDataSource.currentColumnName = columnName;
      _storeDataSource.isSortAscending = true;
    }

    var sortDirection = DataGridSortDirection.descending;
    if (_storeDataSource.isSortAscending) {
      _storeDataSource.isSortAscending = false;
      sortDirection = DataGridSortDirection.descending;
    } else {
      _storeDataSource.isSortAscending = true;
      sortDirection = DataGridSortDirection.ascending;
    }
    _storeDataSource.sortedColumns.clear();
    _storeDataSource.sortedColumns.add(SortColumnDetails(name: columnName, sortDirection: sortDirection));
    _storeDataSource.notifyListeners();
  }
}
