import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports/features/world_cup/domain/repositories/world_cup_repository.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_event.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_state.dart';


class WorldCupBloc extends Bloc<WorldCupEvent, WorldCupState> {
  final WorldCupRepository repository;

  WorldCupBloc({required this.repository}) : super(const WorldCupState()) {

    // Quando receber o evento de buscar jogos:
    on<GetWorldCupMatchesEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true)); // Cérebro: "Estou pensando..."

      final result = await repository.getMatches();

      // O 'fold' decide o que fazer se der erro (Left) ou sucesso (Right)
      result.fold(
            (failure) => emit(state.copyWith(
            isLoading: false,
            errorMessage: "Não consegui os jogos."
        )),
            (matches) => emit(state.copyWith(
            isLoading: false,
            matches: matches
        )),
      );
    });
  }
}