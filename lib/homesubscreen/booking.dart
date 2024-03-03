import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import 'package:travel_app/Service/UserService.dart';
import 'package:travel_app/Service/booking_service.dart';
import 'package:travel_app/Service/room_service.dart';
import 'package:travel_app/components/booking/Hotelcard.dart';
import 'package:travel_app/components/booking/Hotelcardskeleton.dart';
import 'package:travel_app/models/UserDto.dart';
import 'package:travel_app/models/booking_model/search_dto.dart';
import 'package:travel_app/models/listing.dart';
import 'package:travel_app/models/room_model/room_dto.dart';
import 'package:travel_app/realm/realm_services.dart';
import 'package:travel_app/realm/schemas.dart';
import 'package:travel_app/screens/locationscree.dart';

class Bookingpage extends StatefulWidget {
  const Bookingpage({super.key});

  @override
  State<Bookingpage> createState() => _BookingpageState();
}

class _BookingpageState extends State<Bookingpage> {
  String _selectedLocation = "India";
  String _country = "IND";
  int _guestCount = 0;
  int _roomCount = 0;
  int _price = 0;
  final List<int> _hotels = [1, 2, 3, 4, 5, 6, 7, 8];

  //My Code
  List<RoomDto> roomList = [];
  TextEditingController _bookingFromController = TextEditingController();
  TextEditingController _bookingToController = TextEditingController();
  TextEditingController _fromPriceController = TextEditingController();
  TextEditingController _toPriceController = TextEditingController();
  int _roomTypeId = 0;

  UserDto? _loggedInUser;

  //

  StreamSubscription? connectiontrip;
  bool _isHoteloffline = true;

  void checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile) {
      setState(() {
        _isHoteloffline = false;
      });
    } else if (result == ConnectivityResult.wifi) {
      setState(() {
        _isHoteloffline = false;
      });
    } else if (result == ConnectivityResult.ethernet) {
      setState(() {
        _isHoteloffline = false;
      });
    } else if (result == ConnectivityResult.bluetooth) {
      setState(() {
        _isHoteloffline = false;
      });
    } else if (result == ConnectivityResult.none) {
      setState(() {
        _isHoteloffline = true;
      });
    }
  }

  Future<void> getAllRoomData() async {
    final data = await RoomService.getAllRoom();
    setState(() {
      roomList = data;
    });
  }

  Future<void> getAllRoomDataBySearch(SearchDto searchDto) async {
    final data = await BookingService.availableRoomForBooking(searchDto);

    setState(() {
      roomList = data;
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
    print(_isHoteloffline);
    getAllRoomData();
    _fetchLoginUser();
    checkConnectivity();
    connectiontrip = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          _isHoteloffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          _isHoteloffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          _isHoteloffline = false;
        });
      } else if (result == ConnectivityResult.ethernet) {
        //connection is from wired connection
        setState(() {
          _isHoteloffline = false;
        });
      } else if (result == ConnectivityResult.bluetooth) {
        //connection is from bluetooth threatening
        setState(() {
          _isHoteloffline = false;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    connectiontrip!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverAppBar(
          toolbarHeight: 45,
          surfaceTintColor: Colors.transparent,
          title: Text("Our Rooms"),
          floating: true,
          snap: true,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        // SliverAppBar(
        //   automaticallyImplyLeading: false,
        //   surfaceTintColor: Colors.transparent,
        //   pinned: true,
        //   bottom: PreferredSize(
        //     preferredSize: const Size.fromHeight(1),
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       child: MySeparator(color: Colors.grey[300]!),
        //     ),
        //   ),
        //   toolbarHeight: 45,
        //   title: InkWell(
        //     splashColor: Colors.transparent,
        //     highlightColor: Colors.transparent,
        //     focusColor: Colors.transparent,
        //     hoverColor: Colors.transparent,
        //     onTap: () async {
        //       final Map<String, dynamic>? country = await Navigator.push(
        //         context,
        //         CupertinoDialogRoute(
        //           builder: (context) {
        //             return const Setlocationscreen();
        //           },
        //           context: context,
        //         ),
        //       );
        //       if (country != null) {
        //         setState(() {
        //           _country = country["countryCode"];
        //           _selectedLocation = country["selectedCountry"];
        //         });
        //       }
        //     },
        //     child: Row(
        //       children: [
        //         const Icon(
        //           Icons.location_on,
        //           color: Colors.orange,
        //         ),
        //         Text(
        //           _selectedLocation.length > 18
        //               ? "${_selectedLocation.substring(0, 17)}..."
        //               : _selectedLocation,
        //           style: const TextStyle(
        //             fontFamily: "Quicksand",
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        //
        SliverToBoxAdapter(
          child: CupertinoTextField(
            controller: _bookingFromController,
            placeholder: "Choose Booking From",
            prefix: Text("Booking From"),
            readOnly: true,
            decoration: BoxDecoration(),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context, initialDate: DateTime.now(),
                  firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101)
              );

              if(pickedDate != null ){
                print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  _bookingFromController.text = formattedDate; //set output date to TextField value.
                });
              }else{
                print("Date is not selected");
              }
            },
          ),
        ),
        SliverToBoxAdapter(
          child: CupertinoTextField(
            controller: _bookingToController,
            placeholder: "Choose Booking To",
            prefix: Text("Booking To"),
            readOnly: true,
            decoration: BoxDecoration(),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context, initialDate: DateTime.now(),
                  firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101)
              );

              if(pickedDate != null ){
                print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                //you can implement different kind of Date Format here according to your requirement

                setState(() {
                  _bookingToController.text = formattedDate; //set output date to TextField value.
                });
              }else{
                print("Date is not selected");
              }
            },
          ),
        ),
        SliverToBoxAdapter(
          child: CupertinoTextField(
            controller: _fromPriceController,
            placeholder: "Enter From Price",
            prefix: Text("From Price"),
            decoration: BoxDecoration(),
            onChanged: (value) {
              print(value);
              print("txtEditingController: " + _fromPriceController.text);
            },
          ),
        ),
        SliverToBoxAdapter(
          child: CupertinoTextField(
            controller: _toPriceController,
            placeholder: "Enter To Price",
            prefix: Text("To Price"),
            decoration: BoxDecoration(),
            onChanged: (value) {
              print(value);
              print("txtEditingController: " + _toPriceController.text);
            },
          ),
        ),
        SliverToBoxAdapter(
          child: DropdownButton(
              items: const [
                DropdownMenuItem(value: 0,child: Text("---Choose Room Type---"),),
                DropdownMenuItem(value: 1,child: Text("Single"),),
                DropdownMenuItem(value: 2,child: Text("Double"),),
              ],
              onChanged: (roomTypeId) {
                _roomTypeId = int.parse(roomTypeId.toString());
                print(_roomTypeId);
              }
          ),
        ),
        SliverToBoxAdapter(
          child: ElevatedButton(
              onPressed: () {
                SearchDto searchDto = SearchDto();
                searchDto.booking_from = _bookingFromController.text.isEmpty ? null : _bookingFromController.text;
                searchDto.booking_to = _bookingToController.text.isEmpty ? null : _bookingToController.text;
                searchDto.from_price = _fromPriceController.text.isEmpty ? null : double.parse(_fromPriceController.text.toString());
                searchDto.to_price = _toPriceController.text.isEmpty ? null : double.parse(_toPriceController.text.toString());
                searchDto.room_type_id = _roomTypeId == 0 ? null : _roomTypeId;

                print(searchDto.booking_from);
                print(searchDto.booking_to);
                print(searchDto.from_price);
                print(searchDto.to_price);
                print(searchDto.room_type_id);

                print(_loggedInUser == null ? null : _loggedInUser!.id);
                print(_loggedInUser == null ? null : _loggedInUser!.username);

                getAllRoomDataBySearch(searchDto);

              },
              child: Text("Search for Room")
          )
        ),

        //Search Filter
        SliverAppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 45,
          surfaceTintColor: Colors.transparent,
          pinned: true,
          title: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.people_alt_rounded,
                      size: 15,
                    ),
                    Text(
                      "$_guestCount guest,",
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "$_roomCount room",
                      style: const TextStyle(
                        fontFamily: "Quicksand",
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        int guest = _guestCount;
                        int room = _roomCount;
                        int price = _price;

                        return StatefulBuilder(
                            builder: (context, StateSetter mystate) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width + 150,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, top: 16),
                                    child: Text("Guests",
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // TextField(
                                          //   controller: _bookingFromController,
                                          //   decoration: const InputDecoration(
                                          //       icon: Icon(Icons.calendar_today), //icon of text field
                                          //       labelText: "Choose Booking From" //label text of field
                                          //   ),
                                          //   readOnly: true,
                                          //   onTap: () async {
                                          //     DateTime? pickedDate = await showDatePicker(
                                          //         context: context, initialDate: DateTime.now(),
                                          //         firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
                                          //         lastDate: DateTime(2101)
                                          //     );
                                          //
                                          //     if(pickedDate != null ){
                                          //       print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                          //       String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                          //       print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                          //     }else{
                                          //       print("Date is not selected");
                                          //     }
                                          //   },
                                          // ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: IconButton(
                                              onPressed: () {
                                                mystate(() {
                                                  if (guest > 0) {
                                                    guest -= 1;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                FontAwesomeIcons.circleMinus,
                                                size: 35,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "$guest",
                                              style:
                                                  const TextStyle(fontSize: 26),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: IconButton(
                                              onPressed: () {
                                                mystate(() {
                                                  if (guest < 4) {
                                                    guest += 1;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                FontAwesomeIcons.circlePlus,
                                                size: 35,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, top: 16),
                                    child: Text("Rooms",
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: IconButton(
                                              onPressed: () {
                                                mystate(() {
                                                  if (room > 0) {
                                                    room -= 1;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                FontAwesomeIcons.circleMinus,
                                                size: 35,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "$room",
                                              style:
                                                  const TextStyle(fontSize: 26),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: IconButton(
                                              onPressed: () {
                                                mystate(() {
                                                  if (room < 4) {
                                                    room += 1;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                FontAwesomeIcons.circlePlus,
                                                size: 35,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10, top: 16),
                                    child: Text("Price",
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: IconButton(
                                              onPressed: () {
                                                mystate(() {
                                                  if (price > 0) {
                                                    price -= 1;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                FontAwesomeIcons.circleMinus,
                                                size: 35,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "$price",
                                              style:
                                                  const TextStyle(fontSize: 26),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: IconButton(
                                              onPressed: () {
                                                mystate(() {
                                                  if (price < 4) {
                                                    price += 1;
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                FontAwesomeIcons.circlePlus,
                                                size: 35,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  const SizedBox(height: 30),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          minimumSize:
                                              const Size.fromHeight(50)),
                                      onPressed: () {
                                        setState(() {
                                          _guestCount = guest;
                                          _roomCount = room;
                                          _price = price;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Search",
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    );
                  },
                  child: Text(
                    "Filter Room",
                    style: TextStyle(
                      fontFamily: "Quicksand",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.combine([
                        TextDecoration.underline,
                      ]),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        SliverList.builder(
            itemCount: roomList.length,
            itemBuilder: (context , index) {
              final room = roomList[index];

              return HotelCardcomp(data: room);
            },
        ),
        // _isHoteloffline
        //     ? SliverList.builder(
        //         itemCount: _hotels.length,
        //         itemBuilder: (context, index) {
        //           return const Hotelcardskeleton();
        //         },
        //       )
        //     : StreamBuilder<RealmResultsChanges<Listing>>(
        //         stream: realmServices.realm
        //             .query<Listing>(
        //                 "price >= $_price AND roomCount >= $_roomCount AND guestCount >= $_guestCount AND country=='$_country' SORT(_id ASC)")
        //             .changes,
        //         builder: (context, snapshot) {
        //           if (snapshot.connectionState == ConnectionState.waiting) {
        //             return SliverList.builder(
        //               itemCount: _hotels.length,
        //               itemBuilder: (context, index) {
        //                 return const Hotelcardskeleton();
        //               },
        //             );
        //           } else {
        //             if (snapshot.hasData &&
        //                 snapshot.data != null &&
        //                 snapshot.data!.results.isNotEmpty) {
        //               final results = snapshot.data!.results;
        //               return SliverList.builder(
        //                 itemCount: results.realm.isClosed ? 0 : results.length,
        //                 itemBuilder: (context, index) {
        //                   return results[index].isValid
        //                       ? HotelCardcomp(
        //                           data: Listingmodel.fromJson(results[index]),
        //                         )
        //                       : const SizedBox(height: 0);
        //                 },
        //               );
        //             } else {
        //               return SliverToBoxAdapter(
        //                 child: SizedBox(
        //                   height: 500,
        //                   child: Center(
        //                     child: Column(
        //                       mainAxisAlignment: MainAxisAlignment.center,
        //                       children: [
        //                         Text(
        //                           "No hotels found",
        //                           style: TextStyle(
        //                             fontSize: 20,
        //                             color:
        //                                 Theme.of(context).colorScheme.onPrimary,
        //                           ),
        //                         ),
        //                         TextButton(
        //                           onPressed: () {
        //                             setState(() {
        //                               _guestCount = 0;
        //                               _price = 0;
        //                               _roomCount = 0;
        //                               _country = "IND";
        //                               _selectedLocation = "India";
        //                             });
        //                           },
        //                           child: const Text("Reset Filters"),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             }
        //           }
        //         },
        //       )
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
