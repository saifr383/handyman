import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/model/ServiceModel.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/ServiceDetailScreen.dart';
import 'package:booking_system_flutter/screens/SignInScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ServiceComponent extends StatefulWidget {
  final Service? serviceData;
  final Function? onChanged;

  ServiceComponent({this.serviceData,this.onChanged});

  @override
  ServiceComponentState createState() => ServiceComponentState();
}

class ServiceComponentState extends State<ServiceComponent> {
  bool mIsInWishList = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (widget.serviceData!.isFavourite == 0) {
      mIsInWishList = false;
    } else {
      mIsInWishList = true;
    }
  }

  void checkWishList() {
    setState(() {
      if (mIsInWishList == false) {
        addToWishList();
      } else {
        removeToWishList();
      }
    });
  }

  void addToWishList() async {
    Map req = {"id": "", "service_id": widget.serviceData!.id, "user_id": appStore.userId};
    await addWishList(req).then((res) {
      if (!mounted) return;
      setState(() {
        mIsInWishList = true;
      });
      snackBar(context, title: res.message!);
    });
  }

  void removeToWishList() async {
    Map req = {
      "user_id": appStore.userId,
      'service_id': widget.serviceData!.id,
    };

    await removeWishList(req).then((res) {
      if (!mounted) return;
      mIsInWishList = false;
      snackBar(context, title: res.message!);
      setState(() {});
    }).catchError((error) {
      toast(error.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: context.width(),
      decoration: boxDecorationRoundedWithShadow(12, backgroundColor: context.cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            overflow: Overflow.visible,
            children: [
              widget.serviceData!.attchments!.isNotEmpty
                  ? cachedImage(widget.serviceData!.attchments!.first != '' ? widget.serviceData!.attchments!.first.validate() : '', height: 200, width: context.width(), fit: BoxFit.cover)
                      .cornerRadiusWithClipRRect(12)
                  : cachedImage(placeholder, height: 200, width: context.width(), fit: BoxFit.cover).cornerRadiusWithClipRRect(12),
              Positioned(
                bottom: -10,
                left: 8,
                right: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: boxDecorationWithShadow(backgroundColor: primaryColor, borderRadius: radius(4)),
                      child: Text(widget.serviceData!.name.validate(), style: boldTextStyle(color: white, size: 14), maxLines: 1).paddingSymmetric(horizontal: 8, vertical: 4),
                    ).flexible(),
                    8.width,
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(right: 8),
                      decoration: boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: context.cardColor),
                      child: mIsInWishList ? Icon(Icons.favorite, color: Colors.red, size: 20) : Icon(Icons.favorite_border, size: 20),
                    ).onTap(() {
                      if (appStore.isLoggedIn)
                        checkWishList();
                      else
                        SignInScreen().launch(context);
                    }),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 0,
                child: widget.serviceData!.price != null
                    ? Container(
                        decoration: boxDecorationWithRoundedCorners(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), topLeft: Radius.circular(12)), backgroundColor: context.cardColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.serviceData!.price_format!.toString().validate(), style: boldTextStyle(color: primaryColor, size: 16)).paddingOnly(top: 6, bottom: 6, right: 10, left: 10),
                            widget.serviceData!.discount != null
                                ? Text(widget.serviceData!.discount!.toString().validate() + '% off', style: boldTextStyle(size: 14)).paddingOnly(left: 10, right: 10, bottom: 4)
                                : SizedBox(),
                          ],
                        ),
                      )
                    : SizedBox(),
              )
            ],
          ),
          16.height.visible(widget.serviceData!.description.validate().isNotEmpty),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.serviceData!.description.validate().capitalizeFirstLetter(), style: secondaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis)
                  .paddingOnly(left: 8, right: 8, bottom: 8)
                  .expand(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: boxDecorationDefault(color: getRateColor(widget.serviceData!.total_rating!)),
                child: Row(
                  children: [
                    Icon(Icons.star_border, size: 14, color: white),
                    4.width,
                    Text(widget.serviceData!.total_rating!.toString(), style: primaryTextStyle(color: white)),
                  ],
                ),
              ).paddingOnly(right: 8).visible(widget.serviceData!.total_rating! != 0),
            ],
          ),
          Divider().visible(widget.serviceData!.description.validate().isNotEmpty),
          Row(
            children: [
              cachedImage(widget.serviceData!.providerImage, height: 50, width: 50, fit: BoxFit.cover).cornerRadiusWithClipRRect(25),
              4.width,
              Text(widget.serviceData!.provider_name.validate(), style: primaryTextStyle()),
            ],
          ).paddingOnly(left: 8, bottom: 8)
        ],
      ),
    ).onTap(() async {
      bool? res = await ServiceDetailScreen(serviceId: widget.serviceData!.id.validate()).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
      if(res ?? false) {
        widget.onChanged!.call();
      }
    });
  }
}
