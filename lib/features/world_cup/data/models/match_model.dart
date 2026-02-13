

import 'package:wsports/features/world_cup/domain/entities/match_entity.dart';

class MatchModel extends MatchEntity {
  const MatchModel({
    required super.id,
    required super.homeTeamName,
    required super.awayTeamName,
    required super.homeTeamLogo,
    required super.awayTeamLogo,
    required super.homeScore,
    required super.awayScore,
    required super.date,
    required super.status,
    required super.stage,
    super.group,
  });

  // Fábrica que transforma o JSON da API em um objeto que o Flutter entende
  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'].toString(),
      homeTeamName: json['home_team']['name'],
      awayTeamName: json['away_team']['name'],
      homeTeamLogo: json['home_team']['logo'],
      awayTeamLogo: json['away_team']['logo'],
      homeScore: json['scores']['home'] ?? 0,
      awayScore: json['scores']['away'] ?? 0,
      date: DateTime.parse(json['date']),
      status: json['status'],
      stage: json['stage'],
      group: json['group_name'],
    );
  }
}