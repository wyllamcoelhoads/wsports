import 'package:dartz/dartz.dart';
import 'package:wsports/core/errors/failures.dart';
import 'package:wsports/features/world_cup/data/datasources/world_cup_remote_data_source.dart';
import 'package:wsports/features/world_cup/domain/entities/match_entity.dart';
import 'package:wsports/features/world_cup/domain/repositories/world_cup_repository.dart';


class WorldCupRepositoryImpl implements WorldCupRepository {
  final WorldCupRemoteDataSource remoteDataSource;

  WorldCupRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MatchEntity>>> getMatches() async {
    try {
      // Chama o "Robô da Internet" que criamos no passo anterior
      final remoteMatches = await remoteDataSource.getMatches();
      return Right(remoteMatches.cast<MatchEntity>());
    } catch (e) {
      // Se a internet cair ou a API falhar, retornamos o erro padronizado do seu app
      return Left(ServerFailure());
    }
  }
}