

import '../../data/models/RegistrationResponseDto.dart';
import '../../data/models/CommonResponseDto.dart';
import '../repository/UserRepository.dart';

class ForgetPasswordUseCase {
  final UserRepository repository;

  ForgetPasswordUseCase(this.repository);

  Future<CommonResponseDto> call(Map<String, dynamic> data) async {
    return await repository.forgetPassword(data);
  }
}