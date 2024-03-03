import 'package:travel_app/models/room_model/booking_status_dto.dart';
import 'package:travel_app/models/room_model/room_type_dto.dart';

class RoomDto {

  int? id;
  String? room_no;
  double? room_price;
  String? room_image;
  int? room_capacity;
  String? room_description;
  bool? is_active;

  int? booking_status_id;
  BookingStatusDto? booking_status_info;

  int? room_type_id;
  RoomTypeDto? room_type_info;

  RoomDto();

  RoomDto.fromJson(Map<String,dynamic> json) {
    id = int.parse(json['id'].toString());
    room_no = json['room_no'];
    room_price = double.parse(json['room_price'].toString());
    room_image = json['room_image'];
    room_capacity = int.parse(json['room_capacity'].toString());
    room_description = json['room_description'];
    is_active = bool.parse(json['is_active'].toString());
    booking_status_id = json['booking_status_id'];
    booking_status_info = BookingStatusDto.fromJson(json['booking_status_info']);
    room_type_id = json['room_type_id'];
    room_type_info = RoomTypeDto.fromJson(json['room_type_info']);
  }
}