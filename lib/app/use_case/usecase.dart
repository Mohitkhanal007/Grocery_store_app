import 'package:dartz/dartz.dart';

abstract interface class UseWithParams<SuccessType, Params>{}
Future<Either<Failure,SuccessType>>call (Params params);

abstract interface class UsecaseWithoutParams<SuccessType>{
  Future<Either<Failure,SuccessType>>call();
}