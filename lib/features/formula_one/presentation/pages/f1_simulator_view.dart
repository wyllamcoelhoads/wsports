import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports/core/constants/colors.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_ranking_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/race_entity.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_bloc.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_event.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_state.dart';

class F1SimulatorView extends StatelessWidget {
  const F1SimulatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<F1Bloc, F1State>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "DUELO DE TITÃS",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 30),

              // 1. NOVO: SELETOR DE PISTA (GP)
              _buildTrackPicker(context, state.selectedRaceForSimulation, state.races),

              const SizedBox(height: 30),

              // 2. ÁREA DE SELEÇÃO DE PILOTOS (Lado a Lado)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDriverPicker(context, state.driverA, 'A'),
                  const Text("VS", style: TextStyle(color: AppColors.f1Red, fontSize: 24, fontWeight: FontWeight.bold)),
                  _buildDriverPicker(context, state.driverB, 'B'),
                ],
              ),

              const SizedBox(height: 40),

              // 3. BOTÃO SIMULAR (Atualizado com validação da pista)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.f1Red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: (state.driverA != null && state.driverB != null && state.selectedRaceForSimulation != null)
                      ? () => context.read<F1Bloc>().add(RunSimulationEvent())
                      : null,
                  child: const Text("INICIAR SIMULAÇÃO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),

              const SizedBox(height: 30),

              // 4. RESULTADO
              if (state.simulationResult != null) _buildResultCard(state.simulationResult!),
            ],
          ),
        );
      },
    );
  }

  // --- MÉTODOS DE INTERFACE (WIDGETS) ---

  // NOVO: Widget visual do seletor de pista
  Widget _buildTrackPicker(BuildContext context, RaceEntity? selectedRace, List<RaceEntity> races) {
    return GestureDetector(
      onTap: () => _showRaceSelector(context, races),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.CardBackgroud,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selectedRace != null ? AppColors.f1Red : Colors.white10,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: AppColors.f1Red),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedRace != null ? selectedRace.raceName : "SELECIONAR CIRCUITO",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  if (selectedRace != null)
                    Text(
                      selectedRace.circuitName,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                ],
              ),
            ),
            const Icon(Icons.expand_more, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverPicker(BuildContext context, DriverRankingEntity? driver, String slot) {
    return GestureDetector(
      onTap: () => _showDriverSelector(context, slot),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.CardBackgroud,
            backgroundImage: driver != null ? NetworkImage(driver.image) : null,
            child: driver == null ? const Icon(Icons.add, color: Colors.white, size: 40) : null,
          ),
          const SizedBox(height: 10),
          Text(
            driver?.driverName ?? "Selecionar",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // --- MÉTODOS DE LÓGICA (MODAIS/SELEÇÃO) ---

  // NOVO: Abre a lista de pistas (GPs)
  void _showRaceSelector(BuildContext context, List<RaceEntity> races) {
    final f1Bloc = context.read<F1Bloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroud,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => BlocProvider.value(
        value: f1Bloc,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("CALENDÁRIO DA TEMPORADA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: races.length,
                itemBuilder: (context, index) {
                  final race = races[index];
                  return ListTile(
                    leading: const Icon(Icons.flag_outlined, color: Colors.white54),
                    title: Text(race.raceName, style: const TextStyle(color: Colors.white)),
                    subtitle: Text(race.circuitName, style: const TextStyle(color: Colors.white38)),
                    onTap: () {
                      f1Bloc.add(SelectRaceForSimulationEvent(race));
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDriverSelector(BuildContext context, String slot) {
    final f1Bloc = context.read<F1Bloc>();
    final state = f1Bloc.state;

    final filteredDrivers = state.drivers.where((driver) {
      return slot == 'A' ? driver.id != state.driverB?.id : driver.id != state.driverA?.id;
    }).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroud,
      builder: (_) => BlocProvider.value(
        value: f1Bloc,
        child: ListView.builder(
          itemCount: filteredDrivers.length,
          itemBuilder: (context, index) {
            final d = filteredDrivers[index];
            return ListTile(
              title: Text(d.driverName, style: const TextStyle(color: Colors.white)),
              onTap: () {
                f1Bloc.add(slot == 'A' ? SelectDriverAEvent(d) : SelectDriverBEvent(d));
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultCard(result) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.CardBackgroud,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.f1Red, width: 2),
      ),
      child: Column(
        children: [
          const Text("VENCEDOR PREVISTO", style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 10),
          Text(result.winnerName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.white10, height: 30),
          const Text("Baseado em contexto de pista e performance.", style: TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}