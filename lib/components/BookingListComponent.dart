import 'package:booking_system_flutter/model/BookingListResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/booking/BookingDetailScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/TextIconDemo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'AppWidgets.dart';

class BookingListComponent extends StatefulWidget {
  final String? status;

  BookingListComponent({this.status});

  @override
  BookingListComponentState createState() => BookingListComponentState();
}

class BookingListComponentState extends State<BookingListComponent> {
  ScrollController scrollController = ScrollController();
  List<Booking> bookingList = [];

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
      scrollController.addListener(() {
        if (currentPage <= totalPage) {
          if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
            currentPage++;
            init();
          }
        } else {
          appStore.setLoading(false);
        }
      });
    });
  }

  Future<void> init() async {
    if (appStore.isLoggedIn) getBooking(status: widget.status);
  }

  Future<void> getBooking({String? status}) async {
    appStore.setLoading(true);

    await getBookingList(currentPage, status: widget.status.validate()).then((value) {
      totalItems = value.pagination!.total_items.validate();
      appStore.setLoading(true);
      if (totalItems >= 1) {
        bookingList.addAll(value.data!.validate());
        totalPage = value.pagination!.totalPages!.validate();
        currentPage = value.pagination!.currentPage!.validate();
      }
      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: context.cardColor,
      onRefresh: () async {
        bookingList.clear();
        currentPage = 1;
        init();
        await 2.seconds.delay;
      },
      child: bookingList.isNotEmpty
          ? ListView.builder(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 8),
              itemCount: bookingList.length,
              shrinkWrap: true,
              itemBuilder: (_, i) {
                Booking? data = bookingList[i];

                if (bookingList.isNotEmpty) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        4.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: primaryColor.withOpacity(0.1)),
                              child: Text('${'#' + data.id.toString().validate()}', style: boldTextStyle(size: 20, color: primaryColor)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(AntDesign.calendar, color: grey, size: 14),
                                6.width,
                                Text('${formatDate(data.date.toString().validate())}', style: secondaryTextStyle(size: 14)),
                              ],
                            )
                          ],
                        ),
                        16.height,
                        Divider(thickness: 2, height: 0),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: [
                              TextIcon(
                                expandedText: true,
                                edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                prefix: Row(
                                  children: [
                                    PriceWidget(price: data.price, size: 14, color: primaryColor),
                                    Text('.00', style: boldTextStyle(color: primaryColor, size: 14)),
                                    if (data.discount != null) Text(' - ', style: boldTextStyle(color: Colors.red)),
                                    if (data.discount != null) Text("% ${data.discount.toString()}", style: boldTextStyle(size: 14, color: Colors.red)),
                                    if (data.discount != null) Text('.00 off', style: boldTextStyle(size: 14, color: Colors.red)),
                                    data.type.toString().validate() != "fixed" ? Text(' / ' + "hr", style: secondaryTextStyle()) : Text("", style: secondaryTextStyle()),
                                  ],
                                ),
                              ),
                              TextIcon(
                                expandedText: true,
                                edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                prefix: Text(language!.lblProvider, style: secondaryTextStyle()),
                                suffix: Text(data.providerName.validate(), style: boldTextStyle(size: 14)),
                              ),
                              TextIconDemo(
                                expandedText: true,
                                edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                prefix: Text(language!.service, style: secondaryTextStyle()),
                                suffix: Text(
                                  data.serviceName.validate(),
                                  style: boldTextStyle(size: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              TextIcon(
                                expandedText: true,
                                edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                prefix: Text(language!.bookingStatus, style: secondaryTextStyle()),
                                suffix: Text(data.statusLabel.validate(), style: boldTextStyle(color: statusColor(data.statusLabel))),
                              ),
                              TextIcon(
                                expandedText: true,
                                edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                prefix: Text(language!.paymentStatus, style: secondaryTextStyle()),
                                suffix: Text(
                                  data.paymentStatus.validate() == PAID ? 'Paid' : 'Not Paid',
                                  style: boldTextStyle(),
                                ),
                              ),
                              TextIcon(
                                expandedText: true,
                                edgeInsets: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                                prefix: Text(language!.paymentMethod, style: secondaryTextStyle()),
                                suffix: Text(data.paymentMethod.validate().capitalizeFirstLetter(), style: boldTextStyle(color: primaryColor)),
                              ).visible(data.paymentStatus.validate() == PAID)
                            ],
                          ),
                        ),
                        4.height,
                      ],
                    ),
                  ).onTap(() async {
                    var res = await BookingDetailScreen(
                      bookingId: data.id.validate(),
                      booking: data,
                    ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                    if (res is Map) {
                      if (res['update'] ?? false) {
                        log('init livestream');
                        bookingList.clear();
                        appStore.setLoading(true);
                        currentPage = 1;
                        init();
                        setState(() {});
                      }
                      LiveStream().emit(streamTab, res['index'] ?? -1);
                    }
                  });
                } else {
                  return SizedBox();
                }
              })
          : noDataFound().center().visible(bookingList.isEmpty && !appStore.isLoading),
    );
  }
}
