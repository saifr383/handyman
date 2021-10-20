import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ZoomImageScreen extends StatefulWidget {
  final mProductImage;
  final List<String>? galleryImages;

  ZoomImageScreen({this.mProductImage, this.galleryImages});

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(widget.galleryImages![index]),
                initialScale: PhotoViewComputedScale.contained,
                heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryImages![index]),
              );
            },
            itemCount: widget.galleryImages!.length,
            loadingBuilder: (context, event) => Center(
              child: Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 4,
                margin: EdgeInsets.all(4),
                shape: RoundedRectangleBorder(borderRadius: radius(50)),
                child: Container(
                  width: 45,
                  height: 45,
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(strokeWidth: 3, color: primaryColor, value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!),
                ),
              ).center(),
            ),
          ),
          Positioned(
            top: 40,
            child: BackButton(color: context.iconColor),
          )
        ],
      ),
    );
  }
}
