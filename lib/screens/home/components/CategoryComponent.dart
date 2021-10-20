import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/DashboardResponse.dart';
import 'package:booking_system_flutter/screens/ServiceListScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class CategoryComponent extends StatefulWidget {
  final List<Category>? categoryList;

  CategoryComponent({this.categoryList});

  @override
  CategoryComponentState createState() => CategoryComponentState();
}

class CategoryComponentState extends State<CategoryComponent> {
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
    return Wrap(
      runSpacing: 12,
      spacing: 12,
      children: List.generate(widget.categoryList!.length, (index) {
        return Container(
          width: context.width() * 0.325 - 16,
          decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? context.cardColor : secondaryPrimaryColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              8.height,
              Image.network(widget.categoryList![index].category_image != '' ? widget.categoryList![index].category_image.validate() : '',
                      height: 55, width: 55, color: primaryColor, fit: BoxFit.cover)
                  .paddingAll(4.0),
              8.height,
              Text(widget.categoryList![index].name.validate(), style: boldTextStyle(size: 12), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
              8.height,
            ],
          ).paddingOnly(left: 8, right: 8, bottom: 8),
        ).onTap(() {
          ServiceListScreen(categoryId: widget.categoryList![index].id!, categoryName: widget.categoryList![index].name!).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
        }, borderRadius: BorderRadius.circular(defaultRadius.toDouble())).cornerRadiusWithClipRRect(8);
      }),
    ).paddingOnly(left: 16, right: 16, top: 16, bottom: 16);
  }
}
