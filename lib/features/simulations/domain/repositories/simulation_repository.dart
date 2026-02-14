import 'package:wsports/features/simulations/domain/entities/simulation_entity.dart';

abstract class SimulationRepository {
  // Define que o sistema deve ser capaz de salvar uma simulação
  Future<void> saveSimulation(SimulationEntity simulation);

// Futuramente você pode adicionar:
// Future<List<SimulationEntity>> getMySimulations(String userId);
}