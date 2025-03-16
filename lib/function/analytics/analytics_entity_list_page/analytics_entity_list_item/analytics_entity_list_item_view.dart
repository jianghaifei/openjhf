import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/config/rs_color.dart';
import 'package:flutter_report_project/function/analytics/analytics_entity_list_page/analytics_entity_list_item/analytics_entity_list_item_state.dart';
import 'package:flutter_report_project/generated/assets.dart';
import 'package:flutter_report_project/model/business_topic/business_topic_type_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../model/analytics_entity_list/analytics_entity_list_entity.dart';
import 'analytics_entity_list_item_logic.dart';

class AnalyticsEntityListItemPage extends StatefulWidget {
  const AnalyticsEntityListItemPage({super.key, required this.entity, required this.clickCallBack});

  final AnalyticsEntityListList entity;
  final VoidCallback clickCallBack;

  @override
  State<AnalyticsEntityListItemPage> createState() => _AnalyticsEntityListItemPageState();
}

class _AnalyticsEntityListItemPageState extends State<AnalyticsEntityListItemPage> {
  final String tag = '${DateTime.now().millisecondsSinceEpoch}';

  AnalyticsEntityListItemLogic get logic => Get.find<AnalyticsEntityListItemLogic>(tag: tag);
  AnalyticsEntityListItemState get state => Get.find<AnalyticsEntityListItemLogic>(tag: tag).state;

  @override
  void dispose() {
    Get.delete<AnalyticsEntityListItemLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AnalyticsEntityListItemLogic(), tag: tag);

    logic.buildOrderTags(widget.entity);

    return InkWell(
      onTap: () {
        widget.clickCallBack.call();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: RSColor.color_0xFFFFFFFF,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            if (state.orderCornerMarkTypes.isNotEmpty) _createCornerMarkRowWidget(),
            Padding(
              padding: EdgeInsets.only(top: state.orderCornerMarkTypes.isNotEmpty ? 10 : 0),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _createHeadWidget(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _createListItemsWidget(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createHeadWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.entity.primaryField?.displayName ?? "-",
          style: TextStyle(
            color: RSColor.color_0x60000000,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: AutoSizeText(
            widget.entity.primaryField?.displayValue ?? "*",
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: RSColor.color_0x90000000,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (state.orderPayTypes.isNotEmpty) _createPayTypeWidget(),
        if (state.orderOtherTypes.isNotEmpty) _createOtherTypeWidget(),
        Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: const Divider(
            color: RSColor.color_0xFFE7E7E7,
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }

  List<Widget> _createListItemsWidget() {
    List<Widget> listWidget = [];

    int dimsLength = 1;
    widget.entity.dims?.forEach((element) {
      double bottomHeight = dimsLength == widget.entity.dims?.length ? 0 : 4;
      if (element.showing) {
        listWidget.add(Container(
          padding: EdgeInsets.only(bottom: bottomHeight),
          width: 1.sw - 16 * 2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                element.displayName ?? "*",
                style: TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Expanded(
                child: Text(
                  element.displayValue ?? '*',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: RSColor.color_0x60000000,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ));
      }
      dimsLength++;
    });

    return listWidget;
  }

  /// 角标视图
  Widget _createCornerMarkRowWidget() {
    return SizedBox(
        width: 1.sw,
        height: 20,
        child: Directionality(
          textDirection: TextDirection.rtl, // 设置文本方向为从右到左
          child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                if (index < state.orderCornerMarkTypes.length) {
                  return _createTextWidget(state.orderCornerMarkTypes[index].displayName ?? '',
                      titleColor: RSColor.color_0xFFD54941,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(3), bottomRight: Radius.circular(3)));
                } else {
                  return Container();
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  width: 4,
                );
              },
              itemCount: state.orderCornerMarkTypes.length),
        ));
  }

  /// 支付方式
  Widget _createPayTypeWidget() {
    List<Widget> list = [];

    for (var element in state.orderPayTypes) {
      String imageName = Assets.imageEntityCardCash;

      switch (element.tagEnum) {
        case OrderEntityTagType.Cash_Payment:
          imageName = Assets.imageEntityCardCash;
          break;
        case OrderEntityTagType.Bank_Card_Payment:
          imageName = Assets.imageEntityCardBank;
          break;
        case OrderEntityTagType.Online_Payment:
          imageName = Assets.imageEntityCardOnlinePayment;
          break;
        case OrderEntityTagType.Gift_Card:
          imageName = Assets.imageEntityCardGiftCard;
          break;
        default:
          imageName = Assets.imageEntityCardCash;
          break;
      }

      list.add(_createTextWidget(
        element.displayName ?? '',
        textStyle: TextStyle(
          color: RSColor.color_0x90000000,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        imageName: imageName,
      ));
    }

    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 20,
        runSpacing: 10,
        children: list,
      ),
    );
  }

  /// 其它tag
  Widget _createOtherTypeWidget() {
    List<Widget> list = [];

    for (var element in state.orderOtherTypes) {
      Color titleColor;

      switch (element.tagEnum) {
        case OrderEntityTagType.Order_Discount:
          titleColor = const Color(0xFF0052D9);
          break;
        case OrderEntityTagType.Order_Promotion:
          titleColor = const Color(0xFF2BA471);
          break;
        case OrderEntityTagType.Order_Member:
          titleColor = const Color(0xFFFA8C16);
          break;
        default:
          titleColor = const Color(0xFF0052D9);
          break;
      }

      list.add(
        _createTextWidget(
          element.displayName ?? '',
          titleColor: titleColor,
          borderRadius: BorderRadius.all(Radius.circular(3)),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: list,
      ),
    );
  }

  /// icon+text+textColor+background+borderRadius
  Widget _createTextWidget(String title,
      {String? imageName, Color? titleColor, BorderRadius? borderRadius, TextStyle? textStyle}) {
    return Container(
      padding: titleColor != null ? EdgeInsets.symmetric(vertical: 4, horizontal: 8) : EdgeInsets.zero,
      decoration: ShapeDecoration(
        color: titleColor?.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.zero,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageName != null)
            Image.asset(
              imageName,
              width: 12,
              height: 12,
              fit: BoxFit.contain,
            ),
          Padding(
            padding: EdgeInsets.only(left: imageName != null ? 4 : 0),
            child: Text(
              title,
              style: textStyle ??
                  TextStyle(
                    color: titleColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
