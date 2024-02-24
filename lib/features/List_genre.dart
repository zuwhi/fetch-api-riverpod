import 'package:fetch_api/providers/genre_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListGenre extends ConsumerWidget {
  const ListGenre({
    super.key,
    required this.genre,
    required this.genreeSelected,
  });

  final List genre;
  final String genreeSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
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
              color: genreeSelected == e ? Colors.white : Colors.black,
            ),
          ),
          backgroundColor: genreeSelected == e ? Colors.purple : Colors.white,
        ),
      );
    }).toList());
  }
}
