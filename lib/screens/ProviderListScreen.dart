import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/model/DashboardResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'ProviderInfoScreen.dart';

class ProviderListScreen extends StatefulWidget {
  @override
  _ProviderListScreenState createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  ScrollController scrollController = ScrollController();

  List<ProviderData> providerList = [];

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() {
      appStore.setLoading(true);
      init();
    });
  }

  void init() async {
    getHandymanList();
  }

  Future<void> getHandymanList() async {
    await getProvider().then((res) {
      providerList.addAll(res.provider!);
      log(providerList);
      appStore.setLoading(false);
      log(providerList.first);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("All Provider", textColor: white, color: context.primaryColor),
      body: Observer(
        builder: (_) => Stack(
          children: [
            ListView.builder(
              itemCount: providerList.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(16),
              itemBuilder: (_, i) {
                ProviderData data = providerList[i];
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(12),
                  decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor, blurRadius: 1, offset: Offset(1, 1)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cachedImage(data.profileImage.validate(), width: 70, height: 70, fit: BoxFit.cover).cornerRadiusWithClipRRect(35),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.displayName.validate(), style: boldTextStyle()),
                          4.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.mail_outline, size: 18, color: context.iconColor),
                              4.width,
                              Text(data.email.validate(), style: secondaryTextStyle()).expand(),
                            ],
                          ),
                          4.height,
                          Row(
                            children: [
                              Icon(Icons.call_outlined, size: 18, color: context.iconColor),
                              4.width,
                              Text(data.contactNumber.validate(), style: secondaryTextStyle()),
                            ],
                          ),
                          4.height,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on_outlined, size: 18, color: context.iconColor),
                              4.width,
                              Text(data.address.validate(), style: secondaryTextStyle()).expand(),
                            ],
                          ).visible(data.address.validate().isNotEmpty),
                        ],
                      ).expand(),
                    ],
                  ),
                ).onTap(() {
                  ProviderInfoScreen(providerId: data.id).launch(context);
                });
              },
            ),
            noDataFound().center().visible(providerList.isEmpty && !appStore.isLoading),
            LoaderWidget().center().visible(appStore.isLoading),
          ],
        ),
      ),
    );
  }
}
