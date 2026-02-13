

import 'package:wsports/core/shared/entities/simulation_result_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_ranking_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/race_entity.dart';

abstract class F1Event {}

class GetScheduleEvent extends F1Event {}

class GetDriversRankingEvent extends F1Event {
  final String season;
  GetDriversRankingEvent(this.season);
}

class GetTeamsRankingEvent extends F1Event {
  final String season;
  GetTeamsRankingEvent(this.season);
}

class GetDriverDetailsEvent extends F1Event {
  final int driverId;
  GetDriverDetailsEvent(this.driverId);
}

class SelectDriverAEvent extends F1Event {
  final DriverRankingEntity driver;
  SelectDriverAEvent(this.driver);
}

class SelectDriverBEvent extends F1Event {
  final DriverRankingEntity driver;
  SelectDriverBEvent(this.driver);
}

class RunSimulationEvent extends F1Event {}

class ChangeSimulationSportEvent extends F1Event {
  final SportType sport; // SportType vem da sua SimulationResultEntity
  ChangeSimulationSportEvent(this.sport);
}
class ResetSimulationEvent extends F1Event {}

class SelectRaceForSimulationEvent extends F1Event {
  final RaceEntity race;
  SelectRaceForSimulationEvent(this.race);
}