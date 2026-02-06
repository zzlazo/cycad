import "package:flutter/material.dart";

class SharedUserIcon extends StatelessWidget {
  const SharedUserIcon({super.key, required this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    if (avatarUrl == null || avatarUrl!.isEmpty) {
      return DefaultUserIcon();
    }
    return CircleAvatar(
      foregroundImage: NetworkImage(avatarUrl!),
      onForegroundImageError: (exception, stackTrace) =>
          const Icon(Icons.person),
    );
  }
}

class DefaultUserIcon extends StatelessWidget {
  const DefaultUserIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.person);
  }
}
