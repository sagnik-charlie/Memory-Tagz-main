import 'dart:io';

class MemoryTag {
  /// {@macro todo}
  const MemoryTag({
    required this.id,
    required this.title,
    this.description,
    required this.image,
  });

  /// The id of this tag.
  final String id;

  /// The description of this tag.
  final String title;
  final String? description;

  /// Photo snapped for this tag
  final File image;
}
