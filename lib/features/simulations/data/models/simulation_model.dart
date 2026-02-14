import 'package:wsports/features/simulations/domain/entities/simulation_entity.dart';

class SimulationModel extends SimulationEntity {
  const SimulationModel({
    required super.id,
    required super.userId,
    required super.matchId,
    required super.sportId, // "world_cup"
    required super.predictedHomeScore,
    required super.predictedAwayScore,
    required super.createdAt,
    super.pointsEarned,
  });

  // Converte um JSON (do banco ou API) para o nosso objeto
  factory SimulationModel.fromJson(Map<String, dynamic> json) {
    return SimulationModel(
      id: json['id'],
      userId: json['user_id'],
      matchId: json['match_id'],
      sportId: json['sport_id'],
      predictedHomeScore: json['predicted_home_score'],
      predictedAwayScore: json['predicted_away_score'],
      createdAt: DateTime.parse(json['created_at']),
      pointsEarned: json['points_earned'], // Pode ser null
    );
  }

  // Converte nosso objeto para JSON (para salvar)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'match_id': matchId,
      'sport_id': sportId,
      'predicted_home_score': predictedHomeScore,
      'predicted_away_score': predictedAwayScore,
      'created_at': createdAt.toIso8601String(),
      'points_earned': pointsEarned,
    };
  }

  // Método auxiliar para criar uma cópia modificada (útil se o usuário editar o palpite)
  SimulationModel copyWith({
    String? id,
    String? userId,
    String? matchId,
    String? sportId,
    int? predictedHomeScore,
    int? predictedAwayScore,
    DateTime? createdAt,
    int? pointsEarned,
  }) {
    return SimulationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      matchId: matchId ?? this.matchId,
      sportId: sportId ?? this.sportId,
      predictedHomeScore: predictedHomeScore ?? this.predictedHomeScore,
      predictedAwayScore: predictedAwayScore ?? this.predictedAwayScore,
      createdAt: createdAt ?? this.createdAt,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }
}