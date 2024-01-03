import 'cache_config.dart';

class Profile {
  int theme; // 主题颜色索引
  CacheConfig? cache; // 缓存策略配置

  Profile({
    this.theme = 0, // 默认主题索引为0，代表蓝色
    this.cache,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      theme: json['theme'] ?? 0,
      cache: json['cache'] != null ? CacheConfig.fromJson(json['cache']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'cache': cache?.toJson(),
    };
  }
}
