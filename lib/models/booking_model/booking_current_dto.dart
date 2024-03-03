class BookingCurrentDto {
  int? id;
  String? booking_current_name;

  BookingCurrentDto();

  BookingCurrentDto.fromJson(Map<String,dynamic> json) {
    id = int.parse(json['id'].toString());
    booking_current_name = json['booking_current_name'];
  }
}