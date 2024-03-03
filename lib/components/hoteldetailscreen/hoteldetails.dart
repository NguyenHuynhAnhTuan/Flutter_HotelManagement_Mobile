import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_app/Service/UserService.dart';
import 'package:travel_app/components/hoteldetailscreen/hotelbookingpage.dart';
import 'package:travel_app/components/imagecarousel/carousel.dart';
import 'package:travel_app/components/widget/snakbar.dart';
import 'package:travel_app/models/UserDto.dart';
import 'package:travel_app/models/booking_model/booking_dto.dart';
import 'package:travel_app/models/listing.dart';
import 'package:travel_app/models/room_model/room_dto.dart';
import 'package:travel_app/realm/realm_services.dart';

class Hoteldetailpage extends StatefulWidget {
  // const Hoteldetailpage({super.key, data}) : _data = data;
  // final Listingmodel _data;

  RoomDto data;
  Hoteldetailpage({super.key, required this.data});

  @override
  State<Hoteldetailpage> createState() => _HoteldetailpageState();
}

class _HoteldetailpageState extends State<Hoteldetailpage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  bool showMap = false;

  Timer? time;

  UserDto? _loggedInUser;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.677612754699826, 72.88234901045453),
    zoom: 14.4746,
  );

  DateTimeRange? _daterange;

  void delaymap() {
    time = Timer(const Duration(seconds: 4), () {
      setState(() {
        showMap = true;
      });
    });
  }

  Future<void> _fetchLoginUser() async {
    try {
      // await UserService().login('email', 'password'); // call the login method to set the user
      setState(() {
        _loggedInUser = UserService.loggedInUser; // access the stored user
        if (_loggedInUser != null) {
          print("_loggedInUser id: ${_loggedInUser?.id}");
          print("_loggedInUser username: ${_loggedInUser?.username}");
        } else {
          print("_loggedInUser is null");
        }
      });
    } catch (e) {
      print("Error fetching logged-in user data: $e");
    }
  }


  @override
  void initState() {
    _fetchLoginUser();
    super.initState();
    delaymap();
  }

  @override
  void dispose() {
    time!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var realmProvider = Provider.of<RealmServices>(context);
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0.17,
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
            ),
          ),
        ),
        child: BottomAppBar(
            height: 70,
            surfaceTintColor: Colors.transparent,
            color: Theme.of(context).colorScheme.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    var date = await showDateRangePicker(
                      context: context,
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      currentDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(
                        DateTime.now().year,
                        DateTime.now().month + 3,
                      ),
                    );
                    if (date != null) {
                      if (date.start == date.end) {
                        if (!context.mounted) return;
                        showSnakbar(
                            context, "Same date not allowed,pick again!");
                        setState(() {
                          _daterange = null;
                        });
                        return;
                      }
                      setState(() {
                        _daterange = date;
                      });
                    }
                    else {
                      showSnakbar(context, "Please select date before booking");
                    }
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "₹${_daterange != null ? widget.data.room_price! * (_daterange!.end.difference(_daterange!.start).inDays) : widget.data.room_price} total",
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(1),
                            fontSize: 17,
                          ),
                        ),
                        _daterange != null
                            ? Text(
                                // "Nov 21-30",
                                _daterange!.start.year == _daterange!.end.year
                                    ? (_daterange!.start.month ==
                                            _daterange!.end.month
                                        ? "${DateFormat.MMMMd().format(_daterange!.start)} - ${_daterange!.end.day}"
                                        : "${DateFormat.MMMMd().format(_daterange!.start)} - ${DateFormat.MMMMd().format(_daterange!.end)}")
                                    : "${DateFormat.yMd().format(_daterange!.start)} - ${DateFormat.yMd().format(_daterange!.end)}",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.4),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w100,
                                ),
                              )
                            : Text(
                                "Select date",
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.4),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                      ]),
                ),
                ElevatedButton(
                  onPressed: () {
                    // print(DateFormat('yyyy-MM-dd').format(_daterange!.start));
                    // print(DateFormat('yyyy-MM-dd').format(_daterange!.end));
                    // print("Number of Member: ${widget.data.room_capacity}");
                    // print(_loggedInUser == null ? "Please Login to Booking" : "User id: ${_loggedInUser!.id.toString()}");

                    if(_loggedInUser == null) {
                      showSnakbar(context, "Please Login to Continue Your Booking");
                      return;
                    }

                    if (_daterange == null) {
                      showSnakbar(context, "Please select date");
                      return;
                    }

                    BookingDto newBookingDto = BookingDto();
                    newBookingDto.booking_from = _daterange!.start;
                    newBookingDto.booking_to = _daterange!.end;
                    newBookingDto.number_of_member = widget.data.room_capacity;
                    newBookingDto.is_active = true;
                    newBookingDto.customer_id = _loggedInUser!.id;
                    newBookingDto.customer_info = _loggedInUser;
                    newBookingDto.room_id = widget.data.id;
                    newBookingDto.room_info = widget.data;

                    // Navigator.of(context).push(CupertinoPageRoute(
                    //         builder: (context) {
                    //           return Hotelconfirmbook(
                    //             id: widget.data.id,
                    //             bookingrange: _daterange,
                    //           );
                    //         },
                    //
                    // ));

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return Hotelconfirmbook();
                        },
                        settings: RouteSettings(
                          arguments: newBookingDto
                        ),
                      )
                    );

                    // if (realmProvider.currentUser != null &&
                    //     realmProvider.currentUser!.provider !=
                    //         AuthProviderType.anonymous) {
                    //   Navigator.of(context).push(CupertinoPageRoute(
                    //     builder: (context) {
                    //       return Hotelconfirmbook(
                    //         id: widget._data.id,
                    //         bookingrange: _daterange,
                    //       );
                    //     },
                    //   ));
                    // } else {
                    //   showSnakbar(
                    //       context, "Book hotel room plaese login first");
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    fixedSize: const Size(120, 90),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Booking",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagecarousel(id: widget.data.id, images: widget.data.room_image),
            // Image.network(widget.data.room_image.toString()),
            CachedNetworkImage(imageUrl: widget.data.room_image.toString()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.data.id} -- ${widget.data.room_no.toString()}",
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    SizedBox(height: 20,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          // FontAwesomeIcons.locationDot,
                          Icons.king_bed_outlined,
                          color: Colors.orange,
                          size: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5, top: 3),
                          child: Text(
                            "${widget.data.room_type_info!.room_type_name} BED",
                            style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withAlpha(130)),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.8),
                        thickness: 0.4,
                      ),
                    ),
                    Text(
                      widget.data.room_description.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Quicksand',
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.8),
                        thickness: 0.4,
                      ),
                    ),
                    // Text(
                    //   "What this place offers",
                    //   style: TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //     fontFamily: 'Quicksand',
                    //     color: Theme.of(context)
                    //         .colorScheme
                    //         .onPrimary
                    //         .withOpacity(1),
                    //   ),
                    // ),
                    // SizedBox(
                    //   child: ListView.builder(
                    //     padding: const EdgeInsets.all(0),
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: widget._data.facilities.length,
                    //     itemBuilder: (context, index) {
                    //       return Row(
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 vertical: 3, horizontal: 6),
                    //             child: Icon(
                    //               Icons.wifi,
                    //               color: Theme.of(context)
                    //                   .colorScheme
                    //                   .onPrimary
                    //                   .withOpacity(0.4),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 3, vertical: 6),
                    //             child: Text(
                    //               widget._data.facilities[index].fav,
                    //               style: TextStyle(
                    //                 fontSize: 15,
                    //                 fontWeight: FontWeight.w500,
                    //                 fontFamily: 'Quicksand',
                    //                 color: Theme.of(context)
                    //                     .colorScheme
                    //                     .onPrimary
                    //                     .withOpacity(1),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   ),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 5),
                    //   child: Divider(
                    //     color: Theme.of(context)
                    //         .colorScheme
                    //         .onPrimary
                    //         .withOpacity(0.8),
                    //     thickness: 0.4,
                    //   ),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 4),
                    //   child: Text(
                    //     "Where you'll be",
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.bold,
                    //       fontFamily: 'Quicksand',
                    //       color: Theme.of(context)
                    //           .colorScheme
                    //           .onPrimary
                    //           .withOpacity(1),
                    //     ),
                    //   ),
                    // ),
                    // showMap
                    //     ? SizedBox(
                    //         height: 300,
                    //         child: ClipRRect(
                    //           borderRadius:
                    //               const BorderRadius.all(Radius.circular(10)),
                    //           child: GoogleMap(
                    //             mapType: MapType.normal,
                    //             zoomGesturesEnabled: true,
                    //             zoomControlsEnabled: true,
                    //             initialCameraPosition: _kGooglePlex,
                    //             onMapCreated: (GoogleMapController controller) {
                    //               _controller.complete(controller);
                    //             },
                    //             myLocationEnabled: true,
                    //             compassEnabled: true,
                    //           ),
                    //         ),
                    //       )
                    //     : ClipRRect(
                    //         borderRadius: BorderRadius.circular(10),
                    //         child: SizedBox(
                    //           height: 300,
                    //           child: Shimmer(
                    //             gradient: const LinearGradient(
                    //               colors: [
                    //                 Color(0xFFEBEBF4),
                    //                 Color(0xFFF4F4F4),
                    //                 Color(0xFFEBEBF4),
                    //               ],
                    //               stops: [
                    //                 0.1,
                    //                 0.3,
                    //                 0.4,
                    //               ],
                    //               begin: Alignment(-1.0, -0.3),
                    //               end: Alignment(1.0, 0.3),
                    //               tileMode: TileMode.clamp,
                    //             ),
                    //             child: Container(
                    //               height: 300,
                    //               color: Colors.grey,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
