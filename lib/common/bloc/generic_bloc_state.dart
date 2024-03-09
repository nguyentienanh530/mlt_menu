// import 'package:flutter/foundation.dart' show immutable;
import 'package:freezed_annotation/freezed_annotation.dart';
part 'generic_bloc_state.freezed.dart';
// part 'generic_bloc_state.g.dart';

///The base state class should always be named: BlocSubject + State.

enum Status { empty, loading, failure, success }

// @immutable
// class GenericBlocState<T> {
//   final List<T>? datas;
//   final T? data;
//   final String? error;
//   final Status status;

//   const GenericBlocState(
//       {this.data, this.error, required this.status, this.datas});

//   factory GenericBlocState.empty() =>
//       const GenericBlocState(status: Status.empty);

//   factory GenericBlocState.loading() =>
//       const GenericBlocState(status: Status.loading);

//   factory GenericBlocState.failure(String error) =>
//       GenericBlocState(error: error, status: Status.failure);

//   factory GenericBlocState.success({List<T>? datas, T? data}) =>
//       GenericBlocState(datas: datas, data: data, status: Status.success);
// }

// @immutable
@freezed
class GenericBlocState<T> with _$GenericBlocState<T> {
  factory GenericBlocState(
      {final List<T>? datas,
      final T? data,
      final String? error,
      @Default(Status.loading) Status status}) = _GenericBlocState;

  factory GenericBlocState.empty() =>
      GenericBlocState<T>().copyWith(status: Status.empty);
  factory GenericBlocState.loading() =>
      GenericBlocState<T>().copyWith(status: Status.loading);

  factory GenericBlocState.failure(String error) =>
      GenericBlocState<T>().copyWith(status: Status.failure, error: error);

  factory GenericBlocState.success({List<T>? datas, T? data}) =>
      GenericBlocState<T>()
          .copyWith(status: Status.success, datas: datas, data: data);

  factory GenericBlocState.updateOrDeleteSuccess() =>
      GenericBlocState<T>().copyWith(status: Status.success);
}
