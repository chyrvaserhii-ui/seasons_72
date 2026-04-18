# iOS Home Screen Widget — налаштування

Весь Swift-код уже готовий у теці `ios/SeasonsWidget/`. Залишилось у Xcode:
1. Створити Widget Extension target
2. Увімкнути App Group capability на обох targets (app + widget)
3. Додати готові .swift файли в extension target
4. Зібрати і побачити widget

Орієнтовний час: **5–10 хвилин**.

---

## 0. Підготовка

У терміналі:

```bash
cd ~/Documents/Claude/Projects/seasons_72
flutter pub get
open ios/Runner.xcworkspace
```

Відкриється Xcode з твоїм проектом.

---

## 1. Створити Widget Extension target

1. У Xcode → меню `File` → `New` → `Target…`
2. У вікні з шаблонами:
   - Платформа: **iOS**
   - Знайди **Widget Extension** (секція "Application Extension")
   - `Next`
3. Налаштування:
   - **Product Name**: `SeasonsWidget`
   - **Team**: твій Apple ID
   - **Bundle Identifier**: автоматично стане `com.seasons72.seasons72.SeasonsWidget` (або подібне — на основі твого основного bundle id)
   - **Language**: Swift
   - **Include Configuration App Intent**: **зніми галочку** (нам це не потрібно)
   - `Finish`
4. Xcode запитає: *"Activate SeasonsWidget scheme?"* → натисни **Activate**

У лівій панелі з'являться нові файли: `SeasonsWidget.swift`, `SeasonsWidgetBundle.swift`, `Info.plist` і папка для target. **Вони нам не потрібні — замінимо нашими**.

---

## 2. Замінити згенеровані файли нашими

1. Закрий Xcode (важливо, щоб не було конфліктів файлової системи)
2. У терміналі:
   ```bash
   cd ~/Documents/Claude/Projects/seasons_72/ios/SeasonsWidget_generated 2>/dev/null || \
   cd ~/Documents/Claude/Projects/seasons_72/ios
   ls
   ```
   Має бути тека `SeasonsWidget/` (та, що створив Xcode). Xcode поклав туди 3 файли (`SeasonsWidget.swift`, `SeasonsWidgetBundle.swift`, `Info.plist`).

3. Наші готові файли вже лежать у `ios/SeasonsWidget/` (я створив раніше). Перевір:
   ```bash
   ls -la ios/SeasonsWidget/
   ```
   Має бути:
   ```
   SeasonsWidget.swift              # наш, з повним UI (Small/Medium/Large)
   SeasonsWidgetBundle.swift        # наш, entry point
   Info.plist                       # наш
   SeasonsWidget.entitlements       # наш, з App Group
   AssetCatalog.xcassets/           # Xcode створив, не чіпай
   ```

4. Якщо Xcode перезаписав мої файли своїми — відкочуй:
   ```bash
   git status ios/SeasonsWidget/
   # якщо є diff — відкоти мої файли:
   git checkout ios/SeasonsWidget/SeasonsWidget.swift \
                ios/SeasonsWidget/SeasonsWidgetBundle.swift \
                ios/SeasonsWidget/Info.plist
   ```
   (якщо git ще не ініціалізований — див. внизу п.7 скачай ще раз)

5. Знову відкрий Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

---

## 3. App Group capability

**На Runner target (основному app):**

1. Обери `Runner` у навігаторі проекту (синя іконка вгорі)
2. Вкладка `Signing & Capabilities`
3. Натисни `+ Capability` → знайди `App Groups` → двічі клац
4. У списку груп натисни `+` → введи:
   ```
   group.com.seasons72.shared
   ```
5. Постав галочку

**На SeasonsWidget target:**

1. Обери `SeasonsWidget` у списку targets (перемикач target зверху або в проекті)
2. Та ж вкладка `Signing & Capabilities`
3. `+ Capability` → `App Groups`
4. Галочка навпроти `group.com.seasons72.shared` (група вже має бути в списку)

Якщо Xcode скаже *"Couldn't communicate with a helper application"* або помилку підпису — переконайся що:
- `Team` обраний у вкладці `Signing` на обох targets
- `Automatically manage signing` увімкнено

---

## 4. Вставити entitlements

1. У `Runner` target → `Build Settings` → пошук `Code Signing Entitlements`
2. Переконайся, що шлях веде до `Runner/Runner.entitlements` (Xcode зазвичай сам це зробив після додавання App Groups)

Для `SeasonsWidget` target:
1. `Build Settings` → `Code Signing Entitlements`
2. Встав шлях: `SeasonsWidget/SeasonsWidget.entitlements`

Якщо Xcode створив власний `.entitlements` файл замість нашого — можеш його видалити і налаштувати щоб використовувався наш. Або скопіювати вміст нашого у згенерований:

```xml
<key>com.apple.security.application-groups</key>
<array>
  <string>group.com.seasons72.shared</string>
</array>
```

---

## 5. Додати Swift файли до target (якщо Xcode їх не підхопив)

1. У навігаторі натисни на `SeasonsWidget.swift` (у нашій теці)
2. Правий клік → `Show File Inspector` (або Cmd+Option+1)
3. У секції `Target Membership` постав галочку на `SeasonsWidget`
4. Те саме для `SeasonsWidgetBundle.swift`

Файл `SeasonsWidget.swift` — це ЄДИНИЙ великий файл з усім UI (не плутай з `SeasonsWidgetBundle.swift` — це дуже короткий entry point).

---

## 6. Зібрати і запустити widget

1. Вгорі Xcode: поряд з назвою проекту обери **target SeasonsWidget** зі списку
2. Обери симулятор (iPhone 14 Pro Max) або фізичний девайс
3. `Cmd+R` — Run
4. Після старту — Xcode симулятор відкриється з вибраним device
5. На hoam screen симулятора: довгий тап на пустому місці → `+` у верхньому лівому куті → знайди `72 сезони` → обери розмір (Medium рекомендую) → `Add Widget`

Повернись на home screen — побачиш widget з поточним kō.

---

## 7. Якщо щось не працює

**Widget показує placeholder (Перша веселка)** — Flutter ще не записав дані. Запусти основний app хоч один раз (`Cmd+R` на target `Runner`), він запише дані у shared UserDefaults при старті.

**Widget показує порожній прямокутник** — не читає з App Group. Перевір:
- Обидва targets мають App Group capability
- Назва групи однакова: `group.com.seasons72.shared`
- У Flutter-коді `WidgetService.appGroupId` збігається

**"Cannot find 'SeasonEntry' in scope"** — не всі Swift-файли у target. Додай `SeasonsWidget.swift` до target membership (п. 5).

**Widget не оновлюється при зміні сезону** — iOS обмежує оновлення виджетів. Наш код переоновлює кожну годину через TimelineProvider. Плюс Flutter пушить оновлення при старті app і при зміні locale.

---

## 8. Як додати на фізичний iPhone

1. Під'єднай iPhone, дозволь довіру
2. Xcode target → ОБИДВА targets (Runner, SeasonsWidget) → `Signing` → обери свій Team
3. Bundle ID повинен бути унікальним: змінити `com.seasons72` на щось типу `com.chyrva.seasons72`
4. Run

---

## Структура Swift-коду

`SeasonsWidget.swift` містить:
- `SeasonEntry` — модель даних
- `SeasonProvider` — timeline provider, читає UserDefaults
- `SmallView` / `MediumView` / `LargeView` — три розміри
- `SeasonsWidget` — декларація widget з 3 підтримуваними розмірами
- Helpers: hex-парсинг кольору, правильна українська множина

`SeasonsWidgetBundle.swift` — entry point (@main), тонкий wrapper.

## Preview

Можеш дивитися widget прямо у Xcode canvas:
- Відкрий `SeasonsWidget.swift`
- Внизу: `Canvas` (або `Cmd+Option+Return`)
- Побачиш 3 варіанти одразу (Small/Medium/Large) з placeholder-даними

---

## Що буде далі

Якщо базовий widget запрацює — можемо:
- **Додати зображення** (гравюру) у Medium/Large через shared file container
- **Лок-скрін widget** (iOS 16+, maps до `.accessoryRectangular` family)
- **Deep link** на тап — відкривати конкретний kō у app

Коли все працює — скинь скрін widget'а на home screen з симулятора.
