import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/DashboardResponse.dart';
import 'package:booking_system_flutter/model/NotificationResponse.dart';
import 'package:booking_system_flutter/screens/NotificationScreen.dart';
import 'package:booking_system_flutter/screens/ServiceDetailScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';

class SliderComponent extends StatefulWidget {
  final List<SliderModel>? sliderList;
  final NotificationListResponse? notificationListResponse;

  SliderComponent({this.sliderList, this.notificationListResponse});

  @override
  SliderComponentState createState() => SliderComponentState();
}

class SliderComponentState extends State<SliderComponent> {
  PageController sliderPageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return widget.sliderList!.isNotEmpty
        ? Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 300,
                    child: PageView(
                      controller: sliderPageController,
                      children: widget.sliderList!.map((i) {
                        return cachedImage(i.slider_image, height: 250, width: context.width(), fit: BoxFit.cover).onTap(() {
                          if (i.type == 'service') {
                            ServiceDetailScreen(serviceId: i.type_id.validate().toInt()).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                          }
                        });
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    bottom: 34,
                    child: DotIndicator(
                      pageController: sliderPageController,
                      pages: widget.sliderList!,
                      indicatorColor: white,
                      unselectedIndicatorColor: white,
                      currentBoxShape: BoxShape.rectangle,
                      boxShape: BoxShape.rectangle,
                      borderRadius: radius(2),
                      currentBorderRadius: radius(3),
                      currentDotSize: 18,
                      currentDotWidth: 6,
                      dotSize: 6,
                    ),
                  ),
                  if (appStore.isLoggedIn && widget.notificationListResponse != null)
                    Positioned(
                      right: 16,
                      top: 32,
                      child: Container(
                        decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor.withOpacity(0.3), boxShape: BoxShape.circle),
                        child: IconButton(
                          icon: Stack(
                            overflow: Overflow.visible,
                            children: [
                              Icon(Icons.notifications, color: Colors.white, size: 24),
                              Positioned(
                                right: 0,
                                top: -4,
                                child: Container(
                                  color: primaryColor,
                                  padding: EdgeInsets.all(4),
                                  child: Text(widget.notificationListResponse!.allUnreadCount!.toString().validate(), style: secondaryTextStyle(size: 12, color: white)),
                                ).cornerRadiusWithClipRRect(20),
                              ).visible(widget.notificationListResponse!.allUnreadCount.validate() != 0)
                            ],
                          ),
                          onPressed: () {
                            NotificationScreen(notificationList: widget.notificationListResponse!.notificationData).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ],
          )
        : SizedBox();
  }
}
