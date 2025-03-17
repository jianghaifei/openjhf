import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/widget/rs_tab_controller_widget/rs_tab_indicator.dart';

import '../../config/rs_color.dart';
import '../../generated/assets.dart';

enum RSTabControllerWidgetType {
  normal,
  colorBackground,
}

class RSTabControllerWidgetPage extends StatefulWidget {
  const RSTabControllerWidgetPage({
    super.key,
    required this.tabs,
    required this.tabBarViews,
    this.initialIndex = 0,
    this.customSubview,
    this.customSubviewKey,
    this.isScrollable = true,
    this.type = RSTabControllerWidgetType.normal,
    this.isEnableEditingFunction = false,
    this.editingImageName,
    this.editCallBack,
    this.ifTransparent = false,
    this.color = RSColor.color_0xFFFFFFFF,
    this.tabBarController,
    this.tabListenerCallback,
  });

  final List<String> tabs;
  final int initialIndex;
  final Widget? customSubview;
  final Key? customSubviewKey;
  final List<Widget> tabBarViews;
  final bool isScrollable;
  final RSTabControllerWidgetType type;
  final bool isEnableEditingFunction;
  final String? editingImageName;
  final VoidCallback? editCallBack;
  final bool ifTransparent;
  final Color color;
  final TabController? tabBarController;

  // index切换回调
  final Function(int tabIndex)? tabListenerCallback;

  @override
  State<RSTabControllerWidgetPage> createState() => _RSTabControllerWidgetPageState();
}

class _RSTabControllerWidgetPageState extends State<RSTabControllerWidgetPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int? _currentIndex = 0;

  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tabController = widget.tabBarController ??
        TabController(length: widget.tabs.length, vsync: this, initialIndex: widget.initialIndex);

    // 监听动画，从而区分是否是手动滑动
    _tabController.animation?.addListener(() {
      final int tabIndex = _tabController.animation!.value.round();
      if (tabIndex != _currentIndex) {
        setState(() {
          _currentIndex = tabIndex; // 更新当前索引
        });
      }
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        // index切换回调
        widget.tabListenerCallback?.call(_tabController.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Flexible(child: _createTabControllerWidget());
  }

  Widget _createTabControllerWidget() {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: widget.ifTransparent ? Colors.transparent : widget.color,
                  height: 48,
                  child: TabBar(
                    padding: EdgeInsets.symmetric(horizontal: widget.type == RSTabControllerWidgetType.normal ? 0 : 8),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    controller: _tabController,
                    tabAlignment: widget.isScrollable ? TabAlignment.start : null,
                    isScrollable: widget.isScrollable,
                    physics: widget.isScrollable ? const ClampingScrollPhysics() : null,
                    // 自定义指示器
                    indicator: widget.type == RSTabControllerWidgetType.normal
                        ? FixedIndicator(color: RSColor.color_0xFF5C57E6, width: 16, isScrollable: widget.isScrollable)
                        : BubbleTabIndicator(
                            indicatorColor: RSColor.color_0xFF5C57E6.withOpacity(0.1),
                            indicatorRadius: 16,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            insets: EdgeInsets.zero),
                    // 自定义指示器大小
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor:
                        widget.type == RSTabControllerWidgetType.normal ? RSColor.color_0xFF5C57E6 : Colors.transparent,
                    labelColor: RSColor.color_0xFF5C57E6,
                    labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    unselectedLabelColor: RSColor.color_0x60000000,
                    unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    labelPadding: widget.type == RSTabControllerWidgetType.normal ? null : EdgeInsets.zero,
                    dividerHeight: widget.type == RSTabControllerWidgetType.normal ? 1 : 0,
                    dividerColor: RSColor.color_0xFFE7E7E7,
                    tabs: _createTabs(),
                    // onTap: (index) {
                    //   setState(() {
                    //   });
                    // },
                  ),
                ),
              ),
              _createRightWidgets(),
            ],
          ),
          if (widget.customSubview != null)
            Container(
              key: widget.customSubviewKey,
              padding: EdgeInsets.only(bottom: 8),
              color: widget.ifTransparent ? Colors.transparent : widget.color,
              child: widget.customSubview!,
            ),
          if (!widget.ifTransparent && widget.isEnableEditingFunction)
            const Divider(
              height: 0.5,
              thickness: 1,
              color: RSColor.color_0xFFF3F3F3,
              // color: Colors.red,
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabBarViews,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _createTabs() {
    if (widget.type == RSTabControllerWidgetType.normal) {
      return widget.tabs
          .map((e) => Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: AutoSizeText(
                e,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              )))
          .toList();
    } else {
      return widget.tabs
          .map((e) => Container(
              padding: widget.type == RSTabControllerWidgetType.normal
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                e,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.tabs[_currentIndex ?? 0] == e ? FontWeight.w600 : FontWeight.w400,
                ),
              )))
          .toList();
    }
  }

  Widget _createRightWidgets() {
    List<Widget> list = [];

    if (widget.isEnableEditingFunction) {
      list.add(Container(
        height: 16,
        width: 1,
        color: RSColor.color_0xFFE7E7E7,
      ));

      list.add(_createRightButton(widget.editingImageName ?? Assets.imageTopicSetting));
    }

    return Container(
      height: 48,
      color: widget.ifTransparent ? Colors.transparent : widget.color,
      child: Row(
        children: list,
      ),
    );
  }

  Widget _createRightButton(String imageName) {
    return InkWell(
      onTap: () {
        widget.editCallBack?.call();
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        width: 35,
        height: 32,
        child: Image.asset(
          imageName,
          width: 18,
          height: 18,
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
