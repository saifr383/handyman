import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'AppWidgets.dart';

class CustomerReviewComponent extends StatefulWidget {
  final CustomerReview? customerReview;

  CustomerReviewComponent({this.customerReview});

  @override
  _CustomerReviewComponentState createState() => _CustomerReviewComponentState();
}

class _CustomerReviewComponentState extends State<CustomerReviewComponent> {
  TextEditingController reviewCont = TextEditingController();
  double ratings = 0.0;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    //
  }

  void onUpdateSubmit(review, rating) async {
    Map request = {
      "id": widget.customerReview!.id,
      "booking_id": widget.customerReview!.booking_id,
      "service_id": widget.customerReview!.service_id,
      "customer_id": appStore.userId,
      "rating": rating,
      "review": review,
    };

    if (accessAllowed) {
      await updateReview(request).then((res) async {
        appStore.setLoading(false);

        snackBar(context, title: res.message!);

        init();
      });
    } else {
      appStore.setLoading(false);
      snackBar(context, title: demoPurposeMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.customerReview != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language!.yourReview, style: boldTextStyle()),
              16.height,
              Container(
                padding: EdgeInsets.all(8),
                decoration: boxDecorationDefault(color: context.cardColor),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cachedImage(widget.customerReview!.profile_image.validate(), height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(30),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(getStringAsync(USERNAME), style: boldTextStyle()),
                            if (widget.customerReview != null)
                              Container(
                                height: 20,
                                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: getRateColor(widget.customerReview!.rating.validate()),
                                  border: Border.all(width: 0.1),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.star_border, size: 14, color: white),
                                    Text(widget.customerReview!.rating.validate().toString(), style: boldTextStyle(size: 12, color: white)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(widget.customerReview!.review.validate().toString(), style: primaryTextStyle()), Icon(LineIcons.edit)],
                        ),
                      ],
                    ).expand()
                  ],
                ),
              ).onTap(() {
                reviewCont.text = widget.customerReview!.review.toString();
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
                              initialRating: widget.customerReview!.rating!.toDouble(),
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
                                      snackBar(context, title: language!.toastSorry);

                                      return;
                                    }
                                    setState(() {
                                      if (!accessAllowed) {
                                        snackBar(context, title: language!.toastSorry);
                                        return;
                                      }
                                      if (ratings < 1) {
                                        snackBar(context, title: language!.toastRateUs);
                                      } else if (reviewCont.text.isEmpty) {
                                        snackBar(context, title: language!.toastAddReview);
                                      } else {
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
              }),
              16.height,
            ],
          )
        : SizedBox();
  }
}
