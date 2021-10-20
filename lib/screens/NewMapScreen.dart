import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_utils/nb_utils.dart';

class NewMapScreen extends StatefulWidget {
  @override
  NewMapScreenState createState() => NewMapScreenState();
}

class NewMapScreenState extends State<NewMapScreen> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  late GoogleMapController mapController;

  late Position _currentPosition;
  String _currentAddress = '';

  final destinationAddressController = TextEditingController();
  final desrinationAddressFocusNode = FocusNode();

  String _destinationAddress = '';
  double? _destinationLat;
  double? _destinationLong;

  Set<Marker> markers = {};

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _getAddress();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(getDoubleAsync(LATITUDE), getDoubleAsync(LONGITUDE)), zoom: 18.0),
          ),
        );
        markers.add(Marker(
          markerId: MarkerId(_currentAddress),
          position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          infoWindow: InfoWindow(
            title: 'Start $_currentAddress',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(getDoubleAsync(LATITUDE), getDoubleAsync(LONGITUDE));
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        destinationAddressController.text = _currentAddress;
        _destinationAddress = _currentAddress;

        Marker startMarker = Marker(
          markerId: MarkerId(_currentAddress),
          position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          infoWindow: InfoWindow(
            title: 'Start $_currentAddress',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
      });
    } catch (e) {
      print(e);
    }
  }

  //retriving a destination location
  getDestinationAddress(String destination) async {
    log(destination);
    try {
      List<Location> destinationPlacemark = await locationFromAddress(destination);
      log(destinationPlacemark);
      setState(() {
        _destinationLat = destinationPlacemark[0].latitude;
        _destinationLong = destinationPlacemark[0].longitude;
        _destinationAddress = destinationAddressController.text;
        markers.clear();
        markers.add(Marker(
          markerId: MarkerId(destinationPlacemark.toString()),
          position: LatLng(_destinationLat!, _destinationLong!),
          infoWindow: InfoWindow(),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        ));
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_destinationLat!, _destinationLong!), zoom: 18.0),
        ),
      );
    } catch (e) {
      log(e);
    }
  }

  _handleTap(LatLng point) async {
    log(point);
    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });
    List<Placemark> placeMark = await placemarkFromCoordinates(point.latitude, point.longitude);
    Placemark place = placeMark[0];
    log(_destinationAddress);

    setState(() {
      _destinationLat = point.latitude;
      _destinationLong = point.longitude;
      _destinationAddress = "${place.name != null ? place.name : place.subThoroughfare}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}, ${place.country}";
      destinationAddressController.text = _destinationAddress;
    });
    // setValue(CURRENT_ADDRESS, address);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height(),
      width: context.width(),
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              onTap: _handleTap,
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // inkwell color
                        child: SizedBox(width: 50, height: 50, child: Icon(Icons.add)),
                        onTap: () {
                          mapController.animateCamera(CameraUpdate.zoomIn());
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ClipOval(
                    child: Material(
                      color: Colors.blue.shade100, // button color
                      child: InkWell(
                        splashColor: Colors.blue, // inkwell color
                        child: SizedBox(width: 50, height: 50, child: Icon(Icons.remove)),
                        onTap: () {
                          mapController.animateCamera(CameraUpdate.zoomOut());
                        },
                      ),
                    ),
                  ),
                ],
              ).paddingLeft(10),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.orange.shade100, // button color
                      child: Icon(Icons.my_location, size: 25).paddingAll(10),
                    ),
                  ).paddingRight(8).onTap(() {
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 18.0),
                      ),
                    );
                  }),
                  8.height,
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppTextField(
                        textFieldType: TextFieldType.ADDRESS,
                        controller: destinationAddressController,
                        focus: desrinationAddressFocusNode,
                        textStyle: primaryTextStyle(color: black),
                        decoration: inputDecoration(context, hint: language!.hintAddress),
                      ),
                      8.height,
                      AppButton(
                        width: context.width(),
                        height: 16,
                        color: primaryColor,
                        text: language!.getLocation.toUpperCase(),
                        textStyle: boldTextStyle(color: white, size: 12),
                        onTap: (_destinationAddress != '')
                            ? () async {
                                desrinationAddressFocusNode.unfocus();
                                getDestinationAddress(destinationAddressController.text);
                              }
                            : null,
                      ),
                    ],
                  ),
                  4.height,
                  AppButton(
                    width: context.width(),
                    height: 16,
                    color: primaryColor,
                    text:language!.setAddress.toUpperCase(),
                    textStyle: boldTextStyle(color: white, size: 12),
                    onTap: (_destinationAddress != '')
                        ? () async {
                            desrinationAddressFocusNode.unfocus();
                            setValue(LATITUDE, _destinationLat);
                            setValue(LONGITUDE, _destinationLong);
                            setValue(CURRENT_ADDRESS, _destinationAddress);
                            finish(context, true);
                          }
                        : null,
                  ),
                  8.height,
                ],
              ).paddingAll(10),
            )
          ],
        ),
      ),
    );
  }
}
