enum SportType { f1, football }

class SimulationResultEntity {
  final String id;
  final SportType sport;
  final String title;
  final String winnerName;
  final String winnerLogo;
  final DateTime date;

  SimulationResultEntity({
    required this.id, required this.sport, required this.title,
    required this.winnerName, required this.winnerLogo, required this.date,
  });
}