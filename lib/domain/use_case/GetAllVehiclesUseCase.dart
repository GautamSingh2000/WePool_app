import 'package:we_pool_app/data/models/GetAllVehicleDto.dart';

import '../repository/UserRepository.dart';

class GetAllVehiclesUseCase {
  final UserRepository repository;

  GetAllVehiclesUseCase(this.repository);

  Future<GetAllVehicleDto> call() async {
    return await repository.getAllVehicles();
  }
}