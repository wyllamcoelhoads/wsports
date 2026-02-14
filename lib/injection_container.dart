import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
// Imports da F1
import 'package:wsports/features/formula_one/data/datasources/f1_remote_data_source.dart';
import 'package:wsports/features/formula_one/data/repositories/f1_repository_impl.dart';
import 'package:wsports/features/formula_one/domain/repositories/f1_repository.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_bloc.dart';
// NOVOS IMPORTS da Copa do Mundo
import 'package:wsports/features/world_cup/data/datasources/world_cup_remote_data_source.dart';
import 'package:wsports/features/world_cup/data/repositories/world_cup_repository_impl.dart';
import 'package:wsports/features/world_cup/domain/repositories/world_cup_repository.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_bloc.dart';
import 'package:wsports/features/simulations/data/datasources/simulation_datasource.dart';
import 'package:wsports/features/simulations/data/repositories/simulation_repository_impl.dart';
import 'package:wsports/features/simulations/domain/repositories/simulation_repository.dart';
import 'package:wsports/features/simulations/domain/usecases/save_simulation_usecase.dart';
final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Formula 1
  sl.registerFactory(() => F1Bloc(repository: sl()));
  sl.registerLazySingleton<F1Repository>(() => F1RepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<F1RemoteDataSource>(() => F1RemoteDataSourceImpl(client: sl()));

  //! Features - World Cup (OS NOVOS AQUI!)
  sl.registerFactory(() => WorldCupBloc(repository: sl(), saveSimulation: sl()));
  sl.registerLazySingleton<WorldCupRepository>(
        () => WorldCupRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<WorldCupRemoteDataSource>(
        () => WorldCupRemoteDataSourceImpl(client: sl()),
  );

  //! Core
  // O Dio é um só para todo o app (Singleton)
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton(() => Dio());
  }
  // ==========================================================
  // Feature: Simulations
  // ==========================================================

  // 1. Use Case
  // O Bloc vai chamar isso. Registramos como LazySingleton (instância única criada só quando precisar)
  sl.registerLazySingleton(() => SaveSimulationUseCase(sl()));

  // 2. Repository
  // Quando o UseCase pedir um 'SimulationRepository', entregamos o 'SimulationRepositoryImpl'
  sl.registerLazySingleton<SimulationRepository>(
        () => SimulationRepositoryImpl(dataSource: sl()),
  );

  // 3. Data Source
  // Quando o Repository pedir um 'SimulationDataSource', entregamos a implementação
  sl.registerLazySingleton<SimulationDataSource>(
        () => SimulationDataSourceImpl(), // Se usar Firestore, passaria (firestore: sl()) aqui
  );

  // 4. Bloc (Futuramente)
  // Quando criarmos a tela/cubit, registraremos assim:
  // sl.registerFactory(() => SimulationCubit(saveSimulation: sl()));
}