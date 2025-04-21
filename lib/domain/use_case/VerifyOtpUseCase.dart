
import '../../data/models/RegistrationResponseDto.dart';
import '../../data/models/CommonResponseDto.dart';
import '../repository/UserRepository.dart';

class VerifyOtpUseCase {
  final UserRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<CommonResponseDto> call(Map<String, dynamic> data) async {
    return await repository.verifyOtp(data);
  }
}