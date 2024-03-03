// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_app/Service/PaymentService.dart';
import 'package:travel_app/models/booking_model/booking_dto.dart';
import 'package:travel_app/models/paymentDto.dart';
import 'package:travel_app/models/reservation.dart';

class Hotelbooktripcard extends StatelessWidget {
  // const Hotelbooktripcard({super.key, required data}) : _data = data;
  // final Reservationmodel _data;

  final BookingDto data;
  const Hotelbooktripcard({super.key, required this.data});


  Future<void> createPayment(BuildContext context) async {
    try {
      // Call the createNewPayment method with the BookingDto
      PaymentDto createdPayment = await PaymentService.createNewPayment(data);

      // Additional actions after successful payment
      // For example, show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment successful!'),
        ),
      );
    } catch (e) {
      // Handle exceptions, e.g., display an error message
      print('Error creating payment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 350,
      child: Card(
        elevation: 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    placeholder: (context, url) {
                      return SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Shimmer.fromColors(
                          baseColor: Colors.red,
                          highlightColor: Colors.yellow,
                          child: Container(
                            height: 200,
                            color: Colors.white24,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: Shimmer.fromColors(
                          baseColor: Colors.red,
                          highlightColor: Colors.yellow,
                          child: Container(
                            height: 200,
                            color: Colors.white24,
                          ),
                        ),
                      );
                    },
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    imageUrl: data.room_info!.room_image.toString(),
                  ),
                ),
                Positioned(
                    left: 10,
                    bottom: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // data.room_info!.room_no!.length > 26
                          //     ? "${ data.room_info!.room_no!.substring(0, 25)}..."
                          //     :  data.room_info!.room_no!,
                          "",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                data.room_info!.room_no.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.orange
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Text(
                data.room_info!.room_type_info!.room_type_name.toString()+" BED",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(data.booking_from as DateTime),
                        style: const TextStyle(fontFamily: "Quicksand" , fontWeight: FontWeight.bold , fontSize: 18),
                      ),
                      const Text(
                        "------->",
                        style: TextStyle(fontFamily: "Quicksand" , fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(data.booking_to as DateTime),
                        style: const TextStyle(fontFamily: "Quicksand" , fontWeight: FontWeight.bold , fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Call the createNewPayment method here
                          await createPayment(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orangeAccent,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text("PAY"),
                      ),
                    ],
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${data.total_price}/ ${data.total_day} nights",
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
