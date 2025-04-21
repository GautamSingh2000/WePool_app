
import '../../data/models/CommonResponseDto.dart';
import '../repository/UserRepository.dart';

class PublishRideUseCase {
  final UserRepository repository;

  PublishRideUseCase(this.repository);

  Future<CommonResponseDto> call(Map<String, dynamic> data) async {
    return await repository.publishRide(data);
  }
}