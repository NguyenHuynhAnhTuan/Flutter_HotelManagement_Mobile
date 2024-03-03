import 'package:travel_app/models/booking_model/booking_dto.dart';

class PaymentDto {
  int? id;
  double? finalAmount;
  String? paymentType;
  String? paymentStatus;
  bool? isActive;
  DateTime? createdAt;

  int? bookingId;
  BookingDto? bookingInfo;

  PaymentDto();

  PaymentDto.fromBooking(BookingDto bookingInfo) {
    // Convert BookingDto to PaymentDto
    bookingId = bookingInfo.id;
    bookingInfo = bookingInfo;
    // Map other properties accordingly
  }

  PaymentDto.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    finalAmount = double.parse(json['final_amount'].toString());
    paymentType = json['payment_type'].toString();
    paymentStatus = json['payment_status'].toString();
    isActive = bool.parse(json['is_active'].toString());
    createdAt = DateTime.parse(json['created_at'].toString());

    bookingId = int.parse(json['booking_id'].toString());
    bookingInfo = BookingDto.fromJson(json['booking_info']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'final_amount': finalAmount,
      'payment_type': paymentType,
      'payment_status': paymentStatus,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'booking_id': bookingId,
    };

    return data;
  }
}
