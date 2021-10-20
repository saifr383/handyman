import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class AddToCartScreen extends StatefulWidget {
  @override
  AddToCartScreenState createState() => AddToCartScreenState();
}

class AddToCartScreenState extends State<AddToCartScreen> {
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
      appBar: appBarWidget(language!.serviceName),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade100,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(0), backgroundColor: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(language!.typeOfService, style: boldTextStyle(color: Colors.black)),
                        4.height,
                        Text(' • '+language!.thingsInclude, style: secondaryTextStyle()),
                      ],
                    ),
                    Text('\$300', style: boldTextStyle())
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(16.0),
                width: context.width(),
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(0), backgroundColor: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language!.applyCoupon, style: secondaryTextStyle(color: Colors.black)),
                    Icon(AntDesign.arrowright).onTap(() {
                      if (!appStore.isLoggedIn) {
                        snackBar(context,title: language!.loginToApply);
                      }
                    }),
                  ],
                ),
              ),
              16.height,
              Container(
                padding: EdgeInsets.all(16.0),
                width: context.width(),
                decoration: boxDecorationWithRoundedCorners(borderRadius: radius(0), backgroundColor: Colors.white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language!.itemTotal, style: secondaryTextStyle()),
                        Text('\$15.00', style: secondaryTextStyle()),
                      ],
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language!.safetyFee, style: secondaryTextStyle()),
                        Text('\$2.00', style: secondaryTextStyle()),
                      ],
                    ),
                    4.height,
                    Divider(),
                    4.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language!.totalAmount, style: boldTextStyle()),
                        Text('\$17.00', style: boldTextStyle()),
                      ],
                    ),
                  ],
                ),
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
