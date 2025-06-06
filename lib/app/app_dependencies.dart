import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_flow_mobile_app/modules/auth/pages/login/cubit/login_cubit.dart';
import 'package:photo_flow_mobile_app/modules/auth/pages/register/cubit/register_cubit.dart';
import 'package:photo_flow_mobile_app/modules/auth/providers/auth_provider.dart';
import 'package:photo_flow_mobile_app/modules/auth/providers/auth_provider_firebase.dart';
import 'package:photo_flow_mobile_app/modules/home/pages/home/cubit/home_cubit.dart';
import 'package:photo_flow_mobile_app/modules/home/providers/home_provider.dart';
import 'package:photo_flow_mobile_app/modules/home/providers/home_provider_firebase.dart';
import 'package:photo_flow_mobile_app/modules/photo-upload/pages/photo_upload/cubit/photo_upload_cubit.dart';
import 'package:photo_flow_mobile_app/modules/photo-upload/providers/photo_upload_provider.dart';
import 'package:photo_flow_mobile_app/modules/photo-upload/providers/photo_upload_provider_firebase.dart';
import 'package:photo_flow_mobile_app/modules/profile/pages/update/cubit/update_cubit.dart';
import 'package:photo_flow_mobile_app/modules/profile/providers/profile_provider.dart';
import 'package:photo_flow_mobile_app/modules/profile/providers/profile_provider_firebase.dart';
import 'package:photo_flow_mobile_app/modules/profile/pages/user_profile/cubit/user_profile_cubit.dart';
import 'package:photo_flow_mobile_app/modules/profile/providers/user_profile_provider.dart';
import 'package:photo_flow_mobile_app/modules/profile/providers/user_profile_provider_firebase.dart';

import 'package:photo_flow_mobile_app/shared/controllers/account_info/account_info_controller.dart';

class AppDependencies {
  static final injector = GetIt.instance;

  Future<void> setupDependencies() async {
    await _setupFirebase();
    _setupAccountInfoController();
    _setupProviders();
    _setupCubits();
  }

  Future<void> _setupFirebase() async {
    await Firebase.initializeApp();
  }

  void _setupAccountInfoController() {
    injector.registerLazySingleton(
      () => AccountInfoController(firebaseAuth: FirebaseAuth.instance),
    );
  }
  void _setupProviders() {
    injector
      ..registerLazySingleton<AuthProvider>(
        () => AuthProviderFirebase(firebaseAuth: FirebaseAuth.instance),
      )
      ..registerLazySingleton<HomeProvider>(() => HomeProviderFirebase())
      ..registerLazySingleton<ProfileProvider>(
        () => ProfileProviderFirebase(firebaseAuth: FirebaseAuth.instance),
      )
      ..registerLazySingleton<PhotoUploadProvider>(
        () => PhotoUploadProviderFirebase(),
      )
      ..registerLazySingleton<UserProfileProvider>(
        () => UserProfileProviderFirebase(),
      );
  }

  void _setupCubits() {
    injector
      ..registerLazySingleton(
        () => LoginCubit(authProvider: injector.get<AuthProvider>()),
      )
      ..registerLazySingleton(
        () => RegisterCubit(authProvider: injector.get<AuthProvider>()),
      )
      ..registerLazySingleton(
        () => HomeCubit(homeProvider: injector.get<HomeProvider>()),
      )
      ..registerLazySingleton(
        () => UpdateCubit(profileProvider: injector.get<ProfileProvider>()),
      )
      ..registerLazySingleton(
        () => PhotoUploadCubit(
          photoUploadProvider: injector.get<PhotoUploadProvider>(),
          accountInfoController: injector.get<AccountInfoController>(),
        ),
      )      ..registerLazySingleton(
        () => UserProfileCubit(
          userProfileProvider: injector.get<UserProfileProvider>(),
          accountInfoController: injector.get<AccountInfoController>(),
        ),
      );
  }
}
