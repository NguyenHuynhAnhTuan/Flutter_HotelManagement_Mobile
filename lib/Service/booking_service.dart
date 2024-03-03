import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:travel_app/Utils/SD_Client.dart';
import 'package:travel_app/models/booking_model/booking_dto.dart';
import 'package:travel_app/models/booking_model/search_dto.dart';
import 'package:travel_app/models/room_model/room_dto.dart';

class BookingService {
  static Future<List<BookingDto>> getAllBooking() async {
    final url = SD_CLIENT.api_booking_allBooking;
    final uri = Uri.parse(url);

    final response = await http.get(uri , headers: <String,String>{'Content-Type':'application/json'} );

    final json = jsonDecode(response.body);

    final result = json as List<dynamic>;

    final resultList = result.map((e) {
      return BookingDto.fromJson(e);
    }).toList();

    return resultList;
  }

  static Future<List<BookingDto>> getAllBookingByCustomer(int customerId) async {
    final url = "${SD_CLIENT.api_booking_allBookingByCustomer}/$customerId";
    final uri = Uri.parse(url);

    final response = await http.get(uri , headers: <String,String>{'Content-Type':'application/json'} );

    final json  = jsonDecode(response.body);

    final result = json as List<dynamic>;

    final resultList = result.map((e) {
      return BookingDto.fromJson(e);
    }).toList();

    return resultList;
  }

  static Future<BookingDto> getLatestBooking(int roomId) async {
    final url = "${SD_CLIENT.api_booking_latestBookingOfARoom}/$roomId";
    final uri = Uri.parse(url);

    final response = await http.get(uri , headers: <String,String>{'Content-Type':'application/json'} );

    final json  = jsonDecode(response.body);

    return BookingDto.fromJson(json);
  }

  static Future<BookingDto?> confirmBookingDetail(BookingDto newBookingDto) async {
    final body = {
      "booking_from":DateFormat('yyyy-MM-dd').format(newBookingDto.booking_from as DateTime),
      "booking_to":DateFormat('yyyy-MM-dd').format(newBookingDto.booking_to as DateTime),
      "number_of_member":newBookingDto.number_of_member,
      "is_active":newBookingDto.is_active,
      "customer_id":newBookingDto.customer_id,
      "room_id":newBookingDto.room_id
    };

    final url = SD_CLIENT.api_booking_confirmBookingDetail;
    final uri = Uri.parse(url);

    final response = await http.post(
        uri ,
        headers: <String,String>{'Content-Type':'application/json'},
        body: jsonEncode(body)
    );

    print(response.body);

    if(response.body.isEmpty) {
      return null;
    }
    else {
      final result = jsonDecode(response.body);

      return BookingDto.fromJson(result);
    }
  }

  static Future<BookingDto> createBookingByCustomer(BookingDto newBookingDto) async {
    final body = {
      "booking_from":DateFormat('yyyy-MM-dd').format(newBookingDto.booking_from as DateTime),
      "booking_to":DateFormat('yyyy-MM-dd').format(newBookingDto.booking_to as DateTime),
      "number_of_member":newBookingDto.number_of_member,
      "is_active":newBookingDto.is_active,
      "customer_id":newBookingDto.customer_id,
      "room_id":newBookingDto.room_id
    };
    
    print(body['booking_from']);
    print(body['booking_to']);
    print(body['number_of_member']);
    print(body['is_active']);
    print(body['customer_id']);
    print(body['room_id']);
    
    // return BookingDto.fromJson(body);

    final url = SD_CLIENT.api_booking_createBookingByCustomer;
    final uri = Uri.parse(url);

    final response = await http.post(
        uri ,
        headers: <String,String>{'Content-Type':'application/json'},
        body: jsonEncode(body)
    );

    final result = jsonDecode(response.body);

    return BookingDto.fromJson(result);
  }

  static Future<List<RoomDto>> availableRoomForBooking(SearchDto searchDto) async {
    final body = {
      "booking_from": searchDto.booking_from,
      "booking_to":searchDto.booking_to,
      "from_price":searchDto.from_price,
      "to_price":searchDto.to_price,
      "room_type_id":searchDto.room_type_id
    };

    final url = SD_CLIENT.api_booking_availableRoomForBooking;
    final uri = Uri.parse(url);

    final response = await http.post(
      uri ,
      headers: <String,String>{'Content-Type':'application/json'},
      body: jsonEncode(body)
    );

    final json = jsonDecode(response.body);

    final result = json as List<dynamic>;

    final resultList = result.map((e) {
      return RoomDto.fromJson(e);
    }).toList();

    return resultList;
  }
}