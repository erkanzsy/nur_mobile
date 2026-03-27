import 'package:go_router/go_router.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'features/child/presentation/badges_screen.dart';
import 'features/child/presentation/child_shell.dart';
import 'features/child/presentation/home_screen.dart';
import 'features/duas/presentation/dua_learn_screen.dart';
import 'features/duas/presentation/dua_list_screen.dart';
import 'features/hadith/presentation/hadith_learn_screen.dart';
import 'features/hadith/presentation/hadith_list_screen.dart';
import 'features/hareke/presentation/hareke_learn_screen.dart';
import 'features/parent/presentation/parent_dashboard_screen.dart';
import 'features/paywall/presentation/paywall_screen.dart';
import 'features/quiz/presentation/quiz_screen.dart';
import 'features/stories/presentation/story_list_screen.dart';
import 'features/surahs/presentation/surah_learn_screen.dart';
import 'features/surahs/presentation/surah_list_screen.dart';

final router = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/parent/dashboard',
      builder: (context, state) => const ParentDashboardScreen(),
    ),
    GoRoute(
      path: '/paywall',
      builder: (context, state) => const PaywallScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ChildShell(child: child),
      routes: [
        GoRoute(
          path: '/child/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/child/surahs',
          builder: (context, state) => const SurahListScreen(),
        ),
        GoRoute(
          path: '/child/surahs/:id',
          builder: (context, state) => SurahLearnScreen(
            surahId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/child/quiz/:surahId',
          builder: (context, state) => QuizScreen(
            surahId: state.pathParameters['surahId']!,
          ),
        ),
        GoRoute(
          path: '/child/duas',
          builder: (context, state) => const DuaListScreen(),
        ),
        GoRoute(
          path: '/child/duas/:id',
          builder: (context, state) => DuaLearnScreen(
            duaId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/child/stories',
          builder: (context, state) => const StoryListScreen(),
        ),
        GoRoute(
          path: '/child/badges',
          builder: (context, state) => const BadgesScreen(),
        ),
        GoRoute(
          path: '/child/hareke',
          builder: (context, state) => const HarekeLearnScreen(),
        ),
        GoRoute(
          path: '/child/hadith',
          builder: (context, state) => const HadithListScreen(),
        ),
        GoRoute(
          path: '/child/hadith/:id',
          builder: (context, state) => HadithLearnScreen(
            hadithId: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
  ],
);
