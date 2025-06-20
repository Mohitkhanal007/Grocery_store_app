import 'package:equatable/equatable.dart';

/// Base class for all failures
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// For local DB related failures
class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure(String message) : super(message);
}

/// For remote/server/API failures
class RemoteDatabaseFailure extends Failure {
  final int? statusCode;

  const RemoteDatabaseFailure(String message, {this.statusCode}) : super(message);

  @override
  List<Object?> get props => [message, statusCode];
}

/// For SharedPreferences-related failures
class SharedPreferencesFailure extends Failure {
  const SharedPreferencesFailure(String message) : super(message);
}
