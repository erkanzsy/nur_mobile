import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  PrefsService._();
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Onboarding
  static bool get onboardingDone =>
      _prefs.getBool('onboardingDone') ?? false;

  static Future<void> completeOnboarding({
    required String name,
    required String profileType, // 'child' | 'adult'
  }) async {
    await _prefs.setBool('onboardingDone', true);
    await _prefs.setString('userName', name);
    await _prefs.setString('profileType', profileType);
  }

  // Okuma
  static String get userName => _prefs.getString('userName') ?? '';
  static String get profileType =>
      _prefs.getString('profileType') ?? 'child';
}
