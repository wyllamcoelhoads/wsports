class TeamStanding {
  final String teamName;
  final String teamLogo;
  int points;
  int played;
  int won;
  int drawn;
  int lost;
  int goalsFor;
  int goalsAgainst;

  TeamStanding({
    required this.teamName,
    required this.teamLogo,
    this.points = 0,
    this.played = 0,
    this.won = 0,
    this.drawn = 0,
    this.lost = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
  });

  int get goalDifference => goalsFor - goalsAgainst;
}