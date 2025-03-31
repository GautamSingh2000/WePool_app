
import '../../data/models/RegistrationResponseDto.dart';
import '../../data/models/verifyOtpDto.dart';
import '../repository/UserRepository.dart';

class VerifyOtpUseCase {
  final UserRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<VerifyOtpDto> call(Map<String, dynamic> data) async {
    return await repository.verifyOtp(data);
  }
}