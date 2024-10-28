import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataProvider extends ChangeNotifier {
  bool _isFetching = false;
  Map<String, dynamic>? _data;

  bool get isFetching => _isFetching;
  Map<String, dynamic>? get data => _data;

  // Method to fetch data from the API
  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();

    try {
      // Replace '192.168.1.5' with the actual IP address of your development machine
      final response = await http.get(Uri.parse('http://192.168.1.5:3000/')); 
      if (response.statusCode == 200) {
        _data = json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching data: $error');
      }
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }
}
