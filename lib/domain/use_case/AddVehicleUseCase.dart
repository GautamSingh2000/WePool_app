import '../../data/models/CommonResponseDto.dart';
import '../repository/UserRepository.dart';

class AddVehicleUseCase {
  final UserRepository repository;

  AddVehicleUseCase(this.repository);

  Future<CommonResponseDto> call(Map<String, dynamic> data) async {
    return await repository.addNewVehicle(data);
  }
}