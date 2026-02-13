

import 'package:wsports/features/formula_one/domain/entities/driver_ranking_entity.dart';

class DriverRankingModel extends DriverRankingEntity {
  DriverRankingModel({
    required super.id,
    required super.position,
    required super.driverName,
    required super.teamName,
    required super.points,
    required super.image,
  });

  /*factory DriverRankingModel.fromJson(Map<String, dynamic> json) {
    return DriverRankingModel(
      id: json['driver']['id'],
      position: json['position'],
      driverName: json['driver']['name'] ?? 'Piloto desconhecido',
      nationality: json['nationality'] ?? 'Nacionalidades desconhecida',
      countryCode: json['country']?['code'] ?? 'code N/A',
      teamName: json['team']['name'] ?? 'Equipe N/A',
      points: json['points'] ?? 0,
      image: json['driver']['image'],
    );
  }*/
  factory DriverRankingModel.fromJson(Map<String, dynamic> json) {
    return DriverRankingModel(
      // Acessa o ID de dentro do objeto 'driver'
      id: json['driver']?['id'] ?? 0,
      position: json['position'] ?? 0,
      driverName: json['driver']?['name'] ?? 'Piloto desconhecido',
      // Proteção contra objeto 'team' nulo
      teamName: json['team']?['name'] ?? 'Equipe N/A',
      // Trata pontos nulos vindos do JSON
      points: json['points'] ?? 0,
      image: json['driver']?['image'] ?? '',
    );
  }


}