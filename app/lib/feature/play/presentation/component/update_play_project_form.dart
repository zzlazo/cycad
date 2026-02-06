import "package:flutter/widgets.dart";

import "../../../../shared/presentation/drop_down_menu/model/shared_drop_down_menu_model.dart";
import "../../../../shared/presentation/drop_down_menu/shared_drop_down_menu_form_field.dart";
import "../../../../shared/presentation/text_field/shared_text_field.dart";
import "../../../concept_series/model/model/concept_series_model.dart";

class UpdatePlayProjectForm extends StatelessWidget {
  const UpdatePlayProjectForm({
    super.key,
    required this.seriesList,
    this.onTitleChanged,
    required this.formKey,
    this.onSeriesChanged,
  });

  final GlobalKey<FormState> formKey;
  final List<CardConceptSeriesOverview> seriesList;
  final void Function(String text)? onTitleChanged;
  final void Function(int? id)? onSeriesChanged;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      SharedTextFormField(onChanged: onTitleChanged, hintText: "Title"),
      SharedDropDownMenuFormField<CardConceptSeriesOverview>(
        width: double.infinity,
        hintText: "Series",
        onSelected: onSeriesChanged == null
            ? null
            : (value) => onSeriesChanged!(value?.id),
        entries: seriesList
            .map(
              (series) =>
                  SharedDropDownMenuEntryModel<CardConceptSeriesOverview>(
                    value: series,
                    label: series.title,
                  ),
            )
            .toList(),
      ),
    ];

    return Form(
      key: formKey,
      child: ListView.separated(
        itemCount: children.length,
        itemBuilder: (context, index) => Center(child: children[index]),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
      ),
    );
  }
}
