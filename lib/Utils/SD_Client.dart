class SD_CLIENT {
  static final String DOMAIN_APP_API = "http://172.16.1.232:9999";

  //test
  static final Uri apiAllUserUri = Uri.parse('$DOMAIN_APP_API/api/users/all');

  // Login register
  static final Uri apiLoginUri = Uri.parse('$DOMAIN_APP_API/api/users/login');
  static final Uri apiRegisterUri = Uri.parse('$DOMAIN_APP_API/api/users/register');
  static final Uri apiCheckEmailUri = Uri.parse('$DOMAIN_APP_API/api/user/emailexist');

  //payment
  static final Uri apiCreatepayment = Uri.parse('$DOMAIN_APP_API/api/paymentcontroller/create');
  static final Uri apiSendMail = Uri.parse('$DOMAIN_APP_API/api/paymentcontroller/sendEmail');


  //Room Api URL
  static final String api_room_allRoom = "$DOMAIN_APP_API/api/roomcontroller/all";
  static final String api_room_allRoomVacancy = "$DOMAIN_APP_API/api/roomcontroller/allroomvacancy";
  static final String api_room_allRoomSortedByActive = "$DOMAIN_APP_API/api/roomcontroller/allroomsortedbyactive";
  static final String api_room_allRoomActiveAndVacancy = "$DOMAIN_APP_API/api/roomcontroller/allroomactiveandvacancy";
  static final String api_room_findRoom = "$DOMAIN_APP_API/api/roomcontroller/find";

  static final String api_room_createRoom = "$DOMAIN_APP_API/api/roomcontroller/create";
  static final String api_room_updateRoom = "$DOMAIN_APP_API/api/roomcontroller/update";

  //Booking Api URL
  static final String api_booking_allBooking = "$DOMAIN_APP_API/api/bookingcontroller/all";
  static final String api_booking_allBookingByCustomer = "$DOMAIN_APP_API/api/bookingcontroller/allbookingbycustomer";
  static final String api_booking_confirmBookingDetail = "$DOMAIN_APP_API/api/bookingcontroller/confirmbookingdetail";
  static final String api_booking_createBookingByCustomer = "$DOMAIN_APP_API/api/bookingcontroller/createbookingbycustomer";
  static final String api_booking_availableRoomForBooking = "$DOMAIN_APP_API/api/bookingcontroller/availableroomforbooking";
  static final String api_booking_latestBookingOfARoom = "$DOMAIN_APP_API/api/bookingcontroller/findthelatestbookingofaroom";

}
