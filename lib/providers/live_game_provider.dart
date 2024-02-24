// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fetch_api/providers/genre_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fetch_api/models/game.dart';
import 'package:fetch_api/source/game_source.dart';

part 'live_game_provider.g.dart';

@riverpod
class LiveGameNotifier extends _$LiveGameNotifier {
  @override
  LiveGameState build() => LiveGameState('', '', []);

  fetchLiveGames() async {
    state = LiveGameState('Loading', '', []);
    // await Future.delayed(const Duration(seconds: 2));
    final games = await GameSource.getLive();
    if (games == null) {
      state = LiveGameState('failed', 'empty data', []);
    } else {
      // String genre = ref.watch(genreNotifierProvider);
      // List<Game> filerGames =
      //     games.where((element) => element.genre == genre).toList();
      // state = LiveGameState('status', '', filerGames);
      state = LiveGameState('status', '', games);
    }
  }

  ChangeIsSaved(Game newGame) {
    print(newGame.title);
    int index = state.data.indexWhere((element) => element.id == newGame.id);

    state.data[index] = newGame;
    state = LiveGameState('success', '', [...state.data]);
  }
}

class LiveGameState extends Equatable {
  final String status;
  final String message;
  final List<Game> data;
  LiveGameState(
    this.status,
    this.message,
    this.data,
  );

  @override
  // TODO: implement props
  List<Object> get props => [status, message, data];
}
