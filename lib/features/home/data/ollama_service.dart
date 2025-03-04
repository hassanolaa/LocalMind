

import 'package:gpt/core/shared/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class OllamaService {

  final String baseUrl="http://localhost:11434";

  

  Future<List<String>> getAvailableModels() async {
    final url = Uri.parse('$baseUrl/api/tags');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
     

      return List<String>.from(data['models'].map((model) => model['name']));
    }
    return [];
    // throw Exception('Failed to load models');
  }

  Future<Map<String, dynamic>> generateResponse(String prompt) async {
    final url = Uri.parse('$baseUrl/api/generate');
    final body = json.encode({'model': get_storage.readData("model"), 'prompt': prompt, 'stream': false});
    final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to generate response');
  }

  Future<Map<String, dynamic>> chatResponse(
      String modelName, List<Map<String, String>> messages) async {
    final url = Uri.parse('$baseUrl/api/chat');
    final body = json.encode({
      'model': modelName,
      'messages': messages,
      'stream': false, // Disable streaming for a single response
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to generate chat response');
  }

}


