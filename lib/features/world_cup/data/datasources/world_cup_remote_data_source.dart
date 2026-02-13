import 'package:dio/dio.dart';
import 'package:wsports/features/world_cup/data/models/match_model.dart';

abstract class WorldCupRemoteDataSource {
  /// Busca todos os jogos da Copa do Mundo na API
  Future<List<MatchModel>> getMatches();
}

class WorldCupRemoteDataSourceImpl implements WorldCupRemoteDataSource {
  final Dio client;

  WorldCupRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MatchModel>> getMatches() async {
    // 1. Fazemos a chamada para a URL da API (exemplo)
    final response = await client.get(
      'https://api.seuesporte.com/v1/world-cup/matches',
    );

    // 2. Verificamos se deu tudo certo (Status 200)
    if (response.statusCode == 200) {
      final List data = response.data['matches'];

      // 3. Transformamos a lista de JSONs em uma lista de MatchModels
      return data.map((json) => MatchModel.fromJson(json)).toList();
    } else {
      // 4. Se der erro, avisamos o app
      throw Exception('Erro ao buscar jogos da Copa');
    }
  }
}