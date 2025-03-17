import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryPhotoPage extends StatefulWidget {
  const GalleryPhotoPage({
    super.key,
    required this.galleryItems,
    required this.itemIndex,
    this.initialIndex = 0,
  });

  final List<String> galleryItems;
  final int itemIndex;
  final int initialIndex;

  @override
  State<GalleryPhotoPage> createState() => _GalleryPhotoPageState();
}

class _GalleryPhotoPageState extends State<GalleryPhotoPage> {
  // late int currentIndex;

  @override
  void dispose() {
    super.dispose();
    debugPrint("GalleryPhotoPage dispose()");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                imageProvider: CachedNetworkImageProvider(widget.galleryItems[index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: '${widget.itemIndex}$index${widget.galleryItems[index]}'),
                onTapUp: (context, details, controllerValue) {
                  Get.back();
                },
              );
            },
            itemCount: widget.galleryItems.length,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            pageController: PageController(initialPage: widget.initialIndex),
          ),
          Positioned(
              top: AppBar().preferredSize.height,
              right: 16,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              )),
        ],
      ),
    );
  }
}
