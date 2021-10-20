import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/CoustomerReviewComponent.dart';
import 'package:booking_system_flutter/components/GalleryImagesComponent.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/components/ServiceRatingComponent.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/ServiceAddressesModel.dart';
import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/BookServiceScreen.dart';
import 'package:booking_system_flutter/screens/ProviderInfoScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'SignInScreen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int? serviceId;

  ServiceDetailScreen({this.serviceId});

  @override
  ServiceDetailScreenState createState() => ServiceDetailScreenState();
}

class ServiceDetailScreenState extends State<ServiceDetailScreen> {
  ServiceDetailResponse serviceDetailResponse = ServiceDetailResponse();

  RatingData ratingData = RatingData();
  List<String> galleryImages = [];
  List<String> addressList = [];
  List<ServiceAddressesModel> serviceAddressesList = [];

  int? booking_service_id = -1;
  int? selectedOption = 0;

  TextEditingController reviewCont = TextEditingController();

  int _itemCount = 1;

  num discountPrice = 0;
  num totalAmount = 0;

  bool mIsInWishList = false;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });

    createInterstitialAd();
  }

  Future<void> init() async {
    Map req = {
      CommonKeys.serviceId: widget.serviceId,
      if (appStore.isLoggedIn) CommonKeys.customerId: appStore.userId,
    };

    getServiceDetail(req).then((value) {
      appStore.setLoading(false);
      serviceDetailResponse = value;

      serviceDetailResponse.service_detail!.serviceAddressMapping!.map((e) {
        serviceAddressesList.add(ServiceAddressesModel(e.provider_address_id.validate(), e.provider_address_mapping!.address));
        addressList.add(e.provider_address_mapping!.address.validate());
      }).toList();

      serviceAddressesList.add(ServiceAddressesModel(-1, "Other"));

      setState(() {});

      galleryImages.addAll(serviceDetailResponse.service_detail!.attchments.validate());
      if (serviceDetailResponse.service_detail!.isFavourite == 0) {
        mIsInWishList = false;
      } else {
        mIsInWishList = true;
      }
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  void totalPayment() async {
    if (serviceDetailResponse.service_detail!.discount != null) {
      totalAmount = (serviceDetailResponse.service_detail!.price! * _itemCount) -
          (((serviceDetailResponse.service_detail!.price! * _itemCount) * (serviceDetailResponse.service_detail!.discount.validate())) / 100);
      discountPrice = serviceDetailResponse.service_detail!.price! * _itemCount - totalAmount;
    } else {
      totalAmount = (serviceDetailResponse.service_detail!.price! * _itemCount);
    }

    setState(() {});
  }

  void checkWishList() {
    setState(() {
      if (mIsInWishList == false) {
        addToFavouriteList();
      } else {
        removeToFavouriteList();
      }
    });
  }

  void addToFavouriteList() async {
    Map req = {
      "id": "",
      "service_id": serviceDetailResponse.service_detail!.id,
      "user_id": appStore.userId,
    };

    await addWishList(req).then((res) {
      mIsInWishList = true;

      snackBar(context, title: res.message!);
      setState(() {});
    }).catchError((e) {
      toast(e!.toString());
    });
  }

  void removeToFavouriteList() async {
    Map req = {
      "user_id": appStore.userId,
      'service_id': serviceDetailResponse.service_detail!.id,
    };

    await removeWishList(req).then((res) {
      mIsInWishList = false;
      snackBar(context, title: res.message!);

      setState(() {});
    }).catchError((e) {
      toast(e!.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (interstitialAd != null) {
      if (mAdShowCount < 5) {
        mAdShowCount++;
      } else {
        mAdShowCount = 0;
        showInterstitialAd(context);
      }

      interstitialAd?.dispose();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget availableCoupons() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.availableCoupon, style: boldTextStyle()),
          16.height,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: serviceDetailResponse.coupon_data!.map((e) {
              return couponView(context, e.code.validate());
            }).toList(),
          ),
          16.height,
        ],
      ).visible(serviceDetailResponse.coupon_data!.isNotEmpty);
    }

    Widget providerData() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.lblProvider, style: boldTextStyle()),
          16.height,
          if (serviceDetailResponse.provider != null)
            Container(
              padding: EdgeInsets.all(8),
              decoration: boxDecorationDefault(color: context.cardColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  cachedImage(serviceDetailResponse.provider!.profile_image, height: 90, width: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(45),
                  8.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(serviceDetailResponse.provider!.display_name.validate(), style: boldTextStyle(size: 18)).paddingLeft(4).expand(),
                          Icon(Icons.info, size: 20, color: primaryColor),
                        ],
                      ),
                      4.height,
                      if (serviceDetailResponse.provider!.contact_number.validate().isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.call, size: 16, color: primaryColor),
                            4.width,
                            Text(serviceDetailResponse.provider!.contact_number.validate(), style: secondaryTextStyle()),
                          ],
                        ),
                      4.height,
                      if (serviceDetailResponse.provider!.address.validate().isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16, color: primaryColor),
                            4.width,
                            Text(serviceDetailResponse.provider!.address.validate(), style: secondaryTextStyle()).expand(),
                          ],
                        ),
                      Divider(),
                      if (serviceDetailResponse.provider!.contact_number.validate().isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(language!.contactProvider, style: primaryTextStyle(size: 14)).paddingLeft(4),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: boxDecorationWithRoundedCorners(backgroundColor: Colors.green, borderRadius: radius(40)),
                              child: Icon(Icons.call, size: 18, color: Colors.white),
                            ),
                          ],
                        ).onTap(() {
                          launch(('tel://${serviceDetailResponse.provider!.contact_number.validate()}'));
                        }),
                    ],
                  ).expand(),
                ],
              ).onTap(() {
                ProviderInfoScreen(providerId: serviceDetailResponse.provider!.id).launch(context);
              }),
            ),
          16.height,
        ],
      ).visible(serviceDetailResponse.provider != null);
    }

    Widget duration() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.duration, style: boldTextStyle()),
          16.height,
          Container(
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language!.takeTime, style: primaryTextStyle()),
                8.height,
                Text('${serviceDetailResponse.service_detail!.duration.validate()} hr', style: boldTextStyle(color: primaryColor)),
              ],
            ),
          ),
          16.height,
        ],
      ).visible(serviceDetailResponse.service_detail!.duration != null);
    }

    Widget addressList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(language!.serviceAvailable, style: boldTextStyle()),
          16.height,
          Container(
            width: context.width(),
            padding: EdgeInsets.all(8),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Wrap(
              children: serviceAddressesList.map((e) {
                int index = serviceAddressesList.indexOf(e);
                return Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8, right: 8),
                  padding: EdgeInsets.all(8),
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(8), backgroundColor: context.cardColor, border: Border.all(width: 1, color: selectedOption == index ? primaryColor : textSecondaryColor.withOpacity(0.3))),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(8),
                          border: Border.all(color: selectedOption == index ? primaryColor.withOpacity(0.3) : context.cardColor),
                          backgroundColor: selectedOption == index ? primaryColor.withOpacity(0.3) : context.cardColor,
                        ),
                        width: 16,
                        height: 16,
                        child: Icon(Icons.done, size: 12, color: selectedOption == index ? white : context.cardColor),
                      ).visible(selectedOption == index),
                      4.width,
                      Text(e.address.validate(), style: secondaryTextStyle(size: 16)),
                    ],
                  ),
                ).onTap(() {
                  setState(() {
                    selectedOption = index;
                    booking_service_id = e.id;
                  });
                });
              }).toList(),
            ).visible(serviceAddressesList.isNotEmpty),
          ),
          16.height,
        ],
      ).paddingSymmetric(horizontal: 16).visible(serviceDetailResponse.service_detail!.duration != null);
    }

    return WillPopScope(
      onWillPop: () {
        finish(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        body: Stack(
          children: [
            if (serviceDetailResponse.toJson().isNotEmpty)
              Stack(
                children: [
                  Container(
                    height: context.height() * 0.55,
                    child: cachedImage(
                      serviceDetailResponse.service_detail!.attchments!.isNotEmpty ? serviceDetailResponse.service_detail!.attchments!.first.validate() : '',
                      height: context.height() * 0.55,
                      width: context.width(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(top: context.height() * 0.5, bottom: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: context.width(),
                              decoration: BoxDecoration(borderRadius: radiusOnly(topLeft: 30, topRight: 30), color: appStore.isDarkMode ? scaffoldSecondaryDark : Colors.white),
                              padding: EdgeInsets.only(top: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          20.height,
                                          Text(serviceDetailResponse.service_detail!.name.validate(), style: boldTextStyle(size: 18)).paddingOnly(bottom: 4),
                                          Container(width: 10),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(right: 8.0, top: 4.0),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    PriceWidget(price: serviceDetailResponse.service_detail!.price.validate() * _itemCount, color: primaryColor, size: 18),
                                                    4.width.visible(serviceDetailResponse.service_detail!.discount != null),
                                                    Text('(${serviceDetailResponse.service_detail!.discount}% OFF)', style: secondaryTextStyle(color: redColor))
                                                        .visible(serviceDetailResponse.service_detail!.discount != null)
                                                        .paddingTop(2),
                                                    4.width,
                                                    if (serviceDetailResponse.service_detail!.type != 'fixed') Text('/' + "hr", style: secondaryTextStyle(size: 12)).paddingTop(4),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  RatingBarWidget(
                                                    disable: true,
                                                    rating: serviceDetailResponse.service_detail!.total_review!.toDouble(),
                                                    size: 16,
                                                    onRatingChanged: (v) {
                                                      //
                                                    },
                                                  ),
                                                  4.width,
                                                  if (serviceDetailResponse.service_detail!.total_review! != 0)
                                                    Text('(${serviceDetailResponse.service_detail!.total_review!}' + language!.review + ')', style: secondaryTextStyle()),
                                                ],
                                              ).expand().visible(serviceDetailResponse.service_detail!.total_review! != 0),
                                            ],
                                          ),
                                        ],
                                      ).expand(),
                                    ],
                                  ).paddingOnly(left: 16, right: 16, bottom: 16),
                                  Text(language!.service + ' ' + language!.lblGallery, style: boldTextStyle()).paddingOnly(left: 16, right: 16).visible(galleryImages.isNotEmpty),
                                  Container(
                                    margin: EdgeInsets.all(16),
                                    padding: EdgeInsets.all(8),
                                    decoration: boxDecorationDefault(color: context.cardColor),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GalleryImagesComponent(galleryImages).paddingOnly(top: 8, bottom: 8).visible(galleryImages.isNotEmpty),
                                        if (serviceDetailResponse.service_detail!.description != null)
                                          Text(serviceDetailResponse.service_detail!.description.validate(), style: secondaryTextStyle(), textAlign: TextAlign.justify),
                                      ],
                                    ),
                                  ).visible(serviceDetailResponse.service_detail!.description.validate().isNotEmpty),
                                  duration().paddingOnly(left: 16, right: 16),
                                  addressList(),
                                  availableCoupons().paddingOnly(left: 16, right: 16).visible(serviceDetailResponse.coupon_data!.isNotEmpty),
                                  providerData().paddingOnly(left: 16, right: 16),
                                  CustomerReviewComponent(customerReview: serviceDetailResponse.customer_review)
                                      .paddingOnly(left: 16, right: 16)
                                      .visible(appStore.isLoggedIn && serviceDetailResponse.customer_review != null),
                                  ServiceRatingComponent(serviceDetailResponse.rating_data).paddingOnly(left: 16, right: 16),
                                  40.height,
                                ],
                              ),
                            ),
                            Positioned(
                              right: 20,
                              child: Container(
                                height: 40,
                                padding: EdgeInsets.only(right: 4, left: 4, bottom: 4),
                                margin: EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: primaryColor.withOpacity(0.25),
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
                                child: mIsInWishList ? Icon(Icons.favorite, color: Colors.red.withOpacity(0.7), size: 28) : Icon(Icons.favorite_border, size: 28, color: white),
                              ).onTap(() async {
                                if (appStore.isLoggedIn) {
                                  checkWishList();
                                } else {
                                  bool res = await SignInScreen().launch(context);
                                }
                              }),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                      child: Icon(Icons.arrow_back, color: context.iconColor, size: 18),
                    ).onTap(() {
                      finish(context, true);
                    }),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    left: 12,
                    child: AppButton(
                      width: context.width(),
                      text: language!.continueTxt,
                      textStyle: boldTextStyle(color: white),
                      color: primaryColor,
                      onTap: () async {
                        if (await isNetworkAvailable()) {
                          BookServiceScreen(data: serviceDetailResponse, bookingAddressId: booking_service_id).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                        } else {
                          snackBar(context, title: language!.lblCheckInternet);
                        }
                      },
                    ),
                  ),
                ],
              ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
