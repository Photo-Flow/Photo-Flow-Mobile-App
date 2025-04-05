import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_flow_mobile_app/modules/auth/providers/auth_provider.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthProvider authProvider;

  RegisterCubit({
    required this.authProvider,
  }) : super(const RegisterInitialState());

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(const RegisterLoadingState());
    await Future.delayed(const Duration(seconds: 5));

    try {
      await authProvider.register(
        email: email,
        password: password,
      );
      emit(const RegisterSuccessState());
    } catch (e) {
      emit(const RegisterErrorState());
    }
  }
}
