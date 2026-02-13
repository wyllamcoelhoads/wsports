import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports/core/constants/colors.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_bloc.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_state.dart';



class WorldCupPage extends StatelessWidget {
  const WorldCupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroud,
      appBar: AppBar(
        title: const Text("COPA DO MUNDO 2026", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.backgroud,
        elevation: 0,
      ),
      body: BlocBuilder<WorldCupBloc, WorldCupState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.cupGold));
          }
          if (state.errorMessage != null){
            return Center(child: Text("Erro: ${state.errorMessage}", style: TextStyle(color: Colors.red)));
          }

          if (state.matches.isEmpty) {
            return const Center(child: Text("Nenhum jogo encontrado.", style: TextStyle(color: Colors.white54)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.matches.length,
            itemBuilder: (context, index) => _buildMatchCard(state.matches[index]),
          );
        },
      ),
    );
  }

  Widget _buildMatchCard(match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.CardBackgroud,
        borderRadius: BorderRadius.circular(15),
        border: const Border(left: BorderSide(color: AppColors.cupGold, width: 4)), // Identidade visual da Copa
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time da Casa
          _teamInfo(match.homeTeamName, match.homeTeamLogo),
          // Placar
          Column(
            children: [
              Text("${match.homeScore} - ${match.awayScore}",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text(match.stage, style: const TextStyle(color: Colors.white38, fontSize: 10)),
            ],
          ),
          // Time Visitante
          _teamInfo(match.awayTeamName, match.awayTeamLogo),
        ],
      ),
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
}