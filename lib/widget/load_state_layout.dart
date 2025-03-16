import 'package:flutter/material.dart';

import '../config/rs_color.dart';
import '../generated/assets.dart';
import '../generated/l10n.dart';
import 'card_load_state_layout.dart';

///四种视图状态
enum LoadState {
  stateSuccess,
  stateError,
  stateLoading,
  stateEmpty,
}

/// 根据不同状态来展示不同的视图(参考：http://fc-home.cn/article/12.html)
class LoadStateLayout extends StatefulWidget {
  const LoadStateLayout({
    super.key,
    this.state = LoadState.stateLoading, //默认为加载状态
    required this.successWidget,
    required this.reloadCallback,
    this.ifTransparent = false,
    this.color = RSColor.color_0xFFF3F3F3,
    this.errorCode,
    this.errorMessage,
  });

  final LoadState state; //页面状态
  final Widget successWidget; //成功视图
  final VoidCallback reloadCallback;
  final bool ifTransparent;
  final Color color;
  final String? errorCode; //请求错误码
  final String? errorMessage; //请求错误信息

  @override
  State<LoadStateLayout> createState() => _LoadStateLayoutState();
}

class _LoadStateLayoutState extends State<LoadStateLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.ifTransparent ? Colors.transparent : widget.color,
      //宽高都充满屏幕剩余空间
      width: double.infinity,
      height: double.infinity,
      child: _buildWidget(),
    );
  }

  ///根据不同状态来显示不同的视图
  Widget? _buildWidget() {
    switch (widget.state) {
      case LoadState.stateSuccess:
        return widget.successWidget;
      case LoadState.stateError:
        return _notDataView();
      case LoadState.stateLoading:
        return _loadingView();
      case LoadState.stateEmpty:
        return _notDataView();
      default:
        return null;
    }
  }

  Widget _notDataView() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.errorCode ?? S.current.rs_no_data,
            style: const TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
            child: Text(
              widget.errorMessage ?? S.current.rs_no_data_tip,
              textAlign: TextAlign.center,
              maxLines: 10,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: RSColor.color_0x40000000,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: _createReloadButton(),
          ),
        ],
      ),
    );
  }

  /// 数据为空的视图
  Widget _loadingView() {
    return Center(
      child: GradientCircularProgressIndicator(
        colors: [
          RSColor.color_0xFF5C57E6,
          RSColor.color_0xFF5C57E6.withOpacity(0.5),
          Colors.white,
        ],
      ),
    );
    // return Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     color: Colors.white,
    //     child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           if (widget.state != LoadState.stateLoading)
    //             Padding(
    //                 padding: const EdgeInsets.only(top: 18.0),
    //                 child: Text("No data", style: TextStyle(fontSize: 26, color: const Color(0xFF666666)))),
    //           if (widget.state != LoadState.stateLoading)
    //             Padding(
    //               padding: EdgeInsets.only(top: 20.h),
    //               child: _createReloadButton(),
    //             ),
    //         ]));
  }

  Widget _createReloadButton() {
    return InkWell(
      onTap: () => widget.reloadCallback(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: RSColor.color_0xFF5C57E6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(56),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              Assets.imageRefresh,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                S.current.rs_reload,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: RSColor.color_0xFFFFFFFF,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
