import 'package:dio/dio.dart';
import 'package:wsports/core/constants/api_constants.dart';
import 'package:wsports/features/formula_one/data/models/driver_detail_model.dart';
import 'package:wsports/features/formula_one/data/models/driver_ranking_model.dart';
import 'package:wsports/features/formula_one/data/models/race_model.dart';
import 'package:wsports/features/formula_one/data/models/team_ranking_model.dart'; // Removido o "as dio" para evitar conflito


abstract class F1RemoteDataSource {
  Future<List<RaceModel>> getSchedule2026();
  Future<List<DriverRankingModel>> getDriverRankings(String season);
  Future<List<TeamRankingModel>> getTeamRankings(String season);
  Future<DriverDetailModel> getDriverDetails(int id);
}

class F1RemoteDataSourceImpl implements F1RemoteDataSource {
  final Dio client; // Renomeado de 'dio' para 'client' para clareza

  F1RemoteDataSourceImpl({required this.client});

  @override
  Future<DriverDetailModel> getDriverDetails(int id) async {
    final response = await client.get(
      '${ApiConstants.f1BaseUrl}/drivers',
      queryParameters: {'id': id.toString()},
      options: Options(headers: {'x-apisports-key': ApiConstants.apiKey}),
    );
    return DriverDetailModel.fromJson(response.data['response'][0]);
  }

  @override
  Future<List<RaceModel>> getSchedule2026() async {
    try {
      final response = await client.get(
        '${ApiConstants.f1BaseUrl}/races',
        queryParameters: {'season': '2024'},
        options: Options(
          headers: {'x-apisports-key': ApiConstants.apiKey},
        ),
      );

      final List data = response.data['response'];
      return data.map((json) => RaceModel.fromJson(json)).toList();

    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw Exception('Limite diário de acesso atingido!');
      }
      throw Exception('Falha ao conectar com API-SPORTS: ${e.message}');
    } // Chave que fecha o catch
  } // Chave que fecha o método getSchedule2026

  @override
  Future<List<DriverRankingModel>> getDriverRankings(String season) async {
    try {
      final response = await client.get(
        '${ApiConstants.f1BaseUrl}/rankings/drivers',
        queryParameters: {'season': season},
        options: Options(headers: {'x-apisports-key': ApiConstants.apiKey}),
      );
      final List data = response.data['response'];
      return data.map((json) => DriverRankingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar ranking de pilotos: $e');
    }
  }

  @override
  Future<List<TeamRankingModel>> getTeamRankings(String season) async {
    try {
      final response = await client.get(
        '${ApiConstants.f1BaseUrl}/rankings/teams',
        queryParameters: {'season': season},
        options: Options(headers: {'x-apisports-key': ApiConstants.apiKey}),
      );
      final List data = response.data['response'];
      return data.map((json) => TeamRankingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar ranking de equipes: $e');
    }
  }
} // Chave que fecha a classe F1RemoteDataSourceImpl (ESSENCIAL)