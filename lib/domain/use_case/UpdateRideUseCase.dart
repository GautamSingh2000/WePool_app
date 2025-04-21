import '../../data/models/CommonResponseDto.dart';
import '../repository/UserRepository.dart';

class UpdateRideUseCase {
  final UserRepository repository;

  UpdateRideUseCase(this.repository);

  Future<CommonResponseDto> call(Map<String, dynamic> data) async {
    return await repository.updateRide(data);
  }
}