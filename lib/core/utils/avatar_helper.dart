/// Helper class for managing user avatars
/// Provides default avatars for users without profile pictures
class AvatarHelper {
  AvatarHelper._();

  /// List of default avatar paths
  static const List<String> _defaultAvatars = [
    'assets/icons/avatars/avatars/avatar-1.jpg',
    'assets/icons/avatars/avatars/avatar-2.jpg',
    'assets/icons/avatars/avatars/avatar-3.jpg',
    'assets/icons/avatars/avatars/avatar-4.jpg',
    'assets/icons/avatars/avatars/avatar-5.jpg',
    'assets/icons/avatars/avatars/avatar-6.jpg',
    'assets/icons/avatars/avatars/avatar-7.jpg',
  ];

  /// Get avatar URL or default avatar based on user ID
  /// 
  /// Returns the user's avatar URL if available, otherwise returns a
  /// consistent default avatar based on the user's ID hash
  /// 
  /// Example:
  /// ```dart
  /// final avatar = AvatarHelper.getAvatar(
  ///   avatarUrl: user.avatarUrl,
  ///   userId: user.id,
  /// );
  /// ```
  static String getAvatar({
    String? avatarUrl,
    required dynamic userId,
  }) {
    // If user has an avatar URL and it's not empty, use it
    if (avatarUrl != null && avatarUrl.trim().isNotEmpty) {
      return avatarUrl;
    }

    // Otherwise, return a consistent default avatar based on user ID
    return getDefaultAvatar(userId);
  }

  /// Get a consistent default avatar based on user ID
  /// 
  /// Uses the user ID to deterministically select one of the default avatars
  /// This ensures the same user always gets the same default avatar
  static String getDefaultAvatar(dynamic userId) {
    // Convert userId to string and get its hash code
    final idString = userId.toString();
    final hashCode = idString.hashCode.abs();
    
    // Use modulo to select an avatar from the list
    final index = hashCode % _defaultAvatars.length;
    
    return _defaultAvatars[index];
  }

  /// Get a random default avatar (not recommended for user profiles)
  /// 
  /// This method returns a random avatar each time it's called
  /// Only use this for temporary placeholders, not for user profiles
  static String getRandomAvatar() {
    final index = DateTime.now().millisecondsSinceEpoch % _defaultAvatars.length;
    return _defaultAvatars[index];
  }

  /// Check if a URL is a default avatar
  static bool isDefaultAvatar(String? url) {
    if (url == null) return false;
    return _defaultAvatars.contains(url);
  }
}
