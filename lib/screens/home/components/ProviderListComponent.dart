import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/model/DashboardResponse.dart';
import 'package:booking_system_flutter/screens/ProviderInfoScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nb_utils/nb_utils.dart';

class ProviderListComponent extends StatefulWidget {
  final List<ProviderData>? providerList;

  ProviderListComponent({this.providerList});

  @override
  ProviderListComponentState createState() => ProviderListComponentState();
}

class ProviderListComponentState extends State<ProviderListComponent> {
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
    return HorizontalList(
      wrapAlignment: WrapAlignment.spaceEvenly,
      itemCount: widget.providerList!.take(6).length,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      spacing: 8,
      itemBuilder: (_, i) {
        ProviderData data = widget.providerList![i];
        return Container(
          width: context.width() * 0.4,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(right: 8),
          decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              cachedImage(data.profileImage, height: 100, width: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(50),
              8.height,
              Text(data.displayName.validate(), style: boldTextStyle()),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, size: 14),
                  4.width,
                  Text(data.contactNumber.validate().isNotEmpty ? data.contactNumber.validate() : '', style: secondaryTextStyle()),
                ],
              ),
              8.height,
              Text(data.providertype.validate(), style: boldTextStyle(size: 14, color: primaryColor), textAlign: TextAlign.center),
            ],
          ),
        ).onTap(() {
          ProviderInfoScreen(providerId: data.id).launch(context);
        });
      },
    );
  }
}
