import 'package:equatable/equatable.dart';
import 'package:wsports/core/shared/entities/simulation_result_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_detail_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_ranking_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/race_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/team_ranking_entity.dart';

class F1State extends Equatable {
  final List<RaceEntity> races;
  final List<DriverRankingEntity> drivers;
  final List<TeamRankingEntity> teams;
  final DriverDetailEntity? selectedDriver;
  final bool isLoading;
  final String? errorMessage;
  final DriverRankingEntity? driverA;
  final DriverRankingEntity? driverB;
  final SimulationResultEntity? simulationResult;
  final SportType? selectedSportForSimulation;
  final List<SimulationResultEntity> simulationHistory;
  final RaceEntity? selectedRaceForSimulation;

  const F1State({
    this.races = const [],
    this.drivers = const [],
    this.teams = const [],
    this.selectedDriver,
    this.isLoading = false,
    this.errorMessage,
    this.selectedSportForSimulation,
    this.simulationHistory = const [],
    this.driverA,
    this.driverB,
    this.simulationResult,
    this.selectedRaceForSimulation,
  });

  F1State copyWith({
    List<RaceEntity>? races,
    List<DriverRankingEntity>? drivers,
    List<TeamRankingEntity>? teams,
    DriverDetailEntity? selectedDriver,
    bool? isLoading,
    String? errorMessage,
    SportType? selectedSportForSimulation,
    List<SimulationResultEntity>? simulationHistory,
    bool resetSport = false,
    DriverRankingEntity? driverA,
    DriverRankingEntity? driverB,
    SimulationResultEntity? simulationResult,
    RaceEntity? selectedRaceForSimulation,
  }) {
    return F1State(
      races: races ?? this.races,
      drivers: drivers ?? this.drivers,
      teams: teams ?? this.teams,
      selectedDriver: selectedDriver ?? this.selectedDriver,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedSportForSimulation:
      resetSport ? null : (selectedSportForSimulation ?? this.selectedSportForSimulation),
      simulationHistory: simulationHistory ?? this.simulationHistory,
      driverA: driverA ?? this.driverA,
      driverB: driverB ?? this.driverB,
      simulationResult: simulationResult ?? this.simulationResult,
      selectedRaceForSimulation: selectedRaceForSimulation ?? this.selectedRaceForSimulation,
    );
  }

  @override
  List<Object?> get props => [
    races,
    drivers,
    teams,
    selectedDriver,
    isLoading,
    errorMessage,
    selectedSportForSimulation,
    simulationHistory,
    driverA,
    driverB,
    simulationResult,
    selectedRaceForSimulation,
  ];
}
