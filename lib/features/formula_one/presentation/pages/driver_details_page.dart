import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wsports/core/constants/colors.dart';
import 'package:wsports/core/utils/date_formatter.dart';
import 'package:wsports/core/widgets/app_network_image.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_detail_entity.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_bloc.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_state.dart';


class DriverDetailsPage extends StatelessWidget {
  const DriverDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroud, // Corrigido para a cor de fundo padrão
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Perfil do Piloto", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: BlocBuilder<F1Bloc, F1State>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.f1Red));
          }

          final driver = state.selectedDriver;
          if (driver == null) {
            return const Center(
              child: Text("Dados não encontrados.", style: TextStyle(color: Colors.white)),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(driver), // Removido o 'as' pois o tipo já está no método
                const SizedBox(height: 24),
                _buildStatsGrid(driver),
                const SizedBox(height: 32),
                const Text(
                  "HISTÓRICO NA F1",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 16),
                _buildHistoryTimeline(driver),
              ],
            ),
          );
        },
      ),
    );
  }

  // Corrigido: Adicionado o tipo DriverDetailEntity e removida imagem duplicada
  Widget _buildHeader(DriverDetailEntity driver) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(55),
          child: AppNetworkImage(imageUrl: driver.image, size: 110),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver.name.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.network(
                    'https://flagsapi.com/${driver.countryCode}/flat/32.png',
                    width: 24,
                    errorBuilder: (_, __, ___) => const Icon(Icons.flag, color: Colors.white24),
                  ),
                  const SizedBox(width: 10),
                  Text(driver.nationality, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
              if (driver.number != null)
                Text("#${driver.number}", style: const TextStyle(color: AppColors.f1Red, fontSize: 32, fontWeight: FontWeight.w900)),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildStatsGrid(DriverDetailEntity driver) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _statItem("PÓDIOS", driver.podiums.toString()),
        _statItem("PTS CARREIRA", driver.careerPoints),
        // Aplicando o polimento da data brasileira
        _statItem("DATA NASC.", DateFormatter.toBrazilian(driver.birthdate)),
      ],
    );
  }

  Widget _statItem(String label, String value) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.CardBackgroud, // Verifique se o nome está correto no seu arquivo
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHistoryTimeline(DriverDetailEntity driver) {
    return Column(
      children: driver.teamsHistory.map<Widget>((history) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: AppColors.CardBackgroud.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: AppNetworkImage(imageUrl: history.teamLogo, size: 35),
            title: Text(history.teamName, style: const TextStyle(color: Colors.white, fontSize: 14)),
            trailing: Text(
              history.season.toString(),
              style: const TextStyle(color: AppColors.f1Red, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }
}