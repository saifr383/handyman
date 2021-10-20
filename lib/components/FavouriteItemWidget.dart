import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/wishListResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/ServiceDetailScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class FavouriteItemWidget extends StatefulWidget {
  final Wishlist? data;
  final Function? onChanged;

  FavouriteItemWidget({this.data, this.onChanged});

  @override
  _FavouriteItemWidgetState createState() => _FavouriteItemWidgetState();
}

class _FavouriteItemWidgetState extends State<FavouriteItemWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> removeWishListItem(int id) async {
    Map req = {
      "user_id": appStore.userId,
      'service_id': widget.data!.serviceId,
    };

    appStore.setLoading(true);

    removeWishList(req).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);
      snackBar(context, title: res.message!);

      widget.onChanged!.call();
    }).catchError((error) {
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 250,
      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              cachedImage(widget.data!.serviceAttchments!.isNotEmpty ? widget.data!.serviceAttchments!.first.validate() : '', fit: BoxFit.cover, height: 120, width: 250)
                  .cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
              Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.all(4),
                      decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: context.primaryColor.withOpacity(0.2)),
                      child: Icon(Icons.close, size: 18))
                  .onTap(() {
                removeWishListItem(widget.data!.id.validate().toInt());
              }),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data!.name.validate(), maxLines: 2, style: boldTextStyle()),
              8.height,
              createRichText(
                overflow: TextOverflow.ellipsis,
                list: [
                  if (widget.data!.priceFormat != null) TextSpan(text: widget.data!.priceFormat!.validate(), style: boldTextStyle(color: primaryColor)),
                  if (widget.data!.type != null) TextSpan(text: widget.data!.type!.validate() == Hourly ? ' /hr' : '', style: secondaryTextStyle()),
                ],
              ),
            ],
          ).paddingOnly(left: 8, right: 8, top: 8, bottom: 8),
        ],
      ),
    ).onTap(() {
      ServiceDetailScreen(serviceId: widget.data!.serviceId).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
    });
  }
}
