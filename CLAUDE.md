# Nûr Mobile — CLAUDE.md
## Repo: nur-mobile | Flutter + Dart
## Mod: TASARIM ODAKLI — data mock, Supabase + Adapty altyapısı kurulu ama bağlanmıyor

---

## Proje Özeti

**Nûr**, 4–12 yaş arası çocuklara yönelik, ebeveyn kontrollü bir Kuran öğrenme uygulamasıdır.

- **Bu repo:** Mobile uygulama (Flutter, Dart, GoRouter)
- **Backend repo:** `nur-backend` — Cloudflare Workers + Hono (ayrı repo)
- **Veritabanı:** Supabase (PostgreSQL + Auth)
- **Abonelik:** Adapty

**Şu anki aşama:** Tasarım ve UI odaklı.
- Supabase ve Adapty paketleri kurulu ve `main.dart`'ta initialize ediliyor
- Ama tüm ekranlar mock data kullanıyor — gerçek veri çekme yok
- Auth guard yok — uygulama direkt home ekranına açılıyor
- Servisler stub olarak tanımlanmış, gerçek API çağrısı yok

Sonraki aşamada stub servisler gerçek implementasyonla değiştirilecek.

---

## Kurulum

```bash
git clone git@github.com:yourname/nur-mobile.git
cd nur-mobile
flutter pub get
cp .env.example .env
flutter run
```

### Flutter Versiyonu
```
Flutter: 3.22+
Dart: 3.4+
```

### Ortam Değişkenleri (`.env`)
```bash
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
ADAPTY_PUBLIC_KEY=public_live_xxxx
API_URL=https://api.nur-app.com
```
> `.env` şu an yükleniyor ama değerler kullanılmıyor — mock modunda.

---

## Tech Stack

| Paket | Kullanım |
|---|---|
| `go_router` | Navigasyon |
| `supabase_flutter` | Auth + DB — şimdi init edilir, mock modda |
| `adapty_flutter` | Abonelik — şimdi init edilir, mock modda |
| `just_audio` | Ses — mock URL ile |
| `audio_session` | Ses oturumu |
| `flutter_riverpod` | State management |
| `riverpod_annotation` | Provider code gen |
| `hive_flutter` | Local cache |
| `dio` | HTTP client — şimdi kullanılmıyor |
| `flutter_animate` | Animasyonlar |
| `flutter_dotenv` | .env okuma |
| `freezed` | Immutable modeller |
| `json_serializable` | JSON serialize |
| `flutter_local_notifications` | Push bildirim |
| `cached_network_image` | Resim cache |

---

## Klasör Yapısı

```
nur-mobile/
├── CLAUDE.md
├── pubspec.yaml
├── .env
├── lib/
│   ├── main.dart                      ← init: Supabase + Adapty + Hive + dotenv
│   ├── app.dart                       ← MaterialApp + ProviderScope + GoRouter
│   ├── router.dart                    ← GoRouter — şimdi direkt /child/home
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart        ← Renk sistemi
│   │   │   ├── app_text_styles.dart   ← Yazı stilleri
│   │   │   ├── app_spacing.dart       ← Boşluk sabitleri
│   │   │   ├── content_data.dart      ← Sure/dua/kıssa meta verileri
│   │   │   ├── badges_data.dart       ← Rozet tanımları
│   │   │   └── freemium.dart          ← Ücretsiz içerik listesi
│   │   ├── services/
│   │   │   ├── supabase_service.dart  ← STUB — şimdi mock döndürür
│   │   │   ├── adapty_service.dart    ← STUB — isPremium: false döndürür
│   │   │   ├── audio_service.dart     ← just_audio wrapper
│   │   │   └── api_service.dart       ← STUB — şimdi kullanılmıyor
│   │   └── utils/
│   │       ├── arabic_utils.dart
│   │       └── spaced_repetition.dart
│   │
│   ├── mocks/                         ← TÜM MOCK DATA BURAYA
│   │   ├── mock_child.dart
│   │   ├── mock_surahs.dart
│   │   ├── mock_duas.dart
│   │   ├── mock_stories.dart
│   │   ├── mock_progress.dart
│   │   ├── mock_badges.dart
│   │   └── mock_parent.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── presentation/
│   │   │   │   ├── welcome_screen.dart
│   │   │   │   ├── sign_in_screen.dart
│   │   │   │   └── sign_up_screen.dart
│   │   │   └── providers/
│   │   │       └── auth_provider.dart  ← STUB — isLoggedIn: true
│   │   │
│   │   ├── child/
│   │   │   ├── presentation/
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── badges_screen.dart
│   │   │   └── providers/
│   │   │       ├── child_provider.dart  ← mockChild döndürür
│   │   │       └── streak_provider.dart ← mock streak
│   │   │
│   │   ├── surahs/
│   │   │   ├── data/models/
│   │   │   │   ├── surah.dart          ← @freezed
│   │   │   │   └── ayah.dart           ← @freezed
│   │   │   ├── presentation/
│   │   │   │   ├── surah_list_screen.dart
│   │   │   │   └── surah_learn_screen.dart
│   │   │   └── providers/
│   │   │       └── surah_provider.dart  ← mockSurahs döndürür
│   │   │
│   │   ├── duas/
│   │   │   ├── data/models/
│   │   │   │   └── dua.dart            ← @freezed
│   │   │   ├── presentation/
│   │   │   │   ├── dua_list_screen.dart
│   │   │   │   └── dua_learn_screen.dart
│   │   │   └── providers/
│   │   │       └── dua_provider.dart    ← mockDuas döndürür
│   │   │
│   │   ├── stories/
│   │   │   ├── data/models/
│   │   │   │   └── story.dart          ← @freezed
│   │   │   ├── presentation/
│   │   │   │   ├── story_list_screen.dart
│   │   │   │   └── story_screen.dart
│   │   │   └── providers/
│   │   │       └── story_provider.dart  ← mockStories döndürür
│   │   │
│   │   ├── quiz/
│   │   │   ├── data/models/
│   │   │   │   └── quiz_question.dart  ← @freezed
│   │   │   ├── presentation/
│   │   │   │   └── quiz_screen.dart
│   │   │   └── providers/
│   │   │       └── quiz_provider.dart
│   │   │
│   │   ├── parent/
│   │   │   ├── presentation/
│   │   │   │   ├── parent_dashboard_screen.dart
│   │   │   │   └── parent_settings_screen.dart
│   │   │   └── providers/
│   │   │       └── parent_provider.dart  ← mockParent döndürür
│   │   │
│   │   └── paywall/
│   │       └── presentation/
│   │           └── paywall_screen.dart   ← Adapty UI — mock modda görsel
│   │
│   └── shared/
│       └── widgets/
│           ├── arabic_text.dart          ← RTL Arapça — ham Text kullanma
│           ├── audio_player_widget.dart  ← Mock ses oynatıcı
│           ├── streak_counter.dart
│           ├── star_rating.dart
│           ├── badge_card.dart
│           ├── nur_button.dart
│           ├── nur_card.dart
│           ├── progress_bar.dart
│           ├── locked_content_sheet.dart ← "Pro'ya özel" bottom sheet
│           └── weekly_bar_chart.dart
│
└── assets/
    ├── content/
    │   ├── surahs/
    │   │   ├── al_fatiha.json
    │   │   ├── al_ikhlas.json
    │   │   └── ...
    │   ├── duas/
    │   └── stories/
    └── fonts/
```

---

## `main.dart` Yapısı

```dart
// Sırayla init edilir — hepsi try/catch içinde
// Hata olursa mock modda çalışmaya devam et

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env yükle
  await dotenv.load(fileName: '.env');

  // Hive (local cache)
  await Hive.initFlutter();

  // Supabase — init edilir ama şimdi kullanılmıyor
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? 'https://placeholder.supabase.co',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'placeholder',
  );

  // Adapty — init edilir ama şimdi kullanılmıyor
  await Adapty().activate(
    configuration: AdaptyConfiguration(
      apiKey: dotenv.env['ADAPTY_PUBLIC_KEY'] ?? 'placeholder',
    )..withLogLevel(AdaptyLogLevel.error),
  );

  runApp(const ProviderScope(child: NurApp()));
}
```

---

## GoRouter — Şu Anki Yönlendirme

```dart
// router.dart — tasarım aşamasında auth yok
// Uygulama direkt /child/home'a açılır

final router = GoRouter(
  initialLocation: '/child/home',
  routes: [
    ShellRoute(                          // Tab bar
      builder: (context, state, child) => ChildShell(child: child),
      routes: [
        GoRoute(path: '/child/home', builder: ...),
        GoRoute(path: '/child/surahs', builder: ...),
        GoRoute(path: '/child/surahs/:id', builder: ...),
        GoRoute(path: '/child/duas', builder: ...),
        GoRoute(path: '/child/duas/:id', builder: ...),
        GoRoute(path: '/child/stories', builder: ...),
        GoRoute(path: '/child/stories/:id', builder: ...),
        GoRoute(path: '/child/quiz/:surahId', builder: ...),
        GoRoute(path: '/child/badges', builder: ...),
      ],
    ),
    GoRoute(path: '/parent/dashboard', builder: ...),
    GoRoute(path: '/parent/settings', builder: ...),
    GoRoute(path: '/paywall', builder: ...),
    GoRoute(path: '/welcome', builder: ...),
  ],
);

// Sonraki aşamada redirect eklenecek:
// session yoksa → /welcome
// çocuk seçilmemişse → /parent/dashboard
```

---

## Mock Data

### `mocks/mock_child.dart`
```dart
final mockChild = {
  'id': 'child-1',
  'name': 'Yusuf',
  'age': 7,
  'avatar': '⭐',
  'streakDays': 7,
  'totalStars': 14,
  'todayMinutes': 12,
  'dailyGoalMinutes': 20,
  'todayAyahsCompleted': 3,
  'todayAyahsGoal': 5,
};
```

### `mocks/mock_surahs.dart`
```dart
final mockSurahs = [
  {
    'id': 'al-fatiha',
    'nameAr': 'الفاتحة',
    'nameTr': 'Fâtiha Sûresi',
    'ayahCount': 7,
    'isUnlocked': true,
    'progress': 1.0,
    'starsEarned': 3,
    'ayahs': [
      {
        'number': 1,
        'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        'transliteration': 'Bismillahirrahmanirrahim',
        'turkish': 'Rahman ve Rahim olan Allah\'ın adıyla.',
        'audioUrl': null,
      },
      {
        'number': 2,
        'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        'transliteration': 'Elhamdülillahi rabbil alemin',
        'turkish': 'Hamd, âlemlerin Rabbi Allah\'a mahsustur.',
        'audioUrl': null,
      },
      {
        'number': 3,
        'arabic': 'الرَّحْمَٰنِ الرَّحِيمِ',
        'transliteration': 'Errahmanirrahim',
        'turkish': 'O Rahman\'dır, Rahim\'dir.',
        'audioUrl': null,
      },
      {
        'number': 4,
        'arabic': 'مَالِكِ يَوْمِ الدِّينِ',
        'transliteration': 'Maliki yevmiddin',
        'turkish': 'Din gününün sahibidir.',
        'audioUrl': null,
      },
      {
        'number': 5,
        'arabic': 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        'transliteration': 'İyyake na\'budu ve iyyake nesta\'in',
        'turkish': 'Yalnız sana ibadet eder, yalnız senden yardım dileriz.',
        'audioUrl': null,
      },
      {
        'number': 6,
        'arabic': 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        'transliteration': 'İhdinas sıratal mustekim',
        'turkish': 'Bizi doğru yola ilet.',
        'audioUrl': null,
      },
      {
        'number': 7,
        'arabic': 'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ',
        'transliteration': 'Sıratallezine en\'amte aleyhim',
        'turkish': 'Nimet verdiklerinin yoluna.',
        'audioUrl': null,
      },
    ],
  },
  {
    'id': 'al-ikhlas',
    'nameAr': 'الإخلاص',
    'nameTr': 'İhlâs Sûresi',
    'ayahCount': 4,
    'isUnlocked': true,
    'progress': 0.5,
    'starsEarned': 2,
    'ayahs': [
      {
        'number': 1,
        'arabic': 'قُلْ هُوَ اللَّهُ أَحَدٌ',
        'transliteration': 'Kul huvallahu ehad',
        'turkish': 'De ki: O Allah birdir.',
        'audioUrl': null,
      },
      {
        'number': 2,
        'arabic': 'اللَّهُ الصَّمَدُ',
        'transliteration': 'Allahus samed',
        'turkish': 'Allah Samed\'dir (her şey ona muhtaçtır).',
        'audioUrl': null,
      },
      {
        'number': 3,
        'arabic': 'لَمْ يَلِدْ وَلَمْ يُولَدْ',
        'transliteration': 'Lem yelid ve lem yuled',
        'turkish': 'O doğurmamış ve doğurulmamıştır.',
        'audioUrl': null,
      },
      {
        'number': 4,
        'arabic': 'وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        'transliteration': 'Ve lem yekun lehu kufuven ehad',
        'turkish': 'Hiçbir şey ona denk ve benzer değildir.',
        'audioUrl': null,
      },
    ],
  },
  {
    'id': 'al-falaq',
    'nameAr': 'الفلق',
    'nameTr': 'Felak Sûresi',
    'ayahCount': 5,
    'isUnlocked': false,
    'progress': 0.0,
    'starsEarned': 0,
    'ayahs': [],
  },
  {
    'id': 'an-nas',
    'nameAr': 'الناس',
    'nameTr': 'Nâs Sûresi',
    'ayahCount': 6,
    'isUnlocked': false,
    'progress': 0.0,
    'starsEarned': 0,
    'ayahs': [],
  },
  {
    'id': 'al-kawthar',
    'nameAr': 'الكوثر',
    'nameTr': 'Kevser Sûresi',
    'ayahCount': 3,
    'isUnlocked': false,
    'progress': 0.0,
    'starsEarned': 0,
    'ayahs': [],
  },
];
```

### `mocks/mock_duas.dart`
```dart
final mockDuas = [
  {
    'id': 'bismillah',
    'nameTr': 'Bismillah',
    'category': 'daily',
    'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    'transliteration': 'Bismillahirrahmanirrahim',
    'turkish': 'Rahman ve Rahim olan Allah\'ın adıyla.',
    'isLearned': true,
    'isUnlocked': true,
  },
  {
    'id': 'morning',
    'nameTr': 'Sabah Duası',
    'category': 'morning',
    'arabic': 'اَللّٰهُمَّ بِكَ اَصْبَحْنَا',
    'transliteration': 'Allahumme bike asbahna',
    'turkish': 'Allah\'ım! Senin adınla sabahladık.',
    'isLearned': true,
    'isUnlocked': true,
  },
  {
    'id': 'before-eat',
    'nameTr': 'Yemek Öncesi Dua',
    'category': 'daily',
    'arabic': 'بِسْمِ اللَّهِ وَعَلَى بَرَكَةِ اللَّهِ',
    'transliteration': 'Bismillahi ve ala bereketillah',
    'turkish': 'Allah\'ın adıyla ve Allah\'ın bereketi ile.',
    'isLearned': false,
    'isUnlocked': true,
  },
  {
    'id': 'after-eat',
    'nameTr': 'Yemek Sonrası Dua',
    'category': 'daily',
    'arabic': 'الحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا',
    'transliteration': 'Elhamdülillahillezi et\'amena',
    'turkish': 'Bizi doyuran Allah\'a hamdolsun.',
    'isLearned': false,
    'isUnlocked': true,
  },
  {
    'id': 'before-sleep',
    'nameTr': 'Uyku Duası',
    'category': 'sleep',
    'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    'transliteration': 'Bismikallahümme emutü ve ahya',
    'turkish': 'Senin adınla ölür ve dirilim.',
    'isLearned': false,
    'isUnlocked': false,
  },
  // Diğer dualar isUnlocked: false
];
```

### `mocks/mock_stories.dart`
```dart
final mockStories = [
  {
    'id': 'prophet-yusuf',
    'nameTr': 'Hz. Yusuf\'un Kıssası',
    'description': 'Sabır ve tevekkülün güzel örneği',
    'emoji': '🌾',
    'isUnlocked': false,
    'isCompleted': false,
    'starsEarned': 0,
    'pages': [
      {
        'pageNumber': 1,
        'text': 'Çok uzun zaman önce, Kenan diyarında Hz. Yakup adında mübarek bir peygamber yaşardı. On iki oğlu vardı ve içlerinde en çok Hz. Yusuf\'u severdi...',
        'audioUrl': null,
      },
    ],
    'quiz': [
      {
        'question': 'Hz. Yusuf\'un babası kimdir?',
        'options': ['Hz. İbrahim', 'Hz. Yakup', 'Hz. İshak', 'Hz. Musa'],
        'correctIndex': 1,
      },
      {
        'question': 'Hz. Yusuf hangi diyarda yaşadı?',
        'options': ['Mısır', 'Kenan', 'Medine', 'Babil'],
        'correctIndex': 1,
      },
      {
        'question': 'Hz. Yusuf\'un kaç kardeşi vardı?',
        'options': ['10', '11', '12', '9'],
        'correctIndex': 1,
      },
    ],
  },
  {
    'id': 'prophet-yunus',
    'nameTr': 'Hz. Yunus\'un Kıssası',
    'description': 'Tövbe ve Allah\'ın rahmeti',
    'emoji': '🐳',
    'isUnlocked': false,
    'isCompleted': false,
    'starsEarned': 0,
    'pages': [],
    'quiz': [],
  },
  {
    'id': 'ashab-al-kahf',
    'nameTr': 'Ashab-ı Kehf',
    'description': 'İman ve cesaretin hikayesi',
    'emoji': '🕌',
    'isUnlocked': false,
    'isCompleted': false,
    'starsEarned': 0,
    'pages': [],
    'quiz': [],
  },
];
```

### `mocks/mock_progress.dart`
```dart
final mockProgress = {
  'weeklyMinutes': [8, 15, 12, 20, 18, 10, 12],
  'surahsCompleted': 2,
  'surahsTotal': 5,
  'duasLearned': 4,
  'duasTotal': 10,
  'storiesCompleted': 0,
  'storiesTotal': 3,
  'totalStars': 14,
};
```

### `mocks/mock_badges.dart`
```dart
final mockBadges = [
  {'id': 'first_surah',  'nameTr': 'İlk Sure',      'icon': '🌟', 'earned': true,  'earnedDate': '2024-01-10'},
  {'id': 'five_duas',    'nameTr': 'Dua Ustası',    'icon': '🤲', 'earned': false},
  {'id': 'streak_3',     'nameTr': '3 Gün Serisi',  'icon': '🔥', 'earned': true,  'earnedDate': '2024-01-12'},
  {'id': 'streak_7',     'nameTr': '7 Gün Serisi',  'icon': '💪', 'earned': true,  'earnedDate': '2024-01-15'},
  {'id': 'streak_30',    'nameTr': '30 Gün',         'icon': '🏆', 'earned': false},
  {'id': 'first_story',  'nameTr': 'İlk Kıssa',      'icon': '📚', 'earned': false},
  {'id': 'quiz_3stars',  'nameTr': '3 Yıldız',       'icon': '⭐', 'earned': false},
  {'id': 'all_surahs',   'nameTr': 'Hafız Yolunda',  'icon': '📖', 'earned': false},
  {'id': 'all_duas',     'nameTr': 'Dua Hafızı',     'icon': '💎', 'earned': false},
  {'id': 'all_stories',  'nameTr': 'Kıssa Bilgesi',  'icon': '🌙', 'earned': false},
];
```

### `mocks/mock_parent.dart`
```dart
final mockParent = {
  'child': {
    'name': 'Yusuf',
    'age': 7,
    'avatar': '⭐',
    'streakDays': 7,
  },
  'thisWeek': {
    'totalMinutes': 95,
    'dailyMinutes': [8, 15, 12, 20, 18, 10, 12],
    'surahsStudied': ['al-fatiha', 'al-ikhlas'],
    'duasLearned': 2,
  },
  'settings': {
    'dailyLimitMinutes': 30,
    'language': 'tr',
    'notificationsEnabled': true,
    'reminderTime': '18:00',
    'pinEnabled': false,
  },
};
```

---

## Stub Servisler

### `core/services/supabase_service.dart`
```dart
// STUB — mock modda. Sonraki aşamada gerçek Supabase sorguları eklenecek.
class SupabaseService {
  // Auth
  Future<bool> isLoggedIn() async => true;   // mock: her zaman giriş yapılmış
  Future<void> signOut() async {}

  // Children
  Future<List<Map<String, dynamic>>> getChildren() async => [];

  // Progress
  Future<void> syncProgress(Map<String, dynamic> progress) async {}
}
```

### `core/services/adapty_service.dart`
```dart
// STUB — mock modda. Sonraki aşamada gerçek Adapty çağrıları.
class AdaptyService {
  Future<bool> isPremium() async => false;   // mock: free kullanıcı
  Future<bool> purchase(String productId) async => false;
  Future<bool> restore() async => false;

  // Placement ID'leri (sonradan kullanılacak):
  // 'content_lock'      → kilitli içerik
  // 'parent_feature'    → ebeveyn raporu
  // 'streak_motivation' → 3. gün streak
}
```

### `core/services/audio_service.dart`
```dart
// just_audio kullanır ama audioUrl null olunca mock davranış gösterir
class AudioService {
  static final instance = AudioService._internal();
  AudioService._internal();

  final _player = AudioPlayer();
  bool _isMockPlaying = false;

  Future<void> play(String? audioUrl) async {
    if (audioUrl == null) {
      // Mock: 3 saniye sonra tamamlanmış gibi davran
      _isMockPlaying = true;
      await Future.delayed(const Duration(seconds: 3));
      _isMockPlaying = false;
      return;
    }
    await _player.setUrl(audioUrl);
    await _player.play();
  }

  Future<void> pause() async => _player.pause();
  Future<void> stop() async => _player.stop();
  bool get isMockPlaying => _isMockPlaying;
  Stream<PlayerState> get stateStream => _player.playerStateStream;
}
```

---

## Renk Sistemi (`core/constants/app_colors.dart`)

```dart
class AppColors {
  static const primary      = Color(0xFF1D9E75);
  static const primaryLight = Color(0xFF5DCAA5);
  static const primaryBg    = Color(0xFFE1F5EE);
  static const primaryDark  = Color(0xFF0F6E56);
  static const quiz         = Color(0xFF534AB7);
  static const quizLight    = Color(0xFFAFA9EC);
  static const quizBg       = Color(0xFFEEEDFE);
  static const reward       = Color(0xFFBA7517);
  static const rewardBg     = Color(0xFFFAEEDA);
  static const parent       = Color(0xFF2C2C2A);
  static const surface      = Color(0xFFF1EFE8);
  static const border       = Color(0xFFD3D1C7);
  static const textPrimary  = Color(0xFF2C2C2A);
  static const textMuted    = Color(0xFF888780);
  static const white        = Color(0xFFFFFFFF);
  static const coral        = Color(0xFFD85A30);
  static const coralBg      = Color(0xFFFAECE7);
}
// KURAL: Color(0xFF...) hardcode yazma — AppColors sabitlerini kullan
```

---

## Arapça Metin (`shared/widgets/arabic_text.dart`)

```dart
// Ham Text() KULLANMA — her zaman ArabicText widget'ını kullan
class ArabicText extends StatelessWidget {
  const ArabicText(this.text, {super.key, this.fontSize = 26.0});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.rtl,   // zorunlu
      textAlign: TextAlign.right,          // zorunlu
      style: TextStyle(
        fontSize: fontSize,
        height: 1.8,     // hareke için kritik — 1.7 minimum
        // height < 1.7 → şedde/fetha üst satırla çakışır
      ),
    );
  }
}
```

---

## Ekran Referansları

### Ana Ekran (`features/child/presentation/home_screen.dart`)
- Header: `AppColors.primary` arka plan, "Merhaba Yusuf ✨", 🔥 7 gün streak
- Streak altında günlük hedef progress bar (3/5 ayet)
- "Devam Et" büyük kartı: devam eden sure, % ilerleme
- 2×2 grid: Sureler, Dualar, Quiz, Kıssalar
- Yatay scroll: kazanılan rozetler

### Sure Öğrenme (`features/surahs/presentation/surah_learn_screen.dart`)
- Büyük Arapça metin kutusu (`AppColors.surface` arka plan)
- Transliterasyon: teal italik
- Türkçe anlam: normal
- Dinle + Tekrar Et butonları
- Alt progress dots: ● ● ○ ○
- "Quiz'e geç" banner (`AppColors.quizBg`, mor)

### Quiz (`features/quiz/presentation/quiz_screen.dart`)
- Mor header, soru numarası, progress bar
- Büyük Arapça metin
- 4 seçenek: seçilmeden gri, doğru → yeşil, yanlış → kırmızı
- 1–3 yıldız göstergesi

### Ebeveyn Dashboard (`features/parent/presentation/parent_dashboard_screen.dart`)
- Koyu header (`AppColors.parent`)
- Teal çocuk profil kartı
- 4'lü istatistik grid
- Haftalık bar chart (7 gün)
- Ayarlar: toggle satırları

### Kilitli İçerik (`shared/widgets/locked_content_sheet.dart`)
- Bottom sheet modal
- Kilit ikonu + "Bu içerik Pro'ya özel"
- Özellikler listesi
- "Pro'ya Geç" butonu → `/paywall` route'una git
- Şimdi paywall sadece görsel — gerçek satın alma sonraki aşama

---

## Freemium (`core/constants/freemium.dart`)

```dart
const freeSurahs   = ['al-fatiha', 'al-ikhlas'];
const freeDuaCount = 3;
const freeStories  = <String>[];   // tamamen pro
```

---

## Riverpod Provider Kuralları

```dart
// ConsumerWidget veya ConsumerStatefulWidget kullan
// StatefulWidget + setState sadece lokal UI state için (animasyon, quiz seçimi)
// Tüm data → provider'dan gelir (mock döndürür)

// Örnek:
@riverpod
List<Map<String, dynamic>> surahs(SurahsRef ref) {
  return mockSurahs;   // mock modda
  // Sonraki aşamada: return await ref.watch(supabaseServiceProvider).getSurahs();
}
```

---

## Animasyon Kuralları

```dart
// flutter_animate kullan
// Önemli animasyonlar:
// - Rozet kazanınca: scale + bounce
// - Quiz cevap: 300ms renk geçişi
// - Doğru cevap: HapticFeedback.heavyImpact()
// - Yanlış cevap: HapticFeedback.vibrate()
// - Rozet: HapticFeedback.heavyImpact()
// - Tab geçişi: fade in
```

---

## Yasaklı Pratikler (Bu Aşamada)

```
❌ Gerçek Supabase sorgusu   → stub servisler kullan
❌ Gerçek Adapty satın alma  → stub döndürür false
❌ HTTP isteği (Dio)         → mock data kullan
❌ Auth redirect             → direkt /child/home
❌ Loading spinner (data)    → mock anında gelir
❌ Color(0xFF...) hardcode   → AppColors kullan
❌ Ham Text() Arapça         → ArabicText widget kullan
❌ print() production        → debugPrint() + kDebugMode
❌ dynamic tip               → @freezed modeller kullan
❌ StatefulWidget data için  → Riverpod kullan
❌ Reklam                    → asla
```

---

## Komutlar

```bash
flutter pub get                       # bağımlılık yükle
flutter run                           # debug
flutter run --release                 # release
dart run build_runner build           # kod üretimi (freezed, riverpod)
dart run build_runner watch           # izle
flutter analyze                       # statik analiz
flutter test                          # testler
flutter build ios                     # iOS build
```

---

## Geliştirme Sırası

```
1. core/constants/ — renkler, tipler, boşluklar
2. mocks/ — tüm mock datalar
3. shared/widgets/ — ArabicText, NurButton, NurCard, ProgressBar
4. features/child/home_screen.dart
5. features/surahs/ — liste + öğrenme ekranı
6. shared/widgets/audio_player_widget.dart (mock davranış)
7. features/quiz/quiz_screen.dart
8. features/duas/ — liste + detay
9. features/stories/ — liste + detay
10. features/child/badges_screen.dart + gamification widget'ları
11. features/parent/ — dashboard + settings
12. shared/widgets/locked_content_sheet.dart + paywall_screen
13. welcome_screen.dart (onboarding — sadece görsel)
14. Animasyonlar ve polish
```

---

## MVP Tasarım Kriterleri

- [ ] Ana ekran: streak, günlük hedef, modül kartları, rozetler
- [ ] Sure listesi: kilitli / açık durumlar, progress
- [ ] Sure öğrenme: Arapça metin, kontroller, progress dots
- [ ] Quiz: 4 seçenek, doğru/yanlış animasyonu, yıldız sistemi
- [ ] Dua listesi ve dua detay ekranı
- [ ] Kıssa listesi (Pro kilitli görseli)
- [ ] Rozetler ekranı: kazanılan ve kilitliler
- [ ] Ebeveyn dashboard: chart + 4 istatistik + ayarlar
- [ ] Kilitli içerik bottom sheet
- [ ] Tab bar navigasyonu
- [ ] Arapça metinler RTL doğru görünüyor
- [ ] `flutter build ios` başarılı
