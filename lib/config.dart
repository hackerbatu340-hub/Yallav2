class Config {
  /// Agora.io dashboard'dan aldığın App ID (ZORUNLU)
  static const String agoraAppId = 'BURAYA_AGORA_APP_ID';

  /// Token (App Certificate kapalıysa boş bırak, açıkken token server gerekir)
  static const String agoraToken = '';

  /// Firebase Realtime Database URL (Firebase Console > Realtime Database)
  static const String firebaseDbUrl = 'https://PROJEN-default-rtdb.firebaseio.com';

  /// Firebase proje bilgileri (Console > Project Settings)
  static const String firebaseApiKey = 'API_KEY';
  static const String firebaseAppId = 'APP_ID';
  static const String firebaseSenderId = 'SENDER_ID';
  static const String firebaseProjectId = 'PROJECT_ID';
}
