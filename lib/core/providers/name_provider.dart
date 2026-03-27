import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/prefs_service.dart';

final nameProvider = StateProvider<String>((ref) => PrefsService.userName);
