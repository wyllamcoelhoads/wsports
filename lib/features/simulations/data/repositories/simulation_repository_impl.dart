import 'package:wsports/features/simulations/data/datasources/simulation_datasource.dart';
import 'package:wsports/features/simulations/data/models/simulation_model.dart';
import 'package:wsports/features/simulations/domain/entities/simulation_entity.dart';
import 'package:wsports/features/simulations/domain/repositories/simulation_repository.dart';

class SimulationRepositoryImpl implements SimulationRepository {
  final SimulationDataSource dataSource;

  SimulationRepositoryImpl({required this.dataSource});

  @override
  Future<void> saveSimulation(SimulationEntity simulation) async {
    // Converter a Entidade (Domain) para Modelo (Data)
    // Se a entidade já for um modelo, fazemos o cast, senão criamos um novo.
    final simulationModel = simulation is SimulationModel
        ? simulation
        : SimulationModel(
      id: simulation.id,
      userId: simulation.userId,
      matchId: simulation.matchId,
      sportId: simulation.sportId,
      predictedHomeScore: simulation.predictedHomeScore,
      predictedAwayScore: simulation.predictedAwayScore,
      createdAt: simulation.createdAt,
      pointsEarned: simulation.pointsEarned,
    );

    // Chama o datasource para efetivar a gravação
    return await dataSource.saveSimulation(simulationModel);
  }
}