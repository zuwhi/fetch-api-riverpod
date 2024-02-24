import 'package:extended_image/extended_image.dart';
import 'package:fetch_api/models/game.dart';
import 'package:fetch_api/providers/live_game_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListGame extends ConsumerWidget {
  const ListGame({
    super.key,
    required this.games,
  });

  final List<Game> games;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      itemCount: games.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
                      Game newGame = game.copyWith(isSaved: !game.isSaved);
                      // String? title = game.title;
                      // print(title);

                      ref
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
  }
}
