import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/agora_service.dart';
import '../services/room_service.dart';

class RoomScreen extends StatefulWidget {
  final Room room;
  final String username;
  final bool isHost;
  final AgoraService agoraService;
  final RoomService roomService;

  const RoomScreen({
    super.key,
    required this.room,
    required this.username,
    required this.isHost,
    required this.agoraService,
    required this.roomService,
  });

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    widget.agoraService.join(widget.room.id, widget.username);
  }

  @override
  void dispose() {
    widget.agoraService.leave();
    widget.roomService.leaveRoom(widget.room.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1425),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2238),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.room.name,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
            Text(widget.room.topic,
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.red),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          const Text('🎤 Konuşmacılar',
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 16),
          // Konuşmacı kafaları
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _avatar(widget.room.hostName, isHost: true),
              _avatar(widget.username),
            ],
          ),
          const Spacer(),
          // Alt kontrol çubuğu
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF2A2238),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mikrofon
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _muted
                      ? Colors.red.shade700
                      : const Color(0xFFFFB300),
                  child: IconButton(
                    icon: Icon(_muted ? Icons.mic_off : Icons.mic,
                        color: Colors.white, size: 28),
                    onPressed: () async {
                      await widget.agoraService.toggleMic(!_muted);
                      setState(() => _muted = !_muted);
                    },
                  ),
                ),
                // El kaldır (dinleyici)
                if (!widget.isHost)
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade700,
                    child: const Icon(Icons.front_hand,
                        color: Colors.white, size: 28),
                  ),
                // Çıkış
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.red.shade700,
                  child: IconButton(
                    icon: const Icon(Icons.call_end,
                        color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String name, {bool isHost = false}) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: isHost
              ? const Color(0xFFFFB300)
              : const Color(0xFF4A3B5E),
          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(name,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
