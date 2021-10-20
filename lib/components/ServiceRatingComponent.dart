import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

import 'AppWidgets.dart';

class ServiceRatingComponent extends StatefulWidget {
  final List<RatingData>? ratingList;

  ServiceRatingComponent(this.ratingList);

  @override
  ServiceRatingComponentState createState() => ServiceRatingComponentState();
}

class ServiceRatingComponentState extends State<ServiceRatingComponent> {
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
    if (widget.ratingList.validate().isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(language!.review, style: boldTextStyle()),
        16.height,
        Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          child: ListView.separated(
            padding: EdgeInsets.all(8),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              RatingData e = widget.ratingList![index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cachedImage(e.profile_image.validate(), height: 60, width: 60, fit: BoxFit.cover).cornerRadiusWithClipRRect(30),
                  10.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.customer_name.validate(value: ''), style: boldTextStyle()).flexible(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: boxDecorationDefault(color: getRateColor(e.rating.validate()), border: Border.all(width: 0.1)),
                            child: Row(
                              children: [
                                Icon(Icons.star_border, size: 14, color: white),
                                4.width,
                                Text(e.rating!.toString(), style: primaryTextStyle(color: white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      8.height,
                      Text(e.review.validate(), style: secondaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ).expand()
                ],
              ).paddingSymmetric(vertical: 8);
            },
            separatorBuilder: (_, i) => Divider(height: 0),
            itemCount: widget.ratingList!.length,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
