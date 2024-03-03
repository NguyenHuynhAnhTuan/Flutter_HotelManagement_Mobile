// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:travel_app/models/listing.dart';
import 'package:travel_app/models/room_model/room_dto.dart';
import 'package:travel_app/screens/hoteldetailsscreen.dart';

class HotelCardcomp extends StatelessWidget {

  // const HotelCardcomp({super.key, required data}) : _data = data;
  // final Listingmodel _data;

  RoomDto data;
  HotelCardcomp({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return const Hoteldetailscreen();
            },
            settings: RouteSettings(
              arguments: data,
            ),
          ),
        );
      },
      child: Container(
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
                    child: Hero(
                      tag: data.id.toString(),
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
                        imageUrl: data.room_image.toString(),
                      ),
                    ),
                  ),
                  Positioned(
                      left: 10,
                      bottom: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   data.room_no!.length > 26
                          //       ? "${data.room_no!.substring(0, 25)}..."
                          //       : data.room_no!,
                          //   style: const TextStyle(
                          //     color: Colors.orange,
                          //     fontSize: 20,
                          //     overflow: TextOverflow.fade,
                          //   ),
                          // ),
                          Row(children: [
                            Text(
                              "5 start hotel • 90% ",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Icon(
                              Icons.thumb_up,
                              size: 16,
                              color: Colors.white,
                            )
                          ]),
                        ],
                      ))
                ]),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  // data.room_type_info!.room_type_name.toString(),
                  "${data.id} - ${data.room_no.toString()}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            // Icons.auto_graph_outlined,
                            Icons.reduce_capacity,
                            size: 16,
                          ),
                          Text(
                            "${data.room_capacity.toString()} - ${data.room_capacity!+1} people",
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.king_bed_outlined,
                            size: 16,
                          ),
                          Text("${data.room_type_info!.room_type_name} BED")
                        ],
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.ac_unit_outlined,
                            size: 15,
                          ),
                          Text("AC")
                        ],
                      ),
                      // ignore: unnecessary_null_comparison
                      const Row(
                              children: [
                                Icon(
                                  Icons.bathroom_outlined,
                                  size: 15,
                                ),
                                Text("bath")
                              ],
                            )
                    ],
                  )),
              const Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.wifi,
                              size: 16,
                            ),
                            Text(
                              "Free Wi-Fi",
                              style: TextStyle(fontFamily: "Quicksand"),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.screen_lock_landscape,
                              size: 16,
                            ),
                            Text(
                              "Television",
                              style: TextStyle(fontFamily: "Quicksand"),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.add_business,
                              size: 15,
                            ),
                            Text(
                              "Facilities",
                              style: TextStyle(fontFamily: "Quicksand"),
                            )
                          ],
                        ),
                      ],
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${data.room_price}/night",
                      style: const TextStyle(fontSize: 17),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
