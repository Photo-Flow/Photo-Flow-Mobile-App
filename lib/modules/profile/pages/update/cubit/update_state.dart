part of 'update_cubit.dart';

sealed class UpdateState extends Equatable {
  const UpdateState();

  @override
  List<Object> get props => [];
}

final class UpdateInitialState extends UpdateState {
  const UpdateInitialState();
}

final class UpdateLoadingState extends UpdateState {
  const UpdateLoadingState();
}

final class UpdateSuccessState extends UpdateState {
  const UpdateSuccessState();
}

final class UpdateErrorState extends UpdateState {
  const UpdateErrorState();
}
