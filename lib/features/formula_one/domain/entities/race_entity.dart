class RaceEntity {
  final String circuitImage;
  final String raceName;
  final String circuitName;
  final DateTime date;
  final String time;
  final String locality;
  final String country;
  final String type;

  RaceEntity({
    required this.circuitImage,
    required this.raceName,
    required this.circuitName,
    required this.date,
    required this.time,
    required this.locality,
    required this.country,
    required this.type
  });
}