class Category {
  Category({
    this.id = '',
    this.name = '',
    this.slug = '',
    this.order = 0,
  });
  String id;
  String name;
  String slug;
  int order;

  Category.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        order = snapshot['order'] ?? '',
        slug = snapshot['slug'] ?? '';

  toJson() {
    return {
      "name": name,
    };
  }
//DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}
