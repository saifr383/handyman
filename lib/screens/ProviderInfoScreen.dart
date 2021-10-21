import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/GalleryImagesComponent.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/ProviderInfoResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/home/components/ServiceHorizontalListComponent.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ProviderInfoScreen extends StatefulWidget {
  final int? providerId;

  ProviderInfoScreen({this.providerId});

  @override
  ProviderInfoScreenState createState() => ProviderInfoScreenState();
}

class ProviderInfoScreenState extends State<ProviderInfoScreen> {
  ProviderInfoResponse? providerInfoResponse;
  List<String> galleryImages = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      appStore.setLoading(true);
      getProviderData();
    });
  }

  Future<void> getProviderData() async {
    getProviderDetail(widget.providerId!).then((value) {
      providerInfoResponse = value;
      providerInfoResponse!.service!.forEach((element) {
        galleryImages.addAll(element.attchments!);
      });

      appStore.setLoading(false);
      log(value);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.providerDetail, textColor: white, elevation: 1.5, color: context.primaryColor),
      body: Stack(
        children: [
          if (providerInfoResponse != null)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  8.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      cachedImage(providerInfoResponse!.data!.profile_image, height: 100, width: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(60),
                      8.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          8.height,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(providerInfoResponse!.data!.display_name.validate(), style: boldTextStyle(size: 20)),
                                Text(providerInfoResponse!.data!.providertype.validate(), style: boldTextStyle(color: primaryColor)),
                              ],
                            ),
                          ),
                          6.height,
                          if (providerInfoResponse!.data!.contact_number.validate().isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.call, size: 16),
                                6.width,
                                Text(providerInfoResponse!.data!.contact_number.validate(), style: secondaryTextStyle()),
                              ],
                            ).onTap(() {
                              launch(('tel://${providerInfoResponse!.data!.contact_number.validate()}'));
                            }),
                          4.height,
                          if (providerInfoResponse!.data!.city_name.validate().isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.location_on_sharp, size: 16),
                                6.width,
                                Text(providerInfoResponse!.data!.city_name.validate(), style: secondaryTextStyle()),
                              ],
                            ),
                        ],
                      ).expand()
                    ],
                  ).paddingSymmetric(horizontal: 16, vertical: 8),
                  Divider(thickness: 1.5),
                  8.height,
                  Text(language!.serviceList, style: boldTextStyle(size: 18)).paddingLeft(16).visible(providerInfoResponse!.service.validate().isNotEmpty),
                  ServiceHorizontalListComponent(serviceList: providerInfoResponse!.service!).visible(providerInfoResponse!.service.validate().isNotEmpty),
                  Divider(thickness: 1.5).visible(providerInfoResponse!.service.validate().isNotEmpty),
                  16.height,
                  Text(language!.serviceGallery, style: boldTextStyle(size: 18)).paddingOnly(left: 16, bottom: 8).visible(galleryImages.isNotEmpty),
                  GalleryImagesComponent(galleryImages).visible(galleryImages.isNotEmpty).paddingSymmetric(horizontal: 16),
                  16.height
                ],
              ),
            ),
          noDataFound().visible(galleryImages.isEmpty && !appStore.isLoading && providerInfoResponse != null).center(),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
