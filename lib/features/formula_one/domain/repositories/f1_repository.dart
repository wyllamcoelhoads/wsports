

import 'package:wsports/features/formula_one/domain/entities/driver_detail_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_ranking_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/race_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/team_ranking_entity.dart';

abstract class F1Repository {
  Future<List<RaceEntity>> getSchedule();
  Future<List<DriverRankingEntity>> getDriverRankings(String season);
  Future<List<TeamRankingEntity>> getTeamRankings(String season);
  Future<DriverDetailEntity> getDriverDetails(int id);
}