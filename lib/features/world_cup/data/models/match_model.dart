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
    // Passamos os novos campos para o pai (Entity)
    super.userHomePrediction,
    super.userAwayPrediction,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['fixture']['id'].toString(),
      homeTeamName: json['teams']['home']['name'],
      awayTeamName: json['teams']['away']['name'],
      homeTeamLogo: json['teams']['home']['logo'],
      awayTeamLogo: json['teams']['away']['logo'],
      homeScore: json['goals']['home'] ?? 0,
      awayScore: json['goals']['away'] ?? 0,
      date: DateTime.parse(json['fixture']['date']),
      status: json['fixture']['status']['long'],
      stage: json['league']['round'],
      group: json['league']['group'],
      // Nota: Ao vir da API oficial, o palpite do usuário é nulo.
      // Nós vamos preencher isso depois, na lógica do Bloc.
      userHomePrediction: null,
      userAwayPrediction: null,
    );
  }

  // Método auxiliar útil para criar uma cópia atualizada
  MatchModel copyWith({
    int? userHomePrediction,
    int? userAwayPrediction,
  }) {
    return MatchModel(
      id: id,
      homeTeamName: homeTeamName,
      awayTeamName: awayTeamName,
      homeTeamLogo: homeTeamLogo,
      awayTeamLogo: awayTeamLogo,
      homeScore: homeScore,
      awayScore: awayScore,
      date: date,
      status: status,
      stage: stage,
      group: group,
      // Se passar novo valor, usa. Se não, mantém o atual.
      userHomePrediction: userHomePrediction ?? this.userHomePrediction,
      userAwayPrediction: userAwayPrediction ?? this.userAwayPrediction,
    );
  }
}