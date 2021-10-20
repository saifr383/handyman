import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Images.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../main.dart';
import 'Constant.dart';

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'images/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'images/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'images/flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'Gujarati', languageCode: 'gu', fullLanguageCode: 'gu-GU', flag: 'images/flag/ic_india.png'),
    LanguageDataModel(id: 5, name: 'African', languageCode: 'af', fullLanguageCode: 'ar-AF', flag: 'images/flag/ic_af.png'),
    LanguageDataModel(id: 6, name: 'Dutch', languageCode: 'nl', fullLanguageCode: 'nl-NL', flag: 'images/flag/ic_nl.png'),
    LanguageDataModel(id: 7, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'images/flag/ic_fr.png'),
    LanguageDataModel(id: 8, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'images/flag/ic_de.png'),
    LanguageDataModel(id: 9, name: 'Indonesian', languageCode: 'id', fullLanguageCode: 'id-ID', flag: 'images/flag/ic_id.png'),
    LanguageDataModel(id: 10, name: 'Spanish', languageCode: 'es', fullLanguageCode: 'es-ES', flag: 'images/flag/ic_es.jpg'),
    LanguageDataModel(id: 11, name: 'Turkish', languageCode: 'tr', fullLanguageCode: 'tr-TR', flag: 'images/flag/ic_tr.png'),
    LanguageDataModel(id: 12, name: 'Vietnam', languageCode: 'vi', fullLanguageCode: 'vi-VI', flag: 'images/flag/ic_vi.png'),
    LanguageDataModel(id: 13, name: 'Albanian', languageCode: 'sq', fullLanguageCode: 'sq-SQ', flag: 'images/flag/ic_arbanian.png'),
    LanguageDataModel(id: 14, name: 'Portugal', languageCode: 'pt', fullLanguageCode: 'pt-PT', flag: 'images/flag/ic_pt.png'),
  ];
}

InputDecoration inputDecoration(BuildContext context, {String? hint, Widget? prefixIcon}) {
  return InputDecoration(
    labelStyle: TextStyle(color: Theme.of(context).textTheme.headline6!.color),
    contentPadding: EdgeInsets.all(8),
    hintText: hint,
    hintStyle: secondaryTextStyle(),
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(defaultRadius),
      borderSide: BorderSide(color: viewLineColor, width: 1.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(defaultRadius),
      borderSide: BorderSide(color: primaryColor, width: 1.0),
    ),
  );
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

Widget noDataFound() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      cachedImage(notDataFoundImg, height: 200, fit: BoxFit.cover),
      16.height,
      Text(language!.noDataAvailable, style: boldTextStyle()),
    ],
  );
}

Color statusColor(String? status) {
  Color color = primaryColor;
  switch (status.validate().toLowerCase()) {
    case "pending":
      return pendingColor;
    case "processing":
      return processingColor;
    case "on-hold":
      return primaryColor;
    case "completed":
      return completeColor;
    case "cancelled":
      return cancelledColor;
    case "refunded":
      return refundedColor;
    case "failed":
      return failedColor;
    case "accept":
      return Colors.green;
  }
  return color;
}

Future<String> getUserLocation() async {
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);

  setValue(LATITUDE, position.latitude);
  setValue(LONGITUDE, position.longitude);
  Placemark place = placeMark[0];

  String address = "${place.name != null ? place.name : place.subThoroughfare}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
  setValue(CURRENT_ADDRESS, address);
  return address;
}

String formatDate(String? dateTime) {
  return "${DateFormat.yMd().add_jm().format(DateTime.parse(dateTime.validate()))}";
}

Future<void> saveOneSignalPlayerId() async {
  await OneSignal.shared.getDeviceState().then((value) async {
    if (value!.userId.validate().isNotEmpty) await setValue(PLAYERID, value.userId.validate());
    log('notification player id ' + value.toString());
  }).catchError((e) {
    toast(e.toString());
  });
}

Widget statusButton(double width, String btnTxt, Color color, Color txtcolor) {
  return Container(
    alignment: Alignment.center,
    width: width,
    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
    decoration: boxDecorationWithShadow(borderRadius: radius(4), offset: Offset(1, 4), backgroundColor: color, border: Border.all(color: primaryColor)),
    child: Text(
      btnTxt,
      style: boldTextStyle(color: txtcolor),
      textAlign: TextAlign.justify,
    ),
  );
}

String storeBaseURL() {
  return isAndroid ? playStoreUrl : appStoreBaseUrl;
}

Widget setLoading({BuildContext? context}) {
  return Container(
    padding: EdgeInsets.all(8),
    decoration: boxDecorationWithRoundedCorners(backgroundColor: primaryColor.withOpacity(0.25), borderRadius: radius(60)),
    child: cachedImage(loaderGif, height: 80, width: 80, fit: BoxFit.cover),
  ).center();

}

Brightness getSystemIconBrightness() {
  return appStore.isDarkMode ? Brightness.light : Brightness.dark;
}

Brightness getSystemBrightness() {
  return appStore.isDarkMode ? Brightness.dark : Brightness.light;
}

Color getRateColor(num rating) {
  if (rating.validate() == 1) {
    return primaryColor;
  } else if (rating.validate() == 2) {
    return yellowColor;
  } else if (rating.validate() == 3) {
    return yellowColor;
  } else {
    return Color(0xFF66953A);
  }
}

bool get isRTL => RTLLanguage.contains(appStore.selectedLanguageCode);

bool get isSocialLogin => getStringAsync(LOGIN_TYPE) == LoginTypeGoogle;