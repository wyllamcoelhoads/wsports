import 'package:equatable/equatable.dart';

class SimulationEntity extends Equatable {
  final String id;           // ID único da simulação/palpite
  final String userId;       // Quem fez o palpite
  final String matchId;      // ID da partida (o mesmo que vem da API da Copa)
  final String sportId;      // Ex: "world_cup_2022" ou "f1" (útil para filtrar depois)
  final int predictedHomeScore;
  final int predictedAwayScore;
  final DateTime createdAt;
  final int? pointsEarned;   // Null enquanto a partida não acontece

  const SimulationEntity({
    required this.id,
    required this.userId,
    required this.matchId,
    required this.sportId,
    required this.predictedHomeScore,
    required this.predictedAwayScore,
    required this.createdAt,
    this.pointsEarned,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    matchId,
    sportId,
    predictedHomeScore,
    predictedAwayScore,
    pointsEarned
  ];
}