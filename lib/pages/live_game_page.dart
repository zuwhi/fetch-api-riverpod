// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:extended_image/extended_image.dart';
import 'package:fetch_api/models/game.dart';
import 'package:fetch_api/providers/genre_provider.dart';
import 'package:fetch_api/providers/live_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveGame extends ConsumerStatefulWidget {
  const LiveGame({Key? key}) : super(key: key);

  @override
  ConsumerState<LiveGame> createState() => _LiveGameState();
}

class _LiveGameState extends ConsumerState<LiveGame> {
  List genre = ['Shooter', 'MMOARPG', 'ARPG', 'Strategy', 'Fighting'];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(liveGameNotifierProvider.notifier).fetchLiveGames();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Live Games"),
          actions: const [],
        ),
        body: Column(
          children: [
            Consumer(
              builder: (context, wiRef, child) {
                String genreeSelected = wiRef.watch(genreNotifierProvider);

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: genre.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ActionChip(
                        onPressed: () {
                          ref.read(genreNotifierProvider.notifier).change(e);
                        },
                        label: Text(
                          e,
                          style: TextStyle(
                            color: genreeSelected == e
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        backgroundColor:
                            genreeSelected == e ? Colors.blue : Colors.white,
                      ),
                    );
                  }).toList()),
                );
              },
            ),
            Expanded(
              child: Consumer(
                builder: (context, wiRef, child) {
                  LiveGameState state = wiRef.watch(liveGameNotifierProvider);
                  if (state.status == '') return const SizedBox.shrink();
                  if (state.status == 'Loading') {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.status == 'Failed') {
                    return Center(
                      child: Text(state.message),
                    );
                  }
                  List<Game> list = state.data;

                  String genreSelected = wiRef.watch(genreNotifierProvider);
                  List<Game> games = list
                      .where((element) => element.genre == genreSelected)
                      .toList();

                  return GridView.builder(
                    itemCount: games.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      Game game = games[index];
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: ExtendedImage.network(
                              game.thumbnail!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  onPressed: () {
                                    Game newGame =
                                        game.copyWith(isSaved: !game.isSaved);
                                    // String? title = game.title;
                                    // print(title);

                                    wiRef
                                        .read(liveGameNotifierProvider.notifier)
                                        .ChangeIsSaved(newGame);
                                  },
                                  icon: game.isSaved
                                      ? Icon(
                                          Icons.bookmark,
                                          color: Colors.purple,
                                        )
                                      : Icon(
                                          Icons.bookmark_border_outlined,
                                          color: Colors.white,
                                        )))
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
