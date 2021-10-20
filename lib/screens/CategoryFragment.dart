import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/DashboardResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'home/components/CategoryComponent.dart';

class CategoryFragment extends StatefulWidget {


  @override
  CategoryFragmentState createState() => CategoryFragmentState();
}

class CategoryFragmentState extends State<CategoryFragment> with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();

  List<Category> categoryList = [];

  int totalPage = 0;
  int currentPage = 1;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {

      appStore.setLoading(true);
    });
    getCategoryList(currentPage, perPage: "all").then((value) {
      totalItems = value.pagination!.total_items!;
      if (totalItems != 0) {
        categoryList.addAll(value.data.validate());
        totalPage = value.pagination!.totalPages!;
        currentPage = value.pagination!.currentPage!;
      }
      setState(() {});

      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString(), print: true);
      appStore.setLoading(false);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @mustCallSuper
  @override
  Widget build(BuildContext context) {

    super.build(context);
    return Scaffold(
      appBar: appBarWidget(language!.category, textColor: white, showBack: false, elevation: 3.0, color: context.primaryColor),
      body: RefreshIndicator(
        onRefresh: () {
          return init();
        },
        child: Stack(
          children: [
            CategoryComponent(categoryList: categoryList),
            noDataFound().center().visible(categoryList.isEmpty && !appStore.isLoading),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
