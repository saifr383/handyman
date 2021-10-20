import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/components/ServiceComponent.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/ServiceModel.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListScreen extends StatefulWidget {
  final int? categoryId;
  final String? categoryName;

  ServiceListScreen({this.categoryId, this.categoryName = ''});

  @override
  ServiceListScreenState createState() => ServiceListScreenState();
}

class ServiceListScreenState extends State<ServiceListScreen> {
  ScrollController scrollController = ScrollController();

  List<Service> serviceList = [];
  List<Service> serviceData = [];

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
    log(widget.categoryId);
    if (widget.categoryId != null) {
      if (appStore.isCurrentLocation) {
        getServices(enable: appStore.isCurrentLocation, categoryId: widget.categoryId);
      } else {
        getServices(enable: appStore.isCurrentLocation, categoryId: widget.categoryId);
      }
    } else {
      getServices(enable: appStore.isCurrentLocation);
    }

    scrollController.addListener(() {
      if (currentPage <= totalPage) {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          currentPage++;
          appStore.setLoading(true);
          if (widget.categoryId != null) if (appStore.isCurrentLocation) {
            getServices(enable: appStore.isCurrentLocation, categoryId: widget.categoryId);
          } else {
            getServices(enable: appStore.isCurrentLocation, categoryId: widget.categoryId);
          }
          else
            getServices(enable: appStore.isCurrentLocation);
        }
      } else {
        appStore.setLoading(false);
      }
    });
  }

  Future<void> getServices({required bool enable, int? categoryId, double? lat, double? long}) async {
    getServiceList(currentPage,
            isCurrentLocation: enable,
            categoryId: categoryId,
            isCategoryWise: categoryId != null ? true : false,
            customerId: appStore.userId,
            lat: getDoubleAsync(LATITUDE),
            long: getDoubleAsync(LONGITUDE))
        .then((value) {
      totalItems = value.pagination!.total_items!;
      if (totalItems != 0) {
        serviceList.addAll(value.data!);
        print(value);

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
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        finish(context, true);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: appBarWidget(widget.categoryName!.isEmpty ? language!.allServices : '${widget.categoryName.validate()}', backWidget: BackButton(
          onPressed: () {
            finish(context, true);
          },
        ), textColor: white, color: context.primaryColor, actions: [
          Observer(
            builder: (_) => GestureDetector(
                onTap: () {
                  if (appStore.isCurrentLocation) {
                    appStore.setCurrentLocation(false);

                    snackBar(context, title: language!.toastLocationOff);
                  } else {
                    appStore.setCurrentLocation(true);
                    snackBar(context, title: language!.toastLocationOn);
                  }
                  appStore.setCurrentLocation(appStore.isCurrentLocation);
                  serviceList.clear();
                  init();
                },
                child: Container(
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.all(4),
                    decoration: boxDecorationWithShadow(boxShape: BoxShape.circle),
                    child: Icon(Icons.my_location, size: 20, color: appStore.isCurrentLocation ? primaryColor : grey))),
          )
        ]),
        body: Observer(
          builder: (_) => Stack(
            children: [
              RefreshIndicator(
                backgroundColor: context.cardColor,
                onRefresh: () {
                  return init();
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: serviceList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 40),
                  itemBuilder: (_, i) {
                    Service data = serviceList[i];
                    return ServiceComponent(
                        serviceData: data,
                        onChanged: () {
                          serviceList.clear();
                          appStore.setLoading(true);
                          currentPage = 1;
                          init();
                          setState(() {});
                        });
                  },
                ),
              ),
              noDataFound().center().visible(serviceList.isEmpty && !appStore.isLoading),
              LoaderWidget().center().visible(appStore.isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
