import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/components/ServiceComponent.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/ServiceModel.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class SearchServiceScreen extends StatefulWidget {
  @override
  SearchServiceScreenState createState() => SearchServiceScreenState();
}

class SearchServiceScreenState extends State<SearchServiceScreen> {
  TextEditingController searchCont = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<Service> serviceList = [];

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  Future<void> init() async {
    getServices();
    scrollController.addListener(() {
      if (currentPage <= totalPage) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          currentPage++;
          appStore.setLoading(true);
          if (searchCont.text.isNotEmpty) {
            appStore.setLoading(false);
            getServices(searchText: searchCont.text);
          } else {
            appStore.setLoading(false);
            getServices();
          }
        }
      } else {
        appStore.setLoading(false);
      }
    });
  }

  Future<void> getServices({String? searchText, double? lat, double? long}) async {
    getServiceList(currentPage,
            isCurrentLocation: appStore.isCurrentLocation, searchTxt: searchText, isSearch: searchText != null ? true : false, lat: getDoubleAsync(LATITUDE), long: getDoubleAsync(LONGITUDE))
        .then((value) {
      totalItems = value.pagination!.total_items!;
      if (totalItems != 0) {
        serviceList.addAll(value.data!);
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("",
          titleWidget: Container(
            margin: EdgeInsets.only(top: 8),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? context.cardColor : secondaryPrimaryColor),
            child: AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: searchCont,
              onChanged: (v) {
                if (v.length > 0) {
                  serviceList.clear();
                  getServices(searchText: v);
                } else {
                  getServices();
                }
              },
              decoration: InputDecoration(
                hintText: language!.search,
                contentPadding: EdgeInsets.all(16),
                hintStyle: secondaryTextStyle(size: 16, color: primaryColor),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                prefixIcon: Icon(Icons.arrow_back, color: primaryColor, size: 24).onTap(() {
                  finish(context);
                }),
              ),
              suffix: Icon(Icons.search, color: primaryColor),
            ),
          ),
          elevation: 0,
          color: transparentColor,
          showBack: false),
      body: Observer(
        builder: (_) => Stack(
          children: [
            ListView.builder(
              controller: scrollController,
              itemCount: serviceList.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 8, right: 8),
              itemBuilder: (_, i) {
                Service data = serviceList[i];
                return ServiceComponent(serviceData: data);
              },
            ),
            noDataFound().center().visible(serviceList.isEmpty && !appStore.isLoading),
            LoaderWidget().center().visible(appStore.isLoading),
          ],
        ),
      ),
    );
  }
}
