import 'dart:convert';
import 'package:careshareapp2/utils/url.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "$url/index.php?path";

  Future<List<dynamic>> getForums() async {
    final response = await http.get(Uri.parse('$baseUrl=forums'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load forums');
    }
  }

  Future<Map<String, dynamic>> getForumDetail(int forumId) async {
    final response = await http.get(Uri.parse('$baseUrl=forum/$forumId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load forum detail');
    }
  }

  Future<List<dynamic>> getForumChats(int forumId) async {
    final response = await http.get(Uri.parse('$baseUrl=chats/$forumId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load forum chats');
    }
  }

  Future<void> sendMessage(int forumId, String userId, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl=chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'forum_id': forumId, 'user_id': userId, 'message': message}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to send message');
    }
  }
}
