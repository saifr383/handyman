import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/DashboardScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/Images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'WalkThroughScreen.dart';
import 'booking/BookingDetailScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setStatusBarColor(black.withOpacity(0.1), statusBarIconBrightness: Brightness.dark);
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      await 2.seconds.delay;
      await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: defaultLanguage));
      int themeModeIndex = getIntAsync(THEME_MODE_INDEX);

      if (themeModeIndex == ThemeModeSystem) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
      }
      if (getBoolAsync(IS_FIRST_TIME, defaultValue: true)) {
        WalkThroughScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
      } else {
        DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80,
              width: 80,
              decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: primaryColor),
              child: Image.asset(appLogo, height: 100, width: 100).center(),
            ),
            16.height,
            Text(mAppName, style: primaryTextStyle(size: 22)),
          ],
        ),
      ),
    );
  }
}
