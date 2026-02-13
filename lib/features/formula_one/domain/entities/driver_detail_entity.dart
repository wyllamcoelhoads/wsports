class DriverDetailEntity {
  final int id;
  final String name;
  final String image;
  final String nationality;
  final String countryCode;
  final String birthdate;
  final int? number;
  final int podiums;
  final String careerPoints;
  final List<TeamHistoryEntity> teamsHistory;

  DriverDetailEntity({
    required this.id, required this.name, required this.image,
    required this.nationality, required this.countryCode,
    required this.birthdate, this.number, required this.podiums,
    required this.careerPoints, required this.teamsHistory,
  });
}

// ESTA É A CLASSE QUE ESTAVA FALTANDO
class TeamHistoryEntity {
  final int season;
  final String teamName;
  final String teamLogo;

  TeamHistoryEntity({
    required this.season,
    required this.teamName,
    required this.teamLogo
  });
}