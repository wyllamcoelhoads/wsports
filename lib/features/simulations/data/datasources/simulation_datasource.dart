import 'package:wsports/features/simulations/data/models/simulation_model.dart';

abstract class SimulationDataSource {
  Future<void> saveSimulation(SimulationModel simulation);
}

// Implementação da fonte de dados (Aqui entra o código do Firebase, API ou Banco Local)
class SimulationDataSourceImpl implements SimulationDataSource {
  // final FirebaseFirestore firestore; // Exemplo se fosse usar Firebase

  SimulationDataSourceImpl();

  @override
  Future<void> saveSimulation(SimulationModel simulation) async {
    // AQUI VOCÊ COLOCA A LÓGICA REAL DE SALVAR
    // Exemplo:
    // await firestore.collection('simulations').doc(simulation.id).set(simulation.toJson());

    print("Simulação salva no DataSource: ${simulation.toJson()}");
    return Future.value();
  }
}