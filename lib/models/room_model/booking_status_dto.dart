class BookingStatusDto {
  int? id;
  String? booking_status_name;

  BookingStatusDto();

  BookingStatusDto.fromJson(Map<String,dynamic> json) {
    id = int.parse(json['id'].toString());
    booking_status_name = json['booking_status_name'];
  }
}