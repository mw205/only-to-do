// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SplashState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() authenticated,
    required TResult Function() showOnBoarding,
    required TResult Function() unAuthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? authenticated,
    TResult? Function()? showOnBoarding,
    TResult? Function()? unAuthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? authenticated,
    TResult Function()? showOnBoarding,
    TResult Function()? unAuthenticated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(UserAuthenticatedState value) authenticated,
    required TResult Function(ShowOnBoardingState value) showOnBoarding,
    required TResult Function(UserUnAuthenticatedState value) unAuthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(UserAuthenticatedState value)? authenticated,
    TResult? Function(ShowOnBoardingState value)? showOnBoarding,
    TResult? Function(UserUnAuthenticatedState value)? unAuthenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(UserAuthenticatedState value)? authenticated,
    TResult Function(ShowOnBoardingState value)? showOnBoarding,
    TResult Function(UserUnAuthenticatedState value)? unAuthenticated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashStateCopyWith<$Res> {
  factory $SplashStateCopyWith(
          SplashState value, $Res Function(SplashState) then) =
      _$SplashStateCopyWithImpl<$Res, SplashState>;
}

/// @nodoc
class _$SplashStateCopyWithImpl<$Res, $Val extends SplashState>
    implements $SplashStateCopyWith<$Res> {
  _$SplashStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplashState
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
    extends _$SplashStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'SplashState.initial()';
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
    required TResult Function() authenticated,
    required TResult Function() showOnBoarding,
    required TResult Function() unAuthenticated,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? authenticated,
    TResult? Function()? showOnBoarding,
    TResult? Function()? unAuthenticated,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? authenticated,
    TResult Function()? showOnBoarding,
    TResult Function()? unAuthenticated,
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
    required TResult Function(UserAuthenticatedState value) authenticated,
    required TResult Function(ShowOnBoardingState value) showOnBoarding,
    required TResult Function(UserUnAuthenticatedState value) unAuthenticated,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(UserAuthenticatedState value)? authenticated,
    TResult? Function(ShowOnBoardingState value)? showOnBoarding,
    TResult? Function(UserUnAuthenticatedState value)? unAuthenticated,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(UserAuthenticatedState value)? authenticated,
    TResult Function(ShowOnBoardingState value)? showOnBoarding,
    TResult Function(UserUnAuthenticatedState value)? unAuthenticated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements SplashState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$UserAuthenticatedStateImplCopyWith<$Res> {
  factory _$$UserAuthenticatedStateImplCopyWith(
          _$UserAuthenticatedStateImpl value,
          $Res Function(_$UserAuthenticatedStateImpl) then) =
      __$$UserAuthenticatedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserAuthenticatedStateImplCopyWithImpl<$Res>
    extends _$SplashStateCopyWithImpl<$Res, _$UserAuthenticatedStateImpl>
    implements _$$UserAuthenticatedStateImplCopyWith<$Res> {
  __$$UserAuthenticatedStateImplCopyWithImpl(
      _$UserAuthenticatedStateImpl _value,
      $Res Function(_$UserAuthenticatedStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserAuthenticatedStateImpl implements UserAuthenticatedState {
  const _$UserAuthenticatedStateImpl();

  @override
  String toString() {
    return 'SplashState.authenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAuthenticatedStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() authenticated,
    required TResult Function() showOnBoarding,
    required TResult Function() unAuthenticated,
  }) {
    return authenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? authenticated,
    TResult? Function()? showOnBoarding,
    TResult? Function()? unAuthenticated,
  }) {
    return authenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? authenticated,
    TResult Function()? showOnBoarding,
    TResult Function()? unAuthenticated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(UserAuthenticatedState value) authenticated,
    required TResult Function(ShowOnBoardingState value) showOnBoarding,
    required TResult Function(UserUnAuthenticatedState value) unAuthenticated,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(UserAuthenticatedState value)? authenticated,
    TResult? Function(ShowOnBoardingState value)? showOnBoarding,
    TResult? Function(UserUnAuthenticatedState value)? unAuthenticated,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(UserAuthenticatedState value)? authenticated,
    TResult Function(ShowOnBoardingState value)? showOnBoarding,
    TResult Function(UserUnAuthenticatedState value)? unAuthenticated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class UserAuthenticatedState implements SplashState {
  const factory UserAuthenticatedState() = _$UserAuthenticatedStateImpl;
}

/// @nodoc
abstract class _$$ShowOnBoardingStateImplCopyWith<$Res> {
  factory _$$ShowOnBoardingStateImplCopyWith(_$ShowOnBoardingStateImpl value,
          $Res Function(_$ShowOnBoardingStateImpl) then) =
      __$$ShowOnBoardingStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ShowOnBoardingStateImplCopyWithImpl<$Res>
    extends _$SplashStateCopyWithImpl<$Res, _$ShowOnBoardingStateImpl>
    implements _$$ShowOnBoardingStateImplCopyWith<$Res> {
  __$$ShowOnBoardingStateImplCopyWithImpl(_$ShowOnBoardingStateImpl _value,
      $Res Function(_$ShowOnBoardingStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ShowOnBoardingStateImpl implements ShowOnBoardingState {
  const _$ShowOnBoardingStateImpl();

  @override
  String toString() {
    return 'SplashState.showOnBoarding()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShowOnBoardingStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() authenticated,
    required TResult Function() showOnBoarding,
    required TResult Function() unAuthenticated,
  }) {
    return showOnBoarding();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? authenticated,
    TResult? Function()? showOnBoarding,
    TResult? Function()? unAuthenticated,
  }) {
    return showOnBoarding?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? authenticated,
    TResult Function()? showOnBoarding,
    TResult Function()? unAuthenticated,
    required TResult orElse(),
  }) {
    if (showOnBoarding != null) {
      return showOnBoarding();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(UserAuthenticatedState value) authenticated,
    required TResult Function(ShowOnBoardingState value) showOnBoarding,
    required TResult Function(UserUnAuthenticatedState value) unAuthenticated,
  }) {
    return showOnBoarding(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(UserAuthenticatedState value)? authenticated,
    TResult? Function(ShowOnBoardingState value)? showOnBoarding,
    TResult? Function(UserUnAuthenticatedState value)? unAuthenticated,
  }) {
    return showOnBoarding?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(UserAuthenticatedState value)? authenticated,
    TResult Function(ShowOnBoardingState value)? showOnBoarding,
    TResult Function(UserUnAuthenticatedState value)? unAuthenticated,
    required TResult orElse(),
  }) {
    if (showOnBoarding != null) {
      return showOnBoarding(this);
    }
    return orElse();
  }
}

abstract class ShowOnBoardingState implements SplashState {
  const factory ShowOnBoardingState() = _$ShowOnBoardingStateImpl;
}

/// @nodoc
abstract class _$$UserUnAuthenticatedStateImplCopyWith<$Res> {
  factory _$$UserUnAuthenticatedStateImplCopyWith(
          _$UserUnAuthenticatedStateImpl value,
          $Res Function(_$UserUnAuthenticatedStateImpl) then) =
      __$$UserUnAuthenticatedStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserUnAuthenticatedStateImplCopyWithImpl<$Res>
    extends _$SplashStateCopyWithImpl<$Res, _$UserUnAuthenticatedStateImpl>
    implements _$$UserUnAuthenticatedStateImplCopyWith<$Res> {
  __$$UserUnAuthenticatedStateImplCopyWithImpl(
      _$UserUnAuthenticatedStateImpl _value,
      $Res Function(_$UserUnAuthenticatedStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplashState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UserUnAuthenticatedStateImpl implements UserUnAuthenticatedState {
  const _$UserUnAuthenticatedStateImpl();

  @override
  String toString() {
    return 'SplashState.unAuthenticated()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserUnAuthenticatedStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() authenticated,
    required TResult Function() showOnBoarding,
    required TResult Function() unAuthenticated,
  }) {
    return unAuthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? authenticated,
    TResult? Function()? showOnBoarding,
    TResult? Function()? unAuthenticated,
  }) {
    return unAuthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? authenticated,
    TResult Function()? showOnBoarding,
    TResult Function()? unAuthenticated,
    required TResult orElse(),
  }) {
    if (unAuthenticated != null) {
      return unAuthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(UserAuthenticatedState value) authenticated,
    required TResult Function(ShowOnBoardingState value) showOnBoarding,
    required TResult Function(UserUnAuthenticatedState value) unAuthenticated,
  }) {
    return unAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(UserAuthenticatedState value)? authenticated,
    TResult? Function(ShowOnBoardingState value)? showOnBoarding,
    TResult? Function(UserUnAuthenticatedState value)? unAuthenticated,
  }) {
    return unAuthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(UserAuthenticatedState value)? authenticated,
    TResult Function(ShowOnBoardingState value)? showOnBoarding,
    TResult Function(UserUnAuthenticatedState value)? unAuthenticated,
    required TResult orElse(),
  }) {
    if (unAuthenticated != null) {
      return unAuthenticated(this);
    }
    return orElse();
  }
}

abstract class UserUnAuthenticatedState implements SplashState {
  const factory UserUnAuthenticatedState() = _$UserUnAuthenticatedStateImpl;
}
