import "package:get_it/get_it.dart";
import "package:only_to_do/core/network/dio_config.dart";
import "package:only_to_do/features/sleep_tracking/collect_informations/data/services/sleep_tracking_service.dart";

import "../../features/sleep_tracking/collect_informations/data/repository/sleep_tracking_repository.dart";
import "../../features/yourevent/services/storage_service.dart";
import "../data/datasources/local_datasource.dart";
import "../data/repositories/auth_repository.dart";
import "../data/repositories/dashboard_repository.dart";
import "../data/repositories/event_repository.dart";

late GetIt serviceLocator;
void initServiceLocators() {
  serviceLocator = GetIt.instance;
  serviceLocator.registerLazySingleton<StorageService>(() => StorageService());
  serviceLocator
      .registerLazySingleton<EventRepository>(() => EventRepository());
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  serviceLocator
      .registerLazySingleton<DashboardRepository>(() => DashboardRepository());

  serviceLocator.registerLazySingleton<LocalDataSource>(
      () => LocalDataSource(serviceLocator.get<StorageService>()));

  serviceLocator.registerLazySingleton<SleepTrackingService>(
    () => SleepTrackingService(
      dio: DioConfig.instance.getDio(),
      localDataSource: serviceLocator.get<LocalDataSource>(),
    ),
  );
  serviceLocator.registerLazySingleton<SleepTrackingRepository>(
    () => SleepTrackingRepository(
      service: serviceLocator.get<SleepTrackingService>(),
    ),
  );
}
