part of 'home_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitialState extends HomeState {
  const HomeInitialState();
}

final class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

final class HomeSuccessState extends HomeState {
  const HomeSuccessState();
}

final class HomeErrorState extends HomeState {
  const HomeErrorState();
}
