import 'package:firebase_database/firebase_database.dart';
import '../models/room.dart';

class RoomService {
  final DatabaseReference _db =
      FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL: 'https://PROJEN.firebaseio.com', // config ile değiştir
  ).ref('rooms');

  Stream<List<Room>> roomsStream() {
    return _db.orderByChild('createdAt').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      final rooms =
          data.entries.map((e) => Room.fromMap(e.key!, e.value)).toList();
      return rooms.reversed.toList();
    });
  }

  Future<Room> createRoom({
    required String name,
    required String topic,
    required String hostName,
  }) async {
    final ref = _db.push();
    final room = Room(
      id: ref.key!,
      name: name,
      topic: topic,
      hostName: hostName,
      listenerCount: 1,
      createdAt: DateTime.now(),
    );
    await ref.set(room.toMap());
    return room;
  }

  Future<void> joinRoom(String roomId) async {
    await _db.child(roomId).child('listenerCount')
        .runTransaction((current) {
      return Transaction.success((current ?? 0) + 1);
    });
  }

  Future<void> leaveRoom(String roomId) async {
    await _db.child(roomId).child('listenerCount')
        .runTransaction((current) {
      return Transaction.success(((current ?? 1) - 1).clamp(0, 1 << 30));
    });
  }

  Future<void> deleteRoom(String roomId) async {
    await _db.child(roomId).remove();
  }
}
