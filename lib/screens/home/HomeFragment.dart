import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/DashboardResponse.dart';
import 'package:booking_system_flutter/model/NotificationResponse.dart';
import 'package:booking_system_flutter/model/ServiceModel.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/NewMapScreen.dart';
import 'package:booking_system_flutter/screens/SerachServiceScreen.dart';
import 'package:booking_system_flutter/screens/ServiceListScreen.dart';
import 'package:booking_system_flutter/screens/home/components/CategoryComponent.dart';
import 'package:booking_system_flutter/screens/home/components/SliderComponent.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/Images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

import '../ProviderListScreen.dart';
import 'components/ProviderListComponent.dart';
import 'components/ServiceListComponent.dart';

class HomeFragment extends StatefulWidget {
  @override
  HomeFragmentState createState() => HomeFragmentState();
}

class HomeFragmentState extends State<HomeFragment> with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  DashboardResponse? dashboardResponse;
  NotificationListResponse? notificationListResponse;

  List<SliderModel>? sliderList = [];
  List<Category>? categoryList = [];
  List<Service>? serviceList = [];
  List<ProviderData>? providerList = [];
  List<Configuration>? configList = [];
  List<NotificationData> notificationList = [];

  int unReadCount = 0;

  String? currentLocation;
  double? lat;
  double? long;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    await setValue(IS_FIRST_TIME, false);
    checkPermission();

    setState(() {
      currentLocation = getStringAsync(CURRENT_ADDRESS);
      log(currentLocation);

      lat = getDoubleAsync(LATITUDE);
      long = getDoubleAsync(LONGITUDE);
    });

    if (appStore.isCurrentLocation)
      getDashboard(enable: appStore.isCurrentLocation, lat: lat, long: long);
    else
      getDashboard(enable: appStore.isCurrentLocation);
  }

  Future<void> getDashboard({required bool enable, double? lat, double? long}) async {
    if (appStore.isLoggedIn) await getNotificationList();

    await userDashboard(isCurrentLocation: enable, lat: lat, long: long).then((res) async {
      appStore.setLoading(false);
      dashboardResponse = res;
      categoryList = res.category;
      serviceList = res.service;
      sliderList = res.slider;
      providerList = res.provider;
      configList = res.configurations;

      configList!.forEach((element) async {
        if (element.key!.contains(CURRENCY_COUNTRY_ID)) {
          await setValue(CURRENCY_COUNTRY_SYMBOL, element.country!.symbol.validate());
          await setValue(CURRENCY_COUNTRY_CODE, element.country!.currency_code.validate());
        } else {
          await setValue(element.key!, element.value.validate());
        }
      });

      //await setValue(IS_PAYPAL_CONFIGURATION, res.is_paypal_configuration);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  Future<void> getNotificationList() async {
    Map request = {"type": ""};
    appStore.setLoading(true);

    getNotification(request).then((value) {
      appStore.setLoading(false);
      notificationListResponse = value;
      notificationList.addAll(notificationListResponse!.notificationData!);
      unReadCount = notificationListResponse!.allUnreadCount!;
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> checkPermission() async {
    LocationPermission locationPermission = await Geolocator.requestPermission();

    if (locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
      if ((await Geolocator.isLocationServiceEnabled())) {
        getUserLocation();
      } else {
        Geolocator.openLocationSettings().then((value) {
          if (value) getUserLocation();
        });
      }
    } else {
      Geolocator.openAppSettings();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      body: RefreshIndicator(
        backgroundColor: context.cardColor,
        onRefresh: () {
          return init();
        },
        child: Stack(
          children: [
            if (dashboardResponse != null)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      overflow: Overflow.visible,
                      children: [
                        sliderList!.isNotEmpty
                            ? SliderComponent(sliderList: sliderList.validate(), notificationListResponse: notificationListResponse)
                            : cachedImage(placeholder, height: 300, fit: BoxFit.cover),
                        Positioned(
                          bottom: -20,
                          right: 16,
                          left: 16,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                            decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? context.cardColor : secondaryPrimaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(language!.search, style: secondaryTextStyle(size: 16, color: primaryColor)),
                                Icon(Icons.search, color: primaryColor),
                              ],
                            ),
                          ).onTap(() {
                            SearchServiceScreen().launch(context);
                          }),
                        ),
                      ],
                    ),
                    24.height,
                    Container(
                        margin: EdgeInsets.all(16),
                        decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, size: 20, color: primaryColor),
                            4.width,
                            Text(appStore.isCurrentLocation ? currentLocation.validate() : language!.notAvailable, style: secondaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis)
                                .onTap(() async {
                              bool res = await NewMapScreen().launch(context);
                              if (res) {
                                init();
                              }
                            }).expand(),
                            8.width,
                            Observer(
                              builder: (_) => GestureDetector(
                                  onTap: () {
                                    if (appStore.isCurrentLocation) {
                                      appStore.setCurrentLocation(false);

                                      snackBar(context, title: language!.toastLocationOff);
                                    } else {
                                      appStore.setCurrentLocation(true);
                                      snackBar(context, title: language!.toastLocationOff);
                                    }
                                    appStore.setCurrentLocation(appStore.isCurrentLocation);
                                    if (!appStore.isCurrentLocation)
                                      getDashboard(enable: appStore.isCurrentLocation);
                                    else
                                      getDashboard(enable: appStore.isCurrentLocation, lat: getDoubleAsync(LATITUDE), long: getDoubleAsync(LONGITUDE));
                                  },
                                  child: Icon(Icons.my_location, size: 20, color: appStore.isCurrentLocation ? primaryColor : grey)),
                            )
                          ],
                        ).paddingAll(16)),
                    if (categoryList!.isNotEmpty) Text(language!.category, style: boldTextStyle()).paddingOnly(left: 16, right: 16),
                    if (categoryList!.isNotEmpty) CategoryComponent(categoryList: categoryList),
                    Container(
                      decoration: boxDecorationWithShadow(backgroundColor: context.scaffoldBackgroundColor),
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(language!.service, style: boldTextStyle()).paddingOnly(left: 16, right: 16),
                          ServiceListComponent(serviceList: serviceList).paddingOnly(left: 8, right: 8, top: 8),
                          if (serviceList!.length >= 4)
                            AppButton(
                              text: language!.viewAllService,
                              shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: primaryColor)),
                              width: context.width() - 32,
                              color: context.scaffoldBackgroundColor,
                              textColor: primaryColor,
                              elevation: 0.0,
                              onTap: () async {
                                bool? res = await ServiceListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                if (res ?? false) {
                                  appStore.setLoading(true);
                                  init();
                                  setState(() {});
                                }
                              },
                            ).center()
                        ],
                      ),
                    ).visible(serviceList!.isNotEmpty),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language!.lblProvider, style: boldTextStyle()).paddingOnly(left: 16, right: 16),
                        TextButton(
                          onPressed: () {
                            ProviderListScreen().launch(context);
                          },
                          child: Text(language!.lblVeiwAll, style: primaryTextStyle(size: 14, color: primaryColor)),
                        ).visible(appStore.isLoggedIn)
                      ],
                    ),
                    8.height.visible(!appStore.isLoggedIn),
                    ProviderListComponent(providerList: providerList)
                  ],
                ),
              ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
