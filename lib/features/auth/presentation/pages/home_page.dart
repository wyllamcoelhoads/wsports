import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports/core/constants/colors.dart';
import 'package:wsports/core/shared/entities/simulation_result_entity.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_bloc.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_event.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_state.dart';
import 'package:wsports/features/formula_one/presentation/pages/f1_page.dart';
import 'package:wsports/features/formula_one/presentation/pages/f1_simulator_view.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_bloc.dart';
import 'package:wsports/features/world_cup/presentation/bloc/world_cup_event.dart';
import 'package:wsports/features/world_cup/presentation/pages/world_cup_page.dart';
import 'package:wsports/injection_container.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Começa na aba de Fórmula 1

  //Antes de implementar o multcerebro esse funcionava normalmente:
  /*
  @override
  Widget build(BuildContext context) {
    // 1. O BlocProvider no topo garante que a seleção de pilotos funcione em todas as telas
    return BlocProvider(
      create: (context) => sl<F1Bloc>()..add(GetScheduleEvent()),
      child: Scaffold(
        body: BlocBuilder<F1Bloc, F1State>(
          builder: (context, state) {
            return IndexedStack(
              index: _currentIndex,
              children: [
                const Center(child: Text("🏆 Copa do Mundo - Em Breve", style: TextStyle(color: Colors.white))),
                const F1Page(),
                // 2. Aqui usamos o método dinâmico para decidir entre Menu ou Simulador
                _buildSimulatorTab(context, state),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.CardBackgroud,
          selectedItemColor: _currentIndex == 0
              ? AppColors.cupGold
              : _currentIndex == 1
              ? AppColors.f1Red
              : AppColors.simulacao,
          unselectedItemColor: AppColors.textSecondary,
          items: const [
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.trophy), label: 'Copa do Mundo'),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.car), label: 'Fórmula 1'),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.flaskVial), label: 'Simulador'),
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    // 1. MultiBlocProvider permite carregar vários "cérebros" ao mesmo tempo
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<F1Bloc>()..add(GetScheduleEvent())),
        // Adicionamos o cérebro da Copa aqui!
        BlocProvider(create: (context) => sl<WorldCupBloc>()..add(GetWorldCupMatchesEvent())),
      ],
      child: Scaffold(
        body: BlocBuilder<F1Bloc, F1State>(
          builder: (context, state) {
            return IndexedStack(
              index: _currentIndex,
              children: [
                // 2. Trocamos o texto "Em Breve" pela página real da Copa
                const WorldCupPage(),
                const F1Page(),
                _buildSimulatorTab(context, state),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.CardBackgroud,
          selectedItemColor: _currentIndex == 0
              ? AppColors.cupGold
              : _currentIndex == 1
              ? AppColors.f1Red
              : AppColors.simulacao,
          unselectedItemColor: AppColors.textSecondary,
          items: const [
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.trophy), label: 'Copa do Mundo'),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.car), label: 'Fórmula 1'),
            BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.flaskVial), label: 'Simulador'),
          ],
        ),
      ),
    );
  }


  // --- MÉTODOS AUXILIARES (DENTRO DA CLASSE) ---

  Widget _buildSimulatorTab(BuildContext context, F1State state) {
    // 3. Se nenhum esporte foi escolhido, mostra o menu de seleção
    if (state.selectedSportForSimulation == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("ESCOLHA O ESPORTE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 30),
          _sportOption(context, "FÓRMULA 1", FontAwesomeIcons.car, SportType.f1),
          _sportOption(context, "COPA DO MUNDO", FontAwesomeIcons.trophy, SportType.football),
          const Divider(height: 60, color: Colors.white10),
          const Text("HISTÓRICO RECENTE", style: TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 10),
          Expanded(child: _buildSimulationHistoryTab(state)),
        ],
      );
    }

    // 4. Se F1 estiver selecionado, mostra o Duelo com botão de Voltar
    return Column(
      children: [
        SafeArea(
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.read<F1Bloc>().add(ResetSimulationEvent()),
            ),
          ),
        ),
        const Expanded(child: F1SimulatorView()),
      ],
    );
  }

  Widget _sportOption(BuildContext context, String title, IconData icon, SportType type) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      leading: FaIcon(icon, color: type == SportType.f1 ? AppColors.f1Red : AppColors.cupGold),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: () {
        context.read<F1Bloc>().add(ChangeSimulationSportEvent(type));
      },
    );
  }

  Widget _buildSimulationHistoryTab(F1State state) {
    if (state.simulationHistory.isEmpty) {
      return const Center(
        child: Text("Nenhuma simulação salva ainda.", style: TextStyle(color: Colors.white54)),
      );
    }

    return ListView.builder(
      itemCount: state.simulationHistory.length,
      itemBuilder: (context, index) {
        final sim = state.simulationHistory[index];
        return Card(
          color: AppColors.CardBackgroud,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: ClipOval(
                child: Image.network(
                  sim.winnerLogo,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white),
                )
            ),
            title: Text(sim.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text("Vencedor: ${sim.winnerName}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        );
      },
    );
  }
}