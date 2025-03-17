import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_report_project/function/analytics/analytics_entity_list_page/analytics_comment_details/gallery_photo/score_star_view.dart';
import 'package:flutter_report_project/model/analytics_entity_list/evaluate_list_entity.dart';
import 'package:flutter_report_project/widget/expandable_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../config/rs_color.dart';
import '../../../../generated/assets.dart';
import 'analytics_comment_details_logic.dart';
import 'gallery_photo/gallery_photo_view.dart';

class AnalyticsCommentDetailsPage extends StatefulWidget {
  const AnalyticsCommentDetailsPage({super.key, required this.itemIndex, this.entity});

  final int itemIndex;
  final EvaluateListList? entity;

  @override
  State<AnalyticsCommentDetailsPage> createState() => _AnalyticsCommentDetailsPageState();
}

class _AnalyticsCommentDetailsPageState extends State<AnalyticsCommentDetailsPage> {
  final logic = Get.put(AnalyticsCommentDetailsLogic());
  final state = Get.find<AnalyticsCommentDetailsLogic>().state;

  @override
  void dispose() {
    Get.delete<AnalyticsCommentDetailsLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.all(16),
      color: RSColor.color_0xFFFFFFFF,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTopInfoWidget(),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: _createMessageBodyWidget(),
          ),
        ],
      ),
    );
  }

  Widget _createTopInfoWidget() {
    Widget profilePictureWidget;
    if (RegexUtil.isURL(widget.entity?.avatarPicture ?? "")) {
      profilePictureWidget = CachedNetworkImage(
        width: 36,
        height: 36,
        imageUrl: widget.entity?.avatarPicture ?? "",
        placeholder: (context, url) => Image.asset(
          Assets.imageMineDefaultAvatar,
        ),
        errorWidget: (context, url, error) => Image.asset(
          Assets.imageMineDefaultAvatar,
        ),
      );
    } else {
      profilePictureWidget = Image.asset(
        Assets.imageMineDefaultAvatar,
        fit: BoxFit.contain,
        width: 36,
        height: 36,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            clipBehavior: Clip.hardEdge,
            decoration: const ShapeDecoration(
              color: RSColor.color_0xFFF3F3F3,
              shape: OvalBorder(),
            ),
            child: profilePictureWidget),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.entity?.guestName ?? "***",
                style: TextStyle(
                  color: RSColor.color_0x60000000,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              ScoreStarView(score: widget.entity?.score ?? 0),
            ],
          ),
        ),
        const Spacer(),
        Text(
          widget.entity?.commentTime ?? "***",
          textAlign: TextAlign.right,
          style: TextStyle(
            color: RSColor.color_0x40000000,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  Widget _createMessageBodyWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.entity?.content != null)
          RSExpandCollapseText(
            text: widget.entity?.content ?? '',
          ),
        if (widget.entity?.pictures != null && widget.entity!.pictures!.isNotEmpty) _createImageWidget(),
        if (widget.entity?.reply != null && widget.entity!.reply!.isNotEmpty) _createReplyMessageBodyWidget(),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
            widget.entity?.shopName ?? '***',
            style: TextStyle(
              color: RSColor.color_0x40000000,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }

  Widget _createImageWidget() {
    var imageUrls = widget.entity?.pictures;
    if (imageUrls == null) {
      return Container();
    }

    double imageWidth = (1.sw - 16 * 2 - 8 * 2) / 3;
    if (imageUrls.length == 1) {
      imageWidth = 226;
    } else if (imageUrls.length == 2) {
      imageWidth = (1.sw - 16 * 2 - 8) / 3;
    } else if (imageUrls.length == 3) {
      imageWidth = (1.sw - 16 * 2 - 8 * 2) / 3;
    } else if (imageUrls.length == 4) {
      imageWidth = (1.sw - 16 * 2 - 8) / 3;
    }

    for (var element in imageUrls) {
      // 预加载图片资源
      precacheImage(CachedNetworkImageProvider(element), context);
    }

    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Wrap(
        key: ValueKey("${widget.itemIndex}Wrap"),
        spacing: 8,
        runSpacing: 8,
        children: List.generate(imageUrls.length, (index) {
          return GestureDetector(
              onTap: () => openGallery(imageUrls, index),
              child: Hero(
                tag: '${widget.itemIndex}$index${imageUrls[index]}',
                child: Container(
                  width: imageWidth,
                  height: imageWidth,
                  clipBehavior: Clip.hardEdge,
                  decoration: ShapeDecoration(
                    color: RSColor.color_0xFFF3F3F3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    // placeholder: (context, url) => Center(
                    //   child: GradientCircularProgressIndicator(
                    //     colors: [
                    //       RSColor.color_0xFF5C57E6,
                    //       RSColor.color_0xFF5C57E6.withOpacity(0.5),
                    //       Colors.white,
                    //     ],
                    //   ),
                    // ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: RSColor.color_0x40000000,
                    ),
                  ),
                ),
              ));
        }),
      ),
    );
  }

  void openGallery(List<String> imageList, int initialIndex) {
    Get.to(
        () => GalleryPhotoPage(
              galleryItems: imageList,
              itemIndex: widget.itemIndex,
              initialIndex: initialIndex,
            ),
        transition: Transition.noTransition);
  }

  Widget _createReplyMessageBodyWidget() {
    var replay = widget.entity?.reply;

    if (replay == null || replay.isEmpty) {
      return Container();
    } else {
      List<Widget> widgets = [];
      for (var element in replay) {
        widgets.add(Padding(
          padding: EdgeInsets.only(top: 8),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: RSColor.color_0xFFF3F3F3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            ),
            child: Row(
              children: [
                Flexible(
                  child: RSExpandCollapseText(
                    text: element,
                    textStyle: TextStyle(
                      color: RSColor.color_0x60000000,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    endOfTextStyle: TextStyle(
                      color: RSColor.color_0xFF5C57E6,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
      }

      return Column(
        children: widgets,
      );
    }
  }
}
