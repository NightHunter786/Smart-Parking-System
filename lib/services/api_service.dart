import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<Map<String, dynamic>>> fetchSlots() async {
    final response = await http.get(Uri.parse('$baseUrl/api/slots'));

    if (response.statusCode == 200) {
      // Parse the JSON response using json.decode
      List<Map<String, dynamic>> slots =
          List<Map<String, dynamic>>.from(json.decode(response.body));
      return slots;
    } else {
      // Handle errors
      throw Exception('Failed to fetch slots');
    }
  }
}
