class DriverRankingEntity {
  final int id;
  final int position;
  final String driverName;
  final String image; // Garanta que este campo existe
  final String teamName;
  final int points;   // Mude para int para bater com o erro da imagem 2ebc7e

  DriverRankingEntity({
    required this.id,
    required this.position,
    required this.driverName,
    required this.image,
    required this.teamName,
    required this.points,
  });
}