# Передача проекту в Claude Code локально

Цей документ — інструкція, як запустити проект через **Claude Code** на твоєму Mac, щоб він сам виконав усі команди (`flutter create`, `pub get`, `analyze`, `test`, `run`) і сам виправляв помилки якщо знайде.

---

## Крок 1. Встанови Claude Code (якщо ще нема)

```bash
# Потребує Node.js ≥ 18. Якщо немає:
brew install node

# Встанови Claude Code
npm install -g @anthropic-ai/claude-code

# Перевір
claude --version
```

Перший запуск попросить залогінитись — відкриється браузер, авторизуйся своїм Claude-акаунтом.

---

## Крок 2. Перенеси проект у зручне місце

Скопіюй теку `72 seasons` з Cowork-сесії у свою dev-папку:

```bash
cp -R ~/Documents/Claude/Cowork/*72\ seasons* ~/Developer/seasons_72
# АБО перетягни з Cowork-UI у ~/Developer/seasons_72
cd ~/Developer/seasons_72
```

Переконайся, що всередині є `pubspec.yaml`, `lib/`, `assets/`, `test/`.

---

## Крок 3. Встанови Flutter (якщо ще нема)

```bash
brew install --cask flutter
flutter doctor -v
```

Якщо `flutter doctor` скаржиться на Xcode/Android Studio/CocoaPods — див. GETTING_STARTED.md розділ 3.

---

## Крок 4. Запусти Claude Code у теці проекту

```bash
cd ~/Developer/seasons_72
claude
```

Відкриється інтерактивна сесія.

---

## Крок 5. Вставиш цей промпт — Claude Code все зробить сам

Скопіюй текст нижче повністю і вставиш у Claude Code:

````
Я щойно переніс Flutter-проект з Cowork і хочу щоб ти довів його до робочого стану.

Проект — застосунок «72 японські мікро-сезони» (Flutter 3.27+, Riverpod, i18n
EN+UK). Екрани, дані (assets/data/seasons.json з усіма 72 kō), тести,
локалізації, тема — все вже створено. Треба:

1. Виконай у такому порядку:
   a) flutter create --platforms=ios,android --org com.seasons72 \
        --project-name seasons_72 --no-overwrite .
   b) mkdir -p assets/fonts && curl -L -o assets/fonts/NotoSerifJP-Regular.ttf \
        "https://github.com/google/fonts/raw/main/ofl/notoserifjp/NotoSerifJP%5Bwght%5D.ttf" \
        && cp assets/fonts/NotoSerifJP-Regular.ttf assets/fonts/NotoSerifJP-Bold.ttf
   c) flutter pub get
   d) flutter gen-l10n
   e) flutter analyze
   f) flutter test

2. Якщо flutter analyze знайде помилки — поправ їх у коді. Найімовірніші
   місця проблем:
   - `dynamic kō` у lib/features/home/home_screen.dart (_NextCard) і
     lib/features/detail/season_detail_screen.dart (_NavTile) — можливо
     потрібно імпортувати MicroSeason і вказати типи явно, якщо аналізатор
     сваритиметься на implicit dynamic.
   - .withValues(alpha: ...) — потребує Flutter ≥ 3.27. Якщо у тебе старіший
     Flutter, заміни на .withOpacity() у lib/core/theme/app_theme.dart,
     lib/features/shared/widgets/season_hero.dart,
     lib/features/list/seasons_list_screen.dart,
     lib/features/detail/season_detail_screen.dart.
   - Можливі дрібниці з неймінгом згенерованих AppLocalizations методів —
     перевір l10n.yaml та lib/l10n/*.arb.

3. Якщо flutter test впаде — швидше за все один з дат-тестів попадає на
   реальну дату «сьогодні», а не на фіксовану. Переглянь
   test/season_calculator_test.dart — можна поправити тест щоб використовував
   фіксовану DateTime з секцій setUp, а не DateTime.now().

4. Після того, як `flutter analyze` і `flutter test` пройшли чисто,
   спробуй запустити:
     flutter devices
   І якщо є iOS Simulator чи Android Emulator — запусти:
     flutter run -d <device_id>

5. Коли застосунок відкрився — скажи мені, що ти бачиш на екрані
   (поточний мікро-сезон, мова, чи є помилки в консолі).

Документи з контекстом:
- README.md — структура проекту
- BRAINSTORM.md — обґрунтування архітектурних рішень
- GETTING_STARTED.md — детальна довідка з troubleshooting

Працюй автономно, питай мене тільки якщо треба ухвалити архітектурне
рішення (напр. чи додавати нову залежність).
````

---

## Крок 6. Що очікувати

Claude Code в реальному часі виконає всі команди, покаже тобі вивід, поправить помилки, і коли все пройде — запустить застосунок. Типовий сценарій займає 10–20 хвилин на першому проході (основний час — завантаження Xcode-артефактів і pod install).

Якщо під час аналізу знайдуться помилки — він їх бачитиме, пояснюватиме і правитиме. Ти можеш просто відслідковувати процес.

---

## Якщо Claude Code недоступний

Тоді просто йди по `GETTING_STARTED.md` вручну. Там ті самі команди, але без AI-виконавця.

Головне — запусти:
```bash
flutter pub get
flutter gen-l10n
flutter analyze
```

Якщо `flutter analyze` каже "No issues found!" — код чистий, можна `flutter run`. Якщо ні — скопіюй вивід, я виправлю у цій сесії.

---

## Підказка: один-рядковий bootstrap

Якщо не хочеш використовувати Claude Code взагалі, ось bash-скрипт який зробить усі кроки 1-6 з GETTING_STARTED.md послідовно:

```bash
set -e
cd ~/Developer/seasons_72
flutter create --platforms=ios,android --org com.seasons72 --project-name seasons_72 --no-overwrite .
mkdir -p assets/fonts
curl -L -o assets/fonts/NotoSerifJP-Regular.ttf \
  "https://github.com/google/fonts/raw/main/ofl/notoserifjp/NotoSerifJP%5Bwght%5D.ttf"
cp assets/fonts/NotoSerifJP-Regular.ttf assets/fonts/NotoSerifJP-Bold.ttf
flutter pub get
flutter gen-l10n
echo "=== ANALYZE ==="
flutter analyze || true
echo "=== TEST ==="
flutter test || true
echo ""
echo "✅ Bootstrap done. Next: flutter devices && flutter run"
```

Збережи його як `bootstrap.sh` у корені проекту, `chmod +x bootstrap.sh`, і запусти `./bootstrap.sh`. Вивід `analyze` і `test` збережи — якщо є помилки, кидай мені.
