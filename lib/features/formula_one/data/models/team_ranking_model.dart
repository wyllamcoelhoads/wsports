import '../../domain/entities/team_ranking_entity.dart';

class TeamRankingModel extends TeamRankingEntity {
  TeamRankingModel({
    required super.position,
    required super.teamName,
    required super.teamLogo,
    required super.points,
  });

  factory TeamRankingModel.fromJson(Map<String, dynamic> json) {
    return TeamRankingModel(
      position: json['position'],
      teamName: json['team']['name'] ?? 'Equipe desconhecida',
      teamLogo: json['team']['logo'] ?? '',
      points: json['points'] ?? 0,
    );
  }
}