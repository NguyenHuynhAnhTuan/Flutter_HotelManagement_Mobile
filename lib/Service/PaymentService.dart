import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_app/Utils/SD_Client.dart';
import 'package:travel_app/models/paymentDto.dart'; // Assuming PaymentDto is in a separate file
import 'package:travel_app/models/booking_model/booking_dto.dart';

class PaymentService {
  static Future<PaymentDto> createNewPayment(BookingDto bookingData) async {
    // Convert BookingDto to PaymentDto
    PaymentDto newPaymentDto = PaymentDto.fromBooking(bookingData);

    final response = await http.post(
      SD_CLIENT.apiCreatepayment,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(newPaymentDto.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      PaymentDto createdPayment = PaymentDto.fromJson(jsonResponse);

      // Send feedback (send email) when creating a new payment
      await sendFeedback(createdPayment);

      return createdPayment;
    } else {
      throw Exception('Failed to create payment');
    }
  }

  static Future<void> sendFeedback(PaymentDto payment) async {
    // Assuming you have a separate API endpoint to send feedback
    final feedbackResponse = await http.post(
      SD_CLIENT.apiSendMail,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customerName': payment.bookingInfo?.customer_info?.username,
        'roomNo': payment.bookingInfo?.room_info?.room_no,
        'roomPrice': payment.bookingInfo?.room_info?.room_price,
        'totalDay': payment.bookingInfo?.total_day,
        'paymentType': payment.paymentType,
        'totalPrice': payment.finalAmount,
      }),
    );

    if (feedbackResponse.statusCode == 200) {
      // Feedback sent successfully
      print('Feedback sent successfully');
    } else {
      // Failed to send feedback
      print('Failed to send feedback');
    }
  }
}