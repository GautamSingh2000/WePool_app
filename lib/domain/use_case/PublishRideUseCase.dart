
import '../../data/models/verifyOtpDto.dart';
import '../repository/UserRepository.dart';

class PublishRideUseCase {
  final UserRepository repository;

  PublishRideUseCase(this.repository);

  Future<VerifyOtpDto> call(Map<String, dynamic> data) async {
    return await repository.publishRide(data);
  }
}