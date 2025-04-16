import '../../data/models/verifyOtpDto.dart';
import '../repository/UserRepository.dart';

class AddVehicleUseCase {
  final UserRepository repository;

  AddVehicleUseCase(this.repository);

  Future<VerifyOtpDto> call(Map<String, dynamic> data) async {
    return await repository.addNewVehicle(data);
  }
}