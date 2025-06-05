class FeedState {
  final List<Map<String, dynamic>> photos;
  final bool loading;
  final String? error;

  FeedState({this.photos = const [], this.loading = false, this.error});

  FeedState copyWith({
    List<Map<String, dynamic>>? photos,
    bool? loading,
    String? error,
  }) {
    return FeedState(
      photos: photos ?? this.photos,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
