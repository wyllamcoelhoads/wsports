import 'package:wsports/features/simulations/domain/entities/simulation_entity.dart';
import 'package:wsports/features/simulations/domain/repositories/simulation_repository.dart';

class SaveSimulationUseCase {
  final SimulationRepository repository;

  SaveSimulationUseCase(this.repository);

  Future<void> call(SimulationEntity simulation) async {
    return await repository.saveSimulation(simulation);
  }
}