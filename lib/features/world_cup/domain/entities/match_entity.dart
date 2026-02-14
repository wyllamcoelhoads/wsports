import 'package:equatable/equatable.dart';

class MatchEntity extends Equatable {
  final String id;
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final int homeScore; // Placar Real da API
  final int awayScore; // Placar Real da API
  final DateTime date;
  final String status;
  final String stage;
  final String? group;

  // --- NOVOS CAMPOS QUE FALTAVAM ---
  final int? userHomePrediction;
  final int? userAwayPrediction;

  const MatchEntity({
    required this.id,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.homeScore,
    required this.awayScore,
    required this.date,
    required this.status,
    required this.stage,
    this.group,
    // Adicione no construtor
    this.userHomePrediction,
    this.userAwayPrediction,
  });

  @override
  List<Object?> get props => [
    id, homeTeamName, awayTeamName, homeScore, awayScore,
    status, stage, group, userHomePrediction, userAwayPrediction
  ];
}