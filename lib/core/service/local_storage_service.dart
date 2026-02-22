import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ==================== Search History Methods ====================
  
  /// Get search history (returns list of search queries)
  static Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('search_history');
    if (historyJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.cast<String>();
    } catch (e) {
      return [];
    }
  }

  /// Add a search query to history (max 20 items, most recent first)
  static Future<void> addSearchHistory(String query) async {
    if (query.trim().isEmpty) return;
    
    final history = await getSearchHistory();
    
    // Remove if already exists
    history.remove(query);
    
    // Add to beginning
    history.insert(0, query);
    
    // Keep only last 20 searches
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('search_history', jsonEncode(history));
  }

  /// Remove a specific search query from history
  static Future<void> removeSearchHistory(String query) async {
    final history = await getSearchHistory();
    history.remove(query);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('search_history', jsonEncode(history));
  }

  /// Clear all search history
  static Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
  }

  // ==================== Recently Viewed Methods ====================
  
  /// Get recently viewed items
  /// Returns list of maps: [{'id': '123', 'type': 'adslot', 'timestamp': 1234567890}]
  static Future<List<Map<String, dynamic>>> getRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    final viewedJson = prefs.getString('recently_viewed');
    if (viewedJson == null) return [];
    
    try {
      final List<dynamic> decoded = jsonDecode(viewedJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Add an item to recently viewed (max 50 items, most recent first)
  static Future<void> addRecentlyViewed({
    required String id,
    required String type, // 'adslot', 'user', 'service', 'creative', 'template'
    String? imageUrl,
    String? title,
  }) async {
    final viewed = await getRecentlyViewed();
    
    // Remove if already exists
    viewed.removeWhere((item) => item['id'] == id && item['type'] == type);
    
    // Add to beginning with timestamp
    viewed.insert(0, {
      'id': id,
      'type': type,
      'imageUrl': imageUrl,
      'title': title,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    
    // Keep only last 50 items
    if (viewed.length > 50) {
      viewed.removeRange(50, viewed.length);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('recently_viewed', jsonEncode(viewed));
  }

  /// Clear all recently viewed items
  static Future<void> clearRecentlyViewed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('recently_viewed');
  }
}
