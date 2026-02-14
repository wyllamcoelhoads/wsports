import 'package:equatable/equatable.dart';

abstract class WorldCupEvent extends Equatable {
  const WorldCupEvent();

  @override
  List<Object> get props => [];
}

// Evento que já existia (para buscar os jogos)
class GetWorldCupMatchesEvent extends WorldCupEvent {}

// --- O NOVO EVENTO QUE FALTAVA ---
// Este evento carrega os dados que o usuário digitou para o Bloc processar
class SaveWorldCupPredictionEvent extends WorldCupEvent {
  final String matchId;
  final int homeScore;
  final int awayScore;
  final String userId;

  const SaveWorldCupPredictionEvent({
    required this.matchId,
    required this.homeScore,
    required this.awayScore,
    required this.userId,
  });

  @override
  List<Object> get props => [matchId, homeScore, awayScore, userId];
}