import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports/core/constants/colors.dart';
import 'package:wsports/features/world_cup/domain/entities/match_entity.dart';
import 'package:wsports/features/world_cup/domain/entities/team_standing.dart';
import 'package:wsports/features/world_cup/domain/logic/standings_calculator.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_bloc.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_event.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_state.dart';

class WorldCupPage extends StatelessWidget {
  const WorldCupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ALTERAÇÃO 1: Aumentamos o length para 3
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroud,
        appBar: AppBar(
          title: const Text("COPA DO MUNDO 2026",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: AppColors.backgroud,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: AppColors.cupGold,
            labelColor: AppColors.cupGold,
            unselectedLabelColor: Colors.white38,
            isScrollable: true, // Adicionado para caber melhor em telas pequenas
            tabs: [
              Tab(text: "GRUPOS"),
              Tab(text: "TABELA"),
              Tab(text: "MATA-MATA"), // Nova Aba
            ],
          ),
        ),
        body: BlocConsumer<WorldCupBloc, WorldCupState>(
          listener: (context, state) {
            if (state.predictionMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.predictionMessage!),
                  backgroundColor: AppColors.cupGold));
            }
          },
          builder: (context, state) {
            if (state.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.cupGold));
            if (state.matches.isEmpty) return const Center(child: Text("Carregando jogos...", style: TextStyle(color: Colors.white54)));

            return TabBarView(
              children: [
                _buildMatchesTab(context, state.matches), // Aba 1: Jogos de Grupo
                _buildStandingsTab(state.matches),        // Aba 2: Tabela de Pontos
                _buildKnockoutTab(context, state.matches),// Aba 3: Mata-mata
              ],
            );
          },
        ),
      ),
    );
  }

  // ===========================================================================
  // ABA 1: LISTA DE JOGOS (Fase de Grupos)
  // ===========================================================================

  Widget _buildMatchesTab(BuildContext context, List matches) {
    // Filtra apenas jogos que contêm "Group" no nome da fase
    final groupMatches = matches.where((m) => m.stage.contains("Group")).toList();

    if (groupMatches.isEmpty) {
      return const Center(child: Text("Jogos da fase de grupos não encontrados.", style: TextStyle(color: Colors.white54)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupMatches.length,
      itemBuilder: (context, index) => _buildMatchCard(context, groupMatches[index]),
    );
  }

  // ===========================================================================
  // ABA 2: CLASSIFICAÇÃO (TABELAS)
  // ===========================================================================

  Widget _buildStandingsTab(List<MatchEntity> matches) {
    final standingsMap = StandingsCalculator.calculate(matches);

    if (standingsMap.isEmpty) {
      return const Center(child: Text("Grupos ainda não definidos.", style: TextStyle(color: Colors.white54)));
    }

    final sortedGroups = standingsMap.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedGroups.length,
      itemBuilder: (context, index) {
        final groupName = sortedGroups[index];
        final teams = standingsMap[groupName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(groupName, style: const TextStyle(color: AppColors.cupGold, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            _buildGroupTable(teams),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // ABA 3: MATA-MATA (NOVA LÓGICA)
  // ===========================================================================

  Widget _buildKnockoutTab(BuildContext context, List matches) {
    // 1. Filtra tudo que NÃO é fase de grupos
    final knockoutMatches = matches.where((m) => !m.stage.contains("Group")).toList();

    if (knockoutMatches.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 50, color: Colors.white24),
            SizedBox(height: 10),
            Text("Mata-mata ainda não definido.", style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }

    // 2. Agrupa por fase (Stage)
    // Ex: "Round of 16" -> [Jogo 1, Jogo 2...]
    final Map<String, List> stagesMap = {};
    for (var match in knockoutMatches) {
      stagesMap.putIfAbsent(match.stage, () => []).add(match);
    }

    // 3. Ordena as fases (Oitavas -> Quartas -> Semi -> Final)
    final sortedStages = stagesMap.keys.toList()..sort((a, b) {
      return _getStageOrder(a).compareTo(_getStageOrder(b));
    });

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedStages.length,
      itemBuilder: (context, index) {
        final stageName = sortedStages[index];
        final stageMatches = stagesMap[stageName]!;

        return Column(
          children: [
            // Título da Fase (Ex: QUARTAS DE FINAL)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.cupGold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _translateStage(stageName),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            // Lista de Jogos daquela fase
            ...stageMatches.map((match) => _buildMatchCard(context, match)).toList(),
          ],
        );
      },
    );
  }

  // Função auxiliar para ordenar cronologicamente as fases
  int _getStageOrder(String stage) {
    if (stage.contains("16")) return 1;       // Round of 16
    if (stage.contains("Quarter")) return 2;  // Quarter-finals
    if (stage.contains("Semi")) return 3;     // Semi-finals
    if (stage.contains("3rd")) return 4;      // Third Place
    if (stage.contains("Final")) return 5;    // Final
    return 6;
  }

  // Função auxiliar para traduzir o nome da fase para PT-BR
  String _translateStage(String stage) {
    if (stage.contains("16")) return "OITAVAS DE FINAL";
    if (stage.contains("Quarter")) return "QUARTAS DE FINAL";
    if (stage.contains("Semi")) return "SEMIFINAL";
    if (stage.contains("3rd")) return "DISPUTA DE 3º LUGAR";
    if (stage.contains("Final")) return "GRANDE FINAL";
    return stage.toUpperCase();
  }

  // ===========================================================================
  // WIDGETS AUXILIARES (Cards, Diálogos, etc)
  // ===========================================================================

  Widget _buildGroupTable(List<TeamStanding> teams) {
    return Container(
      decoration: BoxDecoration(color: AppColors.CardBackgroud, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text("Seleção", style: TextStyle(color: Colors.white54, fontSize: 10))),
                Expanded(child: Center(child: Text("P", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)))),
                Expanded(child: Center(child: Text("J", style: TextStyle(color: Colors.white54, fontSize: 10)))),
                Expanded(child: Center(child: Text("SG", style: TextStyle(color: Colors.white54, fontSize: 10)))),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          ...teams.asMap().entries.map((entry) {
            final int pos = entry.key + 1;
            final TeamStanding team = entry.value;
            final bool isQualified = pos <= 2;
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(border: isQualified ? const Border(left: BorderSide(color: Colors.green, width: 3)) : null),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Row(children: [
                    Text("$pos", style: const TextStyle(color: Colors.white38, fontSize: 12)),
                    const SizedBox(width: 8),
                    Image.network(team.teamLogo, width: 20, errorBuilder: (_,__,___) => const Icon(Icons.circle, size:10)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(team.teamName, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12))),
                  ])),
                  Expanded(child: Center(child: Text("${team.points}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text("${team.played}", style: const TextStyle(color: Colors.white70, fontSize: 12)))),
                  Expanded(child: Center(child: Text("${team.goalDifference}", style: const TextStyle(color: Colors.white70, fontSize: 12)))),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, match) {
    final bool hasPrediction = match.userHomePrediction != null;
    return Card(
      color: AppColors.CardBackgroud,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: hasPrediction ? AppColors.cupGold : Colors.white10, width: hasPrediction ? 1.5 : 1.0),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showPredictionDialog(context, match),
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _teamInfo(match.homeTeamName, match.homeTeamLogo),
                  Column(
                    children: [
                      const Text("OFICIAL", style: TextStyle(color: Colors.white24, fontSize: 10)),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(8)),
                        child: Text("${match.homeScore} x ${match.awayScore}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Text(match.stage, style: const TextStyle(color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                  _teamInfo(match.awayTeamName, match.awayTeamLogo),
                ],
              ),
              if (hasPrediction) ...[
                const Divider(color: Colors.white10, height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.cupGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cupGold),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.psychology, color: AppColors.cupGold, size: 16),
                    const SizedBox(width: 8),
                    Text("Seu Palpite: ${match.userHomePrediction} - ${match.userAwayPrediction}", style: const TextStyle(color: AppColors.cupGold, fontWeight: FontWeight.bold, fontSize: 14)),
                  ]),
                )
              ] else ...[
                const SizedBox(height: 12),
                const Text("Toque para adicionar seu palpite", style: TextStyle(color: AppColors.cupGold, fontSize: 12))
              ]
            ],
          ),
        ),
      ),
    );
  }

  void _showPredictionDialog(BuildContext context, match) {
    final homeController = TextEditingController();
    final awayController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.CardBackgroud,
          title: const Text("Seu Palpite", style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _scoreInput(homeController, match.homeTeamName),
                  const Text("X", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
                  _scoreInput(awayController, match.awayTeamName),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancelar", style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.cupGold),
              onPressed: () {
                final hScore = int.tryParse(homeController.text) ?? 0;
                final aScore = int.tryParse(awayController.text) ?? 0;

                context.read<WorldCupBloc>().add(
                  SaveWorldCupPredictionEvent(
                    matchId: match.id,
                    homeScore: hScore,
                    awayScore: aScore,
                    userId: "user_padrao",
                  ),
                );
                Navigator.pop(dialogContext);
              },
              child: const Text("Salvar", style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Widget _teamInfo(String name, String logo) {
    return Expanded(
      child: Column(
        children: [
          Image.network(logo, height: 40, errorBuilder: (_, __, ___) => const Icon(Icons.flag, color: Colors.white24)),
          const SizedBox(height: 8),
          Text(name, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _scoreInput(TextEditingController controller, String label) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10), overflow: TextOverflow.ellipsis),
        const SizedBox(height: 5),
        SizedBox(
          width: 50,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }
}