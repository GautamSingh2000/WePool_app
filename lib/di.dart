import 'package:get_it/get_it.dart';

import 'api/ap_client.dart';
import 'api/api_endpoints.dart';
import 'data/repository/RepositoryImp.dart';
import 'domain/repository/UserRepository.dart';
import 'domain/use_case/ForgetPasswordUseCase.dart';
import 'domain/use_case/LoginUseCase.dart';
import 'domain/use_case/RegistrationUseCase.dart';
import 'domain/use_case/ResetPasswordUseCase.dart';
import 'domain/use_case/VerifyForgetPasswordUseCase.dart';
import 'domain/use_case/VerifyOtpUseCase.dart';

final GetIt locator = GetIt.instance;

void setupDi() {
  // Register API client
  locator.registerLazySingleton(() => ApiClient(ApiEndpoints.baseUrl));

  // Register UserRepository
  locator.registerLazySingleton<UserRepository>(
        () => UserRepositoryImp(locator<ApiClient>()),
  );

  // Register UseCase
  locator.registerLazySingleton(
        () => RegisterUserUseCase(locator<UserRepository>()),
  );

  // Login UseCase
  locator.registerLazySingleton(
        () => LoginUseCase(locator<UserRepository>()),
  );
  // VerifyOtp UseCase
  locator.registerLazySingleton(
        () => VerifyOtpUseCase(locator<UserRepository>()),
  );
  // ForgetPassword UseCase
  locator.registerLazySingleton(
        () => ForgetPasswordUseCase(locator<UserRepository>()),
  );
  // ForgetPasswordOtpVerify UseCase
  locator.registerLazySingleton(
        () => VerifyForgetPasswordOtpUseCase(locator<UserRepository>()),
  );
  // ResetPassword UseCase
  locator.registerLazySingleton(
        () => ResetPasswordUseCase(locator<UserRepository>()),
  );
}
