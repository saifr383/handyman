import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ThemeSelectionDaiLog extends StatefulWidget {
  @override
  ThemeSelectionDaiLogState createState() => ThemeSelectionDaiLogState();
}

class ThemeSelectionDaiLogState extends State<ThemeSelectionDaiLog> {
  List<String> themeModeList = [language!.appThemeLight, language!.appThemeDark, language!.appThemeDefault];

  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 16),
        itemCount: themeModeList.length,
        itemBuilder: (BuildContext context, int index) {
          return RadioListTile(
            value: index,activeColor: primaryColor,
            groupValue: currentIndex,
            title: Text(themeModeList[index], style: primaryTextStyle()),
            onChanged: (dynamic val) async {
              currentIndex = val;

              if (val == ThemeModeSystem) {
                appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
              } else if (val == ThemeModeLight) {
                appStore.setDarkMode(false);
              } else if (val == ThemeModeDark) {
                appStore.setDarkMode(true);
              }
              await setValue(THEME_MODE_INDEX, val);
              setState(() {});

              finish(context);
            },
          );
        },
      ),
    );
  }
}
