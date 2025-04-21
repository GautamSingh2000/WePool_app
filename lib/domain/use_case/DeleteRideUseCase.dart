import 'package:we_pool_app/data/models/CommonResponseDto.dart';

import '../../data/models/CancelRideDto.dart';
import '../repository/UserRepository.dart';

class DeleteRideUseCase {
  final UserRepository repository;

  DeleteRideUseCase(this.repository);

  Future<CancelRideDto> call(Map<String, String> data) async {
    return await repository.deleteRide(data);
  }
}