import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/CoustomerReviewComponent.dart';
import 'package:booking_system_flutter/components/ServiceRatingComponent.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/BookingDetailResponse.dart';
import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/model/UserData.dart';
import 'package:booking_system_flutter/screens/ChatScreen.dart';
import 'package:booking_system_flutter/screens/ProviderInfoScreen.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailComponent extends StatefulWidget {
  final BookingDetailResponse? data;
  final BuildContext buildContext;

  BookingDetailComponent({this.data, required this.buildContext});

  @override
  BookingDetailComponentState createState() => BookingDetailComponentState();
}

class BookingDetailComponentState extends State<BookingDetailComponent> {
  BookingDetail? bookingDetail;
  BookingDetailResponse bookingDetailResponse = BookingDetailResponse();
  ServiceDetail serviceData = ServiceDetail();
  UserData? providerData;
  CouponData? couponData;

  num discount = 0;
  num originalRate = 0;
  num totalAmount = 0;
  num discountPrice = 0;
  var duration;
  var price;

  int quantity = 1;
  num couponDiscount = 0;
  num couponDiscountAmount = 0;

  List<UserData>? handymanData = [];
  List<BookingActivity>? bookingActivity = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    bookingDetailResponse = widget.data!;
    providerData = widget.data!.provider_data;
    handymanData = widget.data!.handyman_data!;
    bookingActivity!.addAll(widget.data!.booking_activity!);
    serviceData = widget.data!.service!;
    bookingDetail = widget.data!.booking_detail!;
    couponData = widget.data!.coupon_data;
    duration = bookingDetailResponse.service!.duration;
    setState(() {
      if (bookingDetail!.date != null) {
        originalRate = bookingDetail!.price.validate();
        discount = bookingDetail!.discount.validate();
        if (bookingDetail!.quantity != null) {
          quantity = bookingDetail!.quantity.validate();
        }
        totalPayment();
      }
    });
  }

  void totalPayment() {
    if (bookingDetail!.type == Fixed) {
      totalAmount = (bookingDetail!.price.validate() * quantity) - (((bookingDetail!.price.validate() * quantity) * discount) / 100);
      discountPrice = bookingDetail!.price.validate() * quantity - totalAmount;
    } else {
      var bookingTimeDiff = bookingDetail!.duration_diff.toString().toInt();
      var servicePrice = bookingDetail!.price!.toInt();
      var serviceDuration = (1 * 60);
      if (serviceDuration < bookingTimeDiff) {
        price = (bookingTimeDiff * servicePrice / serviceDuration);
        log(price);
        totalAmount = (price - ((price * discount) / 100));
        discountPrice = price - totalAmount;
      } else {
        totalAmount = (bookingDetail!.price.validate()) - (((bookingDetail!.price.validate()) * discount) / 100);
        discountPrice = bookingDetail!.price.validate() - totalAmount;
      }
    }

    if (couponData != null) {
      couponDiscount = couponData!.discount.validate();
      couponDiscountAmount = ((totalAmount * couponDiscount) / 100);

      if (couponData!.discount_type == Fixed) {
        totalAmount = totalAmount - couponData!.discount.validate();
        couponDiscountAmount = couponData!.discount.validate();
      } else {
        totalAmount = totalAmount - ((totalAmount * couponDiscount) / 100);
        couponDiscountAmount = (couponDiscountAmount);
      }
    }

    setState(() {});
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
        (context.height() * 0.101).toInt().height,
        if (providerData != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), offset: Offset(2.5, 2.5), backgroundColor: context.cardColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    cachedImage(providerData!.profile_image, height: 70, width: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
                    8.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(LineIcons.user, size: 16),
                            4.width,
                            Text(providerData!.display_name.validate(), style: boldTextStyle()).expand(),
                            Icon(Ionicons.md_information_circle_outline, size: 20),
                          ],
                        ),
                        4.height,
                        if (providerData!.contact_number.validate().isNotEmpty)
                          Row(
                            children: [
                              Icon(LineIcons.phone, size: 16),
                              4.width,
                              Text(providerData!.contact_number.validate(), style: secondaryTextStyle()),
                            ],
                          ),
                        4.height,
                        if (providerData!.address.validate().isNotEmpty)
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 16),
                              4.width,
                              Text(providerData!.address.validate(), style: secondaryTextStyle()).expand(),
                            ],
                          ).paddingRight(16),
                        Divider(),
                        if (providerData!.contact_number.validate().isNotEmpty)
                          Row(
                            children: [
                              Text(language!.contactProvider, style: boldTextStyle(size: 14)).expand(),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.green, borderRadius: radius(40)),
                                child: Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white),
                              ).onTap(() {
                                ChatScreen(userData: providerData).launch(context);
                              }).visible(providerData!.uid != null),
                              8.width,
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.green, borderRadius: radius(40)),
                                child: Icon(LineIcons.phone, size: 18, color: Colors.white),
                              ).onTap(() {
                                launch(('tel://${providerData!.contact_number.validate()}'));
                              }),
                            ],
                          )
                      ],
                    ).expand()
                  ],
                ),
              ],
            ),
          ).onTap(() {
            ProviderInfoScreen(providerId: providerData!.id).launch(context);
          }),
        16.height,
        ListView.builder(
            padding: EdgeInsets.all(0),
            physics: NeverScrollableScrollPhysics(),
            itemCount: handymanData!.length,
            shrinkWrap: true,
            itemBuilder: (_, index) {
              UserData data = handymanData![index];
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    width: context.width(),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        8.width,
                        cachedImage(data.profile_image.validate(), height: 70, width: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
                        8.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(LineIcons.user, size: 16),
                                4.width,
                                Text(data.display_name.validate(), style: boldTextStyle()),
                              ],
                            ),
                            4.height,
                            if (data.contact_number.validate().isNotEmpty)
                              Row(
                                children: [
                                  Icon(LineIcons.phone, size: 16),
                                  4.width,
                                  Text(data.contact_number.validate(), style: secondaryTextStyle()),
                                ],
                              ),
                            4.height,
                            if (data.address.validate().isNotEmpty)
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 16),
                                  4.width,
                                  Text(data.address.validate(), style: secondaryTextStyle()).expand(),
                                ],
                              ).paddingRight(16),
                            Divider(),
                            if (data.contact_number!.validate().isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(language!.contactHandyman, style: boldTextStyle(size: 14)).expand(),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.green, borderRadius: radius(40)),
                                    child: Icon(Icons.chat_bubble_outline, size: 18, color: Colors.white),
                                  ).onTap(() {
                                    ChatScreen(userData: data).launch(context);
                                  }).visible(data.uid.validate().isNotEmpty),
                                  8.width,
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.green, borderRadius: radius(40)),
                                    child: Icon(LineIcons.phone, size: 18, color: Colors.white),
                                  ).onTap(() {
                                    launch(('tel://${data.contact_number!.validate()}'));
                                  }),
                                ],
                              )
                          ],
                        ).expand()
                      ],
                    ),
                  ).paddingOnly(bottom: 16)
                ],
              );
            }),
        16.height,
        if (bookingDetail!.payment_status != null && bookingDetail!.payment_method != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), offset: Offset(2.5, 2.5), backgroundColor: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                4.height,
                Text(language!.paymentDetail, style: boldTextStyle(size: 18), textAlign: TextAlign.center),
                4.height,
                Divider(thickness: 0.5),
                8.height,
                Row(
                  children: [
                    Text(language!.paymentStatus, style: secondaryTextStyle()).expand(),
                    Text(bookingDetail!.payment_status.validate(value: 'NA').capitalizeFirstLetter(), style: boldTextStyle(color: statusColor(bookingDetail!.payment_status)))
                  ],
                ),
                4.height,
                4.height.visible(serviceData.type.validate() != Fixed),
                Row(
                  children: [
                    Text(language!.paymentMethod, style: secondaryTextStyle()).expand(),
                    Text(bookingDetail!.payment_method.validate(value: 'NA').capitalizeFirstLetter(), style: boldTextStyle())
                  ],
                ),
                4.height,
                Divider(thickness: 0.5),
                4.height.visible(serviceData.type.validate() != Fixed),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(language!.totalAmountPaid, style: primaryTextStyle()).expand(),
                    Text(
                      bookingDetail!.payment_status.validate() == PAID ? getStringAsync(CURRENCY_COUNTRY_SYMBOL) + bookingDetail!.price.toString().validate() : language!.PaymentConfirmation,
                      style: boldTextStyle(color: Colors.blue),
                      textAlign: TextAlign.end,
                    ).expand(),
                  ],
                ),
              ],
            ),
          ),
        16.height,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), offset: Offset(2.5, 2.5), backgroundColor: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              4.height,
              Text(language!.pricingDetail, style: boldTextStyle(size: 18), textAlign: TextAlign.center),
              4.height,
              Divider(thickness: 0.5),
              8.height,
              Row(
                children: [
                  Text(language!.rate, style: secondaryTextStyle()).expand(),
                  PriceWidget(price: serviceData.price.validate()),
                ],
              ),
              4.height,
              Row(
                children: [
                  Text(language!.quantity, style: secondaryTextStyle()).expand(),
                  Text('x ${bookingDetail!.quantity.validate(value: 1)}', style: boldTextStyle()),
                ],
              ).visible(serviceData.type.validate() == Fixed),
              Row(
                children: [
                  Text(language!.hourly, style: secondaryTextStyle()).expand(),
                  Text(widget.data!.booking_detail!.durationDiff.toString() + " hr", style: boldTextStyle()),
                ],
              ).visible(serviceData.type.validate() != Fixed),
              4.height,
              Row(
                children: [
                  Row(
                    children: [
                      Text(language!.discountOnMRP, style: secondaryTextStyle()),
                      4.width,
                      if (bookingDetail!.discount != null) Text('(${bookingDetail!.discount}% off)', style: boldTextStyle(size: 14, color: Colors.red)),
                    ],
                  ).expand(),
                  if (bookingDetail!.discount != null) Text('${'- ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${discountPrice.toStringAsFixed(2)}'}', style: boldTextStyle(color: Colors.red)),
                  bookingDetail!.type.toString().validate() != "fixed" ? Text(' / ' + 'hr', style: secondaryTextStyle()) : Text("", style: secondaryTextStyle()),
                ],
              ).visible(bookingDetail!.discount != null),
              4.height,
              if (couponData != null)
                Row(
                  children: [
                    Row(
                      children: [
                        Text(language!.couponDiscount, style: primaryTextStyle()),
                        4.width,
                        Text(couponData!.discount_type == Fixed ? '(${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}$couponDiscount off)' : '(%$couponDiscount off)',
                            style: secondaryTextStyle(color: Colors.red)),
                      ],
                    ).expand(),
                    Text(
                      couponDiscountAmount != 0 ? '- ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${couponDiscountAmount.toStringAsFixed(2)}' : 'Apply Coupon',
                      style: boldTextStyle(color: couponDiscountAmount != 0 ? Colors.green : Colors.redAccent),
                    ),
                  ],
                ),
              if (couponData != null) 4.height,
              Divider(thickness: 0.5),
              4.height,
              Row(
                children: [
                  Text(language!.totalAmount, style: primaryTextStyle()).expand(),
                  Text(getStringAsync(CURRENCY_COUNTRY_SYMBOL) + totalAmount.toStringAsFixed(2).toString(), style: boldTextStyle()),
                ],
              ),
              8.height,
            ],
          ),
        ),
        16.height,
        if (appStore.isLoggedIn && bookingDetailResponse.customer_review != null) CustomerReviewComponent(customerReview: bookingDetailResponse.customer_review!),
        ServiceRatingComponent(bookingDetailResponse.rating_data),
        16.height,
      ],
    ).paddingSymmetric(horizontal: 16);
  }
}
