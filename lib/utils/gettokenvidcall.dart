import 'package:careshareapp2/utils/url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> fetchToken(String channelName) async {
  final response = await http
      .get(Uri.parse('$url/generate_token.php?channelName=$channelName'));

  if (response.statusCode == 200) {
    return json.decode(response.body)['token'];
  } else {
    throw Exception('Failed to load token');
  }
}
