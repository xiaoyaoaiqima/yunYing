class CacheConfig {
  bool enable; // 是否启用缓存
  int maxAge; // 缓存最大生命周期，单位秒
  int maxCount; // 缓存最大数量

  CacheConfig({
    this.enable = true, // 默认启用缓存
    this.maxAge = 3600, // 缓存最大生命周期为1小时
    this.maxCount = 100, // 缓存最大数量为100
  });

  factory CacheConfig.fromJson(Map<String, dynamic> json) {
    return CacheConfig(
      enable: json['enable'] ?? true,
      maxAge: json['maxAge'] ?? 3600,
      maxCount: json['maxCount'] ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable': enable,
      'maxAge': maxAge,
      'maxCount': maxCount,
    };
  }
}
