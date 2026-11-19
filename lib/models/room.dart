class Room {
  final String id;
  final String name;
  final String topic;
  final String hostName;
  final int listenerCount;
  final DateTime createdAt;

  Room({
    required this.id,
    required this.name,
    required this.topic,
    required this.hostName,
    required this.listenerCount,
    required this.createdAt,
  });

  factory Room.fromMap(String id, Map<dynamic, dynamic> map) => Room(
        id: id,
        name: map['name'] ?? 'Oda',
        topic: map['topic'] ?? '',
        hostName: map['hostName'] ?? '',
        listenerCount: map['listenerCount'] ?? 0,
        createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'topic': topic,
        'hostName': hostName,
        'listenerCount': listenerCount,
        'createdAt': createdAt.toIso8601String(),
      };
}
