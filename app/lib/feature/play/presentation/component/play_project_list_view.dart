import "package:flutter/material.dart";

import "../../model/model/play_model.dart";

class PlayProjectListView extends StatelessWidget {
  const PlayProjectListView({
    super.key,
    required this.overviews,
    required this.onTap,
  });

  final List<PlayProjectOverviewViewModel> overviews;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: overviews.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            overviews[index].title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            overviews[index].updatedAt,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onTap: () => onTap(index),
        );
      },
    );
  }
}
