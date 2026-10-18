class BookingModel {
  final int id;

  final String workshopName;

  final String imageUrl;

  final String serviceName;

  final String bookingDate;

  final String bookingTime;

  final String status;

  BookingModel({
    required this.id,
    required this.workshopName,
    required this.imageUrl,
    required this.serviceName,
    required this.bookingDate,
    required this.bookingTime,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json["id"],
      workshopName: json["name"] ?? "",
      imageUrl: json["image_url"] ?? "",
      serviceName: json["service_name"] ?? "",
      bookingDate: json["booking_date"] ?? "",
      bookingTime: json["booking_time"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
