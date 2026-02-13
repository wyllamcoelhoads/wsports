import 'package:equatable/equatable.dart';

class MatchEntity extends Equatable {
  final String id;
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final int homeScore;
  final int awayScore;
  final DateTime date;
  final String status; // 'scheduled', 'live', 'finished'
  final String stage;  // 'Group Stage', 'Quarter-final', etc.
  final String? group; // 'Group A', 'Group B'

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
  });

  @override
  List<Object?> get props => [id, homeScore, awayScore, status];
}