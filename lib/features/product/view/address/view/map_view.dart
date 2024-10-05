import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
class AddressMapView extends StatefulWidget {
  const AddressMapView({super.key, required this.onLocationSelect});

  final Function(LatLng? latLng, String? address, String? cc) onLocationSelect;

  @override
  State<AddressMapView> createState() => AddressMapViewState();
}

class AddressMapViewState extends State<AddressMapView> {
  bool btLoad = false;
  // String address = '';
  String? country;

  LatLng? current;
  final markerId = const MarkerId('self');
  bool mkLoad = false;
  final txCtrl = TextEditingController();

  final _controller = Completer<GoogleMapController>();

  @override
  void dispose() {
    txCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    final location = Location();

    bool service;
    PermissionStatus permission;
    LocationData loc;

    service = await location.serviceEnabled();
    if (!service) {
      service = await location.requestService();
      if (!service) {
        Toaster.showError('Please enable location service');
        return;
      }
    }

    permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        Toaster.showError('Please grant location permission');
        return;
      }
    }

    loc = await location.getLocation();
    final latLng = LatLng(loc.latitude!, loc.longitude!);
    current = latLng;
    await getAddressString(latLng);
    if (mounted) setState(() {});
    await animateToCurrent();
  }

  getAddressString(LatLng latlng) async {
    final LatLng(:latitude, :longitude) = latlng;
    final place = await geo.placemarkFromCoordinates(latitude, longitude);

    final loc = place.firstOrNull;

    if (loc == null) return;

    txCtrl.text =
        '${loc.street}, ${loc.subLocality}, ${loc.locality}, ${loc.country}';

    country = loc.isoCountryCode;
  }

  Future<void> searchAddress() async {
    final place = await geo.locationFromAddress(txCtrl.text);
    final loc = place.firstOrNull;
    if (loc == null) return;
    Logger.json(place.map((e) => e.toJson()).toList());
    current = LatLng(loc.latitude, loc.longitude);
    setState(() {});
    await animateToCurrent();
  }

  Future<void> animateToCurrent() async {
    if (current == null) return;
    final ctrl = await _controller.future;
    ctrl.animateCamera(CameraUpdate.newLatLng(current!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        leading: IconButton(
          onPressed: () {
            widget.onLocationSelect(current, txCtrl.text, country);
            context.nPop();
          },
          icon: const Icon(Icons.done_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () => context.nPop(),
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          if (current == null)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:
                    CameraPosition(target: current!, zoom: 14),
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                onTap: (latLng) {
                  current = latLng;
                  getAddressString(latLng);
                  setState(() {});
                },
                markers: {
                  Marker(
                    markerId: markerId,
                    position: current!,
                    flat: true,
                    draggable: true,
                    onDragEnd: (value) => setState(() {
                      current = value;
                      getAddressString(value);
                    }),
                  ),
                },
              ),
            ),
          Container(
            color: context.colors.surface,
            padding: defaultPaddingAll,
            width: context.width,
            child: Row(
              children: [
                Flexible(
                  child: TextField(
                    controller: txCtrl,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      suffixIcon: IconButton(
                        onPressed: () => searchAddress(),
                        icon: const Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                ),
                const Gap(Insets.med),
                IconButton.filled(
                  onPressed: () async {
                    setState(() => btLoad = true);
                    await getLocation();
                    setState(() => btLoad = false);
                  },
                  icon: btLoad
                      ? SizedBox.square(
                          dimension: 24,
                          child: CircularProgressIndicator(
                            color: context.colors.onPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.location_on),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
