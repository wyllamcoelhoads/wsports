import 'package:equatable/equatable.dart';
import 'package:wsports/features/world_cup/domain/entities/match_entity.dart';


class WorldCupState extends Equatable {
  final bool isLoading;
  final List<MatchEntity> matches;
  final String? errorMessage;

  const WorldCupState({
    this.isLoading = false,
    this.matches = const [],
    this.errorMessage,
  });

  // Método auxiliar para mudar apenas o que for preciso (Padrão Premium)
  WorldCupState copyWith({
    bool? isLoading,
    List<MatchEntity>? matches,
    String? errorMessage,
  }) {
    return WorldCupState(
      isLoading: isLoading ?? this.isLoading,
      matches: matches ?? this.matches,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, matches, errorMessage];
}