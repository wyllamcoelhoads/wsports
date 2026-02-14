import 'package:equatable/equatable.dart';
import 'package:wsports/features/world_cup/domain/entities/match_entity.dart';

class WorldCupState extends Equatable {
  final bool isLoading;
  final List<MatchEntity> matches;
  final String? errorMessage;
  // Feedback para quando salvar o palpite
  final String? predictionMessage;

  const WorldCupState({
    this.isLoading = false,
    this.matches = const [],
    this.errorMessage,
    this.predictionMessage,
  });

  // Este método permite atualizar apenas um campo mantendo os outros
  WorldCupState copyWith({
    bool? isLoading,
    List<MatchEntity>? matches,
    String? errorMessage,
    String? predictionMessage,
  }) {
    return WorldCupState(
      isLoading: isLoading ?? this.isLoading,
      matches: matches ?? this.matches,
      errorMessage: errorMessage, // Se passar null, limpa o erro (opcional)
      predictionMessage: predictionMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, matches, errorMessage, predictionMessage];
}