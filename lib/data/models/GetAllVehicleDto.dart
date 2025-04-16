/// success : true
/// message : "All vehicles fetched successfully"
/// vehicles : [{"id":"0cea1af4-2ea4-4ecc-b431-c01278bc5f57","brand":"RangeRover","model":"Sports","color":"Black"}]
class GetAllVehicleDto {
 late bool _success;
 late String _message;
  List<Vehicles>? _vehicles;

  GetAllVehicleDto({
    required bool success,
    required String message,
    List<Vehicles>? vehicles,
  }) {
    _success = success;
    _message = message;
    _vehicles = vehicles;
  }

  GetAllVehicleDto.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['vehicles'] != null) {
      _vehicles = [];
      json['vehicles'].forEach((v) {
        _vehicles!.add(Vehicles.fromJson(v));
      });
    }
  }

  GetAllVehicleDto copyWith({
    bool? success,
    String? message,
    List<Vehicles>? vehicles,
  }) =>
      GetAllVehicleDto(
        success: success ?? _success,
        message: message ?? _message,
        vehicles: vehicles ?? _vehicles,
      );

  bool get success => _success ?? false;
  String get message => _message ?? "";
  List<Vehicles> get vehicles => _vehicles ?? [];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_vehicles != null) {
      map['vehicles'] = _vehicles!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}


class Vehicles {
  String? _id;
  String? _brand;
  String? _model;
  String? _color;

  Vehicles({
    String? id,
    String? brand,
    String? model,
    String? color,
  }) {
    _id = id;
    _brand = brand;
    _model = model;
    _color = color;
  }

  Vehicles.fromJson(dynamic json) {
    _id = json['id'];
    _brand = json['brand'];
    _model = json['model'];
    _color = json['color'];
  }

  Vehicles copyWith({
    String? id,
    String? brand,
    String? model,
    String? color,
  }) =>
      Vehicles(
        id: id ?? _id,
        brand: brand ?? _brand,
        model: model ?? _model,
        color: color ?? _color,
      );

  String get id => _id ?? "";
  String get brand => _brand ?? "";
  String get model => _model ?? "";
  String get color => _color ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['brand'] = _brand;
    map['model'] = _model;
    map['color'] = _color;
    return map;
  }
}
