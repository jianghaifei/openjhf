import 'package:flutter/material.dart';
import 'base_card.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../ai_chat_theme.dart';

class AIChatImageCard extends AIChatBaseCard {
  const AIChatImageCard({super.key, required super.data});

  @override
  Widget buildBody(BuildContext context) {
    // 获取图片 URL
    final imageUrl = data['cardMetadata']['url'];

    return GestureDetector(
      onTap: () => _showImageFullScreen(context, imageUrl),
      child: Container(
          padding: EdgeInsets.only( top: AIChatTheme.cardVerticalPadding), child: Image.network(imageUrl)),
    );
  }

  // 显示图片的全屏视图
  void _showImageFullScreen(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context), // 返回上一级页面
            ),
          ),
          body: PhotoViewGallery.builder(
            itemCount: 1,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(),
          ),
        ),
      ),
    );
  }
}
