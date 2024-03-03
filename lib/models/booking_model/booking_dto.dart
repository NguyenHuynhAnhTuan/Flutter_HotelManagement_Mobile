import 'package:travel_app/models/UserDto.dart';
import 'package:travel_app/models/booking_model/booking_current_dto.dart';
import 'package:travel_app/models/room_model/room_dto.dart';

class BookingDto {
  int? id;
  DateTime? booking_from;
  DateTime? booking_to;
  int? total_day;
  double? total_price;
  int? number_of_member;
  bool? is_active;

  int? booking_current_id;
  BookingCurrentDto? booking_current_info;

  int? customer_id;
  UserDto? customer_info;

  int? room_id;
  RoomDto? room_info;
  
  BookingDto();
  
  BookingDto.fromJson(Map<String,dynamic> json) {
    id = int.parse(json['id'].toString());
    booking_from = DateTime.parse(json['booking_from'].toString());
    booking_to = DateTime.parse(json['booking_to'].toString());
    total_day = int.parse(json['total_day'].toString());
    total_price = double.parse(json['total_price'].toString());
    number_of_member = int.parse(json['number_of_member'].toString());
    is_active = bool.parse(json['is_active'].toString());
    
    booking_current_id = int.parse(json['booking_current_id'].toString());
    booking_current_info = BookingCurrentDto.fromJson(json['booking_current_info']);
    
    customer_id = int.parse(json['customer_id'].toString());
    customer_info = UserDto.fromJson(json['customer_info']);

    room_id = int.parse(json['room_id'].toString());
    room_info = RoomDto.fromJson(json['room_info']);
  }

}