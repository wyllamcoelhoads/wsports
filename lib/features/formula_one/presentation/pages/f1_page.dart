import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wsports/core/constants/colors.dart';
import 'package:wsports/features/formula_one/domain/entities/driver_ranking_entity.dart';
import 'package:wsports/features/formula_one/domain/entities/race_entity.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_bloc.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_event.dart';
import 'package:wsports/features/formula_one/presentation/bloc/f1_state.dart';
import 'package:wsports/features/formula_one/presentation/pages/driver_details_page.dart';


class F1Page extends StatelessWidget {
  const F1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // Use o nome exato que você definiu na classe AppColors
        backgroundColor: AppColors.backgroud,
        appBar: AppBar(
          title: const Text("F1 - Temporada 2026", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.backgroud,
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: AppColors.f1Red,
            tabs: [
              Tab(text: "Noticias", icon: FaIcon(FontAwesomeIcons.newspaper),),
              Tab(text: "Corridas", icon: FaIcon(FontAwesomeIcons.flagCheckered),),
              Tab(text: "Pilotos", icon: FaIcon(FontAwesomeIcons.peopleGroup), ),
              Tab(text: "Equipes", icon: FaIcon(FontAwesomeIcons.gears),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNewspaper(),
            _buildRacesTab(),
            _buildDriversTab(),
            _buildTeamsTab(),
          ],
        ),
      ),
    );
  }

  // --- ABA DE NOTICIAS ---
  Widget _buildNewspaper() {
    return Center(
      child: Container(
        child: const Center(child: Text("🏆 Noticias - Em Breve", style: TextStyle(color: Colors.white))),
      ),
    );
  }
  // --- ABA DE CORRIDAS ---
  Widget _buildRacesTab() {
    return BlocBuilder<F1Bloc, F1State>(
      builder: (context, state) {
        if (state.isLoading && state.races.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.f1Red));
        }

        if (state.races.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.races.length,
            itemBuilder: (context, index) => _buildRaceCard(state.races[index]),
          );
        }

        // Se a lista estiver vazia e não estiver carregando, mostra o botão para buscar
        return Center(
          child: ElevatedButton(
            onPressed: () => context.read<F1Bloc>().add(GetScheduleEvent()),
            child: const Text("Carregar Corridas 2024"),
          ),
        );
      },
    );
  }

  // --- ABA DE PILOTOS ---
  /*Widget _buildDriversTab() {
    return BlocBuilder<F1Bloc, F1State>(
      builder: (context, state) {
        // 1. Se estiver carregando e não tiver nada na lista, mostra o loading
        if (state.isLoading && state.drivers.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.f1Red));
        }

        // 2. Se a lista tiver dados, desenha a tela (Independente do estado ser de loading ou não)
        if (state.drivers.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.drivers.length,
            itemBuilder: (context, index) {
              final driver = state.drivers[index];
              return ListTile(
                onTap: () {
                  // 1. Pegamos a instância do BLoC que já existe nesta tela
                  final f1Bloc = context.read<F1Bloc>();

                  // 2. Disparamos o evento de buscar detalhes ANTES de navegar
                  f1Bloc.add(GetDriverDetailsEvent(driver.id));

                  // 3. Passamos o BLoC existente para a próxima tela
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: f1Bloc, // Passa o BLoC que já tem os dados
                        child: const DriverDetailsPage(),
                      ),
                    ),
                  );
                },
                leading: CircleAvatar(child: Text("${driver.position}")),
                title: Text(driver.driverName, style: const TextStyle(color: Colors.white)),
                trailing: Text("${driver.points} pts"),
              );
            },
          );
        }

        // 3. Se estiver vazio, exibe o botão para carregar
        return Center(
          child: ElevatedButton(
            onPressed: () => context.read<F1Bloc>().add(GetDriversRankingEvent('2024')),
            child: const Text("Carregar Pilotos 2024"),
          ),
        );
      },
    );
  }*/
  Widget _buildDriversTab() {
    return BlocBuilder<F1Bloc, F1State>(
      builder: (context, state) {
        if (state.isLoading && state.drivers.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.f1Red));
        }

        if (state.drivers.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.drivers.length,
            itemBuilder: (context, index) {
              final driver = state.drivers[index];
              // Certifique-se de retornar o card correto!
              return _buildDriverCard(context, driver);
            },
          );
        }

        return Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.f1Red),
            onPressed: () {
              debugPrint("Botão Carregar Pilotos Pressionado");
              context.read<F1Bloc>().add(GetDriversRankingEvent('2024'));
            },
            child: const Text("Carregar Pilotos 2024", style: TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
  //versão antiga
  /*
  Widget _buildDriverCard(BuildContext context, DriverRankingEntity driver) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.CardBackgroud,
        borderRadius: BorderRadius.circular(15),
        // Borda lateral vermelha idêntica à tela de circuitos
        border: const Border(left: BorderSide(color: AppColors.f1Red, width: 4)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          final f1Bloc = context.read<F1Bloc>();
          f1Bloc.add(GetDriverDetailsEvent(driver.id));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: f1Bloc,
                child: const DriverDetailsPage(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // 1. POSIÇÃO E INFO (Lado Esquerdo)
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${driver.position}º",
                          style: const TextStyle(
                            color: AppColors.f1Red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            driver.driverName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Pontuação com estilo suave
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "${driver.points} PTS",
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. IMAGEM DO PILOTO (Lado Direito)
              Expanded(
                flex: 1,
                child: Hero(
                  tag: 'driver-${driver.id}',
                  child: Image.network(
                    driver.image, // URL da imagem do piloto vinda da API
                    height: 70,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.person, color: Colors.white10, size: 50),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  */
  // VERSÃO MESCLADA feita pela ia: Visual da Nova + Lógica Funcional da Antiga
  /*Widget _buildDriverCard(BuildContext context, DriverRankingEntity driver) {
    print("passando aqui no card");
    return Card(
      color: AppColors.CardBackgroud,
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Teste de clique no console
          debugPrint("Clicou no piloto: ${driver.driverName}");
          final f1Bloc = context.read<F1Bloc>();
          f1Bloc.add(GetDriverDetailsEvent(driver.id));

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: f1Bloc,
                child: const DriverDetailsPage(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.f1Red.withOpacity(0.1),
                child: Text("${driver.position}",
                    style: const TextStyle(color: AppColors.f1Red, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  driver.driverName.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.flag_outlined, size: 16, color: Colors.white24),
              const SizedBox(width: 10),
              Text("${driver.points} pts", style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }*/
  Widget _buildDriverCard(BuildContext context, DriverRankingEntity driver) {
    return Card(
      color: AppColors.CardBackgroud,
      margin: const EdgeInsets.only(bottom: 12, left: 6, right: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final f1Bloc = context.read<F1Bloc>();
          f1Bloc.add(GetDriverDetailsEvent(driver.id));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: f1Bloc,
                child: const DriverDetailsPage(),
              ),
            ),
          );
        },
        child: Container(
          height: 85, // Altura fixa para manter a lista simétrica
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              // 1. Badge de Posição
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.f1Red.withOpacity(0.1),
                child: Text(
                  "${driver.position}",
                  style: const TextStyle(
                      color: AppColors.f1Red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 2. Informações do Piloto (Nome e Equipe)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver.driverName.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                          letterSpacing: 0.5
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver.teamName, // Exibe o nome da equipe
                      style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${driver.points} PTS",
                      style: const TextStyle(
                          color: AppColors.f1Red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Imagem do Piloto (Transparente no canto direito)
              // Usamos Alinhamento inferior para um visual de "figurinha"
              Align(
                alignment: Alignment.bottomRight,
                child: Hero(
                  tag: 'driver-${driver.id}',
                  child: Image.network(
                    driver.image, // URL mapeada no seu DriverRankingModel
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Padding(
                      padding: EdgeInsets.only(right: 16, bottom: 16),
                      child: Icon(Icons.person, color: Colors.white10, size: 40),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // --- ABA DE EQUIPES ---
  Widget _buildTeamsTab() {
    return BlocBuilder<F1Bloc, F1State>(
      builder: (context, state) {
        // 1. Loading inicial
        if (state.isLoading && state.teams.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.f1Red));
        }

        // 2. Exibição da lista de Construtores
        if (state.teams.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.teams.length,
            itemBuilder: (context, index) {
              final team = state.teams[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.CardBackgroud,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(team.teamLogo, fit: BoxFit.contain),
                  ),
                  title: Text(
                    team.teamName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Posição: ${team.position}º", style: const TextStyle(color: Colors.white70)),
                  trailing: Text(
                    "${team.points} PTS",
                    style: const TextStyle(color: AppColors.f1Red, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              );
            },
          );
        }

        // 3. Botão para carregar (Lembrando de usar 2024 devido ao plano gratuito)
        return Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.f1Red),
            onPressed: () => context.read<F1Bloc>().add(GetTeamsRankingEvent('2024')),
            child: const Text("Carregar Construtores 2024"),
          ),
        );
      },
    );
  }

  // Widget de erro genérico para reutilização
  Widget _buildErrorWidget(BuildContext context, String message, F1Event retryEvent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.f1Red, size: 60),
          const SizedBox(height: 16),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
          ElevatedButton(
            onPressed: () => context.read<F1Bloc>().add(retryEvent),
            child: const Text("Tentar Novamente"),
          )
        ],
      ),
    );
  }

  Widget _buildRaceCard(RaceEntity race) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22, left: 5, right: 5),
      decoration: BoxDecoration(
        color: AppColors.CardBackgroud,
        borderRadius: BorderRadius.circular(20),
        // Pequeno detalhe na borda esquerda para identificar a F1
        border: const Border(left: BorderSide(color: AppColors.f1Red, width: 5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // 1. INFORMAÇÕES (Lado Esquerdo)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    race.raceName.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),
                  // Localização com ícone
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppColors.f1Red),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(
                            "${race.locality}, ${race.country}",
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Nome do Circuito em tom discreto
                  Text(
                    race.circuitName,
                    style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        fontStyle: FontStyle.italic
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            // 2. MAPA DO CIRCUITO (Lado Direito)
            // Aqui usamos o campo 'circuit.image' do seu JSON
            Expanded(
              flex: 1,
              child: Container(
                height: 150,
                padding: const EdgeInsets.all(5),
                child: Opacity(
                  opacity: 0.8,
                  child: Image.network(
                    race.circuitImage, // Link da imagem da pista
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(Icons.map, color: Colors.white10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}