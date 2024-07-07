// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/io.dart';

// class WebSocketService {
//   late WebSocketChannel channel;

//   WebSocketService() {
//     channel =
//         IOWebSocketChannel.connect('ws://192.168.126.1/careshare/config.php');
//   }

//   Stream<dynamic> getMessages() {
//     return channel.stream;
//   }

//   void sendMessage(String message) {
//     channel.sink.add(message);
//   }

//   void close() {
//     channel.sink.close();
//   }
// }
