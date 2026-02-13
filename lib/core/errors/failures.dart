import 'package:equatable/equatable.dart';

// Este é o "molde" para qualquer erro no seu app
abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

// Este erro acontece quando a API ou o Servidor falham
class ServerFailure extends Failure {}

// Este erro acontece quando o banco de dados local falha
class CacheFailure extends Failure {}