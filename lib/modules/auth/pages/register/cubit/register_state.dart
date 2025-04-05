part of 'register_cubit.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitialState extends RegisterState {
  const RegisterInitialState();
}

final class RegisterLoadingState extends RegisterState {
  const RegisterLoadingState();
}

final class RegisterSuccessState extends RegisterState {
  const RegisterSuccessState();
}

final class RegisterErrorState extends RegisterState {
  const RegisterErrorState();
}
