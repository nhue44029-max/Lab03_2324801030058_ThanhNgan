class Destination {
  const Destination({
    required this.name,
    required this.description,
    required this.imagePath,
    this.discountLabel,
  });

  final String name;
  final String description;
  final String imagePath;
  final String? discountLabel;
}
