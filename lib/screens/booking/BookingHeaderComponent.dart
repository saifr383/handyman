import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/model/BookingDetailResponse.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingHeaderComponent extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final BookingDetailResponse? data;
  final BuildContext buildContext;

  String dayVal = '';
  String hourVal = '';
  String monthVal = '';

  BookingHeaderComponent({required this.buildContext, required this.expandedHeight, required this.data});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = 60;
    final top = expandedHeight - shrinkOffset - size / 1;

    if (data!.booking_detail!.date != null) {
      DateTime date = DateFormat('yyyy-MM-dd hh:mm:ss').parse('${data!.booking_detail!.date}');
      String hourValue = '${date.hour}';
      String minValue = '${date.minute}';

      if (date.hour < 10) {
        hourValue = '0$hourValue';
      }

      if (date.minute < 10) {
        minValue = '0$minValue';
      }

      hourVal = '$hourValue:$minValue';
      dayVal = '${date.day}';
      monthVal = '${date.month.toMonthName(isHalfName: true)}';
    }

    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.visible,
      children: [
        buildBackground(shrinkOffset),
        Positioned(top: top, left: 16, right: 16, child: buildFloating(context, shrinkOffset)),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildBackground(double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: cachedImage(data!.service!.attchments.validate().isNotEmpty ? data!.service!.attchments!.first.validate() : '', height: 310, fit: BoxFit.cover),
      );

  Widget buildFloating(BuildContext context, double shrinkOffset) => Opacity(
        opacity: disappear(shrinkOffset),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), offset: Offset(2.5, 5), backgroundColor: buildContext.cardColor),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data!.service!.name.validate(), style: boldTextStyle(size: 18)),
                  8.height,
                  Row(
                    children: [
                      Icon(LineIcons.user, size: 18),
                      8.width,
                      Text(data!.customer!.username.validate(), style: secondaryTextStyle()),
                    ],
                  ),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, size: 18),
                      8.width,
                      Text(
                        data!.customer!.address.validate(),
                        style: secondaryTextStyle(),
                        maxLines: 2,
                      ).expand(),
                    ],
                  ).visible(data!.customer!.address.validate().isNotEmpty),
                ],
              ).expand(),
              4.width,
              Container(
                padding: EdgeInsets.all(data!.booking_detail!.date != null ? 16 : 0),
                decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(hourVal.validate(), style: boldTextStyle()),
                    8.height,
                    Text(dayVal.validate(), style: boldTextStyle(size: 20, color:primaryColor)),
                    4.height,
                    Text(monthVal.validate(), style: boldTextStyle()),
                  ],
                ),
              ).visible(data!.booking_detail!.date != null),
            ],
          ),
        ),
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
