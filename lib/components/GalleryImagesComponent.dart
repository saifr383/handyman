import 'package:booking_system_flutter/screens/ZoomImageScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nb_utils/nb_utils.dart';
import 'AppWidgets.dart';

class GalleryImagesComponent extends StatefulWidget {
  final List<String> galleryImages;

  GalleryImagesComponent(this.galleryImages);

  @override
  GalleryImagesComponentState createState() => GalleryImagesComponentState();
}

class GalleryImagesComponentState extends State<GalleryImagesComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredGridView.countBuilder(
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          padding: EdgeInsets.all(0),
          itemCount: widget.galleryImages.length,
          itemBuilder: (context, index) {
            return cachedImage(widget.galleryImages[index].validate(), fit: BoxFit.cover).cornerRadiusWithClipRRect(8.0).onTap((){
              ZoomImageScreen(galleryImages:widget.galleryImages ).launch(context);
            });
          },
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          mainAxisSpacing:12,
          crossAxisSpacing:12,
        ),
      ],
    );
  }
}
