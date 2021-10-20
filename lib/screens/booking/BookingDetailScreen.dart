import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/model/BookingDetailResponse.dart';
import 'package:booking_system_flutter/model/BookingListResponse.dart';
import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/PaymentScreen.dart';
import 'package:booking_system_flutter/screens/booking/BookingDetailComponent.dart';
import 'package:booking_system_flutter/screens/booking/BookingHeaderComponent.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/Dashed_Rect.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import '../BookServiceScreen.dart';

class BookingDetailScreen extends StatefulWidget {
  final int? bookingId;
  final Booking? booking;

  BookingDetailScreen({this.bookingId, this.booking});

  @override
  BookingDetailScreenState createState() => BookingDetailScreenState();
}

class BookingDetailScreenState extends State<BookingDetailScreen> {
  BookingDetailResponse? bookingDetailResponse;
  BookingDetail? bookingDetail;
  RatingData? ratingData;
  ServiceDetailResponse? serviceData;

  TextEditingController reviewCont = TextEditingController();
  String? btnNameOne;
  String? btnNameTwo;
  String afterUpdateMessage = '';
  String? startDateTime = '';
  String? timeInterval = '0';
  String? endDateTime = '';

  double ratings = 0.0;

  bool? updated = false;
  bool? singleButton = false;
  bool? hideBottom = false;

  bool? clicked = false;
  int tabIndex = -1;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  Future<void> init() async {
    loadBookingDetail();
    createInterstitialAd();
  }

  Future<void> loadBookingDetail() async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.bookingId: widget.bookingId.toString(),
      CommonKeys.customerId: appStore.userId,
    };

    await getBookingDetail(request).then((value) {
      appStore.setLoading(false);
      bookingDetailResponse = value;
      bookingDetail = value.booking_detail!;
      if (bookingDetail!.status.validate() == BookingStatusKeys.pending || bookingDetail!.status.validate() == BookingStatusKeys.accept) {
        btnNameOne = CANCEL;
        singleButton = true;
        //
      } else if (bookingDetail!.status.validate() == BookingStatusKeys.onGoing) {
        btnNameOne = START;
        singleButton = true;
        //
      } else if (bookingDetail!.status.validate() == BookingStatusKeys.inProgress) {
        if (bookingDetail!.payment_status == PAID) {
          btnNameOne = COMPLETE;
          singleButton = true;
        } else {
          btnNameOne = HOLD;
          btnNameTwo = DONE;
          singleButton = false;
        }
        //
      } else if (bookingDetail!.status.validate() == BookingStatusKeys.hold) {
        btnNameOne = RESUME;
        btnNameTwo = END;
        //
      } else if (bookingDetail!.status.validate() == BookingStatusKeys.complete) {
        if (bookingDetail!.payment_status == PAID) {
          if (bookingDetailResponse!.rating_data.validate().isNotEmpty) {
            btnNameOne = REVIEW;
            btnNameTwo = RESCHEDULE;
            singleButton = false;
          } else {
            btnNameOne = RESCHEDULE;
            singleButton = true;
            //
          }
        } else if (bookingDetail!.payment_status == PENDING && bookingDetail!.payment_method == COD) {
          updated = true;
          hideBottom = true;
        } else {
          btnNameOne = PAY;
          singleButton = true;
        }
      }

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      log(e.toString());
    });
  }

  Future<void> bookingStatusUpdate({String? reason, String? updatedStatus}) async {
    DateTime now = DateTime.now();
    if (updatedStatus == BookingStatusKeys.inProgress) {
      startDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      endDateTime = bookingDetail!.endAt.validate();
      timeInterval = bookingDetail!.durationDiff.isEmptyOrNull ? '0' : bookingDetail!.durationDiff;
      clicked = true;
      tabIndex = 3;
      //
    } else if (updatedStatus == BookingStatusKeys.hold) {
      String? currentDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      startDateTime = bookingDetail!.startAt.validate();
      endDateTime = currentDateTime;
      var diff = DateTime.parse(currentDateTime).difference(DateTime.parse(bookingDetail!.startAt.validate())).inMinutes;
      num count = int.parse(bookingDetail!.durationDiff.validate()) + diff;
      timeInterval = count.toString();
      clicked = true;
      tabIndex = 4;
      //
    } else if (updatedStatus == BookingStatusKeys.complete) {
      endDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      startDateTime = bookingDetail!.startAt.validate();
      var diff = DateTime.parse(endDateTime.validate()).difference(DateTime.parse(bookingDetail!.startAt.validate())).inMinutes;
      num count = int.parse(bookingDetail!.durationDiff.validate()) + diff;
      timeInterval = count.toString();
      clicked = true;
      tabIndex = 7;
      //
    } else if (updatedStatus == BookingStatusKeys.cancelled || updatedStatus == BookingStatusKeys.failed) {
      startDateTime = bookingDetail!.startAt.validate().isNotEmpty ? bookingDetail!.startAt.validate() : bookingDetail!.date.validate();
      endDateTime = DateFormat('yyyy-MM-dd kk:mm:ss').format(now);
      timeInterval = bookingDetail!.durationDiff;
      clicked = true;
      if (updatedStatus == BookingStatusKeys.cancelled) {
        tabIndex = 8;
      } else {
        tabIndex = 6;
      }
      //
    } else {
      startDateTime = bookingDetail!.startAt.validate();
      endDateTime = bookingDetail!.endAt.validate();
      timeInterval = bookingDetail!.durationDiff;
      //
    }
    setState(() {});
    Map request = {
      CommonKeys.id: widget.bookingId.validate(),
      BookingUpdateKeys.startAt: startDateTime,
      BookingUpdateKeys.endAt: endDateTime,
      BookingUpdateKeys.durationDiff: timeInterval,
      BookingUpdateKeys.reason: reason,
      CommonKeys.status: updatedStatus,
    };

    log(request);

    await updateBooking(request).then((res) async {
      appStore.setLoading(false);

      snackBar(context, title: res.message!);

      await loadBookingDetail();
      if (updatedStatus == BookingStatusKeys.cancelled) {
        clicked = true;
        tabIndex = 5;
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> rescheduleService() async {
    appStore.isLoading = true;
    Map req = {
      CommonKeys.serviceId: widget.booking!.serviceId,
      if (appStore.isLoggedIn) CommonKeys.customerId: appStore.userId,
    };
    getServiceDetail(req).then((value) {
      appStore.isLoading = false;
      serviceData = value;
      BookServiceScreen(data: serviceData).launch(context);
    }).catchError((e) {
      appStore.isLoading = false;
      toast(e.toString(), print: true);
    });
  }

  void onUpdateSubmit(review, rating) async {
    Map request = {
      "id": "",
      "booking_id": bookingDetail!.id,
      "service_id": bookingDetail!.service_id,
      "customer_id": bookingDetail!.customer_id,
      "rating": rating,
      "review": review,
    };
    if (accessAllowed) {
      await updateReview(request).then((value) async {
        appStore.setLoading(false);
        toast(value.message.toString());
      });
    } else {
      appStore.setLoading(false);
      toast(demoPurposeMsg);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void reasonDialog(String? label, String status) {
    TextEditingController _textFieldReason = TextEditingController();
    showInDialog(context, title: Text(label!, style: boldTextStyle(), textAlign: TextAlign.justify), barrierColor: Colors.black45, builder: (context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              onChanged: (value) {},
              controller: _textFieldReason,
              textFieldType: TextFieldType.ADDRESS,
              decoration: inputDecoration(context, hint: language!.enterReason),
              minLines: 4,
              maxLines: 10,
            ),
            16.height,
            AppButton(
              color: primaryColor,
              height: 40,
              text: language!.lblOk,
              textStyle: boldTextStyle(color: Colors.white),
              width: context.width() - context.navigationBarHeight,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: radius(defaultAppButtonRadius),
                side: BorderSide(color: viewLineColor),
              ),
              onTap: () {
                _textFieldReason.text.isNotEmpty
                    ? setState(() {
                        bookingStatusUpdate(reason: _textFieldReason.text, updatedStatus: status);
                        if (status == BookingStatusKeys.cancelled || status == BookingStatusKeys.failed) {
                          afterUpdateMessage = language!.cancelled;
                          updated = true;
                          finish(context, afterUpdateMessage);
                        } else if (status == BookingStatusKeys.hold) {
                          bookingStatusUpdate(reason: _textFieldReason.text, updatedStatus: BookingStatusKeys.hold);
                          btnNameOne = RESUME;
                          btnNameTwo = END;
                          afterUpdateMessage = 'hold';
                          setState(() {});
                          finish(context, afterUpdateMessage);
                        }
                      })
                    : toast(language!.toastReason);
              },
            )
          ],
        ),
      );
    });
  }

  void reviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: radius(8)),
        elevation: 0.0,
        child: Container(
          width: 300,
          padding: EdgeInsets.all(12),
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10), backgroundColor: context.cardColor),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              // To make the card compact
              children: <Widget>[
                Text(language!.lblRateTitle, style: boldTextStyle()),
                Divider().paddingSymmetric(vertical: 4),
                Text(language!.lblRateApp, style: secondaryTextStyle()),
                8.height,
                RatingBar(
                  initialRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  ratingWidget: RatingWidget(
                    full: Icon(Icons.star, color: Colors.amber),
                    empty: Icon(Icons.star_outline_outlined, color: Colors.amber),
                    half: Icon(Icons.star, color: Colors.amber),
                  ),
                  onRatingUpdate: (rating) {
                    ratings = rating;
                  },
                ).paddingSymmetric(horizontal: 16),
                8.height,
                AppTextField(
                  textFieldType: TextFieldType.ADDRESS,
                  controller: reviewCont,
                  maxLines: 10,
                  minLines: 5,
                  decoration: inputDecoration(context, hint: language!.lblHintRate),
                ).paddingSymmetric(horizontal: 6),
                8.height,
                Column(
                  children: [
                    AppButton(
                      width: context.width(),
                      text: language!.btnSubmit,
                      textStyle: primaryTextStyle(color: white),
                      color: primaryColor,
                      onTap: () {
                        if (!accessAllowed) {
                          toast(language!.toastSorry);
                          return;
                        }
                        setState(() {
                          if (!accessAllowed) {
                            toast(language!.toastSorry);
                            return;
                          }
                          if (ratings < 1) {
                            toast(language!.toastRateUs);
                          } else if (reviewCont.text.isEmpty) {
                            toast(language!.toastAddReview);
                          } else {
                            toast(reviewCont.text);
                            toast(ratings.toString());
                            onUpdateSubmit(reviewCont.text, ratings);
                            finish(context);
                            setState(() {});
                          }
                        });
                      },
                    ),
                    8.height,
                    AppButton(
                      width: context.width(),
                      color: context.cardColor,
                      elevation: 0,
                      text: language!.btnLater,
                      textStyle: primaryTextStyle(color: primaryColor),
                      onTap: () {
                        finish(context);
                      },
                    )
                  ],
                ).paddingAll(16.toDouble()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showBookingDetailSheet() {
    return Container(
      decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(language!.bookingHistory, style: boldTextStyle(size: 18)),
                IconButton(
                    onPressed: () {
                      finish(context);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            bookingDetailResponse!.booking_activity!.length != 0
                ? ListView.builder(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bookingDetailResponse!.booking_activity!.length,
                    itemBuilder: (_, i) {
                      BookingActivity data = bookingDetailResponse!.booking_activity![i];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(color: primaryColor, borderRadius: radius(16)),
                              ),
                              SizedBox(height: 30, child: DashedRect(gap: 2, color: primaryColor)).visible(i != bookingDetailResponse!.booking_activity!.length - 1),
                            ],
                          ),
                          8.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data.activity_type.validate().replaceAll('_', ' ').capitalizeFirstLetter(), style: boldTextStyle(size: 16)),
                                  Text(formatDate(data.datetime.toString().validate()), style: secondaryTextStyle()),
                                ],
                              ),
                              4.height,
                              Text(data.activity_message.validate().replaceAll('_', ' ').capitalizeFirstLetter(), style: secondaryTextStyle(size: 14)),
                            ],
                          ).paddingOnly(bottom: 16).expand()
                        ],
                      );
                    })
                : Text(language!.noDataAvailable),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (interstitialAd != null) {
      if (mAdShowCount < 5) {
        mAdShowCount++;
      } else {
        mAdShowCount = 0;
        showInterstitialAd(context);
      }
      interstitialAd?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        log(tabIndex);
        pop({'update': clicked, 'index': tabIndex});
        return Future.value(false);
        //
      },
      child: Scaffold(
        body: Stack(
          children: [
            if (bookingDetailResponse != null)
              CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    delegate: BookingHeaderComponent(buildContext: context, data: bookingDetailResponse, expandedHeight: 300),
                    pinned: false,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      BookingDetailComponent(data: bookingDetailResponse, buildContext: context),
                    ]),
                  )
                ],
              ),
            Positioned(
              top: 38,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    child: Icon(Icons.arrow_back, color: context.iconColor, size: 18),
                  ).onTap(() {
                    // finish(context,afterUpdateMessage);
                    log(tabIndex);
                    log(clicked);
                    finish(context, {'update': clicked, 'index': tabIndex});
                  }),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                    child: Icon(Icons.info, color: context.iconColor, size: 18),
                  ).onTap(() {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (_) {
                          return showBookingDetailSheet();
                        });
                  }),
                ],
              ),
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading))
          ],
        ),
        bottomNavigationBar: bookingDetail != null
            ? updated == false
                ? Container(
                    child: bookingDetail!.status == BookingStatusKeys.failed || bookingDetail!.status == BookingStatusKeys.rejected || bookingDetail!.status == BookingStatusKeys.cancelled
                        ? SizedBox()
                        : Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                            child: singleButton == true
                                ? AppButton(
                                    height: 50,
                                    width: context.width(),
                                    color: btnNameOne == CANCEL
                                        ? Colors.red
                                        : btnNameOne == RESCHEDULE
                                            ? Colors.amber
                                            : Colors.green,
                                    text: btnNameOne,
                                    onTap: () {
                                      if (btnNameOne == CANCEL) {
                                        reasonDialog(
                                            language!.lblCancelReason,
                                            bookingDetail!.status == BookingStatusKeys.pending || bookingDetail!.status == BookingStatusKeys.accept
                                                ? BookingStatusKeys.cancelled
                                                : BookingStatusKeys.failed);
                                      } else if (btnNameOne == COMPLETE) {
                                        setState(() {
                                          bookingStatusUpdate(reason: '', updatedStatus: BookingStatusKeys.complete);
                                          updated = true;
                                          afterUpdateMessage = 'Done';
                                        });
                                      } else if (btnNameOne == START) {
                                        setState(() {
                                          bookingStatusUpdate(reason: '', updatedStatus: BookingStatusKeys.inProgress);
                                          btnNameOne = HOLD;
                                          btnNameTwo = DONE;
                                          singleButton = false;
                                        });
                                      } else if (btnNameOne == REVIEW) {
                                        reviewDialog();
                                        updated = true;
                                        afterUpdateMessage = '';
                                      } else if (btnNameOne == RESCHEDULE) {
                                        afterUpdateMessage = '';
                                        rescheduleService();
                                        log('service Data : $serviceData');
                                        BookServiceScreen(data: serviceData).launch(context);
                                        updated = false;
                                      } else {
                                        PaymentScreen(data: bookingDetailResponse).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                                      }
                                    },
                                  )
                                : Container(
                                    height: 42,
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        statusButton(context.width() / 2.5, btnNameOne.validate(), primaryColor, Colors.white).onTap(() {
                                          setState(() {
                                            if (btnNameOne == START || bookingDetail!.status == BookingStatusKeys.inProgress) {
                                              reasonDialog(language!.lblHoldReason, BookingStatusKeys.hold);
                                            } else if (bookingDetail!.status == BookingStatusKeys.hold) {
                                              bookingStatusUpdate(reason: '', updatedStatus: BookingStatusKeys.inProgress);
                                              setState(() {
                                                btnNameOne = HOLD;
                                                btnNameTwo = DONE;
                                                singleButton = false;
                                              });
                                            } else if (btnNameOne == REVIEW) {
                                              reviewDialog();
                                            }
                                          });
                                        }),
                                        8.width,
                                        statusButton(context.width() / 2.5, btnNameTwo.validate(), context.cardColor, primaryColor).onTap(() {
                                          setState(() {
                                            if (btnNameTwo == DONE) {
                                              bookingStatusUpdate(reason: 'done', updatedStatus: BookingStatusKeys.complete);
                                              if (bookingDetail!.payment_status == PAID && bookingDetail!.payment_method == COD) {
                                                log(bookingDetail!.payment_status);
                                                afterUpdateMessage = language!.lblComplete;
                                                updated = true;
                                              } else {
                                                log(bookingDetail!.payment_status);
                                                singleButton = true;
                                                btnNameOne = PAY;
                                              }
                                            } else if (btnNameTwo == END) {
                                              reasonDialog(
                                                  language!.lblCancelReason,
                                                  bookingDetail!.status == BookingStatusKeys.pending || bookingDetail!.status == BookingStatusKeys.accept
                                                      ? BookingStatusKeys.cancelled
                                                      : BookingStatusKeys.failed);
                                            } else if (btnNameTwo == RESCHEDULE) {
                                              rescheduleService();
                                            }
                                          });
                                        }),
                                      ],
                                    ),
                                  ),
                          ).visible(!appStore.isLoading),
                  )
                : hideBottom == false
                    ? Container(
                        padding: EdgeInsets.all(16),
                        decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.scaffoldBackgroundColor),
                        child: Text("afterUpdateMessage", style: boldTextStyle(), textAlign: TextAlign.center),
                      )
                    : SizedBox()
            : SizedBox(),
      ),
    );
  }
}
