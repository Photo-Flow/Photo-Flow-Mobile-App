import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/feed_cubit.dart';
import 'cubit/feed_state.dart';
import 'package:photo_flow_mobile_app/shared/components/card/card_feed_component.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final FeedCubit cubit = FeedCubit();

  @override
  void initState() {
    super.initState();
    cubit.fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        centerTitle: true,
        title: Image.asset('assets/Logo.png', height: 40),
      ),
      body: BlocBuilder<FeedCubit, FeedState>(
        bloc: cubit,
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Erro: ${state.error}'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: state.photos.length,
            itemBuilder: (context, index) {
              final photo = state.photos[index];
              return CardFeedComponent(
                userName: photo['userName'] ?? 'Usuário',
                profileImageUrl: photo['profileImageUrl'] ?? '',
                feedImageUrl: photo['url'] ?? '',
              );
            },
          );
        },
      ),
    );
  }
}
