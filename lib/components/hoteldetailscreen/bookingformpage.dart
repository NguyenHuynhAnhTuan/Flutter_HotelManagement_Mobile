import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_app/Service/booking_service.dart';
import 'package:travel_app/components/hoteldetailscreen/paymentdetail.dart';
import 'package:travel_app/components/widget/snakbar.dart';
import 'package:travel_app/homesubscreen/mytrip.dart';
import 'package:travel_app/models/booking_model/booking_dto.dart';
import 'package:travel_app/models/listing.dart';
import 'package:travel_app/homesubscreen/booking.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:travel_app/screens/homescreen.dart';

class Hotelbookformpage extends StatefulWidget {
  // const Hotelbookformpage({super.key, required data, required bookingrange})
  //     : _data = data,
  //       _bookingrange = bookingrange;
  // final Listingmodel _data;
  // final DateTimeRange _bookingrange;

  BookingDto bookingDtoInfo;
  Hotelbookformpage({super.key, required this.bookingDtoInfo});

  @override
  State<Hotelbookformpage> createState() => _HotelbookformpageState();
}

class _HotelbookformpageState extends State<Hotelbookformpage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool checkbox = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTimeRange _daterange = DateTimeRange(
        start: widget.bookingDtoInfo!.booking_from as DateTime,
        end: widget.bookingDtoInfo!.booking_to as DateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 1,
          surfaceTintColor: Colors.transparent,
          color: Theme.of(context).colorScheme.background,
          shadowColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
          child: SizedBox(
            // height: 500,
            child: Column(
              children: [
                Stack(children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: widget.bookingDtoInfo.room_info!.room_image
                          .toString(),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Shimmer.fromColors(
                          baseColor: Colors.red,
                          highlightColor: Colors.yellow,
                          child: Container(
                            height: 150,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => SizedBox(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        child: Shimmer.fromColors(
                          baseColor: Colors.red,
                          highlightColor: Colors.yellow,
                          child: Container(
                            height: 150,
                            color: Colors.white24,
                            child: const Center(
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //     left: 10,
                  //     bottom: 3,
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           widget.bookingDtoInfo.room_info!.room_description!
                  //                       .length >
                  //                   26
                  //               ? "${widget.bookingDtoInfo.room_info!.room_description!.substring(0, 25)}..."
                  //               : widget
                  //                   .bookingDtoInfo.room_info!.room_description
                  //                   .toString(),
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 20,
                  //             overflow: TextOverflow.fade,
                  //           ),
                  //         ),
                  //       ],
                  //     )),
                ]),
                // SizedBox(
                //   height: 35,
                //   child: ListView.builder(
                //     itemCount: widget._data.facilities.length,
                //     scrollDirection: Axis.horizontal,
                //     itemBuilder: (context, index) {
                //       return SizedBox(
                //         child: Row(
                //           children: [
                //             widget._data.facilities[index].icon == "AC"
                //                 ? const Icon(FontAwesomeIcons.airbnb)
                //                 : const Text(""),
                //             Text(
                //               widget._data.facilities[index].fav,
                //               style: TextStyle(
                //                 color: Theme.of(context).colorScheme.onPrimary,
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MySeparator(color: Colors.grey[300]!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Room No" , style: TextStyle(fontSize: 20),),
                      Text(widget.bookingDtoInfo.room_info!.room_no.toString() , style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MySeparator(color: Colors.grey[300]!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Room Type" , style: TextStyle(fontSize: 20),),
                      Text(widget.bookingDtoInfo.room_info!.room_type_info!
                          .room_type_name
                          .toString() + " BED" , style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MySeparator(color: Colors.grey[300]!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Room Description" , style: TextStyle(fontSize: 20),),
                      Text(widget.bookingDtoInfo.room_info!.room_description
                          .toString() , style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MySeparator(color: Colors.grey[300]!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Booking From" , style: TextStyle(fontSize: 20),),
                      Text(DateFormat('yyyy-MM-dd').format(
                          widget.bookingDtoInfo.booking_from as DateTime) , style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MySeparator(color: Colors.grey[300]!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Booking To" , style: TextStyle(fontSize: 20),),
                      Text(DateFormat('yyyy-MM-dd').format(
                          widget.bookingDtoInfo.booking_to as DateTime) , style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MySeparator(color: Colors.grey[300]!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Day" , style: TextStyle(fontSize: 20),),
                      Text((_daterange!.end
                                  .difference(_daterange!.start)
                                  .inDays) >
                              1
                          ? "${_daterange!.end.difference(_daterange!.start).inDays} days"
                          : "${_daterange!.end.difference(_daterange!.start).inDays} day" ,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MySeparator(color: Colors.grey[300]!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Price" , style: TextStyle(fontSize: 20),),
                      Text(
                          "\$${widget.bookingDtoInfo.room_info!.room_price}/day" , style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 5),
                //   child: MySeparator(color: Colors.grey[300]!),
                // ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 5),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const Text("Tex"),
                //       Text("\$${widget._data.price}"),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: MySeparator(color: Colors.grey[300]!),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Price" , style: TextStyle(fontSize: 20),),
                      Text(
                          "\$${widget.bookingDtoInfo.room_info!.room_price! * (_daterange!.end.difference(_daterange!.start).inDays)}" , style: TextStyle(fontSize: 20),),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      BookingDto newBookingDto = BookingDto();
                      newBookingDto.booking_from = widget.bookingDtoInfo.booking_from;
                      newBookingDto.booking_to = widget.bookingDtoInfo.booking_to;
                      newBookingDto.number_of_member = widget.bookingDtoInfo.room_info!.room_capacity;
                      newBookingDto.is_active = true;
                      newBookingDto.room_id = widget.bookingDtoInfo.room_id;
                      newBookingDto.customer_id = widget.bookingDtoInfo.customer_id;

                      BookingDto? confirmResult = await BookingService.confirmBookingDetail(newBookingDto);
                      if(confirmResult == null) {
                        BookingDto latestBooking = await BookingService.getLatestBooking(int.parse(widget.bookingDtoInfo.room_id.toString()));

                        showSnakbar(context, "This room have been booked, Please choose another date after ${DateFormat('yyyy-MM-dd').format(latestBooking.booking_to as DateTime)}");
                      }
                      else {
                        print(confirmResult);
                        BookingDto createNewBookingByCustomer = await BookingService.createBookingByCustomer(confirmResult);
                        showSnakbar(context, "Successfully Create Booking");
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => HomeScreen() ,
                            settings: RouteSettings(
                              arguments: 2
                            ),
                          )
                        );
                      }
                    },
                    child: Text("Confirm and Create Booking" , style: TextStyle(fontSize: 20),) ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Form(
        //   key: _formKey,
        //   child: Container(
        //     padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         const Padding(
        //           padding: EdgeInsets.symmetric(
        //             horizontal: 15,
        //           ),
        //           child: Text("Full Name"),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 5),
        //           child: TextFormField(
        //             controller: _name,
        //             validator: (value) {
        //               if (value == null || value.isEmpty) {
        //                 return "Enter your name";
        //               } else if (value.length < 3) {
        //                 return "Enter minimun 3 character name";
        //               } else {
        //                 return null;
        //               }
        //             },
        //             decoration: const InputDecoration(
        //               contentPadding:
        //                   EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        //               hintText: "Your name",
        //               enabledBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(100)),
        //                 borderSide: BorderSide(
        //                   width: 1,
        //                   color: Colors.red,
        //                 ),
        //               ),
        //               focusedBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(100)),
        //                 borderSide: BorderSide(
        //                   width: 1,
        //                   color: Colors.red,
        //                 ),
        //               ),
        //               border: OutlineInputBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(100)),
        //                 borderSide: BorderSide(
        //                   width: 1,
        //                   color: Colors.red,
        //                 ),
        //               ),
        //             ),
        //             textAlignVertical: TextAlignVertical.center,
        //             style: TextStyle(
        //               color: Colors.grey[700]!,
        //               fontSize: 15,
        //               height: 1,
        //             ),
        //           ),
        //         ),
        //         const Padding(
        //           padding:
        //               EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
        //           child: Text("Email"),
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 0),
        //           child: TextFormField(
        //             controller: _email,
        //             validator: (value) {
        //               if (value == null || value.isEmpty || value.length < 6) {
        //                 return "Invalid email";
        //               } else {
        //                 return null;
        //               }
        //             },
        //             decoration: const InputDecoration(
        //               contentPadding:
        //                   EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        //               hintText: "Email",
        //               enabledBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(100)),
        //                 borderSide: BorderSide(
        //                   width: 1,
        //                   color: Colors.red,
        //                 ),
        //               ),
        //               focusedBorder: OutlineInputBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(100)),
        //                 borderSide: BorderSide(
        //                   width: 1,
        //                   color: Colors.red,
        //                 ),
        //               ),
        //               border: OutlineInputBorder(
        //                 borderRadius: BorderRadius.all(Radius.circular(100)),
        //                 borderSide: BorderSide(
        //                   width: 1,
        //                   color: Colors.red,
        //                 ),
        //               ),
        //             ),
        //             textAlignVertical: TextAlignVertical.center,
        //             style: TextStyle(
        //               color: Colors.grey[700]!,
        //               fontSize: 15,
        //               height: 1,
        //             ),
        //           ),
        //         ),
        //         Row(
        //           children: [
        //             Checkbox(
        //               value: checkbox,
        //               onChanged: (value) {
        //                 setState(() {
        //                   checkbox = value!;
        //                 });
        //               },
        //             ),
        //             const Padding(
        //               padding: EdgeInsets.only(left: 0),
        //               child: Text("Use my profile email"),
        //             )
        //           ],
        //         ),
        //         Padding(
        //           padding: const EdgeInsets.only(top: 15),
        //           child: ElevatedButton(
        //             onPressed: () {
        //               // if (_formKey.currentState!.validate()) {
        //               //   Navigator.of(context)
        //               //       .push(MaterialPageRoute(builder: (context) {
        //               //     return Hotelpaymentdetails(
        //               //       data: widget._data,
        //               //       email: _email.text,
        //               //       name: _name.text,
        //               //       checkmark: checkbox,
        //               //       daterange: widget._bookingrange,
        //               //     );
        //               //   }));
        //               // }
        //             },
        //             style: ElevatedButton.styleFrom(
        //                 minimumSize: const Size.fromHeight(50),
        //                 backgroundColor: Colors.orange),
        //             child: const Text(
        //               "Next",
        //               style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 19,
        //                 fontWeight: FontWeight.w700,
        //               ),
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }
}
