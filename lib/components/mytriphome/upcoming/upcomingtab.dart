import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart' hide ConnectionState;
import 'package:travel_app/Service/UserService.dart';
import 'package:travel_app/Service/booking_service.dart';
import 'package:travel_app/components/booking/Hotelcardskeleton.dart';
import 'package:travel_app/components/mytriphome/hotelbooktrip/hotelbooktripcard.dart';
import 'package:travel_app/models/UserDto.dart';
import 'package:travel_app/models/booking_model/booking_dto.dart';
import 'package:travel_app/models/reservation.dart';
import 'package:travel_app/realm/realm_services.dart';
import 'package:travel_app/realm/schemas.dart';

class Upcomingtab extends StatefulWidget {
  const Upcomingtab({super.key});

  @override
  State<Upcomingtab> createState() => _UpcomingtabState();
}

class _UpcomingtabState extends State<Upcomingtab> {
  final List<int> _hotels = [1, 2, 3, 4, 5, 6, 7, 8];

  UserDto? _loggedInUser;
  List<BookingDto> allBookingByCustomer = [];

  Future<void> _fetchLoginUserAndBookingData() async {
    UserDto? checkLoginCustomer = UserService.loggedInUser;

    if(checkLoginCustomer == null) {
      print("_loggedInUser is null");
    }
    else {
      List<BookingDto> getAllBookingByCustomer = await BookingService.getAllBookingByCustomer(int.parse(checkLoginCustomer.id.toString()));
      print("Customer Id: ${checkLoginCustomer.id}");
      print("Customer Name: ${checkLoginCustomer.username}");

      setState(() {
        _loggedInUser = checkLoginCustomer;
        allBookingByCustomer = getAllBookingByCustomer.where((e) => e.booking_current_id != 4).toList();
      });
    }


    // try {
    //   // await UserService().login('email', 'password'); // call the login method to set the user
    //   setState(() async {
    //     _loggedInUser = UserService.loggedInUser; // access the stored user
    //     if (_loggedInUser != null) {
    //       print("_loggedInUser id: ${_loggedInUser?.id}");
    //       print("_loggedInUser username: ${_loggedInUser?.username}");
    //
    //       allBookingByCustomer = await BookingService.getAllBookingByCustomer(int.parse(_loggedInUser!.id.toString()));
    //     } else {
    //       print("_loggedInUser is null");
    //     }
    //   });
    // } catch (e) {
    //   print("Error fetching logged-in user data: $e");
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchLoginUserAndBookingData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    return StreamBuilder<RealmResultsChanges<AllReservations>>(
      stream: realmServices.realm
          .query<AllReservations>(r'owner_id == $0 AND enddate >= $1', [
        ObjectId.fromHexString(realmServices.currentUser!.id),
        DateTime.now().subtract(const Duration(days: 0))
      ]).changes,
      builder: (context, snapshot) {
        if(_loggedInUser == null) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 500,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login to Check Upcoming Booking",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        else {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SliverList.builder(
              itemCount: _hotels.length,
              itemBuilder: (context, index) {
                return const Hotelcardskeleton();
              },
            );
          }
          else {
            // if (snapshot.hasData &&
            //     snapshot.data != null &&
            //     snapshot.data!.results.isNotEmpty) {
            if (allBookingByCustomer.isNotEmpty) {
              // final results = snapshot.data!.results;
              // return SliverList.builder(
              //   itemCount: results.realm.isClosed ? 0 : results.length,
              //   itemBuilder: (context, index) {
              //     return results[index].isValid
              //         ? Hotelbooktripcard(
              //         data: Reservationmodel.fromJson(results[index]))
              //         : const SizedBox(height: 0);
              //   },
              // );

              return SliverList.builder(
                itemCount: allBookingByCustomer.length,
                itemBuilder: (context, index) {
                  BookingDto bookingInfo = allBookingByCustomer[index];
                  return Hotelbooktripcard(data: bookingInfo);
                },
              );
            }
            else {
              return SliverToBoxAdapter(
                child: SizedBox(
                  height: 500,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No bookings found",
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        }
      },
    );
  }
}
