import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports/features/simulations/domain/entities/simulation_entity.dart';
import 'package:wsports/features/simulations/domain/usecases/save_simulation_usecase.dart';
import 'package:wsports/features/world_cup/domain/repositories/world_cup_repository.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_event.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_state.dart';

class WorldCupBloc extends Bloc<WorldCupEvent, WorldCupState> {
  final WorldCupRepository repository;
  final SaveSimulationUseCase saveSimulation;

  WorldCupBloc({
    required this.repository,
    required this.saveSimulation,
  }) : super(const WorldCupState()) {

    // Registra os handlers (funções que lidam com os eventos)
    on<GetWorldCupMatchesEvent>(_onGetMatches);
    on<SaveWorldCupPredictionEvent>(_onSavePrediction);
  }

  // Lógica para buscar os jogos (já existente)
  Future<void> _onGetMatches(
      GetWorldCupMatchesEvent event,
      Emitter<WorldCupState> emit,
      ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await repository.getMatches();

    result.fold(
          (failure) => emit(state.copyWith(
        isLoading: false,
        errorMessage: "Não consegui carregar os jogos.",
      )),
          (matches) => emit(state.copyWith(
        isLoading: false,
        matches: matches,
      )),
    );
  }

  // --- NOVA LÓGICA: Salvar a Simulação ---
  Future<void> _onSavePrediction(
      SaveWorldCupPredictionEvent event,
      Emitter<WorldCupState> emit,
      ) async {
    // 1. Cria a entidade com os dados vindos da UI (Evento)
    final simulation = SimulationEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Gera ID único temporário
      userId: event.userId,
      matchId: event.matchId,
      sportId: 'world_cup', // Identificador fixo da feature
      predictedHomeScore: event.homeScore,
      predictedAwayScore: event.awayScore,
      createdAt: DateTime.now(),
      pointsEarned: null, // Ainda não calculou pontos
    );

    try {
      // 2. Chama o UseCase injetado
      await saveSimulation(simulation);

      // 3. Emite estado de sucesso
      // Usamos 'predictionMessage' para a UI mostrar um SnackBar, por exemplo.
      emit(state.copyWith(
        predictionMessage: "Palpite salvo com sucesso! ⚽",
      ));

      // Dica: Limpe a mensagem logo depois se necessário, ou deixe a UI tratar isso.

    } catch (e) {
      // 4. Emite estado de erro caso falhe
      emit(state.copyWith(
        errorMessage: "Erro ao salvar o palpite. Tente novamente.",
      ));
    }
  }
}