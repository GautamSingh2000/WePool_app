

import '../../data/models/RegistrationResponseDto.dart';
import '../../data/models/CommonResponseDto.dart';
import '../repository/UserRepository.dart';

class ResetPasswordUseCase {
  final UserRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<CommonResponseDto> call(Map<String, dynamic> data) async {
    return await repository.resetPassword(data);
  }
}