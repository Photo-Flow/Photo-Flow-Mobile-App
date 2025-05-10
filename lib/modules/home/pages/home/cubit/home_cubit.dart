import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_flow_mobile_app/modules/home/providers/home_provider.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeProvider homeProvider;

  HomeCubit({required this.homeProvider}) : super(const HomeInitialState());

  Future<void> fetchData() async {
    emit(const HomeLoadingState());
    await Future.delayed(const Duration(seconds: 5));

    try {
      await homeProvider.fetchData();
      emit(const HomeSuccessState());
    } catch (e) {
      emit(const HomeErrorState());
    }
  }
}
