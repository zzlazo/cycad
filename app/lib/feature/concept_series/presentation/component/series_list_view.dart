import "package:flutter/material.dart";

import "../../model/model/concept_series_model.dart";

class SeriesListView extends StatelessWidget {
  const SeriesListView({super.key, required this.overviews, this.onTap});

  final List<CardConceptSeriesOverviewListItemModel> overviews;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: overviews.length,
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemBuilder: (context, index) {
        return SeriesListTile(
          key: ValueKey(overviews[index].id),
          title: overviews[index].title,
          updatedTime: overviews[index].updatedAt,
          onTap: onTap == null ? null : () => onTap!(index),
        );
      },
    );
  }
}

class SeriesListTile extends StatelessWidget {
  const SeriesListTile({super.key, this.title, this.updatedTime, this.onTap});
  final VoidCallback? onTap;
  final String? title;
  final String? updatedTime;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title ?? "No Title",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      subtitle: updatedTime == null
          ? null
          : Text(
              "Updated: $updatedTime",
              style: Theme.of(context).textTheme.titleSmall,
            ),
      onTap: onTap,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
