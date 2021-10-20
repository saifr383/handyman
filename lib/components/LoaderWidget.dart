import 'package:booking_system_flutter/utils/Images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:nb_utils/src/extensions/context_extensions.dart';

import 'AppWidgets.dart';

class LoaderWidget extends StatefulWidget {

  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> with TickerProviderStateMixin {

  late AnimationController controller;
  late final Animation<double> _animation = CurvedAnimation(
    parent: controller,
    curve: Curves.linearToEaseOut,
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds:  1000))..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: ScaleTransition(
        scale: _animation,
        child: cachedImage(appLogo, height: 60, width: 60, fit: BoxFit.cover, alignment: Alignment.topRight),
      ).center(),
    );
  }
}
