import 'package:flutter/material.dart';
import '../ai_chat_theme.dart';
import '../utils/help.dart';

enum SortOrder { none, ascending, descending }

class AIChatTableCard extends StatefulWidget {
  const AIChatTableCard({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  _AIChatTableCardState createState() => _AIChatTableCardState();
}

class _AIChatTableCardState extends State<AIChatTableCard> {
  int? _sortedColumnIndex;
  SortOrder _sortOrder = SortOrder.none;
  late List<Map<String, dynamic>> columns;
  late List<List<dynamic>> rows;
  late List<List<dynamic>> originalRows;
  String initErrorMessage = '';

  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    try {
      initErrorMessage = '';
      columns = (widget.data['cardMetadata']?['columns'] as List<dynamic>?)
              ?.map((column) => column as Map<String, dynamic>)
              .toList() ??
          [];

      rows = (widget.data['cardMetadata']?['rows'] as List<dynamic>?)
              ?.map(
                  (row) => (row as List<dynamic>).map((cell) => cell).toList())
              .toList() ??
          [];

      originalRows = List.from(rows);
    } catch (e) {
      initErrorMessage = e.toString();
      rows = [];
      columns = [];
      originalRows = [];
    }
  }

  String getColumnTitle(Map<String, dynamic> column) {
    return column['title'] ?? '';
  }

  Map<String, dynamic> getColumnStyle(Map<String, dynamic> column) {
    Map<String, dynamic> columnStyle = column['columnStyle'] ?? {};
    double fontSize = toDouble(columnStyle['fontSize'], defaultValue: 12.0);
    Color color = columnStyle['color'] != null
        ? Color(int.parse(columnStyle['color'], radix: 16))
        : Color(0xFF1A1A1A);
    FontWeight fontWeight =
        getFontWeightFromString(columnStyle['fontWeight'] ?? 'normal');
    FontStyle fontStyle =
        getFontStyleFromString(columnStyle['fontStyle'] ?? 'normal');
    AlignmentGeometry align =
        getTextAlignFromString(columnStyle['align'] ?? 'left');
    bool sortable = columnStyle['sortable'] ?? false;
    return {
      'fontSize': fontSize,
      'color': color,
      'fontWeight': fontWeight,
      'fontStyle': fontStyle,
      'align': align,
      'sortable': sortable
    };
  }

  Map<String, dynamic> getRowStyle(Map<String, dynamic> column) {
    Map<String, dynamic> columnStyle = column['rowStyle'] ?? {};
    double fontSize = toDouble(columnStyle['fontSize'], defaultValue: 12.0);
    Color color = columnStyle['color'] != null
        ? Color(int.parse(columnStyle['color'], radix: 16))
        : const Color(0xFF646464);
    FontWeight fontWeight =
        getFontWeightFromString(columnStyle['fontWeight'] ?? 'normal');
    FontStyle fontStyle =
        getFontStyleFromString(columnStyle['fontStyle'] ?? 'normal');
    AlignmentGeometry align =
        getTextAlignFromString(columnStyle['align'] ?? 'left');
    return {
      'fontSize': fontSize,
      'color': color,
      'fontWeight': fontWeight,
      'fontStyle': fontStyle,
      'align': align,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (initErrorMessage.isNotEmpty) {
      return _buildErrorMessage();
    }
    return columns.isEmpty || rows.isEmpty
        ? _buildEmptyState()
        : _buildTableContent(context);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        'No data',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Text(
        "表格数据解析出错: $initErrorMessage",
        softWrap: true,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _buildTableContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 10),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: screenWidth,
        ),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTableHeader(),
                _buildTableBody(),
              ],
            )),
      ),
    );
  }

  Widget _buildTableHeader() {
    double hPadding = columns.length > 5 ? 2 : 12;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: hPadding, right: hPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(columns.length, (index) {
          double width = getColumnWidth(hPadding);
          return _buildHeaderCell(
              index, index == 0, index == columns.length - 1, width);
        }),
      ),
    );
  }

  Widget _buildHeaderCell(int index, isFirst, isLast, double width) {
    Map<String, dynamic> column = columns[index];
    Map<String, dynamic> styles = getColumnStyle(column);
    return Container(
      width: width,
      child: InkWell(
        onTap: () => _sortColumn(index),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10, left: 2.0, right: 2.0),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: styles['align'] as AlignmentGeometry,
                  child: Text(
                    getColumnTitle(columns[index]),
                    style: TextStyle(
                      color: styles['color'] as Color,
                      fontSize: styles['fontSize'] as double,
                      fontWeight: styles['fontWeight'] as FontWeight,
                      fontStyle: styles['fontStyle'] as FontStyle,
                    ),
                  ),
                ),
              ),
              if (styles['sortable'] == true) _buildSortIcon(index, styles),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortIcon(int columnIndex, Map<String, dynamic> styles) {
    if (styles['sortable'] == true) {
      Widget ascendingImg = Image.asset(
        'assets/image/sort_up_icon.png',
        width: 18,
        height: 18,
      );

      Widget descendingImg = Image.asset(
        'assets/image/sort_down_icon.png',
        width: 18,
        height: 18,
      );

      Widget defaultImg = Image.asset(
        'assets/image/sort_default_icon.png',
        width: 18,
        height: 18,
      );

      switch (_sortOrder) {
        case SortOrder.ascending:
          return _sortedColumnIndex == columnIndex ? ascendingImg : defaultImg;
        case SortOrder.descending:
          return _sortedColumnIndex == columnIndex ? descendingImg : defaultImg;
        default:
          return defaultImg;
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildTableBody() {
    return Column(
      children: List.generate(rows.length, (index) {
        return _buildTableRow(rows[index], index.isOdd);
      }),
    );
  }

  Widget _buildTableRow(List<dynamic> row, bool isOddRow) {
    double hPadding = columns.length > 5 ? 2 : 12;
    double width = getColumnWidth(hPadding);
    return Container(
      color: isOddRow ? Colors.white : const Color(0xFFFAFAFA),
      padding: EdgeInsets.only(left: hPadding, right: hPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: row.asMap().entries.map((entry) {
          int columnIndex = entry.key;
          var cell = entry.value;
          Map<String, dynamic> column = columns[columnIndex];
          Map<String, dynamic> styles = getRowStyle(column);
          Color color = styles['color'] as Color;
          double fontSize = styles['fontSize'] as double;
          FontWeight fontWeight = styles['fontWeight'] as FontWeight;
          FontStyle fontStyle = styles['fontStyle'] as FontStyle;
          String cellValue = '';
          if (cell is Map<String, dynamic>) {
            cellValue = cell['value'] ?? '';
            if (cell['color'] != null) {
              color = Color(int.parse(cell['color'], radix: 16));
            }
          } else if (cell is String) {
            cellValue = cell;
          }

          return Container(
            width: width,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10.0, bottom: 10, left: 2.0, right: 2.0),
              child: Align(
                alignment: styles['align'] as AlignmentGeometry,
                child: Text(
                  cellValue,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    fontStyle: fontStyle,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  double getColumnWidth(double hPadding) {
    return (screenWidth - hPadding * 2 - AIChatTheme.horizontalMargin * 2) /
        columns.length;
  }

  String getCellValue(dynamic cell) {
    String cellValue = '';
    if (cell is Map<String, dynamic>) {
      cellValue = cell['value'] ?? '';
    } else if (cell is String) {
      cellValue = cell;
    }
    return cellValue;
  }

  void _sortColumn(int columnIndex) {
    setState(() {
      if (_sortedColumnIndex == columnIndex) {
        _sortOrder =
            SortOrder.values[(_sortOrder.index + 1) % SortOrder.values.length];
      } else {
        _sortedColumnIndex = columnIndex;
        _sortOrder = SortOrder.ascending;
      }

      if (_sortOrder == SortOrder.none) {
        rows
          ..clear()
          ..addAll(originalRows);
      } else {
        rows.sort((a, b) {
          final aValue = getCellValue(a[columnIndex]);
          final bValue = getCellValue(b[columnIndex]);

          return _sortOrder == SortOrder.ascending
              ? _compareValues(aValue, bValue)
              : _compareValues(bValue, aValue);
        });
      }
    });
  }

  int _compareValues(String aStr, String bStr) {
    // 1. 检查是否是数字
    final numRegex = RegExp(r'^[-+]?\d+(\.\d+)?$');
    if (numRegex.hasMatch(aStr) && numRegex.hasMatch(bStr)) {
      return double.parse(aStr).compareTo(double.parse(bStr));
    }

    // 2. 检查是否是百分比
    final percentRegex = RegExp(r'^[-+]?\d+(\.\d+)?%$');
    if (percentRegex.hasMatch(aStr) && percentRegex.hasMatch(bStr)) {
      double aPercent = double.parse(aStr.replaceAll('%', ''));
      double bPercent = double.parse(bStr.replaceAll('%', ''));
      return aPercent.compareTo(bPercent);
    }

    // 3. 检查是否是正负值标记
    final signRegex = RegExp(r'^[-+]\d+(\.\d+)?$');
    if (signRegex.hasMatch(aStr) && signRegex.hasMatch(bStr)) {
      return double.parse(aStr).compareTo(double.parse(bStr));
    }

    // 4. 默认使用字符串比较
    return aStr.compareTo(bStr);
  }
}
