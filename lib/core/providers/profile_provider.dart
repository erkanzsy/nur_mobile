import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/prefs_service.dart';

enum ProfileType { child, adult }

final profileProvider = StateProvider<ProfileType>((ref) {
  return PrefsService.profileType == 'adult'
      ? ProfileType.adult
      : ProfileType.child;
});
