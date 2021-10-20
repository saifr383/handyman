import 'dart:ui';

import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/screens/BookingFragment.dart';
import 'package:booking_system_flutter/screens/CategoryFragment.dart';
import 'package:booking_system_flutter/screens/ProfileFragment.dart';
import 'package:booking_system_flutter/screens/SignInScreen.dart';
import 'package:booking_system_flutter/screens/home/HomeFragment.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'booking/BookingDetailScreen.dart';
import 'ChatFragment.dart';

class DashboardScreen extends StatefulWidget {
  final int? index;

  DashboardScreen({this.index});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<Widget> fragmentList = [
    HomeFragment(),
    CategoryFragment(),
    BookingFragment(),
    ChatFragment(),
    ProfileFragment(),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      setStatusBarColor(black.withOpacity(0.1), statusBarIconBrightness: Brightness.dark);

      if (isMobile) {
        OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult notification) async {
          if (notification.notification.additionalData!.containsKey('ID')) {
            String? notId = notification.notification.additionalData!["ID"];
            if (notId.validate().isNotEmpty) {
              BookingDetailScreen( bookingId: notId.toString().toInt()).launch(context);
            }
          }
        });
      }

      await Future.delayed(Duration(milliseconds: 400));

      if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      window.onPlatformBrightnessChanged = () async {
        if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem) {
          appStore.setDarkMode(context.platformBrightness() == Brightness.light);
        }
      };
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: fragmentList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(AntDesign.home, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(AntDesign.home, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(AntDesign.codepen, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(AntDesign.codepen, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(AntDesign.book, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(AntDesign.book, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.ios_chatbox_outline, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(Ionicons.ios_chatbox_outline, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Feather.user, color: Colors.grey.shade400),
            label: '',
            activeIcon: Column(
              children: [
                Icon(Feather.user, color: primaryColor),
                6.height,
                Container(width: 25, height: 4, color: primaryColor).cornerRadiusWithClipRRect(8),
              ],
            ),
          ),
        ],
        onTap: (index) {
          if ((index != 2 || (index == 2 && appStore.isLoggedIn)) && (index != 3 || (index == 3 && appStore.isLoggedIn))) {
           print(index);
            currentIndex = index;
          } else {
            SignInScreen().launch(context);
          }
          setState(() {});
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
