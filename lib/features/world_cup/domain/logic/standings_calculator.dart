import 'package:wsports/features/world_cup/domain/entities/match_entity.dart';
import 'package:wsports/features/world_cup/domain/entities/team_standing.dart';

class StandingsCalculator {

  /// Recebe todos os jogos e retorna um Map onde a Chave é o Grupo (ex: "Group A")
  /// e o Valor é a lista de times classificados.
  static Map<String, List<TeamStanding>> calculate(List<MatchEntity> allMatches) {
    final Map<String, Map<String, TeamStanding>> groupsMap = {};

    // 1. Filtra apenas jogos que tem grupo definido
    final groupMatches = allMatches.where((m) => m.group != null).toList();

    for (var match in groupMatches) {
      final groupName = match.group!;

      // Garante que o grupo existe no mapa
      groupsMap.putIfAbsent(groupName, () => {});

      // Garante que os times existem no mapa do grupo
      groupsMap[groupName]!.putIfAbsent(match.homeTeamName,
              () => TeamStanding(teamName: match.homeTeamName, teamLogo: match.homeTeamLogo));
      groupsMap[groupName]!.putIfAbsent(match.awayTeamName,
              () => TeamStanding(teamName: match.awayTeamName, teamLogo: match.awayTeamLogo));

      // 2. Define qual placar usar (Prioridade: Palpite do Usuário > Placar Real)
      // Se quiser usar só o real, basta remover a verificação do userPrediction
      int? homeScore;
      int? awayScore;

      if (match.userHomePrediction != null && match.userAwayPrediction != null) {
        homeScore = match.userHomePrediction;
        awayScore = match.userAwayPrediction;
      } else if (match.status == "Match Finished") { // Ou verifique se scores não são nulos
        homeScore = match.homeScore;
        awayScore = match.awayScore;
      }

      // Se o jogo ainda não aconteceu e não tem palpite, ignora o cálculo
      if (homeScore == null || awayScore == null) continue;

      // 3. Aplica a lógica de pontos
      final homeStats = groupsMap[groupName]![match.homeTeamName]!;
      final awayStats = groupsMap[groupName]![match.awayTeamName]!;

      homeStats.played++;
      awayStats.played++;
      homeStats.goalsFor += homeScore;
      homeStats.goalsAgainst += awayScore;
      awayStats.goalsFor += awayScore;
      awayStats.goalsAgainst += homeScore;

      if (homeScore > awayScore) {
        homeStats.points += 3;
        homeStats.won++;
        awayStats.lost++;
      } else if (awayScore > homeScore) {
        awayStats.points += 3;
        awayStats.won++;
        homeStats.lost++;
      } else {
        homeStats.points += 1;
        awayStats.points += 1;
        homeStats.drawn++;
        awayStats.drawn++;
      }
    }

    // 4. Converte para lista e Ordena (Critérios FIFA: Pontos > Saldo > Gols Pró)
    final Map<String, List<TeamStanding>> finalStandings = {};

    groupsMap.forEach((group, teamsMap) {
      final classification = teamsMap.values.toList();
      classification.sort((a, b) {
        if (b.points != a.points) return b.points.compareTo(a.points);
        if (b.goalDifference != a.goalDifference) return b.goalDifference.compareTo(a.goalDifference);
        return b.goalsFor.compareTo(a.goalsFor);
      });
      finalStandings[group] = classification;
    });

    return finalStandings;
  }
}