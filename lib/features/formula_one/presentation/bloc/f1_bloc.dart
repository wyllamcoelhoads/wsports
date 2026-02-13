import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports/core/shared/entities/simulation_result_entity.dart';
import 'package:wsports/features/formula_one/domain/repositories/f1_repository.dart';
import 'package:wsports/features/formula_one/domain/entities/race_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_ranking_entity.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_event.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_state.dart';


class F1Bloc extends Bloc<F1Event, F1State> {
  final F1Repository repository;
  F1Bloc({required this.repository}) : super(F1State()) {

    on<GetScheduleEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final allRaces = await repository.getSchedule();

        final mainRaceOnly = allRaces.where((r) => r.type == "Race").toList();
        emit(state.copyWith(races: mainRaceOnly, isLoading: false));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      }
    });

    on<GetDriversRankingEvent>((event, emit) async {
      debugPrint("EVENTO GetDriversRankingEvent RECEBIDO");
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final drivers = await repository.getDriverRankings(event.season);
        emit(state.copyWith(drivers: drivers, isLoading: false));
        debugPrint("EVENTO GetDriversRankingEvent chegou até emit");
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
        debugPrint("EVENTO GetDriversRankingEvent chegou até emit catch");
      }
    });

    on<GetDriverDetailsEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final details = await repository.getDriverDetails(event.driverId);
        emit(state.copyWith(selectedDriver: details, isLoading: false));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
      }
    });

    on<GetTeamsRankingEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null));
      try {
        final teams = await repository.getTeamRankings(event.season);
        emit(state.copyWith(teams: teams, isLoading: false));
      } catch (e) {
        emit(state.copyWith(errorMessage: "Erro ao buscar equipes: $e", isLoading: false));
      }
    });

    // No f1_bloc.dart, dentro do construtor:

    on<SelectDriverAEvent>((event, emit) {
      emit(state.copyWith(driverA: event.driver, simulationResult: null));
    });

    on<SelectDriverBEvent>((event, emit) {
      emit(state.copyWith(driverB: event.driver, simulationResult: null));
    });

    // 1. NOVO: Seleção da Corrida/Pista''
    on<SelectRaceForSimulationEvent>((event, emit) {
      emit(state.copyWith(
        selectedRaceForSimulation: event.race,
        simulationResult: null, // Limpa resultado anterior ao mudar a pista
      ));
    });

    // 2. ATUALIZADO: Simulação com Fator Pista
    on<RunSimulationEvent>((event, emit) {
      // Verificamos se tudo está selecionado: Piloto A, Piloto B e a Pista
      if (state.driverA != null && state.driverB != null && state.selectedRaceForSimulation != null) {

        // Pontuação base (carreira/temporada)
        double scoreA = state.driverA!.points.toDouble();
        double scoreB = state.driverB!.points.toDouble();

        // --- LÓGICA DE REALIDADE ---
        // Exemplo: Se a pista for travada (Mônaco, Hungria), damos bônus por habilidade.
        // Se for pista veloz (Monza, Spa), damos bônus por motor (Equipe).
        String circuit = state.selectedRaceForSimulation!.circuitName.toLowerCase();

        if (circuit.contains("monaco") || circuit.contains("hungaroring")) {
          // Bônus para pilotos técnicos em pistas travadas
          scoreA += 15.0;
        } else if (circuit.contains("monza") || circuit.contains("spa")) {
          // Bônus para carros mais rápidos em retas
          scoreB += 10.0;
        }

        // Determina o vencedor com base no novo score calculado
        final winner = scoreA >= scoreB ? state.driverA! : state.driverB!;

        final result = SimulationResultEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sport: SportType.f1,
          // Agora o título inclui o nome do GP!
          title: "GP de ${state.selectedRaceForSimulation!.raceName}: ${state.driverA!.driverName} vs ${state.driverB!.driverName}",
          winnerName: winner.driverName,
          winnerLogo: winner.image,
          date: DateTime.now(),
        );

        emit(state.copyWith(
          simulationResult: result,
          simulationHistory: [result, ...state.simulationHistory],
        ));
      }
    });

    // 3. ATUALIZADO: Reset agora limpa a pista também
    on<ResetSimulationEvent>((event, emit) {
      emit(F1State(
        races: state.races,
        drivers: state.drivers,
        teams: state.teams,
        simulationHistory: state.simulationHistory,
        selectedSportForSimulation: null,
        selectedRaceForSimulation: null, // Limpa a pista ao voltar
        driverA: null,
        driverB: null,
      ));
    });

    on<ChangeSimulationSportEvent>((event, emit) {
      // Ao mudar de esporte, limpamos as seleções antigas para evitar bugs
      emit(state.copyWith(
        selectedSportForSimulation: event.sport,
        driverA: null, // Limpa seleção de F1 anterior
        driverB: null,
        simulationResult: null,
      ));
    });
  }
}