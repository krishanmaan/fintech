import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class BannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String redirectUrl;
  final int order;

  BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.redirectUrl,
    required this.order,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      redirectUrl: json['redirect_url'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}

class BannerService {
  // Corrected endpoint: Removed '/all' assuming standard REST or filtered query
  static const String baseUrl = 'https://api.webfino.com/api/v1/banner';
  final StorageService _storageService = StorageService();

  Future<List<BannerModel>> fetchBanners() async {
    try {
      final token = await _storageService.getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      // Changed from '$baseUrl/all' to just '$baseUrl' if 'all' is interpreted as ID
      // But typically filtering is done via query params on the resource collection.
      // Trying without '/all' path segment first.
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'for_entity_name': 'DASHBOARD',
          'limit': '10',
          'page': '1',
        },
      );

      print('🚀 fetching banners from: $uri');

      final response = await http.get(uri, headers: headers);

      print('🚀 Banner Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('🚀 Banner Response Success');
        if (jsonResponse['data'] != null &&
            jsonResponse['data']['data'] != null) {
          final List<dynamic> bannerList = jsonResponse['data']['data'];
          return bannerList.map((json) => BannerModel.fromJson(json)).toList();
        }
        return [];
      } else {
        debugPrint('Failed to fetch banners: ${response.statusCode}');
        print('Error Body: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching banners: $e');
      return [];
    }
  }
}
