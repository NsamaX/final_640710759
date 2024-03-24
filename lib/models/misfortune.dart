class misfortune {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  bool selected;

  misfortune({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.selected = false,
  });

  factory misfortune.fromJson(Map<String, dynamic> json) {
    return misfortune(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      imageUrl: json['image'],
    );
  }
}
