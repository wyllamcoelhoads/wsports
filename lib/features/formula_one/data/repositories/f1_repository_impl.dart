
import 'package:wsports/features/formula_one/data/datasources/f1_remote_data_source.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_detail_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_ranking_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/race_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/team_ranking_entity.dart';
import 'package:wsports/features/formula_one/domain/repositories/f1_repository.dart';

class F1RepositoryImpl implements F1Repository {
  final F1RemoteDataSource remoteDataSource;

  F1RepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RaceEntity>> getSchedule() async {
    return await remoteDataSource.getSchedule2026();
  }

  @override
  Future<List<DriverRankingEntity>> getDriverRankings(String season) async {
    final models = await remoteDataSource.getDriverRankings(season);
    // Cast explícito para garantir que a lista de Model seja aceita como Entity
    return models;
  }

  @override
  Future<List<TeamRankingEntity>> getTeamRankings(String season) async {
    final result = await remoteDataSource.getTeamRankings(season);
    return result.cast<TeamRankingEntity>();
  }

  @override
  Future<DriverDetailEntity> getDriverDetails(int id) async {
    try {
      // Chama o método que você criou no Data Source (image_894d9f.jpg)
      final result = await remoteDataSource.getDriverDetails(id);
      return result; // Retorna o modelo (que já é uma entidade)
    } catch (e) {
      rethrow;
    }
  }
}