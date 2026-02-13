import 'package:equatable/equatable.dart';

abstract class WorldCupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Ordem para o cérebro: "Busque os jogos da Copa!"
class GetWorldCupMatchesEvent extends WorldCupEvent {}