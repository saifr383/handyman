import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/Images.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'DashboardScreen.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  List<WalkThroughModelClass> pages = [];
  int currentPosition = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() async {
      await setValue(IS_FIRST_TIME, false);
      pages.add(WalkThroughModelClass(title: language!.walkTitle1, image: walk_Img1, subTitle: language!.walkThrough1));
      pages.add(WalkThroughModelClass(title: language!.walkTitle2, image: walk_Img2, subTitle: language!.walkThrough2));
      pages.add(WalkThroughModelClass(title: language!.walkTitle3, image: walk_Img3, subTitle: language!.walkThrough3));

      setState(() {});
    });
  }

  init() async {
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            child: Arc(
              arcType: ArcType.CONVEX,
              edge: Edge.TOP,
              height: 50,
              child: Container(height: context.height() * 0.5, width: context.width(), color: primaryColor.withOpacity(0.5)),
            ),
          ),

          if (pages.isNotEmpty)
            PageView.builder(
              itemCount: pages.length,
              itemBuilder: (BuildContext context, int index) {
                WalkThroughModelClass page = pages[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    (context.height() * 0.1).toInt().height,
                    if (page.image != null) Image.asset(page.image!, height: context.height() * 0.48),
                    16.height,
                    Text(page.title.toString().toUpperCase(), style: boldTextStyle(size: 24, color: white), textAlign: TextAlign.center),
                    16.height,
                    Text(page.subTitle.toString(), style: secondaryTextStyle(color: white), textAlign: TextAlign.center),
                  ],
                ).paddingOnly(left: 8, right: 8);
              },
              controller: pageController,
              scrollDirection: Axis.horizontal,
              onPageChanged: (num) {
                currentPosition = num + 1;
                setState(() {});
              },
            ),
          Positioned(
            top: 30,
            right: 10,
            child: TextButton(
              onPressed: () async {
                await setValue(IS_FIRST_TIME, false);
                DashboardScreen().launch(context, isNewTask: true);
              },
              child: Text(language!.lblSkip, style: boldTextStyle(color: primaryColor)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DotIndicator(
                pageController: pageController,
                pages: pages,
                indicatorColor: primaryColor,
                unselectedIndicatorColor: white,
                currentBoxShape: BoxShape.rectangle,
                boxShape: BoxShape.rectangle,
                borderRadius: radius(2),
                currentBorderRadius: radius(3),
                currentDotSize: 18,
                currentDotWidth: 6,
                dotSize: 6,
              ).paddingBottom(22),
              AppButton(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                text: language!.getStarted,
                textStyle: boldTextStyle(color: white),
                color: primaryColor,
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                onTap: () async {
                  await setValue(IS_FIRST_TIME, false);
                  DashboardScreen().launch(context, isNewTask: true);
                },
              ).visible(currentPosition == 3),
              AppButton(
                height: 20,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                text: language!.btnNext,
                textStyle: boldTextStyle(color: white),
                color: primaryColor,
                shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                onTap: () async {
                  pageController.nextPage(duration: 500.milliseconds, curve: Curves.linearToEaseOut);
                },
              ).visible(currentPosition < 3),
            ],
          ).paddingBottom(60),
        ],
      ),
    );
  }
}
