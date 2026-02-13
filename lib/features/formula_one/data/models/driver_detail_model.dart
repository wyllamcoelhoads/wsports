

import 'package:wsports/features/formula_one/domain/entities/driver_detail_entity.dart';

class DriverDetailModel extends DriverDetailEntity {
  DriverDetailModel({
    required super.id, required super.name, required super.image,
    required super.nationality, required super.countryCode,
    required super.birthdate, super.number, required super.podiums,
    required super.careerPoints, required super.teamsHistory,
  });

  factory DriverDetailModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      nationality: json['nationality'],
      countryCode: json['country']?['code'] ?? 'N/A',
      birthdate: json['birthdate'] ?? 'N/A',
      number: json['number'],
      podiums: json['podiums'] ?? 0,
      careerPoints: json['career_points'] ?? '0',
      // Mapeia a lista de times do JSON para a nossa lista de modelos
      teamsHistory: (json['teams'] as List)
          .map((t) => TeamHistoryModel.fromJson(t))
          .toList(),
    );
  }
}

class TeamHistoryModel extends TeamHistoryEntity {
  TeamHistoryModel({
    required super.season,
    required super.teamName,
    required super.teamLogo
  });

  factory TeamHistoryModel.fromJson(Map<String, dynamic> json) {
    return TeamHistoryModel(
      season: json['season'],
      teamName: json['team']['name'],
      teamLogo: json['team']['logo'],
    );
  }
}