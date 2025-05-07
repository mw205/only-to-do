// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sleep_tracking_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SleepTrackingState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PredictSleepQualityRequestBody data) dataUpdated,
    required TResult Function(double result) success,
    required TResult Function(String error) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult? Function(double result)? success,
    TResult? Function(String error)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult Function(double result)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SleepTrackingDataLoading value) loading,
    required TResult Function(SleepTrackingDataUpdated value) dataUpdated,
    required TResult Function(SleepTrackingSuccess value) success,
    required TResult Function(SleepTrackingFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SleepTrackingDataLoading value)? loading,
    TResult? Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult? Function(SleepTrackingSuccess value)? success,
    TResult? Function(SleepTrackingFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SleepTrackingDataLoading value)? loading,
    TResult Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult Function(SleepTrackingSuccess value)? success,
    TResult Function(SleepTrackingFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SleepTrackingStateCopyWith<$Res> {
  factory $SleepTrackingStateCopyWith(
          SleepTrackingState value, $Res Function(SleepTrackingState) then) =
      _$SleepTrackingStateCopyWithImpl<$Res, SleepTrackingState>;
}

/// @nodoc
class _$SleepTrackingStateCopyWithImpl<$Res, $Val extends SleepTrackingState>
    implements $SleepTrackingStateCopyWith<$Res> {
  _$SleepTrackingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$SleepTrackingStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'SleepTrackingState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PredictSleepQualityRequestBody data) dataUpdated,
    required TResult Function(double result) success,
    required TResult Function(String error) failure,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult? Function(double result)? success,
    TResult? Function(String error)? failure,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult Function(double result)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SleepTrackingDataLoading value) loading,
    required TResult Function(SleepTrackingDataUpdated value) dataUpdated,
    required TResult Function(SleepTrackingSuccess value) success,
    required TResult Function(SleepTrackingFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SleepTrackingDataLoading value)? loading,
    TResult? Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult? Function(SleepTrackingSuccess value)? success,
    TResult? Function(SleepTrackingFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SleepTrackingDataLoading value)? loading,
    TResult Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult Function(SleepTrackingSuccess value)? success,
    TResult Function(SleepTrackingFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements SleepTrackingState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$SleepTrackingDataLoadingImplCopyWith<$Res> {
  factory _$$SleepTrackingDataLoadingImplCopyWith(
          _$SleepTrackingDataLoadingImpl value,
          $Res Function(_$SleepTrackingDataLoadingImpl) then) =
      __$$SleepTrackingDataLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SleepTrackingDataLoadingImplCopyWithImpl<$Res>
    extends _$SleepTrackingStateCopyWithImpl<$Res,
        _$SleepTrackingDataLoadingImpl>
    implements _$$SleepTrackingDataLoadingImplCopyWith<$Res> {
  __$$SleepTrackingDataLoadingImplCopyWithImpl(
      _$SleepTrackingDataLoadingImpl _value,
      $Res Function(_$SleepTrackingDataLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SleepTrackingDataLoadingImpl implements SleepTrackingDataLoading {
  const _$SleepTrackingDataLoadingImpl();

  @override
  String toString() {
    return 'SleepTrackingState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepTrackingDataLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PredictSleepQualityRequestBody data) dataUpdated,
    required TResult Function(double result) success,
    required TResult Function(String error) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult? Function(double result)? success,
    TResult? Function(String error)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult Function(double result)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SleepTrackingDataLoading value) loading,
    required TResult Function(SleepTrackingDataUpdated value) dataUpdated,
    required TResult Function(SleepTrackingSuccess value) success,
    required TResult Function(SleepTrackingFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SleepTrackingDataLoading value)? loading,
    TResult? Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult? Function(SleepTrackingSuccess value)? success,
    TResult? Function(SleepTrackingFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SleepTrackingDataLoading value)? loading,
    TResult Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult Function(SleepTrackingSuccess value)? success,
    TResult Function(SleepTrackingFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SleepTrackingDataLoading implements SleepTrackingState {
  const factory SleepTrackingDataLoading() = _$SleepTrackingDataLoadingImpl;
}

/// @nodoc
abstract class _$$SleepTrackingDataUpdatedImplCopyWith<$Res> {
  factory _$$SleepTrackingDataUpdatedImplCopyWith(
          _$SleepTrackingDataUpdatedImpl value,
          $Res Function(_$SleepTrackingDataUpdatedImpl) then) =
      __$$SleepTrackingDataUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PredictSleepQualityRequestBody data});
}

/// @nodoc
class __$$SleepTrackingDataUpdatedImplCopyWithImpl<$Res>
    extends _$SleepTrackingStateCopyWithImpl<$Res,
        _$SleepTrackingDataUpdatedImpl>
    implements _$$SleepTrackingDataUpdatedImplCopyWith<$Res> {
  __$$SleepTrackingDataUpdatedImplCopyWithImpl(
      _$SleepTrackingDataUpdatedImpl _value,
      $Res Function(_$SleepTrackingDataUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SleepTrackingDataUpdatedImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as PredictSleepQualityRequestBody,
    ));
  }
}

/// @nodoc

class _$SleepTrackingDataUpdatedImpl implements SleepTrackingDataUpdated {
  const _$SleepTrackingDataUpdatedImpl({required this.data});

  @override
  final PredictSleepQualityRequestBody data;

  @override
  String toString() {
    return 'SleepTrackingState.dataUpdated(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepTrackingDataUpdatedImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepTrackingDataUpdatedImplCopyWith<_$SleepTrackingDataUpdatedImpl>
      get copyWith => __$$SleepTrackingDataUpdatedImplCopyWithImpl<
          _$SleepTrackingDataUpdatedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PredictSleepQualityRequestBody data) dataUpdated,
    required TResult Function(double result) success,
    required TResult Function(String error) failure,
  }) {
    return dataUpdated(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult? Function(double result)? success,
    TResult? Function(String error)? failure,
  }) {
    return dataUpdated?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult Function(double result)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (dataUpdated != null) {
      return dataUpdated(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SleepTrackingDataLoading value) loading,
    required TResult Function(SleepTrackingDataUpdated value) dataUpdated,
    required TResult Function(SleepTrackingSuccess value) success,
    required TResult Function(SleepTrackingFailure value) failure,
  }) {
    return dataUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SleepTrackingDataLoading value)? loading,
    TResult? Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult? Function(SleepTrackingSuccess value)? success,
    TResult? Function(SleepTrackingFailure value)? failure,
  }) {
    return dataUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SleepTrackingDataLoading value)? loading,
    TResult Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult Function(SleepTrackingSuccess value)? success,
    TResult Function(SleepTrackingFailure value)? failure,
    required TResult orElse(),
  }) {
    if (dataUpdated != null) {
      return dataUpdated(this);
    }
    return orElse();
  }
}

abstract class SleepTrackingDataUpdated implements SleepTrackingState {
  const factory SleepTrackingDataUpdated(
          {required final PredictSleepQualityRequestBody data}) =
      _$SleepTrackingDataUpdatedImpl;

  PredictSleepQualityRequestBody get data;

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SleepTrackingDataUpdatedImplCopyWith<_$SleepTrackingDataUpdatedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SleepTrackingSuccessImplCopyWith<$Res> {
  factory _$$SleepTrackingSuccessImplCopyWith(_$SleepTrackingSuccessImpl value,
          $Res Function(_$SleepTrackingSuccessImpl) then) =
      __$$SleepTrackingSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double result});
}

/// @nodoc
class __$$SleepTrackingSuccessImplCopyWithImpl<$Res>
    extends _$SleepTrackingStateCopyWithImpl<$Res, _$SleepTrackingSuccessImpl>
    implements _$$SleepTrackingSuccessImplCopyWith<$Res> {
  __$$SleepTrackingSuccessImplCopyWithImpl(_$SleepTrackingSuccessImpl _value,
      $Res Function(_$SleepTrackingSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
  }) {
    return _then(_$SleepTrackingSuccessImpl(
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$SleepTrackingSuccessImpl implements SleepTrackingSuccess {
  const _$SleepTrackingSuccessImpl({required this.result});

  @override
  final double result;

  @override
  String toString() {
    return 'SleepTrackingState.success(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepTrackingSuccessImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepTrackingSuccessImplCopyWith<_$SleepTrackingSuccessImpl>
      get copyWith =>
          __$$SleepTrackingSuccessImplCopyWithImpl<_$SleepTrackingSuccessImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PredictSleepQualityRequestBody data) dataUpdated,
    required TResult Function(double result) success,
    required TResult Function(String error) failure,
  }) {
    return success(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult? Function(double result)? success,
    TResult? Function(String error)? failure,
  }) {
    return success?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult Function(double result)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SleepTrackingDataLoading value) loading,
    required TResult Function(SleepTrackingDataUpdated value) dataUpdated,
    required TResult Function(SleepTrackingSuccess value) success,
    required TResult Function(SleepTrackingFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SleepTrackingDataLoading value)? loading,
    TResult? Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult? Function(SleepTrackingSuccess value)? success,
    TResult? Function(SleepTrackingFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SleepTrackingDataLoading value)? loading,
    TResult Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult Function(SleepTrackingSuccess value)? success,
    TResult Function(SleepTrackingFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SleepTrackingSuccess implements SleepTrackingState {
  const factory SleepTrackingSuccess({required final double result}) =
      _$SleepTrackingSuccessImpl;

  double get result;

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SleepTrackingSuccessImplCopyWith<_$SleepTrackingSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SleepTrackingFailureImplCopyWith<$Res> {
  factory _$$SleepTrackingFailureImplCopyWith(_$SleepTrackingFailureImpl value,
          $Res Function(_$SleepTrackingFailureImpl) then) =
      __$$SleepTrackingFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String error});
}

/// @nodoc
class __$$SleepTrackingFailureImplCopyWithImpl<$Res>
    extends _$SleepTrackingStateCopyWithImpl<$Res, _$SleepTrackingFailureImpl>
    implements _$$SleepTrackingFailureImplCopyWith<$Res> {
  __$$SleepTrackingFailureImplCopyWithImpl(_$SleepTrackingFailureImpl _value,
      $Res Function(_$SleepTrackingFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$SleepTrackingFailureImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SleepTrackingFailureImpl implements SleepTrackingFailure {
  const _$SleepTrackingFailureImpl({required this.error});

  @override
  final String error;

  @override
  String toString() {
    return 'SleepTrackingState.failure(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SleepTrackingFailureImpl &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SleepTrackingFailureImplCopyWith<_$SleepTrackingFailureImpl>
      get copyWith =>
          __$$SleepTrackingFailureImplCopyWithImpl<_$SleepTrackingFailureImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(PredictSleepQualityRequestBody data) dataUpdated,
    required TResult Function(double result) success,
    required TResult Function(String error) failure,
  }) {
    return failure(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult? Function(double result)? success,
    TResult? Function(String error)? failure,
  }) {
    return failure?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(PredictSleepQualityRequestBody data)? dataUpdated,
    TResult Function(double result)? success,
    TResult Function(String error)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(SleepTrackingDataLoading value) loading,
    required TResult Function(SleepTrackingDataUpdated value) dataUpdated,
    required TResult Function(SleepTrackingSuccess value) success,
    required TResult Function(SleepTrackingFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(SleepTrackingDataLoading value)? loading,
    TResult? Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult? Function(SleepTrackingSuccess value)? success,
    TResult? Function(SleepTrackingFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(SleepTrackingDataLoading value)? loading,
    TResult Function(SleepTrackingDataUpdated value)? dataUpdated,
    TResult Function(SleepTrackingSuccess value)? success,
    TResult Function(SleepTrackingFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class SleepTrackingFailure implements SleepTrackingState {
  const factory SleepTrackingFailure({required final String error}) =
      _$SleepTrackingFailureImpl;

  String get error;

  /// Create a copy of SleepTrackingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SleepTrackingFailureImplCopyWith<_$SleepTrackingFailureImpl>
      get copyWith => throw _privateConstructorUsedError;
}
