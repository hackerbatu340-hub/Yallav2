import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/room_service.dart';
import '../services/agora_service.dart';
import '../models/room.dart';
import 'room_screen.dart';
import '../config.dart';

class RoomsScreen extends StatefulWidget {
  final String username;
  const RoomsScreen({super.key, required this.username});
  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  final RoomService _roomService = RoomService();
  final AgoraService _agoraService = AgoraService();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'API_KEY',
      appId: 'APP_ID',
      messagingSenderId: 'SENDER_ID',
      projectId: 'PROJECT_ID',
      databaseURL: Config.firebaseDbUrl,
    ));
    await _agoraService.init();
  }

  void _createRoom() {
    final nameCtrl = TextEditingController();
    final topicCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2238),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl,
                decoration: const InputDecoration(hintText: 'Oda adı')),
            const SizedBox(height: 12),
            TextField(controller: topicCtrl,
                decoration: const InputDecoration(hintText: 'Konu')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                final room = await _roomService.createRoom(
                  name: nameCtrl.text.trim(),
                  topic: topicCtrl.text.trim(),
                  hostName: widget.username,
                );
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (_) => RoomScreen(
                          room: room,
                          username: widget.username,
                          isHost: true,
                          agoraService: _agoraService,
                          roomService: _roomService)));
                }
              },
              child: const Text('Oda Oluştur'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1425),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B1425),
        title: Text('Merhaba, ${widget.username}',
            style: const TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFFFB300), size: 32),
            onPressed: _createRoom,
          ),
        ],
      ),
      body: StreamBuilder<List<Room>>(
        stream: _roomService.roomsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final rooms = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rooms.length,
            itemBuilder: (context, i) {
              final room = rooms[i];
              return Card(
                color: const Color(0xFF2A2238),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  title: Text(room.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '${room.topic} • ${room.hostName}',
                      style: const TextStyle(color: Colors.white54)),
                  trailing: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.red.shade900,
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('${room.listenerCount} 🎧',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  onTap: () async {
                    await _roomService.joinRoom(room.id);
                    if (mounted) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (_) => RoomScreen(
                              room: room,
                              username: widget.username,
                              isHost: false,
                              agoraService: _agoraService,
                              roomService: _roomService)));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
