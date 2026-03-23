class Group {
  final String id;
  final String name;
  final List<String> members;

  Group({required this.id, required this.name, required this.members});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'],
      name: json['name'],
      members: List<String>.from(json['members']),
    );
  }
}