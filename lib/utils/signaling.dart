// import 'dart:convert';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class Signaling {
//   WebSocketChannel? _channel;
//   RTCVideoRenderer _localRenderer;
//   RTCVideoRenderer _remoteRenderer;

//   Signaling(this._localRenderer, this._remoteRenderer);

//   void connect() {
//     _channel = WebSocketChannel.connect(
//       Uri.parse('ws://your.websocket.server:port'),
//     );

//     _channel?.stream.listen((message) {
//       Map<String, dynamic> data = json.decode(message);
//       // Handle signaling messages here
//     });
//   }

//   void send(String event, Map<String, dynamic> data) {
//     _channel?.sink.add(json.encode({
//       'event': event,
//       'data': data,
//     }));
//   }

//   void dispose() {
//     _channel?.sink.close();
//   }
// }
