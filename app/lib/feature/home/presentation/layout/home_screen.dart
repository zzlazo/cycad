import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/router/router/router.dart";
import "../../../../shared/presentation/base_screen/shared_app_bar.dart";
import "../../../../shared/presentation/base_screen/shared_base_screen.dart";
import "../component/home_user_icon.dart";

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SharedBaseScreen(
      appBar: SharedAppBar(
        title: "Cycad",
        actions: [HomeUserIcon()],
        canPop: false,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.edit_square),
              title: FeatureTitle(title: "Edit Series"),
              onTap: () async {
                await SelectSeriesRoute().push(context);
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.play_arrow),
              title: FeatureTitle(title: "Play"),
              onTap: () async {
                await SelectPlayProjectRoute().push(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureTitle extends StatelessWidget {
  const FeatureTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }
}
