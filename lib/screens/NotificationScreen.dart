import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/model/NotificationResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/booking/BookingDetailScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class NotificationScreen extends StatefulWidget {
  final List<NotificationData>? notificationList;

  NotificationScreen({this.notificationList});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List<NotificationData> notificationsDataList = [];
  ScrollController scrollController = ScrollController();
  int? unreadNotification;
  int pageCount = 1;
  int currentPage = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
      scrollController.addListener(() {
        scrollHandler();
      });
    });
  }

  Future<void> init() async {
    getNotificationList();
  }

  scrollHandler() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
      currentPage++;
      init();
    }
  }

  Future<void> getNotificationList({String? type = ''}) async {
    Map request = {NotificationKey.type: type, NotificationKey.page: currentPage};

    appStore.setLoading(true);

    await getNotification(request, page: currentPage).then((res) async {
      if (!mounted) return;
      setState(() {
        appStore.setLoading(false);
        isLastPage = false;

        if (currentPage == 1) {
          notificationsDataList.clear();
        }
        notificationsDataList.addAll(res.notificationData!);
        unreadNotification = res.allUnreadCount;
      });
      setState(() {});
    }).catchError((e) {
      if (!mounted) return;
      isLastPage = true;
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        color: context.primaryColor,
        textColor: white,
        titleWidget: Row(
          children: [
            Text(language!.lnlNotification, style: boldTextStyle(size: 18, color: white)),
            4.width,
            if (unreadNotification != 0 && unreadNotification != null)
              Container(
                padding: EdgeInsets.all(6),
                decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: Colors.white),
                child: Text(unreadNotification.toString(), style: boldTextStyle(color: primaryColor, size: 12)),
              ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    bool isMarkRead = false;
                    return Container(
                      margin: EdgeInsets.all(8),
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(12), backgroundColor: primaryColor),
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextIcon(
                            text: language!.markAsRead,
                            textStyle: secondaryTextStyle(color: white, size: 16),
                            prefix: SizedBox(
                              width: 14,
                              height: 14,
                              child: StatefulBuilder(
                                builder: (BuildContext context, setState) => Theme(
                                  data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                                  child: Checkbox(
                                    checkColor: context.iconColor,
                                    value: isMarkRead,
                                    side: BorderSide(color: white, style: BorderStyle.solid),
                                    onChanged: (v) {
                                      isMarkRead = v!;
                                      getNotificationList(type: MarkAsRead);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ).paddingRight(4),
                          ),
                        ],
                      ),
                    );
                  });
            },
            icon: Icon(Icons.settings, color: white),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return getNotificationList();
        },
        child: Stack(
          children: [
            if (notificationsDataList.isNotEmpty)
              ListView.separated(
                controller: scrollController,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(thickness: 1, height: 0);
                },
                itemCount:notificationsDataList.length,
                itemBuilder: (_, i) {
                  NotificationData data =notificationsDataList[i];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(0), backgroundColor: data.readAt != null ? context.cardColor : primaryColor.withOpacity(0.2)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: primaryColor.withOpacity(0.1)),
                          child: Text('# ${data.data!.id.validate()}', style: boldTextStyle(size: 14, color: primaryColor)),
                        ),
                        12.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(language!.booking, style: boldTextStyle()).expand(),
                                Text('${data.createdAt.validate()}', style: secondaryTextStyle()),
                              ],
                            ),
                            8.height,
                            Text('${data.data!.message.toString().replaceAll('_', ' ').capitalizeFirstLetter().validate()}', style: secondaryTextStyle()),
                            8.height,
                          ],
                        ).expand(),
                      ],
                    ).paddingSymmetric(vertical: 8).onTap(() {
                      BookingDetailScreen(bookingId: data.data!.id.validate()).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    }),
                  );
                },
              ),
            noDataFound().visible(!appStore.isLoading && widget.notificationList!.isEmpty).center(),
            LoaderWidget().visible(appStore.isLoading).center()
          ],
        ),
      ),
    );
  }

  static String getTime(String inputString, String time) {
    List<String> wordList = inputString.split(" ");
    if (wordList.isNotEmpty) {
      return wordList[0] + ' ' + time;
    } else {
      return ' ';
    }
  }
}
