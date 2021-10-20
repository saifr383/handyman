import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/model/ServiceModel.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/ServiceDetailScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/Images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class ServiceListComponent extends StatefulWidget {
  final List<Service>? serviceList;

  ServiceListComponent({this.serviceList});

  @override
  ServiceListComponentState createState() => ServiceListComponentState();
}

class ServiceListComponentState extends State<ServiceListComponent> {
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
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.serviceList!.take(6).length,
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      shrinkWrap: true,
      padding: EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int i) {
        Service data = widget.serviceList![i];

        return Container(
          decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomLeft,
                children: [
                  cachedImage(
                    data.attchments!.isNotEmpty ? data.attchments!.first.validate() : '',
                    fit: BoxFit.cover,
                    height: 120,
                    width: context.width(),
                  ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
                  Container(
                    height: 120,
                    width: context.width(),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: black.withOpacity(0.1)),
                  ),
                  Positioned(
                    bottom: -10,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      constraints: BoxConstraints(maxWidth: context.width() * 0.4),
                      decoration: boxDecorationWithShadow(backgroundColor: primaryColor, borderRadius: radius(4)),
                      child: Text(
                        data.name.validate(),
                        style: boldTextStyle(color: white, size: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).paddingSymmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  Row(
                    children: [
                      Image.asset(provider, fit: BoxFit.cover, height: 20, width: 20, color: context.iconColor),
                      4.width,
                      if (data.provider_name != null) Text(data.provider_name.validate().toString(), overflow: TextOverflow.ellipsis, style: secondaryTextStyle()).expand(),
                    ],
                  ),
                  4.height,
                  Row(
                    children: [
                      createRichText(
                        overflow: TextOverflow.ellipsis,
                        list: [
                          if (data.price_format != null) TextSpan(text: data.price_format.validate().toString(), style: boldTextStyle(color: primaryColor, size: 14)),
                          TextSpan(text: data.type!.validate() == Hourly ? ' /hr' : '', style: secondaryTextStyle(size: 14)),
                        ],
                      ),
                      2.width,
                      if (data.discount != null) Text('( ' + data.discount!.toString().validate() + '% off )', style: boldTextStyle(size: 14, color: redColor)).visible(data.discount != null),
                    ],
                  ),
                  8.height,
                ],
              ).paddingAll(8),
            ],
          ),
        ).onTap(() {
          ServiceDetailScreen(serviceId: data.id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
        });
      },
    );
  }
}
