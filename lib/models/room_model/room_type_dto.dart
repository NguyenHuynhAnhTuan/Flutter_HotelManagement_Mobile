class RoomTypeDto {
  int? id;
  String? room_type_name;

  RoomTypeDto();

  RoomTypeDto.fromJson(Map<String,dynamic> json) {
    id = int.parse(json['id'].toString());
    room_type_name = json['room_type_name'];
  }
}