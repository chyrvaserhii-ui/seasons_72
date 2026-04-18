# Покрокова інструкція запуску

Ця інструкція описує повний шлях від «щойно відкрив проект на чистому комп'ютері» до «бачу застосунок на симуляторі/пристрої».

Орієнтовний час першого запуску: **30–60 хвилин** (більшість займе завантаження Flutter SDK, Xcode/Android Studio і перший `pub get`).

---

## 0. Що ти маєш наприкінці

- Застосунок «72 сезони» запущено в iOS Simulator (macOS) **та** Android Emulator
- Видно екран «Зараз» з поточним мікро-сезоном і progress-баром
- Можна переходити між сезонами і міняти мову в налаштуваннях

---

## 1. Підготовка комп'ютера

### 1.1 Визнач свою ОС

| ОС | Що зможеш запустити |
|----|---------------------|
| **macOS** (Intel або Apple Silicon) | iOS + Android |
| **Windows 10/11** | тільки Android |
| **Linux** | тільки Android |

iOS можна білдити **лише на macOS з Xcode** — це обмеження Apple, обійти не вдасться. Для Flutter-розробки на iOS тобі потрібен Mac.

### 1.2 Перевір диск

Тобі треба ~20 GB вільного місця:
- Flutter SDK: ~3 GB
- Xcode (якщо macOS): ~12 GB
- Android Studio + SDK + один емулятор: ~6 GB

---

## 2. Встановлення Flutter SDK

### 2.1 macOS (через Homebrew — найпростіше)

Якщо Homebrew ще нема: https://brew.sh

```bash
# Встанови Flutter
brew install --cask flutter

# Перевір версію
flutter --version
# Має бути 3.27.0 або новіша
```

### 2.2 macOS / Linux (ручне встановлення)

```bash
# 1. Завантаж архів (заміни URL на актуальний з https://docs.flutter.dev/release/archive)
cd ~/Developer    # або куди завгодно
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.27.0-stable.zip

# 2. Розпакуй
unzip flutter_macos_arm64_3.27.0-stable.zip

# 3. Додай у PATH. Для zsh:
echo 'export PATH="$PATH:$HOME/Developer/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# Для bash:
echo 'export PATH="$PATH:$HOME/Developer/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# 4. Перевір
flutter --version
```

### 2.3 Windows

1. Завантаж ZIP з https://docs.flutter.dev/get-started/install/windows
2. Розпакуй у `C:\flutter` (**не** у `Program Files` — там проблеми з permissions)
3. Додай `C:\flutter\bin` у змінну середовища `PATH`:
   - Win+R → `sysdm.cpl` → вкладка `Advanced` → `Environment Variables`
   - У `User variables` → знайди `Path` → `Edit` → `New` → `C:\flutter\bin`
4. Відкрий новий PowerShell і перевір:
   ```powershell
   flutter --version
   ```

---

## 3. Встановлення інструментів платформ

### 3.1 Xcode (тільки macOS, тільки якщо збираєшся на iOS)

```bash
# Завантаж Xcode з App Store (великий, ~12 GB)
# Після встановлення:

# 1. Прийми ліцензію
sudo xcodebuild -license accept

# 2. Встанови Command Line Tools
xcode-select --install

# 3. Переконайся, що xcode-select вказує на повний Xcode (не CommandLineTools)
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 4. Встанови CocoaPods (менеджер нативних залежностей iOS)
sudo gem install cocoapods
# або якщо є проблеми з Ruby:
brew install cocoapods

# 5. Прийми ліцензії симуляторів
xcodebuild -runFirstLaunch
```

### 3.2 Android Studio (будь-яка ОС)

1. Завантаж з https://developer.android.com/studio
2. Встанови → запусти → SDK Manager встановить SDK автоматично
3. Додатково постав:
   - **SDK Platforms** → Android 14 (API 34) або новіша
   - **SDK Tools** → `Android SDK Command-line Tools (latest)`, `Android SDK Build-Tools`, `Android SDK Platform-Tools`, `Android Emulator`
4. Створи емулятор:
   - `Tools` → `Device Manager` → `Create Virtual Device` → обери Pixel 7 → Android 14 → `Finish`

5. Прийми Android-ліцензії з терміналу:
   ```bash
   flutter doctor --android-licenses
   # натисни y на всі
   ```

### 3.3 IDE (рекомендовано VS Code)

**VS Code** (найлегший варіант):
1. Завантаж з https://code.visualstudio.com
2. Відкрий Extensions (Cmd/Ctrl+Shift+X):
   - `Flutter` (Dart Code)
   - `Dart` (Dart Code) — поставиться автоматично як залежність

**або Android Studio** — відкрий, встанови плагін `Flutter` через `Preferences → Plugins`.

---

## 4. Перевірка встановлення

```bash
flutter doctor -v
```

Очікуваний вивід:
```
[✓] Flutter (Channel stable, 3.27.x ...)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS      (тільки на Mac)
[✓] Chrome - develop for the web            (опціонально)
[✓] Android Studio
[✓] VS Code
[✓] Connected device
[✓] Network resources
```

Якщо поряд з будь-яким рядком стоїть ✗ або ! — йди по підказці flutter doctor, вона зазвичай точна.

---

## 5. Підготовка проекту

### 5.1 Отримай файли проекту

Проект знаходиться у теці `72 seasons` з цієї сесії. Скопіюй її у зручне місце, наприклад:

```bash
# macOS/Linux
cp -R "72 seasons" ~/Developer/seasons_72
cd ~/Developer/seasons_72

# Windows (PowerShell)
Copy-Item -Recurse "72 seasons" C:\Dev\seasons_72
cd C:\Dev\seasons_72
```

Переконайся, що бачиш структуру:
```
seasons_72/
├── pubspec.yaml
├── lib/
├── assets/
├── test/
└── l10n.yaml
```

### 5.2 Згенеруй нативні теки iOS і Android

У проекті спеціально немає `ios/` та `android/` тек — вони генеруються одною командою:

```bash
flutter create --platforms=ios,android --org com.seasons72 --project-name seasons_72 .
```

Після цього з'являться теки `ios/` і `android/` (їх **не треба** видаляти).

### 5.3 Завантаж Noto Serif JP (шрифт для kanji)

**Варіант А — рекомендований, з Google Fonts GitHub:**

```bash
mkdir -p assets/fonts
curl -L -o assets/fonts/NotoSerifJP-Regular.ttf \
  "https://github.com/google/fonts/raw/main/ofl/notoserifjp/NotoSerifJP%5Bwght%5D.ttf"
# Bold ваги у variable-шрифті вже є — просто копія:
cp assets/fonts/NotoSerifJP-Regular.ttf assets/fonts/NotoSerifJP-Bold.ttf
```

**Варіант Б — без шрифту:**

Видали з `pubspec.yaml` блок `fonts:` (рядки 40–44) — система відрендерить kanji дефолтним Japanese-шрифтом ОС. На macOS і iOS це «Hiragino Sans», на Android — «Noto Sans CJK», на Windows — «Yu Gothic». Виглядатиме нормально.

### 5.4 Встанови залежності

```bash
flutter pub get
```

Має завантажити ~15 пакетів. Якщо бачиш помилку `Because seasons_72 depends on ... version solving failed` — закинь мені вивід, розберемо.

### 5.5 Згенеруй локалізації з ARB-файлів

```bash
flutter gen-l10n
```

Ця команда читає `lib/l10n/app_en.arb` і `app_uk.arb` та генерує `lib/l10n/app_localizations.dart` (і `app_localizations_en.dart`, `app_localizations_uk.dart`).

Результат: у Dart з'явиться клас `AppLocalizations` з усіма ключами як методи.

### 5.6 Запусти статичний аналіз

```bash
flutter analyze
```

Очікуваний вивід: `No issues found!`

Якщо є попередження — закинь лог сюди, поправлю.

### 5.7 Запусти unit-тести

```bash
flutter test
```

Має пройти 8 тестів у `test/season_calculator_test.dart`. Якщо якийсь впав — найімовірніше справа у тому, що реальна поточна дата на твоєму комп'ютері попадає у сезон, відмінний від того, на який тест розрахований. Поглянь на вивід.

---

## 6. Запуск застосунку

### 6.1 Перелік доступних пристроїв

```bash
flutter devices
```

Має показати щось на кшталт:
```
Found 3 connected devices:
  iPhone 16 (mobile)             • ...  • ios       • com.apple.CoreSimulator.SimRuntime.iOS-18-0
  Pixel 7 (mobile)               • ...  • android   • android-arm64
  macOS (desktop)                • macos • darwin-arm64
```

### 6.2 iOS Simulator (macOS)

```bash
# Відкрий симулятор (якщо він не запущений)
open -a Simulator

# Почекай поки завантажиться iPhone, потім:
flutter run -d iphone
# або вкажи точно яким девайсом:
flutter run -d "iPhone 16"
```

Перший запуск на iOS займе 5–10 хвилин (Pod install + білд). Наступні запуски — ~30 сек.

Hot reload під час роботи: натискай `r` у терміналі щоб миттєво перебілдити зміни. `R` — hot restart з нуля.

### 6.3 Android Emulator

```bash
# Переконайся що емулятор запущений — або стартуй з Android Studio:
# Device Manager → натисни ▶️ на Pixel 7

# Або з CLI:
flutter emulators
flutter emulators --launch Pixel_7_API_34

# Потім:
flutter run -d emulator
```

### 6.4 Фізичний iPhone (macOS, потрібен Apple ID)

1. Під'єднай iPhone USB-кабелем, довір комп'ютеру на девайсі.
2. Відкрий `ios/Runner.xcworkspace` у Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
3. У Xcode: `Runner` → таб `Signing & Capabilities`:
   - Постав галочку `Automatically manage signing`
   - Team: обери свій Apple ID (можна безкоштовний, просто додай у Xcode → Settings → Accounts)
   - Bundle Identifier: зміни на щось унікальне, напр. `com.yourname.seasons72`
4. Закрий Xcode, повернися у термінал:
   ```bash
   flutter run
   ```
5. На iPhone при першому запуску: `Settings → General → VPN & Device Management → Developer App → Trust`.

### 6.5 Фізичний Android

1. На девайсі: `Settings → About phone` → тапни 7 разів по `Build number` → активується Developer options.
2. `Settings → Developer options` → увімкни `USB debugging`.
3. Під'єднай кабель, прийми запит на дозвіл з комп'ютера.
4. ```bash
   flutter devices   # переконайся що телефон у списку
   flutter run
   ```

### 6.6 Release-білд для тестування продуктивності

Debug-білд у 5–10 разів повільніший за production. Щоб побачити реальну швидкість:

```bash
flutter run --release
```

Для чистих білдів-артефактів (для App Store / Play Store):

```bash
# Android APK
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk

# Android App Bundle (для Play Store)
flutter build appbundle --release

# iOS (потрібен розробницький сертифікат)
flutter build ios --release
```

---

## 7. Типові проблеми і як лікувати

### 7.1 `flutter pub get` каже "Could not find package"

Скоріше за все кеш Dart пошкоджений:
```bash
flutter clean
rm -rf ~/.pub-cache/hosted
flutter pub get
```

### 7.2 `CocoaPods could not find compatible versions` на iOS

```bash
cd ios
rm -rf Pods Podfile.lock
pod repo update
pod install
cd ..
flutter run
```

Якщо не допомогло:
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### 7.3 `Xcode build done` і все — нічого не запускається

У терміналі у директорії проекту:
```bash
flutter clean
flutter pub get
flutter run
```

### 7.4 Android: `Gradle build failed`

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

Якщо бачиш «Execution failed for task ':app:compileDebugKotlin'» через Kotlin-версію — онови `android/build.gradle`:
```gradle
ext.kotlin_version = '1.9.25'
```

### 7.5 `AppLocalizations is not defined`

Забув згенерувати локалізації:
```bash
flutter gen-l10n
```

Якщо вже генерував, але клас не підтягнувся — перезапусти IDE або виконай:
```bash
flutter clean
flutter pub get
flutter gen-l10n
```

### 7.6 Шрифт NotoSerifJP не знайдено

Якщо не завантажував шрифт (п. 5.3 Варіант Б) — видали з `pubspec.yaml` блок:
```yaml
fonts:
  - family: NotoSerifJP
    fonts:
      - asset: assets/fonts/NotoSerifJP-Regular.ttf
      - asset: assets/fonts/NotoSerifJP-Bold.ttf
        weight: 700
```

А у `lib/core/theme/app_theme.dart` прибери рядок `fontFamily: 'NotoSerifJP',` з обох `ThemeData`.

### 7.7 iOS Simulator показує лише білий екран

Найчастіше — hot reload не відловив помилку асета. Зроби hot restart (`R` у терміналі) або:
```bash
flutter clean
flutter run
```

### 7.8 "Provider not found" (Riverpod)

Це значить, що я десь забув огорнути `MaterialApp` у `ProviderScope`. Перевір `lib/main.dart` — там має бути:
```dart
runApp(const ProviderScope(child: SeasonsApp()));
```
Якщо є — запости сюди точний stack trace.

### 7.9 Bundle Identifier зайнятий (iOS)

Apple не дає двом різним розробникам використовувати один і той самий bundle ID. У Xcode зміни `com.seasons72` на щось унікальне, напр. `com.chyrva.seasons72`.

### 7.10 Після `flutter create` з'явилися зайві файли

Команда могла згенерувати `lib/main.dart` з дефолтним counter-застосунком і переписати мій. Перевір `lib/main.dart` — він має імпортувати `app.dart` і викликати `SeasonsRepository.instance.load()`.

Якщо таки переписався — ось оригінал (14 рядків):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/data/seasons_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SeasonsRepository.instance.load();
  runApp(const ProviderScope(child: SeasonsApp()));
}
```

**Щоб уникнути цього:** краще запусти `flutter create` з опцією, що вона НЕ перезаписує:
```bash
flutter create --platforms=ios,android --org com.seasons72 --project-name seasons_72 --no-overwrite .
```

---

## 8. Наступні кроки

Коли все працює:

1. **Поміняй мову** у Settings → перевір, що українська перемикає всі назви сезонів і описи
2. **Переглянь усі 72** у табі «Усі 72» — має бути плавна прокрутка, жодних лагів
3. **Відкрий деталі сезону** → перевір навігацію «Попередній/Наступний», включно із wrap-around (72→1)
4. **Переключи в темну тему** — перевір контраст, kanji мають бути читабельні

Далі — Phase 2 (див. `BRAINSTORM.md`):
- Home Screen Widget (твоя обрана wow-feature)
- Локальні нотифікації
- Real ukiyo-e illustrations

Коли готовий братися за Phase 2 — дай знати, я розпишу архітектуру і почнемо з widget-а.

---

## Джерела

- [Flutter install docs](https://docs.flutter.dev/get-started/install)
- [Flutter doctor troubleshooting](https://docs.flutter.dev/install/troubleshoot)
- [CocoaPods guide](https://guides.cocoapods.org/using/getting-started.html)
