class Contact {
  Contact({
    this.id = '',
    this.name = '',
    this.email = '',
    this.message = '',
  });
  String id;
  String name;
  String email;
  String message;

  Contact.fromMap(Map snapshot, String id)
      : id = id ?? '',
        name = snapshot['name'] ?? '',
        email = snapshot['email'] ?? '',
        message = snapshot['message'] ?? '';

  toJson() {
    return {
      "name": name,
      "email": email,
      "message": message,
    };
  }
}
