import 'package:dartz/dartz.dart';
import 'package:wsports/core/errors/failures.dart';
import 'package:wsports/features/world_cup/domain/entities/match_entity.dart';

abstract class WorldCupRepository {
  // Retorna um "Erro" (Left) ou a "Lista de Jogos" (Right)
  Future<Either<Failure, List<MatchEntity>>> getMatches();
}