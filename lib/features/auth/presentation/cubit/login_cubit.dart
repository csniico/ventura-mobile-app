import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/domain/entities/user_entity.dart';
import 'package:ventura/core/domain/use_cases/local_save_user.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_in_with_google.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final logger = AppLogger('LoginCubit');
  final UserSignIn _userSignIn;
  final UserSignInWithGoogle _userSignInWithGoogle;
  final LocalSaveUser _localSaveUser;

  LoginCubit({
    required UserSignIn userSignIn,
    required UserSignInWithGoogle userSignInWithGoogle,
    required LocalSaveUser localSaveUser,
  }) : _userSignIn = userSignIn,
       _userSignInWithGoogle = userSignInWithGoogle,
       _localSaveUser = localSaveUser,
       super(LoginInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(LoginLoading());

    final result = await _userSignIn(
      UserSignInParams(email: email, password: password),
    );

    result.fold((failure) => emit(LoginError(failure.message)), (user) {
      _localSaveUser(UserParams(user: user));
      emit(LoginSuccess(user));
    });
  }

  Future<void> signInWithGoogle({
    required String email,
    required String googleId,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    emit(LoginLoading());

    final result = await _userSignInWithGoogle(
      UserSignInWithGoogleParams(
        email: email,
        googleId: googleId,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
      ),
    );

    result.fold((failure) => emit(LoginError(failure.message)), (user) {
      _localSaveUser(UserParams(user: user));
      emit(LoginSuccess(user));
    });
  }

  void reset() {
    emit(LoginInitial());
  }
}
