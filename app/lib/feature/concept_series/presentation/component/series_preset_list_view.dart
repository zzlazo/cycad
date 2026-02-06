import "package:flutter/material.dart";

import "../../model/model/concept_series_model.dart";

class SeriesPresetListView extends StatelessWidget {
  const SeriesPresetListView({super.key, required this.presets, this.onTap});

  final List<CardConceptSeriesPreset> presets;
  final void Function(int id)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final preset = presets[index];
        return SeriesPresetListTile(
          title: preset.title,
          description: preset.description,
          onTap: () {
            onTap?.call(preset.id);
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: presets.length,
    );
  }
}

class SeriesPresetListTile extends StatelessWidget {
  const SeriesPresetListTile({
    super.key,
    required this.title,
    required this.description,
    this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      subtitle: Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: onTap,
    );
  }
}
