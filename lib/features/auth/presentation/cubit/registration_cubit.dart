import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/domain/use_cases/local_save_user.dart';
import 'package:ventura/core/domain/use_cases/use_case.dart';
import 'package:ventura/features/auth/domain/entities/server_sign_up.dart';
import 'package:ventura/features/auth/domain/use_cases/user_sign_up.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final logger = AppLogger('RegistrationCubit');
  final UserSignUp _userSignUp;
  final LocalSaveUser _localSaveUser;

  RegistrationCubit({
    required UserSignUp userSignUp,
    required LocalSaveUser localSaveUser,
  }) : _userSignUp = userSignUp,
       _localSaveUser = localSaveUser,
       super(RegistrationInitial());

  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    emit(RegistrationLoading());

    final result = await _userSignUp(
      UserSignUpParams(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        avatarUrl: avatarUrl,
      ),
    );

    result.fold((failure) => emit(RegistrationError(failure.message)), (
      serverSignUp,
    ) {
      _localSaveUser(UserParams(user: serverSignUp.user));
      emit(RegistrationAwaitingVerification(serverSignUp));
    });
  }

  void reset() {
    emit(RegistrationInitial());
  }
}
