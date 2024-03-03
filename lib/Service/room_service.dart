import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:travel_app/Utils/SD_Client.dart';
import 'package:travel_app/models/room_model/room_dto.dart';

class RoomService {

  static Future<List<RoomDto>> getAllRoom() async {
    final url = SD_CLIENT.api_room_allRoom;
    final uri = Uri.parse(url);

    final response = await http.get(uri, headers: <String,String>{'Content-Type':'application/json'});

    final json = jsonDecode(response.body);

    final result = json as List<dynamic>;

    final resultList = result.map((e) {
      return RoomDto.fromJson(e);
    }).toList();

    print(resultList.length);

    return resultList;
  }

  static Future<RoomDto> findRoomById(int roomId) async {
    final url = "${SD_CLIENT.api_room_findRoom}/${roomId.toString()}";
    final uri = Uri.parse(url);

    final response = await http.get(uri , headers: <String,String>{'Content-Type':'application/json'});

    final json = jsonDecode(response.body);

    return RoomDto.fromJson(json);
  }

  static Future<RoomDto> createNewRoom(RoomDto newRoom) async {
    final body = {
      "room_no":newRoom.room_no,
      "room_price":newRoom.room_price,
      "room_image":newRoom.room_image,
      "room_capacity":newRoom.room_capacity,
      "room_description":newRoom.room_description,
      "is_active":newRoom.is_active,
      "room_type_id":newRoom.room_type_id
    };

    final url = SD_CLIENT.api_room_createRoom;
    final uri = Uri.parse(url);

    final response = await http.post(
        uri,
        headers: <String,String>{'Content-Type':'application/json'},
        body: jsonEncode(body)
    );

    final result = jsonDecode(response.body) as dynamic;

    return RoomDto.fromJson(result);
  }

  static Future<RoomDto> updateRoom(RoomDto updateRoom) async {
    final body = {
      "id":updateRoom.id,
      "room_no":updateRoom.room_no,
      "room_price":updateRoom.room_price,
      "room_image":updateRoom.room_image,
      "room_capacity":updateRoom.room_capacity,
      "room_description":updateRoom.room_description,
      "is_active":updateRoom.is_active,
      "room_type_id":updateRoom.room_type_id,
      "booking_status_id":updateRoom.booking_status_id
    };

    final url = SD_CLIENT.api_room_updateRoom;
    final uri = Uri.parse(url);

    final response = await http.put(
        uri,
        headers: <String,String>{'Content-Type':'application/json'},
        body: jsonEncode(body)
    );

    final result = jsonDecode(response.body);

    return RoomDto.fromJson(result);
  }

}