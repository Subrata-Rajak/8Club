/// Experience entity - domain layer representation
class Experience {
  final int id;
  final String name;
  final String? tagline;
  final String? description;
  final String? imageUrl;
  final String? iconUrl;
  final int order;

  const Experience({
    required this.id,
    required this.name,
    this.tagline,
    this.description,
    this.imageUrl,
    this.iconUrl,
    required this.order,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Experience &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          tagline == other.tagline &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          iconUrl == other.iconUrl &&
          order == other.order;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      tagline.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      iconUrl.hashCode ^
      order.hashCode;
}

