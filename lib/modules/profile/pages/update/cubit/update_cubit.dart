import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_flow_mobile_app/modules/profile/providers/profile_provider.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  final ProfileProvider profileProvider;

  UpdateCubit({required this.profileProvider})
    : super(const UpdateInitialState());

  Future<void> update({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(const UpdateLoadingState());

    try {
      await profileProvider.update(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      emit(const UpdateSuccessState());
    } catch (e) {
      emit(const UpdateErrorState());
    }
  }
}
