import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class StaticPageModel {
  final String title;
  final String content;
  final String metaTitle;
  final String metaDescription;

  StaticPageModel({
    required this.title,
    required this.content,
    required this.metaTitle,
    required this.metaDescription,
  });

  factory StaticPageModel.fromJson(Map<String, dynamic> json) {
    return StaticPageModel(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      metaTitle: json['meta_title'] ?? '',
      metaDescription: json['meta_description'] ?? '',
    );
  }
}

class StaticPageService {
  static const String baseUrl = 'https://api.webfino.com/api/v1/pages';

  Future<StaticPageModel?> getPage(String type) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$type'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['data'] != null) {
          return StaticPageModel.fromJson(jsonResponse['data']);
        }

        return null;
      } else {
        debugPrint('Failed to load page $type: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching page $type: $e');
      return null;
    }
  }
}
