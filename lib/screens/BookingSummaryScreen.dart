import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/ApplyCouponScreen.dart';
import 'package:booking_system_flutter/screens/NoInternetScreen.dart';
import 'package:booking_system_flutter/screens/SignInScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/Images.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'DashboardScreen.dart';

class BookingSummaryScreen extends StatefulWidget {
  final ServiceDetailResponse? data;
  final String? description;
  final String? dateTimeVal;
  final int? bookingAddressId;

  BookingSummaryScreen({this.data, this.description, this.dateTimeVal, this.bookingAddressId});

  @override
  BookingSummaryScreenState createState() => BookingSummaryScreenState();
}

class BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool checkNetworkAvailability = false;

  CouponData couponData = CouponData();
  String data = "";
  String bookingDate = '';
  String bookingTime = '';

  int itemCount = 1;
  int hourCount = 1;

  num discount = 0;
  num originalRate = 0;
  num totalAmount = 0;
  num discountPrice = 0;

  num couponDiscount = 0;
  num couponDiscountAmount = 0;

  String couponCode = '';

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    checkAvailability();
    dateSet();
    totalPayment();
    originalRate = widget.data!.service_detail!.price!.validate();
    discount = widget.data!.service_detail!.discount.validate();
    setState(() {});
  }

  Future<void> checkAvailability() async {
    if (await isNetworkAvailable()) {
      setState(() {
        checkNetworkAvailability = true;
      });
    } else {
      setState(() {
        checkNetworkAvailability = false;
      });
    }
  }

  void dateSet() {
    DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm").parse(widget.dateTimeVal.toString());
    var dateFormat = DateFormat('EE, MMMM, dd, yyyy');
    var timeFormat = DateFormat('hh:mm a');

    bookingDate = dateFormat.format(DateTime.parse(parseDate.toString()));
    bookingTime = timeFormat.format(DateTime.parse(parseDate.toString()));
  }

  void couponDiscountCount({CouponData? res}) async {
    data = res!.discount_type!;
    couponDiscount = res.discount.validate();
    couponCode = res.code.validate();
    couponDiscountAmount = ((totalAmount * couponDiscount) / 100);
    if (res.discount_type == Fixed) {
      totalAmount = totalAmount - res.discount.validate();
      couponDiscountAmount = res.discount.validate();
    } else {
      totalAmount = totalAmount - ((totalAmount * couponDiscount) / 100);
      couponDiscountAmount = (couponDiscountAmount);
    }
    setState(() {});
  }

  void totalPayment() async {
    if (widget.data!.service_detail!.discount != null) {
      totalAmount = (widget.data!.service_detail!.price! * itemCount) - (((widget.data!.service_detail!.price! * itemCount) * (widget.data!.service_detail!.discount.validate())) / 100);
      discountPrice = widget.data!.service_detail!.price! * itemCount - totalAmount;
      totalAmount = totalAmount - couponDiscountAmount;
    } else {
      totalAmount = (widget.data!.service_detail!.price! * itemCount);
      totalAmount = totalAmount - couponDiscountAmount;
    }
    setState(() {});
  }

  Future<void> bookServices() async {
    Map request = {
      CommonKeys.id: "",
      CommonKeys.serviceId: widget.data!.service_detail!.id.toString(),
      CommonKeys.providerId: widget.data!.provider!.id.validate(),
      CommonKeys.customerId: appStore.userId.toString(),
      BookingServiceKeys.description: widget.description.validate(),
      CommonKeys.address: getStringAsync(ADDRESS),
      CommonKeys.date: widget.dateTimeVal.validate(),
      BookingServiceKeys.couponId: couponCode.validate(),
      BookingServiceKeys.totalAmount: totalAmount.validate(),
      BookService.amount: widget.data!.service_detail!.price.toString(),
      BookService.totalAmount: totalAmount,
      BookService.quantity: '${itemCount.validate()}',
      BookService.bookingAddressId: widget.bookingAddressId != -1 ? widget.bookingAddressId : null,
      CouponKeys.discount: widget.data!.service_detail!.discount != null ? widget.data!.service_detail!.discount.toString() : "",
    };
    log("$request");
    appStore.setLoading(true);
    bookTheServices(request).then((value) {
      appStore.setLoading(false);

      snackBar(context, title: value['message'].toString());

      DashboardScreen().launch(context, isNewTask: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return checkNetworkAvailability
        ? Scaffold(
            appBar: appBarWidget(language!.bookingSummary, color: context.primaryColor, textColor: white),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  Container(
                    margin: EdgeInsets.all(8),
                    width: context.width(),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.data!.service_detail != null)
                              if (widget.data!.service_detail!.attchments.validate().isNotEmpty)
                                cachedImage(widget.data!.service_detail!.attchments.validate().isNotEmpty ? widget.data!.service_detail!.attchments!.first.validate() : placeholder,
                                        height: 110, width: 100, fit: BoxFit.cover)
                                    .cornerRadiusWithClipRRectOnly(topLeft: defaultRadius.toInt(), bottomLeft: defaultRadius.toInt()),
                            8.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                4.height,
                                Text(widget.data!.service_detail!.name.validate(), style: boldTextStyle()),
                                8.height,
                                Text(widget.data!.service_detail!.description.validate(), style: secondaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
                                8.height.visible(widget.data!.service_detail!.type.validate() != Fixed),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        PriceWidget(price: widget.data!.service_detail!.price.validate() * itemCount),
                                        if (widget.data!.service_detail!.type != Fixed) Text(' / ' + "hr", style: primaryTextStyle(size: 14)),
                                      ],
                                    ).expand(),
                                    Container(
                                      height: 40,
                                      margin: EdgeInsets.only(right: 8),
                                      padding: EdgeInsets.all(8),
                                      decoration: boxDecorationWithRoundedCorners(backgroundColor: context.dividerColor),
                                      child: Row(
                                        children: [
                                          Icon(Icons.remove, size: 16).onTap(() {
                                            if (itemCount != 1) setState(() => itemCount--);
                                            totalPayment();
                                          }),
                                          VerticalDivider(),
                                          4.width,
                                          Text(itemCount.toString(), style: primaryTextStyle()),
                                          4.width,
                                          VerticalDivider(),
                                          Icon(Icons.add, size: 16).onTap(() {
                                            setState(() => itemCount++);
                                            totalPayment();
                                          }),
                                        ],
                                      ),
                                    ).paddingAll(8).visible(widget.data!.service_detail!.type.validate() == Fixed)
                                  ],
                                )
                              ],
                            ).expand(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    width: context.width(),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Text(language!.bookingAt, style: boldTextStyle()),
                        16.height,
                        Row(
                          children: [
                            Icon(Icons.date_range, color: context.iconColor),
                            8.width,
                            Text('${bookingDate.validate()}', style: secondaryTextStyle()).expand(),
                            Text('${bookingTime.validate()}', style: secondaryTextStyle()),
                          ],
                        ),
                        8.height,
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    width: context.width(),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Text(language!.lblAddress, style: boldTextStyle()),
                        16.height,
                        Row(
                          children: [
                            Icon(Icons.location_pin),
                            8.width,
                            Text(getStringAsync(ADDRESS), style: secondaryTextStyle()).expand(),
                          ],
                        ),
                        8.height,
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    width: context.width(),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Text(language!.priceDetail, style: boldTextStyle()),
                        16.height,
                        Row(
                          children: [
                            Text(language!.rate, style: primaryTextStyle()).expand(),
                            PriceWidget(price: originalRate * itemCount),
                          ],
                        ),
                        4.height,
                        Divider(thickness: 0.5).visible(widget.data!.service_detail!.type.validate() == Fixed),
                        4.height.visible(widget.data!.service_detail!.type.validate() != Fixed),
                        Row(
                          children: [
                            Text(language!.quantity, style: primaryTextStyle()).expand(),
                            Text('x$itemCount', style: boldTextStyle()),
                          ],
                        ).visible(widget.data!.service_detail!.type.validate() == Fixed),
                        4.height.visible(discountPrice != 0),
                        Divider(thickness: 0.5),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(language!.discountOnMRP, style: primaryTextStyle()),
                                4.width,
                                Text('(%${widget.data!.service_detail!.discount} OFF)', style: secondaryTextStyle(color: Colors.red)),
                              ],
                            ).expand(),
                            Text('${'- ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${discountPrice.toStringAsFixed(2)}'}', style: boldTextStyle(color: Colors.green)),
                          ],
                        ).visible(discountPrice != 0),
                        4.height,
                        Divider(thickness: 0.5).visible(discountPrice != 0),
                        4.height,
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(language!.couponDiscount, style: primaryTextStyle()),
                                4.width,
                                Text(data == Fixed ? '(${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}$couponDiscount OFF)' : '(%$couponDiscount OFF)', style: secondaryTextStyle(color: Colors.red)),
                              ],
                            ).expand(),
                            Text(
                              couponDiscountAmount != 0 ? '- ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${couponDiscountAmount.toStringAsFixed(2)}' : language!.applyCoupon,
                              style: boldTextStyle(color: couponDiscountAmount != 0 ? Colors.green : Colors.redAccent),
                            ).onTap(() async {
                              CouponData res = await ApplyCouponScreen(couponList: widget.data!.coupon_data!).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                              couponDiscountCount(res: res);
                              setState(() {});
                            }),
                          ],
                        ).visible(widget.data!.coupon_data!.isNotEmpty),
                        4.height.visible(widget.data!.coupon_data!.isNotEmpty),
                        Divider(thickness: 0.5).visible(widget.data!.coupon_data!.isNotEmpty),
                        4.height,
                        Row(
                          children: [
                            Text(language!.totalAmount, style: primaryTextStyle()).expand(),
                            PriceWidget(price: totalAmount),
                          ],
                        ),
                        8.height,
                      ],
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithShadow(backgroundColor: context.scaffoldBackgroundColor),
              child: AppButton(
                height: 50,
                width: context.width(),
                text: language!.bookTheService,
                textStyle: boldTextStyle(color: white),
                color: primaryColor,
                onTap: () {
                  if (appStore.isLoggedIn) {
                    showConfirmDialogCustom(
                      context,
                      positiveText: language!.lblYes,
                      negativeText: language!.lblNo,
                      title: language!.lblAlertBooking,
                      onAccept: (context) async {
                        if (await isNetworkAvailable()) {
                          bookServices();
                        } else {
                          snackBar(context, title: language!.lblCheckInternet);
                        }
                      },
                    );
                  } else {
                    SignInScreen(isFromRegister: true).launch(context);
                  }
                },
              ),
            ),
          )
        : NoInternetScreen();
  }
}
