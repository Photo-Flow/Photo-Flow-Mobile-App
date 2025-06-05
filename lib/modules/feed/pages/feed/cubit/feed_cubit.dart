import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedState());

  Future<void> fetchFeed() async {
    emit(state.copyWith(loading: true));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('photos')
          .orderBy('createdAt', descending: true)
          .get();
      final photos = snapshot.docs.map((doc) => doc.data()).toList();
      emit(state.copyWith(photos: photos, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
