import 'package:we_pool_app/data/models/UpcomingRideDto.dart';

import '../../data/models/RegistrationResponseDto.dart';
import '../../data/models/CommonResponseDto.dart';
import '../repository/UserRepository.dart';

class UpcomingRidesUseCase {
  final UserRepository repository;

  UpcomingRidesUseCase(this.repository);

  Future<UpcomingRideDto> call() async {
    return await repository.upcomingRides();
  }
}