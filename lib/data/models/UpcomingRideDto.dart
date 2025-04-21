class UpcomingRideDto {
  final bool success;
  final String message;
  final List<Ride>? rides;

  UpcomingRideDto({
    required this.success,
    required this.message,
    this.rides,
  });

  factory UpcomingRideDto.fromJson(Map<String, dynamic> json) {
    return UpcomingRideDto(
    success: json['success'] ?? false,
    message: json['message'] ?? '',
    rides: json['rides'] != null
    ? List<Ride>.from(json['rides'].map((x) => Ride.fromJson(x)))
    : null,
    );
  }
}

class Ride {
  final String id;
  final User user;
  final String from;
  final String fromLat;
  final String fromLong;
  final String to;
  final String toLat;
  final String toLong;
  final String date;
  final String time;
  final int noOfSeats;
  final int pricePerSeat;
  final String summary;
  final Vehicle vehicle;

  Ride({
    required this.id,
    required this.user,
    required this.from,
    required this.fromLat,
    required this.fromLong,
    required this.to,
    required this.toLat,
    required this.toLong,
    required this.date,
    required this.time,
    required this.noOfSeats,
    required this.pricePerSeat,
    required this.summary,
    required this.vehicle,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] ?? '',
      user: User.fromJson(json['user']),
      from: json['from'] ?? '',
      fromLat: json['fromLat'] ?? '',
      fromLong: json['fromLong'] ?? '',
      to: json['to'] ?? '',
      toLat: json['toLat'] ?? '',
      toLong: json['toLong'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      noOfSeats: json['noOfSeats'] ?? 0,
      pricePerSeat: json['pricePerSeat'] ?? 0,
      summary: json['summary'] ?? '',
      vehicle: Vehicle.fromJson(json['vehicle']),
    );
  }
}

class User {
  final String fullName;

  User({required this.fullName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'] ?? '',
    );
  }
}

class Vehicle {
  final String brand;
  final String model;
  final String color;

  Vehicle({
    required this.brand,
    required this.model,
    required this.color,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      color: json['color'] ?? '',
    );
  }
}