import 'package:booking_system_flutter/components/FavouriteItemWidget.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/model/wishListResponse.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  List<WishListResponse> wishListResponse = [];
  List<Wishlist> wishList = [];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  Future<void> init() async {
    fetchWishListData();
  }

  Future<void> fetchWishListData() async {
    appStore.setLoading(true);

    getWishlist().then((res) {
      appStore.setLoading(false);
      wishList.addAll(res.data!);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.lblFavorite, color: context.primaryColor, textColor: white),
      body: Stack(
        children: [
          if (wishList.isNotEmpty)
            StaggeredGridView.countBuilder(
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              itemCount: wishList.length,
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 12.0,
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                Wishlist data = wishList[index];

                return FavouriteItemWidget(
                  data: data,
                  onChanged: () {
                    wishList.clear();
                    fetchWishListData();
                  },
                );
              },
            ),
          noDataFound().center().visible(!appStore.isLoading && wishList.isEmpty),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
