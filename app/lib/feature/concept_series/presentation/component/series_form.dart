import "package:collection/collection.dart";
import "package:flutter/material.dart";

import "../../../../shared/presentation/text_field/shared_text_field.dart";
import "../../model/model/concept_series_model.dart";

class SeriesForm extends StatelessWidget {
  const SeriesForm({
    super.key,
    required this.title,
    required this.onChangedTitle,
    required this.onChangedConcept,
    required this.concepts,
  });

  final String title;
  final void Function(String text)? onChangedTitle;
  final void Function(int index, String text)? onChangedConcept;
  final List<CardConcept> concepts;

  @override
  Widget build(BuildContext context) {
    final formList = <Widget>[
      SharedTextFormField(
        hintText: "Title",
        onChanged: onChangedTitle,
        initialValue: title,
      ),
      ...concepts.mapIndexed(
        (index, entry) => ConceptFormItem(
          suitName: entry.code.suit.name,
          numberName: entry.code.number.name,
          onChanged: (text) => onChangedConcept?.call(index, text),
          initialValue: entry.concept,
        ),
      ),
    ];
    return Form(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: formList.length,
        itemBuilder: (context, index) => formList[index],
      ),
    );
  }
}

class ConceptFormItem extends StatelessWidget {
  const ConceptFormItem({
    super.key,
    required this.suitName,
    required this.numberName,
    this.initialValue,
    required this.onChanged,
  });

  final String suitName;
  final String numberName;
  final String? initialValue;
  final void Function(String text)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuitWidget(name: suitName),
            NumberWidget(name: numberName),
          ],
        ),
        SharedTextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          maxLines: 5,
        ),
      ],
    );
  }
}

class SuitWidget extends StatelessWidget {
  const SuitWidget({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(name, style: Theme.of(context).textTheme.titleMedium);
  }
}

class NumberWidget extends StatelessWidget {
  const NumberWidget({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(name, style: Theme.of(context).textTheme.titleMedium);
  }
}
