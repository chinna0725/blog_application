import 'package:blog_application/core/commom/cubits/app_user/app_user_cubit.dart';
import 'package:blog_application/core/entities/user.dart';
import 'package:blog_application/core/usecase/usecase.dart';
import 'package:blog_application/features/auth/domain/usecase/current_user.dart';
import 'package:blog_application/features/auth/domain/usecase/user_sign_in.dart';
import 'package:blog_application/features/auth/domain/usecase/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc(
      {required UserSignUp userSignUp,
      required UserSignIn userSignIn,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
//------------------
    on<AuthEvent>(
      (event, emit) => emit(
        AuthLoading(),
      ),
    );
//------------------------------
    on<AuthSignup>((event, emit) async {
      final res = await _userSignUp(UserSignUpParams(
          name: event.name, email: event.email, password: event.password));

      res.fold(
        (l) => emit(AuthFailure(msg: l.message)),
        (r) => _emitAuthSucess(r, emit),
      );
    });
//---------------------------------
    on<AuthSignIn>((event, emit) async {
      final res = await _userSignIn(
          UserSignInParams(email: event.email, password: event.password));

      res.fold(
        (l) => emit(AuthFailure(msg: l.message)),
        (r) => _emitAuthSucess(r, emit),
      );
    });
//--------------------------
    on<AuthIsUserLoggedIn>((event, emit) async {
      final res = await _currentUser(NoParams());
      res.fold(
        (l) {
          emit(AuthFailure(msg: l.message));
        },
        (r) {
          return _emitAuthSucess(r, emit);
        },
      );
    });
  }

  void _emitAuthSucess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
