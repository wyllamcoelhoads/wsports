import '../../domain/entities/race_entity.dart';

class RaceModel extends RaceEntity{
  RaceModel({
    required super.raceName,
    required super.circuitName,
    required super.date,
    required super.time,
    required super.locality,
    required super.country,
    required super.type,
    required super.circuitImage,


  });

  // a transformação de json vindo da API para um objeto flutter

  factory RaceModel.fromJson(Map<String, dynamic> json) {
    return RaceModel(
      raceName: json['competition']['name'] ?? 'GP Desconhecido',
      circuitName: json['circuit']['name'] ?? 'Circuito não informado',
      circuitImage: json['circuit']['image'] ?? '',
      // A API-SPORTS usa o formato ISO 8601 (Ex: 2026-03-15T10:00:00+00:00)
      date: DateTime.parse(json['date']),
      time: json['date'].toString().split('T')[1].substring(0, 5), // Extrai apenas "10:00"
      locality: json['circuit']['name'] ?? 'N/A',
      country: json['competition']['location']['country'] ?? 'N/A',
      type:  json['type'] ?? 'Tipo não identificado',
    );
  }
}