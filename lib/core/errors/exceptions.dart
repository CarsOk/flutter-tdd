import 'package:equatable/equatable.dart';

import 'failure.dart';

class ServerException extends Equatable implements Exception {
  const ServerException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [
        message,
        statusCode,
      ];
}

class APIException extends Equatable implements Failure {
  const APIException({required this.message, required this.statusCode});

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [
        message,
        statusCode,
      ];

  @override
  // TODO: implement errorMessage
  String get errorMessage => throw UnimplementedError();
}
