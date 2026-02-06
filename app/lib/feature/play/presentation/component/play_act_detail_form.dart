import "package:collection/collection.dart";
import "package:flutter/material.dart";

import "../../../../shared/presentation/error_view/shared_error_view.dart";
import "../../../../shared/presentation/loading_indicator/shared_loading_indicator.dart";
import "../../../../shared/presentation/outlined_button/shared_outlined_button.dart";
import "../../model/model/play_model.dart";
import "play_line_form.dart";

class PlayActDetailForm extends StatelessWidget {
  const PlayActDetailForm({
    super.key,
    this.formKey,
    required this.act,
    this.onActLineCreate,
    this.onActLineSaved,
    this.onActLineBlur,
    this.onActLineDelete,
    this.onSceneLineSaved,
    this.onSceneLineBlur,
    this.onSceneLineDelete,

    this.onPullSceneList,
    this.isLoadingScene = false,
    this.sceneError,
  });

  final PlayAct act;
  final GlobalKey<FormState>? formKey;

  final void Function(String lineId, String content)? onActLineSaved;
  final void Function(String lineId, String content)? onActLineBlur;
  final void Function(String lineId)? onActLineDelete;
  final void Function(int sortOrder)? onActLineCreate;
  final void Function(String sceneId, String lineId, String content)?
  onSceneLineSaved;
  final void Function(String sceneId, String lineId, String content)?
  onSceneLineBlur;
  final void Function(String sceneId, String lineId)? onSceneLineDelete;
  final void Function()? onPullSceneList;
  final bool isLoadingScene;
  final dynamic sceneError;

  @override
  Widget build(BuildContext context) {
    List<Widget> sceneChildren(PlayScene scene) {
      final List<Widget> sceneChildren = [
        Text(
          "${scene.concept.code.suit.name} ${scene.concept.code.number.name}",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          scene.concept.concept,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        ...scene.lines.values
            .sortedBy((line) => line.sortOrder)
            .map(
              (line) => PlayLineForm(
                key: ValueKey("${line.id}_form"),
                line: line,
                onSaved: onSceneLineSaved == null
                    ? null
                    : (text) => onSceneLineSaved!(scene.id, line.id, text),
                onDelete: onSceneLineDelete == null
                    ? null
                    : () => onSceneLineDelete!(scene.id, line.id),
                onBlur: onSceneLineBlur == null
                    ? null
                    : (text) => onSceneLineBlur!(scene.id, line.id, text),
              ),
            ),
      ];
      return sceneChildren;
    }

    List<Widget> actChildren(PlayAct act) {
      final List<Widget> actChildren = [
        ...act.lines.values
            .sortedBy((line) => line.sortOrder)
            .map(
              (line) => PlayLineForm(
                key: ValueKey("${line.id}_form"),
                line: line,
                onSaved: onActLineSaved == null
                    ? null
                    : (text) => onActLineSaved!(line.id, text),
                onDelete: onActLineDelete == null
                    ? null
                    : () => onActLineDelete!(line.id),
                onBlur: onActLineBlur == null
                    ? null
                    : (text) => onActLineBlur!(line.id, text),
              ),
            ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: SharedOutlinedButton(
            iconData: Icons.add,
            label: "Add Line",
            onPressed: onActLineCreate == null
                ? null
                : () => onActLineCreate!(act.lines.length + 1),
          ),
        ),
        SizedBox(height: 20),
        if (!isLoadingScene && sceneError == null)
          ...act.scenes.values
              .sortedBy((line) => line.sortOrder)
              .expandIndexed(
                (index, scene) => [
                  ...sceneChildren(scene),
                  if (index <= act.scenes.length - 1) SizedBox(height: 20),
                ],
              ),
        if (isLoadingScene)
          SizedBox(height: 50, child: SharedLoadingIndicator()),
        if (sceneError != null) SharedErrorView(message: sceneError.toString()),

        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: SharedOutlinedButton(
            iconData: Icons.add,
            label: "Pull Cards",
            onPressed: onPullSceneList == null
                ? null
                : () => onPullSceneList!(),
          ),
        ),
      ];
      return actChildren;
    }

    final List<Widget> children = actChildren(act);

    return Form(
      key: formKey,
      child: Container(
        margin: EdgeInsets.all(10),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: children.length,
          itemBuilder: (context, index) => Center(child: children[index]),
        ),
      ),
    );
  }
}
