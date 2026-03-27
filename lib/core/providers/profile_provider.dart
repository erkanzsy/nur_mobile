import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProfileType { child, adult }

final profileProvider = StateProvider<ProfileType>(
  (ref) => ProfileType.child,
);
