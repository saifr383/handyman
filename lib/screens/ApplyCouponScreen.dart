import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ApplyCouponScreen extends StatefulWidget {
  final List<CouponData>? couponList;

  ApplyCouponScreen({this.couponList});

  @override
  ApplyCouponScreenState createState() => ApplyCouponScreenState();
}

class ApplyCouponScreenState extends State<ApplyCouponScreen> {
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
    return Scaffold(
      appBar: appBarWidget(language!.applyCoupon, color: primaryColor, textColor: white),
      body: ListView.builder(
          itemCount: widget.couponList!.length,
          padding: EdgeInsets.all(8),
          itemBuilder: (_, i) {
            CouponData data = widget.couponList![i];
            return Container(
              width: context.width(),
              padding: EdgeInsets.all(8),
              decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(),backgroundColor: context.cardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  couponView(context,data.code.validate()),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language!.expDate + ' :', style: primaryTextStyle()),
                      8.width,
                      Text(data.expire_date.validate(), style: boldTextStyle()),
                    ],
                  ),
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language!.discount + ' :', style: primaryTextStyle()),
                      8.width,
                      Text(data.discount_type == Fixed ? '${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${data.discount.toString().validate()}' : '${data.discount.toString().validate()}%', style: boldTextStyle()),
                    ],
                  ),
                  8.height,
                ],
              ),
            ).onTap(() {
              finish(context, data);
            });
          }),
    );
  }
}
