/// Chinese tea pairings — one variety per Japanese micro-season (kō).
///
/// Each kō is matched to a Chinese tea whose harvest season, character, or
/// imagery resonates with the moment: pre-Qingming Long Jing for the first
/// cherry blossoms, "White Peony" 白牡丹 for the peonies of late spring,
/// aged shu pu-erh for the deepest winter cold. Thirteen classical
/// categories are represented, each with a fixed set of named subVarieties.
///
/// Double quotes are intentional: Ukrainian text contains apostrophes
/// ("ластів'ї", "п'янить", ...) which would need escaping in single quotes.
// ignore_for_file: prefer_single_quotes, constant_identifier_names
library;

enum TeaType {
  greenTea,
  whiteTea,
  yellowTea,
  redTea,
  northFujianOolong,
  southFujianOolong,
  guangdongOolong,
  taiwaneseLightOolong,
  taiwaneseDarkOolong,
  shengPuerh,
  shuPuerh,
  heicha,
  liubao,
}

class TeaPairing {
  const TeaPairing({
    required this.chinese,
    required this.pinyin,
    required this.nameUk,
    required this.nameEn,
    required this.type,
    required this.subVariety,
    required this.noteUk,
    required this.noteEn,
  });

  /// Chinese characters, traditional or simplified, e.g. "龙井".
  final String chinese;

  /// Pinyin with tone marks, e.g. "Lóng Jǐng".
  final String pinyin;

  /// Ukrainian transliteration with translation in parentheses.
  final String nameUk;

  /// English transliteration with translation in parentheses.
  final String nameEn;

  /// Tea category — one of the thirteen classical Chinese types we use.
  final TeaType type;

  /// Named subVariety within the category — must match the allowed list
  /// for the category (Ukrainian transliteration, e.g. "Лун Цзін").
  final String subVariety;

  /// One-sentence Ukrainian note linking the tea to this kō.
  final String noteUk;

  /// One-sentence English note linking the tea to this kō.
  final String noteEn;
}

/// Detailed information about a specific Chinese tea subvariety.
///
/// Used by the about / detail screens to display general info, an optional
/// origin legend, and practical brewing instructions for each named
/// subVariety listed in the [TeaPairing] catalogue. All fields are plain
/// text; UI hides the legend section when [legendUk] / [legendEn] are empty.
class TeaVariety {
  const TeaVariety({
    required this.infoUk,
    required this.infoEn,
    required this.legendUk,
    required this.legendEn,
    required this.brewingUk,
    required this.brewingEn,
  });

  /// General info in Ukrainian: terroir, processing, character, notable facts.
  final String infoUk;

  /// General info in English.
  final String infoEn;

  /// Origin story or legend in Ukrainian. Empty string when no famous legend.
  final String legendUk;

  /// Origin story or legend in English. Empty string when no famous legend.
  final String legendEn;

  /// Brewing instructions in Ukrainian: temperature, vessel, ratio, timing.
  final String brewingUk;

  /// Brewing instructions in English.
  final String brewingEn;
}

/// Map keyed by kō index (1..72).
const Map<int, TeaPairing> teaPairings = {
  // ─── Spring ────────────────────────────────────────────────────────────
  1: TeaPairing(
    chinese: "易武",
    pinyin: "Yī Wǔ",
    nameUk: "І У (Шен пуер з гори І У)",
    nameEn: "Yi Wu (Sheng Pu-erh from Yi Wu Mountain)",
    type: TeaType.shengPuerh,
    subVariety: "І У",
    noteUk: "Перші, ще трохи терпкі бруньки року з древніх дерев І У — як східний вітер, що пробуджує сік у замерзлих гілках.",
    noteEn: "Year's-first buds from Yi Wu's ancient tea trees — a tea that thaws the palate the way the east wind thaws the river.",
  ),
  2: TeaPairing(
    chinese: "碧螺春",
    pinyin: "Bì Luó Chūn",
    nameUk: "Бі Ло Чунь (Смарагдові весняні спіралі)",
    nameEn: "Bi Luo Chun (Green Snail Spring)",
    type: TeaType.greenTea,
    subVariety: "Бі Ло Чунь",
    noteUk: "Найперший передцинмінський збір з Дунтін — яскраво-зелені скручені листочки дзвенять у склянці, як уґуїсу, що вперше заспівав у горах.",
    noteEn: "The earliest pre-Qingming Dongting pluck — vivid green spirals chime in the glass like a warbler greeting the first song of the mountain spring.",
  ),
  3: TeaPairing(
    chinese: "君山银针",
    pinyin: "Jūnshān Yínzhēn",
    nameUk: "Цзюньшань Іньчжень (Срібні голки з гори Цзюнь)",
    nameEn: "Junshan Yinzhen (Silver Needles from Junshan Island)",
    type: TeaType.yellowTea,
    subVariety: "Цзюньшань Іньчжень",
    noteUk: "Жовті бруньки в склянці тричі здіймаються й опускаються — наче риба, що вперше за зиму торкається дзеркала води.",
    noteEn: "Brewed in a tall glass, the buds rise and sink three times — fish breaking the thinning ice, then slipping under again.",
  ),
  4: TeaPairing(
    chinese: "白牡丹",
    pinyin: "Bái Mǔdān",
    nameUk: "Бай Му Дань (Біла півонія)",
    nameEn: "Bai Mu Dan (White Peony)",
    type: TeaType.whiteTea,
    subVariety: "Бай Му Дань",
    noteUk: "Лист і брунька, в'ялені у весняній прохолоді — м'яка, мов дощова крапля, біла півонія, що зволожує сонне поле саме в потрібну мить.",
    noteEn: "Leaf and bud withered through cool spring days — a soft rain-tender white peony moistening the drowsy earth at exactly its waking hour.",
  ),
  5: TeaPairing(
    chinese: "黄山毛峰",
    pinyin: "Huángshān Máofēng",
    nameUk: "Хуаншань Мао Фен (Ворсистий пік з Жовтих гір)",
    nameEn: "Huangshan Mao Feng (Fur-Tip Peak of Yellow Mountain)",
    type: TeaType.greenTea,
    subVariety: "Хуаншань Мао Фен",
    noteUk: "Знаменитий аньхойський зелений з гір, які самі рідко виходять із туману — кожна ворсиста брунька несе цю серпанкову ноту.",
    noteEn: "Picked on the same Anhui peaks where the fog famously never lifts; the downy buds carry that veiled-mountain perfume directly into the cup.",
  ),
  6: TeaPairing(
    chinese: "白毫银针",
    pinyin: "Báiháo Yínzhēn",
    nameUk: "Бай Хао Інь Чжень (Срібні голки з білими ворсинками)",
    nameEn: "Bai Hao Yin Zhen (Silver Needle)",
    type: TeaType.whiteTea,
    subVariety: "Бай Хао Інь Чжень",
    noteUk: "Найперший збір року — самі лише вкриті пухом бруньки, що випрямляються в склянці, як паростки, які щойно пробили теплу землю.",
    noteEn: "The year's very first pluck — silver-down buds straightening in the bowl exactly the way young shoots straighten as they pierce the warming soil.",
  ),
  7: TeaPairing(
    chinese: "景迈古树生普",
    pinyin: "Jǐngmài Gǔshù Shēng Pǔ",
    nameUk: "Цзінмай (Шен з древніх дерев Цзінмаю)",
    nameEn: "Jingmai (Sheng from Jingmai's ancient trees)",
    type: TeaType.shengPuerh,
    subVariety: "Цзінмай",
    noteUk: "Шен пуер з древніх коренів Цзінмаю — орхідейна нота, що теплішає в чашці так само, як комахи прокидаються в зігрітому ґрунті.",
    noteEn: "Sheng pu-erh drawn from Jingmai's ancient roots — an orchid warmth rising in the cup the way insects stir awake in the sun-thawed soil.",
  ),
  8: TeaPairing(
    chinese: "太平猴魁",
    pinyin: "Tàipíng Hóukuí",
    nameUk: "Тай Пін Хоу Куй (Мавпячий ватажок з Тайпіну)",
    nameEn: "Tai Ping Hou Kui (Monkey King of Taiping)",
    type: TeaType.greenTea,
    subVariety: "Тай Пін Хоу Куй",
    noteUk: "Пласкі листки нагадують пелюстки персика, прокатані між пальцями: легкий орхідейний аромат і прохолодна солодкість.",
    noteEn: "The long flat leaves echo a peach petal between the fingers; the brew is cool, faintly orchid-sweet, almost edible.",
  ),
  9: TeaPairing(
    chinese: "霍山黄芽",
    pinyin: "Huòshān Huángyá",
    nameUk: "Хошань Хуан Я (Жовті бруньки з гори Хо)",
    nameEn: "Huo Shan Huang Ya (Yellow Buds of Mount Huo)",
    type: TeaType.yellowTea,
    subVariety: "Хошань Хуан Я",
    noteUk: "Повільне «мень-хуан», коли лист томиться загорнутим у власне тепло, — точна копія гусениці, що в коконі стає метеликом.",
    noteEn: "The slow men-huang smothering, where leaves ripen wrapped in their own warmth, mirrors the caterpillar dissolving inside its chrysalis into wings.",
  ),
  10: TeaPairing(
    chinese: "太平猴魁",
    pinyin: "Tàipíng Hóukuí",
    nameUk: "Тай Пін Хоу Куй (Мавпячий ватажок з Тайпіну)",
    nameEn: "Tai Ping Hou Kui (Monkey King of Taiping)",
    type: TeaType.greenTea,
    subVariety: "Тай Пін Хоу Куй",
    noteUk: "Витягнуті пласкі листочки нагадують горобцевий язичок — дві крихітні брунечки в обіймах першого листка, як гніздо двох-і-одного.",
    noteEn: "The long flat leaves echo a sparrow's tongue itself — two tiny buds wrapped by one opening leaf, a household of three in miniature.",
  ),
  11: TeaPairing(
    chinese: "龙井",
    pinyin: "Lóngjǐng",
    nameUk: "Лун Цзін (Колодязь дракона)",
    nameEn: "Long Jing (Dragon Well)",
    type: TeaType.greenTea,
    subVariety: "Лун Цзін",
    noteUk: "Імператорський чай Сіху, зібраний саме перед Цинмін — момент, який китайці шанують так само, як японці перший цвіт сакури.",
    noteEn: "The imperial tea of West Lake, picked just before Qingming — a date the Chinese honour the way Japan honours the first cherry blossom.",
  ),
  12: TeaPairing(
    chinese: "霍山黄芽",
    pinyin: "Huòshān Huángyá",
    nameUk: "Хошань Хуан Я (Жовті бруньки з гори Хо)",
    nameEn: "Huo Shan Huang Ya (Yellow Buds of Mount Huo)",
    type: TeaType.yellowTea,
    subVariety: "Хошань Хуан Я",
    noteUk: "Жовтий чай із гір, де грім котиться долинами, — повільне «смаження жовтим» додає чашці глибокого, грозового тону.",
    noteEn: "From the mountains where thunder rolls along the valleys; the slow yellow-smothering process gives the cup a deep, storm-warmed register.",
  ),
  13: TeaPairing(
    chinese: "凤凰宋种",
    pinyin: "Fènghuáng Sòng Zhǒng",
    nameUk: "Феньхуан Сон Чжун (Фенікс, кущ династії Сон)",
    nameEn: "Phoenix Song Zhong (Song-Dynasty Mother Bush)",
    type: TeaType.guangdongOolong,
    subVariety: "Сон Чжун",
    noteUk: "Найдавніша лінія Феньхуан Дань Цун — фенікс, що повертається з півдня щовесни, як ластівка до старого даху.",
    noteEn: "The oldest lineage of Phoenix Dan Cong: a phoenix that returns from the south each spring, the way swallows return to the eaves.",
  ),
  14: TeaPairing(
    chinese: "金骏眉",
    pinyin: "Jīn Jùn Méi",
    nameUk: "Цзінь Цзюнь Мей (Золота брова жвавого коня)",
    nameEn: "Jin Jun Mei (Golden Steed Eyebrow)",
    type: TeaType.redTea,
    subVariety: "Цзінь Цзюнь Мей",
    noteUk: "Дрібні золоті брунечки, скручені, як летюча зграя гусей, що тягнеться на північ узимку, що тільки-но скінчилася.",
    noteEn: "Tiny golden buds curl like a flock of geese drawn against the sky, heading north as the warm month closes.",
  ),
  15: TeaPairing(
    chinese: "金萱",
    pinyin: "Jīn Xuān",
    nameUk: "Цзінь Сюань (Тайванський «молочний» улун)",
    nameEn: "Jin Xuan (Milk Oolong)",
    type: TeaType.taiwaneseLightOolong,
    subVariety: "Цзінь Сюань",
    noteUk: "Ніжно-вершкова нота тайванського сорту #12 і світла квіткова веселка над чашкою — сонце, дощ і молоко в одному настої.",
    noteEn: "The famous TRES #12 cultivar — a creamy, floral rainbow that hangs over the cup the way sun, rain and bloom briefly hang together in one sky.",
  ),
  16: TeaPairing(
    chinese: "碧螺春",
    pinyin: "Bì Luó Chūn",
    nameUk: "Бі Ло Чунь (Смарагдові весняні спіралі)",
    nameEn: "Bi Luo Chun (Green Snail Spring)",
    type: TeaType.greenTea,
    subVariety: "Бі Ло Чунь",
    noteUk: "Скручені спіральки з Дунтін розкручуються в склянці тонко й прямо, як перші очеретинки, що тягнуться зі стоячої води.",
    noteEn: "The Dongting spirals unfurl thin and straight, like the first reeds rising from still water along the lake's edge.",
  ),
  17: TeaPairing(
    chinese: "龙井",
    pinyin: "Lóngjǐng",
    nameUk: "Лун Цзін (Колодязь дракона)",
    nameEn: "Long Jing (Dragon Well)",
    type: TeaType.greenTea,
    subVariety: "Лун Цзін",
    noteUk: "Сіхуські пласкі листочки стоять у склянці, як рисові паростки на затопленій гряді після останнього інію.",
    noteEn: "West-Lake's flat leaves stand in the glass like rice seedlings in a flooded paddy after the last frost has gone.",
  ),
  18: TeaPairing(
    chinese: "白牡丹",
    pinyin: "Bái Mǔdān",
    nameUk: "Бай Му Дань (Біла півонія)",
    nameEn: "Bai Mu Dan (White Peony)",
    type: TeaType.whiteTea,
    subVariety: "Бай Му Дань",
    noteUk: "Назва говорить сама за себе: лист і брунька разом, ніби розкрита півонія в чашці — м'який мед, абрикос і сіно з-під сонця.",
    noteEn: "The name says it: leaf and bud opened together, a peony in the bowl — soft honey, apricot, and sun-warmed hay.",
  ),

  // ─── Summer ────────────────────────────────────────────────────────────
  19: TeaPairing(
    chinese: "武夷水仙",
    pinyin: "Wǔyí Shuǐxiān",
    nameUk: "Уї Шуй Сянь (Уішанський Водяний Безсмертний)",
    nameEn: "Wuyi Shui Xian (Wuyi Water Sprite)",
    type: TeaType.northFujianOolong,
    subVariety: "Уї Шуй Сянь",
    noteUk: "Уішанський улун зі старих кущів — мох, мокре каміння, тиха ставкова свіжість, у якій раптом плескає жабеня.",
    noteEn: "A Wuyi oolong from venerable bushes — moss, wet stone, the still pond freshness in which a small frog suddenly leaps.",
  ),
  20: TeaPairing(
    chinese: "碧螺春",
    pinyin: "Bì Luó Chūn",
    nameUk: "Бі Ло Чунь (Смарагдові весняні спіралі)",
    nameEn: "Bi Luo Chun (Green Snail Spring)",
    type: TeaType.greenTea,
    subVariety: "Бі Ло Чунь",
    noteUk: "Пізньовесняні спіралі з Дунтін: дрібні скручені листочки пробиваються крізь воду так само, як черв'як уперше підіймається до тепла.",
    noteEn: "Late-spring Dongting spirals — the curled leaves push through the hot water the way an earthworm first nudges into the warming soil.",
  ),
  21: TeaPairing(
    chinese: "太平猴魁",
    pinyin: "Tàipíng Hóukuí",
    nameUk: "Тай Пін Хоу Куй (Мавпячий ватажок з Тайпіну)",
    nameEn: "Tai Ping Hou Kui (Monkey King of Taiping)",
    type: TeaType.greenTea,
    subVariety: "Тай Пін Хоу Куй",
    noteUk: "Стрімкі плоскі листочки — точна копія молодого бамбукового пагона, що рветься з лісової підстилки.",
    noteEn: "The spear-flat leaves are the exact silhouette of a young bamboo shoot bursting from the forest floor.",
  ),
  22: TeaPairing(
    chinese: "白毫银针",
    pinyin: "Báiháo Yínzhēn",
    nameUk: "Бай Хао Інь Чжень (Срібні голки з білими ворсинками)",
    nameEn: "Bai Hao Yin Zhen (White-Hair Silver Needle)",
    type: TeaType.whiteTea,
    subVariety: "Бай Хао Інь Чжень",
    noteUk: "Лише бруньки, вкриті сріблястим пушком, — як шовкова нитка, яку щойно випустив шовкопряд, що пробудився серед шовковиці.",
    noteEn: "Buds only, sheathed in silver down — the very thread a silkworm has just spun, having woken among the mulberry leaves.",
  ),
  23: TeaPairing(
    chinese: "宜兴红茶",
    pinyin: "Yíxīng Hóngchá",
    nameUk: "Іcін Хун Ча (Чорний з Іcіну)",
    nameEn: "Yixing Hong Cha (Yixing Red)",
    type: TeaType.redTea,
    subVariety: "Іcін Хун Ча",
    noteUk: "Глибокий малиново-багряний настій з-під фіолетової глини — сафлори червоніють, і чашка теж вбирається у той самий колір.",
    noteEn: "A deep crimson cup from the purple-clay homeland — safflowers turn red across the field, and the liquor takes on the same dye.",
  ),
  24: TeaPairing(
    chinese: "勐海熟普",
    pinyin: "Měnghǎi Shú Pǔ",
    nameUk: "Менхайський Шу (рецепт 7572)",
    nameEn: "Menghai Shu (Recipe 7572)",
    type: TeaType.shuPuerh,
    subVariety: "Менхайський 7572",
    noteUk: "Дозрілий шу пуер заводу Менхай — глибока, повна солодкість стиглого зерна, що золотиться, як пшениця, яку нарешті несуть з поля.",
    noteEn: "Menghai's well-piled shu pu-erh — a deep, full sweetness of ripened grain, golden the way wheat is golden the day the harvest finally comes home.",
  ),
  25: TeaPairing(
    chinese: "白鸡冠",
    pinyin: "Bái Jīguān",
    nameUk: "Бай Цзі Ґуань (Білий півнячий гребінь)",
    nameEn: "Bai Ji Guan (White Cockscomb)",
    type: TeaType.northFujianOolong,
    subVariety: "Бай Цзі Ґуань",
    noteUk: "Один із чотирьох уішанських «знаменитих кущів»: жовтувато-зелений лист стирчить, як гребінь щойно вилупленого богомола.",
    noteEn: "One of the four 'famous bushes' of Wuyi; the pale yellow-green leaf stands up like the crest of a freshly hatched mantis nymph.",
  ),
  26: TeaPairing(
    chinese: "祁门红茶",
    pinyin: "Qímén Hóngchá",
    nameUk: "Ці Мень Хун Ча (Цихун, чорний з Ці Мень)",
    nameEn: "Keemun (Qihong, Black Tea from Qimen)",
    type: TeaType.redTea,
    subVariety: "Ці Мень Хун Ча",
    noteUk: "Аньхойський чорний із золотим відблиском настою — ніби світлячок гойдається в повітрі і розчиняється в темряві.",
    noteEn: "An Anhui red with a golden lustre in the liquor — a firefly wavering, then drifting silently into the dusk.",
  ),
  27: TeaPairing(
    chinese: "蜜兰香单丛",
    pinyin: "Mìlán Xiāng Dāncōng",
    nameUk: "Мі Лань Сян Дань Цун (Феньхуан з ароматом медової орхідеї)",
    nameEn: "Mi Lan Xiang Dan Cong (Honey-Orchid Phoenix Oolong)",
    type: TeaType.guangdongOolong,
    subVariety: "Мі Лань Сян",
    noteUk: "Найвідоміший аромат феньхуанських улунів: дозрілий мед, кісточкові плоди, теплий жовтень — як уме, що набирає сонця у червні.",
    noteEn: "The most beloved Phoenix aroma — honeyed stone-fruit, the kind a yellowing ume plum gathers from the early-summer sun.",
  ),
  28: TeaPairing(
    chinese: "寿眉",
    pinyin: "Shòuméi",
    nameUk: "Шоу Мей (Брова довголіття)",
    nameEn: "Shou Mei (Longevity Eyebrow)",
    type: TeaType.whiteTea,
    subVariety: "Шоу Мей",
    noteUk: "Білий чай, що відлежав сім років і більше: фінікова шкірка, сухе зілля, заспокоєння трав, які вже пройшли свій пік.",
    noteEn: "White tea rested seven years or more — date skin, dry herbs, the calm of grasses that have passed their flowering and are content to wither.",
  ),
  29: TeaPairing(
    chinese: "芝兰香单丛",
    pinyin: "Zhīlán Xiāng Dāncōng",
    nameUk: "Чжи Лань Сян Дань Цун (Феньхуан з ароматом орхідеї)",
    nameEn: "Zhi Lan Xiang Dan Cong (Orchid-Fragrance Phoenix Oolong)",
    type: TeaType.guangdongOolong,
    subVariety: "Чжи Лань Сян",
    noteUk: "Тонкий орхідейно-ірисовий тон гірських улунів Феньхуан — холодна квітка над поверхнею старого ставка.",
    noteEn: "The cool orchid-iris register of Phoenix Mountain — a single flower held above the surface of an old, still pond.",
  ),
  30: TeaPairing(
    chinese: "六堡茶",
    pinyin: "Liùbǎo Chá",
    nameUk: "Молодий Лю Бао (Гуансійський хей-ча з шести фортець)",
    nameEn: "Young Liu Bao (Six-Fortresses Dark Tea, fresh)",
    type: TeaType.liubao,
    subVariety: "Молодий Лю Бао",
    noteUk: "Молодий гуансійський Лю Бао з вогкого півдня — землиста бетелева нота, що відповідає липкому повітрю середини літа.",
    noteEn: "Young Guangxi Liu Bao from the humid south — a betel-earth note that meets sticky midsummer air on its own terms.",
  ),
  31: TeaPairing(
    chinese: "冻顶乌龙",
    pinyin: "Dòngdǐng Wūlóng",
    nameUk: "Дун Дін (Улун із Замерзлої вершини)",
    nameEn: "Dong Ding (Frozen Peak Oolong)",
    type: TeaType.taiwaneseLightOolong,
    subVariety: "Дун Дін",
    noteUk: "Тайванський класичний улун — попри теплу назву, він охолоджує гарячий день: масляна солодкість і легкий смажений післясмак.",
    noteEn: "A classic Taiwanese oolong — despite its name, it cools a humid afternoon: butter, milk, and a quiet roasted edge.",
  ),
  32: TeaPairing(
    chinese: "寿眉",
    pinyin: "Shòuméi",
    nameUk: "Шоу Мей (Брова довголіття)",
    nameEn: "Shou Mei (Longevity Eyebrow)",
    type: TeaType.whiteTea,
    subVariety: "Шоу Мей",
    noteUk: "Великі пухнасті листки розкриваються в кип'ятку, як перший цвіт лотоса над водою — кругла солодкість і тиха кишенька меду.",
    noteEn: "The broad fluffy leaves unfurl in the bowl like the first lotus opening above the pond — a round sweetness with a quiet pocket of honey.",
  ),
  33: TeaPairing(
    chinese: "武夷肉桂",
    pinyin: "Wǔyí Ròuguì",
    nameUk: "Уї Жоу Ґуй (Уішанський коричник)",
    nameEn: "Wuyi Rou Gui (Wuyi Cinnamon Cliff Tea)",
    type: TeaType.northFujianOolong,
    subVariety: "Жоу Ґуй",
    noteUk: "Скельний улун з гострою корицево-смолистою нотою — той самий неспокій, з яким молодий яструб пробує вітер на крилах.",
    noteEn: "A cliff oolong with a sharp cinnamon-resin lift — the same nervy energy as a young hawk testing the wind for the first time.",
  ),
  34: TeaPairing(
    chinese: "布朗",
    pinyin: "Bùlǎng",
    nameUk: "Булан (Шен з гори Булан)",
    nameEn: "Bulang (Sheng from Bulang Mountain)",
    type: TeaType.shengPuerh,
    subVariety: "Булан",
    noteUk: "Найпотужніший з юньнаньських шенів — густа, м'ясиста гіркота, що стає солодкою, як павловнія наливає силу у своє щойно зав'язане насіння.",
    noteEn: "The most muscular of Yunnan sheng — a thick bitterness turning sweet, as paulownia gathers all its strength into the hard seeds it has just set.",
  ),
  35: TeaPairing(
    chinese: "勐海7572",
    pinyin: "Měnghǎi 7572",
    nameUk: "Менхайський 7572 (Класичний шу пуер заводу Менхай)",
    nameEn: "Menghai 7572 (Classic Menghai Factory Shu Pu-erh)",
    type: TeaType.shuPuerh,
    subVariety: "Менхайський 7572",
    noteUk: "Чорна земля після зливи, мокрий ліс, гриби — рецепт 7572, ферментований у купах, відтворює саме цей запах розпарілого ґрунту.",
    noteEn: "Black earth after rain, wet wood, mushrooms — the 7572 recipe, wet-piled in Menghai, tastes precisely like a forest floor at the height of muggy summer.",
  ),
  36: TeaPairing(
    chinese: "老班章",
    pinyin: "Lǎo Bān Zhāng",
    nameUk: "Лао Бань Чжан (Витриманий шен з гори Бань Чжан)",
    nameEn: "Lao Ban Zhang (Aged Sheng from Ban Zhang Village)",
    type: TeaType.shengPuerh,
    subVariety: "Лао Бань Чжан",
    noteUk: "Шен пуер з найзнаменитішої гори після п'ятнадцяти років — камфора, стара деревина, грозова свіжість, що накочується великими хвилями, як літня злива.",
    noteEn: "Sheng pu-erh from Yunnan's most legendary mountain, fifteen years on — camphor, old wood, a stormy freshness that rolls through the cup the way a summer downpour rolls down a hill.",
  ),

  // ─── Autumn ────────────────────────────────────────────────────────────
  37: TeaPairing(
    chinese: "浓香铁观音",
    pinyin: "Nóngxiāng Tiěguānyīn",
    nameUk: "Теґуаньїнь сильної обжарки (Осінній збір)",
    nameEn: "Heavy-Roast Tieguanyin (Autumn Pluck)",
    type: TeaType.southFujianOolong,
    subVariety: "Теґуаньїнь сильної обжарки",
    noteUk: "Осінній аньсійський улун із густою обжаркою: повітря вже прохолодне, і смажена орхідея стає глибокою, темно-карамельною.",
    noteEn: "Autumn-pluck Anxi oolong with a deep roast — the cooled air sharpens the orchid lift into something darker, caramel-warmed and bell-clear.",
  ),
  38: TeaPairing(
    chinese: "陈年六堡",
    pinyin: "Chén Nián Liùbǎo",
    nameUk: "Витриманий Лю Бао (10-річний)",
    nameEn: "Aged Liu Bao (10-year)",
    type: TeaType.liubao,
    subVariety: "Витриманий Лю Бао",
    noteUk: "Витриманий гуансійський Лю Бао — землиста, лісова глибина, в якій звучить остання вечірня цикада, перш ніж замовкнути назавжди.",
    noteEn: "Aged Guangxi Liu Bao — a forest-floor depth in which the last evening cicada lets out its final, fading voice before the night closes in.",
  ),
  39: TeaPairing(
    chinese: "滇红",
    pinyin: "Diānhóng",
    nameUk: "Дянь Хун (Юньнаньський чорний)",
    nameEn: "Dianhong (Yunnan Red)",
    type: TeaType.redTea,
    subVariety: "Дянь Хун",
    noteUk: "Юньнаньський чорний з товстих, повних золотавих бруньок — солодкий батат і темний мед, що стелиться долиною, наче вранішній туман.",
    noteEn: "From thick golden Yunnan buds — sweet potato, dark honey, a body that settles in the throat the way a heavy fog settles in a valley.",
  ),
  40: TeaPairing(
    chinese: "寿眉",
    pinyin: "Shòuméi",
    nameUk: "Шоу Мей (Брова довголіття)",
    nameEn: "Shou Mei (Longevity Eyebrow)",
    type: TeaType.whiteTea,
    subVariety: "Шоу Мей",
    noteUk: "Найповніший і найпухнастіший із білих чаїв — великий лист, як розкрита бавовняна коробочка над зрілим полем.",
    noteEn: "The fullest, fluffiest of white teas — broad leaves that look exactly like a cotton boll splitting open over a late-summer field.",
  ),
  41: TeaPairing(
    chinese: "鸭屎香单丛",
    pinyin: "Yāshǐ Xiāng Dāncōng",
    nameUk: "Я Ши Сян Дань Цун (Феньхуан із «качиним» ароматом)",
    nameEn: "Ya Shi Xiang Dan Cong (Duck-Shit Aroma Phoenix Oolong)",
    type: TeaType.guangdongOolong,
    subVariety: "Я Ши Сян",
    noteUk: "Назва жартівлива, аромат — серйозний: гарденія, мигдаль і ясне нічне небо, у яке поступово виходить місяць.",
    noteEn: "The name is a tease, the aroma is not — gardenia, almond, and the clear evening sky into which the moon slowly rises.",
  ),
  42: TeaPairing(
    chinese: "宜兴红茶",
    pinyin: "Yíxīng Hóngchá",
    nameUk: "Іcін Хун Ча (Чорний з Іcіну)",
    nameEn: "Yixing Hong Cha (Yixing Red)",
    type: TeaType.redTea,
    subVariety: "Іcін Хун Ча",
    noteUk: "Чорний з рідних місць глини для чайників — теплий, зерновий, схожий на хліб з печі під час дозрілого рисового жнива.",
    noteEn: "From the homeland of purple-clay teapots — warm, grainy, the cup smells faintly of fresh bread baked while the rice ripens outside.",
  ),
  43: TeaPairing(
    chinese: "东方美人",
    pinyin: "Dōngfāng Měirén",
    nameUk: "Дун Фан Мей Жень (Східна красуня)",
    nameEn: "Dong Fang Mei Ren (Oriental Beauty)",
    type: TeaType.taiwaneseDarkOolong,
    subVariety: "Дун Фан Мей Жень",
    noteUk: "Тайванський темний улун з листа, проколеного цикадкою, — мед, персик і м'яка прохолодна роса, що блищить на травинці.",
    noteEn: "The Taiwanese dark oolong whose leafhopper-bitten leaves give honey, peach, and the soft cool gleam of dew along a single blade of grass.",
  ),
  44: TeaPairing(
    chinese: "正山小种",
    pinyin: "Zhèngshān Xiǎozhǒng",
    nameUk: "Лапсан Сушон (Копчений з гори Тонму)",
    nameEn: "Lapsang Souchong (Smoked Tongmu Black)",
    type: TeaType.redTea,
    subVariety: "Лапсан Сушон",
    noteUk: "Перший у світі чорний чай — смолистий сосновий дим заплутується між скелями, як пісня плиски над струмком у Уішанських горах.",
    noteEn: "The original black tea — pine smoke caught between Wuyi cliffs, as a wagtail's call catches between two stones above a mountain stream.",
  ),
  45: TeaPairing(
    chinese: "宫廷熟普",
    pinyin: "Gōngtíng Shú Pǔ",
    nameUk: "Ґун Тін (Палацовий шу)",
    nameEn: "Gongting (Imperial Shu)",
    type: TeaType.shuPuerh,
    subVariety: "Гун Тін",
    noteUk: "Найвищий ґатунок шу-пуера з самих лише золотавих бруньок — царствене, оксамитове прощання, з яким ластівки залишають дах і відлітають на південь.",
    noteEn: "The top imperial grade of shu pu-erh, all golden buds — a regal, velvet farewell, the same poise with which swallows leave the eaves and turn south.",
  ),
  46: TeaPairing(
    chinese: "武夷水仙",
    pinyin: "Wǔyí Shuǐxiān",
    nameUk: "Уї Шуй Сянь (Уішанський Водяний Безсмертний)",
    nameEn: "Wuyi Shui Xian (Wuyi Water Sprite)",
    type: TeaType.northFujianOolong,
    subVariety: "Уї Шуй Сянь",
    noteUk: "Глибокий, добре просмажений уішанський улун — гладке темне дерево й тиха мінеральність неба, з якого нарешті пішов грім.",
    noteEn: "A deeply roasted Wuyi oolong — polished dark wood and the quiet mineral hush of a sky finally finished with thunder.",
  ),
  47: TeaPairing(
    chinese: "茯砖",
    pinyin: "Fú Zhuān",
    nameUk: "Фу Чжуань (Цегла з «золотою квіткою»)",
    nameEn: "Fu Zhuan (Golden-Flower Brick)",
    type: TeaType.heicha,
    subVariety: "Фу Чжуань",
    noteUk: "Хунаньська цегла з культурою eurotium cristatum: чай дозріває замкнений у формі, як комаха, що сама себе запечатує в землі.",
    noteEn: "A Hunan brick fermented with the golden Eurotium fungus — the tea ripens sealed inside its mould, the way an insect seals itself underground.",
  ),
  48: TeaPairing(
    chinese: "老班章",
    pinyin: "Lǎo Bān Zhāng",
    nameUk: "Лао Бань Чжан (Шен з найвідомішого регіону Менхая)",
    nameEn: "Lao Ban Zhang (Sheng from Menghai's most prestigious village)",
    type: TeaType.shengPuerh,
    subVariety: "Лао Бань Чжан",
    noteUk: "Шен пуер найзнаменитішого менхайського села — глибока гірська ці, що тримається в кореневому ґрунті, коли воду з рисових полів нарешті спустили.",
    noteEn: "Sheng pu-erh from Menghai's most legendary village — a deep mountain qi rooted in old soil, holding fast as the paddies are drained for the year.",
  ),
  49: TeaPairing(
    chinese: "安化黑砖",
    pinyin: "Ānhuà Hēi Zhuān",
    nameUk: "Аньхуа Хей Чжуань (Хунаньська чорна цегла)",
    nameEn: "Anhua Hei Zhuan (Hunan Dark Brick)",
    type: TeaType.heicha,
    subVariety: "Аньхуа Хей Чжуань",
    noteUk: "Хунаньський хей-ча, який століттями возили на північ караванами, — чай-мандрівник, що повертається на батьківщину разом із гусьми.",
    noteEn: "A Hunan dark tea that has travelled the northern caravan routes for centuries — a wandering tea returning home in formation with the geese.",
  ),
  50: TeaPairing(
    chinese: "月光白",
    pinyin: "Yuèguāng Bái",
    nameUk: "Юе Ґуан Бай (Білий «Місячне сяйво»)",
    nameEn: "Yueguang Bai (Moonlight White)",
    type: TeaType.whiteTea,
    subVariety: "Юе Ґуан Бай",
    noteUk: "Юньнаньський білий, в'ялений у нічній прохолоді: пелюсткові тони хризантеми й тихий мед, що розквітає в чашці так само, як квіти у саду.",
    noteEn: "A Yunnan white withered through cool nights — chrysanthemum-petal tones and a quiet honey that opens in the bowl the way blossoms open in the garden.",
  ),
  51: TeaPairing(
    chinese: "冻顶乌龙",
    pinyin: "Dòngdǐng Wūlóng",
    nameUk: "Дун Дін (Улун із Замерзлої вершини)",
    nameEn: "Dong Ding (Frozen Peak Oolong)",
    type: TeaType.taiwaneseLightOolong,
    subVariety: "Дун Дін",
    noteUk: "Тайванський класичний улун зі смаженою маслянистою нотою — теплий, як цвіркун, що співає за дверима всю ніч.",
    noteEn: "A classic Taiwanese oolong with a buttery roast — warm and patient, like a cricket at the door singing all the way through the cool night.",
  ),
  52: TeaPairing(
    chinese: "凤凰宋种",
    pinyin: "Fènghuáng Sòng Zhǒng",
    nameUk: "Феньхуан Сон Чжун (Фенікс, кущ династії Сон)",
    nameEn: "Phoenix Song Zhong (Song-Dynasty Mother Bush)",
    type: TeaType.guangdongOolong,
    subVariety: "Сон Чжун",
    noteUk: "Стародавня лінія Феньхуан — теплий, зігрівальний чай для перших днів інію, з мінеральною осінньою глибиною.",
    noteEn: "The old Phoenix lineage — a warming, body-thickening cup for the morning the first frost takes the field, with autumn's mineral depth.",
  ),
  53: TeaPairing(
    chinese: "白鸡冠",
    pinyin: "Bái Jīguān",
    nameUk: "Бай Цзі Ґуань (Білий півнячий гребінь)",
    nameEn: "Bai Ji Guan (White Cockscomb)",
    type: TeaType.northFujianOolong,
    subVariety: "Бай Цзі Ґуань",
    noteUk: "Жовтувато-зелений уішанський лист тримається легкий і прозорий — короткі осінні зливи, які так само швидко приходять і йдуть.",
    noteEn: "The pale yellow-green Wuyi leaf brews light and bright — the kind of brief autumn shower that arrives and is gone before the cup cools.",
  ),
  54: TeaPairing(
    chinese: "黄枝香单丛",
    pinyin: "Huángzhī Xiāng Dāncōng",
    nameUk: "Хуан Чжи Сян Дань Цун (Феньхуан з ароматом гарденії)",
    nameEn: "Huang Zhi Xiang Dan Cong (Yellow-Gardenia Phoenix Oolong)",
    type: TeaType.guangdongOolong,
    subVariety: "Хуан Чжи Сян",
    noteUk: "Найжовтіший із ароматів феньхуанського улуну — стиглий мед і тепла гарденія, як клен у вечірньому світлі.",
    noteEn: "The most yellow of all Phoenix aromas — ripe honey and warm gardenia, the colour of a maple leaf held up to the late sun.",
  ),

  // ─── Winter ────────────────────────────────────────────────────────────
  55: TeaPairing(
    chinese: "武夷肉桂",
    pinyin: "Wǔyí Ròuguì",
    nameUk: "Уї Жоу Ґуй (Уішанський коричник)",
    nameEn: "Wuyi Rou Gui (Wuyi Cinnamon Cliff Tea)",
    type: TeaType.northFujianOolong,
    subVariety: "Жоу Ґуй",
    noteUk: "Скельний улун з пряно-кориковою нотою — як останні червоні камелії, що розквітають крізь холодне повітря саду.",
    noteEn: "A cliff oolong with a spicy cinnamon edge — like the last red camellias still pushing open through the cold garden air.",
  ),
  56: TeaPairing(
    chinese: "宾岛",
    pinyin: "Bīn Dǎo",
    nameUk: "Бінь Дао (Шен пуер з гори Бінь Дао)",
    nameEn: "Bing Dao (Sheng Pu-erh from Bing Dao Village)",
    type: TeaType.shengPuerh,
    subVariety: "Бінь Дао",
    noteUk: "Витриманий шен з гори Бінь Дао — стильна вологість підвалу, кедр, сухий камфорний дим: чай, що сам уже промерз і відтанув багато разів.",
    noteEn: "A long-rested Bing Dao raw pu-erh — cellar damp, cedar, dry camphor smoke: a tea that has already frozen and thawed inside its own years.",
  ),
  57: TeaPairing(
    chinese: "金萱",
    pinyin: "Jīn Xuān",
    nameUk: "Цзінь Сюань (Тайванський «молочний» улун)",
    nameEn: "Jin Xuan (Milk Oolong)",
    type: TeaType.taiwaneseLightOolong,
    subVariety: "Цзінь Сюань",
    noteUk: "Тайванський сорт #12: природна молочно-вершкова нота й білий квітковий тон, що висне в холодному повітрі довше за нарциси.",
    noteEn: "The famous TRES #12 cultivar — a natural cream-and-flower note that hangs in cold air longer than narcissus scent itself.",
  ),
  58: TeaPairing(
    chinese: "千两茶",
    pinyin: "Qiān Liǎng Chá",
    nameUk: "Цянь Лян Ча (Чай у тисячу лянів)",
    nameEn: "Qian Liang Cha (Thousand-Tael Tea)",
    type: TeaType.heicha,
    subVariety: "Цянь Лян Ча",
    noteUk: "Гігантські стовпи аньхуаського хей-ча, обмотані бамбуком: чай-моноліт для сірих неба, де веселок уже не лишилося.",
    noteEn: "Giant bamboo-wrapped pillars of Anhua dark tea — a monolithic, smoky-sweet liquor for grey skies that no longer offer rainbows.",
  ),
  59: TeaPairing(
    chinese: "陈年六堡",
    pinyin: "Chén Nián Liùbǎo",
    nameUk: "Витриманий Лю Бао",
    nameEn: "Aged Liu Bao",
    type: TeaType.liubao,
    subVariety: "Витриманий Лю Бао",
    noteUk: "Гуансійський Лю Бао з вологого підвалу — арека-горіх, темна деревина, заспокійлива тепла глибина проти північного вітру, що зриває останній лист.",
    noteEn: "Damp-cellar Guangxi Liu Bao — areca nut, dark wood, a settling warmth holding the bone-cold north wind at bay as it strips the last leaf away.",
  ),
  60: TeaPairing(
    chinese: "陈皮普洱",
    pinyin: "Chénpí Pǔ'ěr",
    nameUk: "Чень Пі Пуер (Пуер у шкірці витриманого мандарина)",
    nameEn: "Chen Pi Pu-erh (Aged-Tangerine-Peel Pu-erh)",
    type: TeaType.shuPuerh,
    subVariety: "Чень Пі Пуер",
    noteUk: "Шу пуер, дозрілий усередині висушеної гуандунської мандаринки, — точна вічна копія дерева татібани в зимовому саду.",
    noteEn: "Ripe pu-erh aged inside the dried peel of a Guangdong tangerine — a citrus-and-earth pairing that is the tachibana tree itself, in a cup.",
  ),
  61: TeaPairing(
    chinese: "冰岛",
    pinyin: "Bīngdǎo",
    nameUk: "Бінь Дао (Шен з гори Бінь Дао)",
    nameEn: "Bingdao (Sheng from Bingdao Mountain)",
    type: TeaType.shengPuerh,
    subVariety: "Бінь Дао",
    noteUk: "Фірмовий крижано-солодкий настій Бінь Дао — холодний цукровий тростинний тон, що зігріває тіло саме в перший день справжньої зими.",
    noteEn: "Bingdao's signature ice-sweet liquor — a cold cane-sugar register that warms the body from inside on the first true day of winter.",
  ),
  62: TeaPairing(
    chinese: "陈年白毫银针",
    pinyin: "Chén Nián Báiháo Yínzhēn",
    nameUk: "Витримані Срібні голки (Бай Хао Інь Чжень)",
    nameEn: "Aged Bai Hao Yin Zhen",
    type: TeaType.whiteTea,
    subVariety: "Бай Хао Інь Чжень",
    noteUk: "Срібні голки, що вісім чи десять років спали в коморі: запах меду, лугової трави, паперу — спокій ведмедя у барлозі.",
    noteEn: "Silver-needle white that has slept eight or ten years in a dry storeroom — honey, dry meadow, old paper: the bear's calm in its den.",
  ),
  63: TeaPairing(
    chinese: "金骏眉",
    pinyin: "Jīn Jùn Méi",
    nameUk: "Цзінь Цзюнь Мей (Золота брова жвавого коня)",
    nameEn: "Jin Jun Mei (Golden Steed Eyebrow)",
    type: TeaType.redTea,
    subVariety: "Цзінь Цзюнь Мей",
    noteUk: "Золоті бруньки з тонму: мускусна нота, дика слива, тиха сила лосося, що йде проти течії під льодом.",
    noteEn: "Golden Tongmu buds — musk, wild plum, the same quiet stubbornness as a salmon fighting its way upriver under the ice.",
  ),
  64: TeaPairing(
    chinese: "霍山黄芽",
    pinyin: "Huòshān Huángyá",
    nameUk: "Хошань Хуан Я (Жовті бруньки з гори Хо)",
    nameEn: "Huo Shan Huang Ya (Yellow Buds of Mount Huo)",
    type: TeaType.yellowTea,
    subVariety: "Хошань Хуан Я",
    noteUk: "Аньхойський жовтий, рідкісний навіть у Китаї: ніжна крупозалива нота, тихий парадокс паростків, що з'являються в найтемніший день.",
    noteEn: "A rare Anhui yellow — sweet-corn softness and a faint mineral lift, the paradox of a green shoot appearing on the year's darkest night.",
  ),
  65: TeaPairing(
    chinese: "大红袍",
    pinyin: "Dà Hóng Páo",
    nameUk: "Да Хун Пао (Великий червоний халат)",
    nameEn: "Da Hong Pao (Big Red Robe)",
    type: TeaType.northFujianOolong,
    subVariety: "Да Хун Пао",
    noteUk: "Найвідоміший уішанський улун — глибока смажена кора, шоколад, кориця: царствений чай для оленя, що скидає роги і ще раз стане сильним.",
    noteEn: "The most legendary Wuyi oolong — roasted bark, dark cocoa, cinnamon: a kingly cup for the stag who sheds his crown and waits to grow it back.",
  ),
  66: TeaPairing(
    chinese: "贡眉",
    pinyin: "Gòngméi",
    nameUk: "Ґун Мей (Бровиста данина)",
    nameEn: "Gong Mei (Tribute Eyebrow)",
    type: TeaType.whiteTea,
    subVariety: "Ґун Мей",
    noteUk: "Білий чай із дрібного листового збору, спресований у круги: солодке сухе сіно, що ховає всередині майбутнє літо.",
    noteEn: "A white tea pressed into cakes — sweet dry hay covering the same secret as wheat under snow: a green summer waiting silently inside.",
  ),
  67: TeaPairing(
    chinese: "龙井",
    pinyin: "Lóngjǐng",
    nameUk: "Лун Цзін (Колодязь дракона)",
    nameEn: "Long Jing (Dragon Well)",
    type: TeaType.greenTea,
    subVariety: "Лун Цзін",
    noteUk: "Старий запас Сіху, відкритий у розпал зими, — яскраво-смарагдовий настій, як петрушка, що пронизує крижаний потік.",
    noteEn: "A West-Lake reserve, opened deep into winter — the cup is a vivid emerald, the colour of parsley standing bright against an icy stream.",
  ),
  68: TeaPairing(
    chinese: "月光白",
    pinyin: "Yuèguāng Bái",
    nameUk: "Юе Ґуан Бай (Білий «Місячне сяйво»)",
    nameEn: "Yueguang Bai (Moonlight White)",
    type: TeaType.whiteTea,
    subVariety: "Юе Ґуан Бай",
    noteUk: "Юньнаньський білий, в'ялений у нічній прохолоді: одна сторона листа темна, друга — срібна, як замерзле джерело, що тільки прокидається.",
    noteEn: "A Yunnan white withered through the cool nights — one side of each leaf dark, the other silver, like a thawing spring catching its first light.",
  ),
  69: TeaPairing(
    chinese: "杏仁香单丛",
    pinyin: "Xìngrén Xiāng Dāncōng",
    nameUk: "Сін Жень Сян Дань Цун (Феньхуан з мигдалевим ароматом)",
    nameEn: "Xing Ren Xiang Dan Cong (Almond-Fragrance Phoenix Oolong)",
    type: TeaType.guangdongOolong,
    subVariety: "Сін Жень Сян",
    noteUk: "Один з рідкісних ароматів Феньхуану — гірко-солодкий мигдаль і ясний звук, як крик фазана над снігом.",
    noteEn: "One of the rarer Phoenix aromas — bittersweet almond and a sharp clear ring, like a pheasant's cry across a silent snowfield.",
  ),
  70: TeaPairing(
    chinese: "陈年六堡",
    pinyin: "Chén Nián Liù Bǎo",
    nameUk: "Витриманий Лю Бао (Гуансійський хей-ча)",
    nameEn: "Aged Liu Bao (Aged Guangxi Six-Fortresses)",
    type: TeaType.liubao,
    subVariety: "Витриманий Лю Бао",
    noteUk: "Гуансійський Лю Бао після десяти-п'ятнадцяти років — глибокі тони арека-горіха й вологого підвалу: перша усмішка холодної гори.",
    noteEn: "Guangxi Liu Bao after a decade in the basket — areca nut, damp cellar, deep aged sweetness: the cold mountain's first quiet smile.",
  ),
  71: TeaPairing(
    chinese: "老茶头",
    pinyin: "Lǎo Chátóu",
    nameUk: "Лао Ча Тоу (Старі чайні голівки, пуерні самородки)",
    nameEn: "Lao Cha Tou (Pu-erh Tea Nuggets)",
    type: TeaType.shuPuerh,
    subVariety: "Лао Ча Тоу",
    noteUk: "Тверді грудки, що випадково спеклися під час ферментації шу-пуера: солодкі, в'язкі, як чорні брили льоду на зимовому потоці.",
    noteEn: "Hard nuggets that fuse together during pu-erh fermentation — sweet, viscous, dense, like blocks of ice locking together over a frozen stream.",
  ),
  72: TeaPairing(
    chinese: "清香铁观音",
    pinyin: "Qīngxiāng Tiěguānyīn",
    nameUk: "Теґуаньїнь слабкої обжарки (Весняний збір)",
    nameEn: "Light-Roast Tieguanyin (Spring Pluck)",
    type: TeaType.southFujianOolong,
    subVariety: "Теґуаньїнь слабкої обжарки",
    noteUk: "Весняний аньсійський улун легкої обжарки — золотистий настій, орхідея, тепло — тиха обіцянка нового року, що вже почав вилуплюватися.",
    noteEn: "Light-roast spring Anxi oolong — golden, orchid-bright, warming: the quiet promise of a year already beginning to hatch from its shell.",
  ),
};

/// Detailed information for each named subVariety used in [teaPairings].
///
/// Keys are the exact Ukrainian transliterations stored in
/// [TeaPairing.subVariety]. The map currently covers 45 subvarieties
/// spanning all thirteen [TeaType] categories.
const Map<String, TeaVariety> teaVarieties = {
  // ─── Зелені чаї ──────────────────────────────────────────────────────────
  "Лун Цзін": TeaVariety(
    infoUk:
        "Найвідоміший зелений чай Китаю, що росте на пагорбах Сіху (Західного озера) поблизу Ханчжоу в провінції Чжецзян. Лист збирають вручну до свята Цинмін, обсмажують у пласкій залізній сковороді бао-пань — звідси характерна гладенька форма, схожа на горобиний язичок. Класичні «чотири характеристики» — смарагдовий колір, чистий аромат смажених каштанів, солодкий післясмак і пласка форма. Найвищий ґатунок походить зі Шифена (Левиного піка) — терруару з кислими ґрунтами і ранковим туманом.",
    infoEn:
        "The most famous green tea of China, grown on the hills around West Lake (Xī Hú) near Hangzhou in Zhejiang province. Leaves are hand-plucked before the Qingming festival and pan-fired in a flat iron wok using the bao-pan technique, which gives the tea its signature smooth, sparrow-tongue shape. The four classical hallmarks are emerald colour, clean roasted-chestnut aroma, sweet aftertaste, and flat blade form. The highest grade comes from Shi Feng (Lion Peak), whose acidic soils and morning mist define the benchmark terroir.",
    legendUk:
        "Імператор Цяньлун династії Цін, відвідавши храм Хугун біля Сіху, особисто збирав чай із вісімнадцяти кущів перед павільйоном. Звістка про важку хворобу матері змусила його похапцем сховати листочки в рукав; коли він приїхав до палацу і мати відчула чудовий аромат, відвар із цих сплющених рукавом листків миттєво її зцілив. Ті самі вісімнадцять «імператорських кущів» досі ростуть біля храму Хугун.",
    legendEn:
        "The Qing-dynasty Qianlong Emperor visited the Hugong Temple beside West Lake and personally plucked tea from eighteen bushes in front of the pavilion. Hearing his mother had fallen gravely ill, he stuffed the leaves into his sleeve and rushed back to the palace; when she smelled the fragrance, the brew from those flattened sleeve-pressed leaves cured her at once. The same eighteen 'imperial bushes' still grow beside Hugong Temple today.",
    brewingUk:
        "80–85 °C м'якої води, скляний ґайвань або висока склянка. 3 г на 150 мл, перший настій 30 секунд без попереднього змочування. Витримує 4–6 проливів; з кожним наступним додавайте по 10–15 секунд.",
    brewingEn:
        "Soft water at 80–85 °C, glass gaiwan or a tall glass. 3 g per 150 ml, 30-second first infusion with no rinse. Yields 4–6 brews, adding 10–15 seconds to each subsequent steep.",
  ),
  "Бі Ло Чунь": TeaVariety(
    infoUk:
        "Зелений чай із гір Дунтін на озері Тайху в провінції Цзянсу. Дрібні бруньки, вкриті сріблястим пухом, скручують вручну в тугі спіральки — звідси назва «Зелена равликова весна». Чайні кущі ростуть упереміж із персиковими, абрикосовими та сливовими деревами, і лист вбирає квіткову солодкість, яка вирізняє Бі Ло Чунь з-поміж усіх китайських зелених. Передцинмінський збір — найніжніший і найдорожчий.",
    infoEn:
        "A green tea from the Dongting hills on Lake Tai in Jiangsu province. Tiny silver-downy buds are hand-rolled into tight spirals — hence the name 'Green Snail Spring'. The bushes grow interplanted with peach, apricot and plum trees, and the leaves absorb a floral sweetness that sets Bi Luo Chun apart from every other Chinese green. The pre-Qingming pluck is the most delicate and the most expensive.",
    legendUk:
        "За легендою, чай уперше зібрала молода черниця, яка, не маючи кошика, сховала листочки на грудях. Тепло її тіла розкрило аромат так сильно, що вона вигукнула: «Ох, аж лякає!» — і чай довго звався «Лякаючою пахощою» (Ся Ша Жень Сян), доки імператор Кансі не перейменував його на більш поетичне «Бі Ло Чунь».",
    legendEn:
        "A young nun is said to have first picked the tea without a basket and tucked the leaves against her bosom. The warmth of her body opened the aroma so strongly that she cried out 'frightful!' — and the tea was long known as Xia Sha Ren Xiang, 'Frightful Fragrance', until the Kangxi Emperor renamed it with the more poetic 'Bi Luo Chun'.",
    brewingUk:
        "75–80 °C — листочки тонкі і легко «обпікаються». Скляна склянка, метод шан-тоу: спершу налийте воду, потім кидайте чай — спіральки тонутимуть, як сніг. 3 г на 200 мл, перший настій 40 секунд, 4–5 проливів.",
    brewingEn:
        "75–80 °C — the buds are thin and scorch easily. Use a tall glass with the shang-tou method: pour water first, then drop the tea — the spirals sink like falling snow. 3 g per 200 ml, 40-second first infusion, 4–5 brews.",
  ),
  "Хуаншань Мао Фен": TeaVariety(
    infoUk:
        "Зелений чай із Жовтих гір (Хуаншань) у провінції Аньхой, де хмари майже не сходять із вершин. Назва «Ворсистий пік» походить від білого пушку на бруньках і характерної форми листа, що нагадує пташиний язичок із вістрям. Виготовляється методом легкої смаження з мінімальним скручуванням, тому смак тонкий, із нотами орхідеї, свіжого бобу та м'якої солодкості. Один з «десяти знаменитих чаїв Китаю».",
    infoEn:
        "A green tea from the Yellow Mountains (Huangshan) of Anhui, where the cloud cover almost never lifts. The name 'Fur-Tip Peak' comes from the white down on the buds and the bird-tongue blade shape with a pointed tip. The leaves are lightly pan-fired with minimal rolling, giving a delicate cup of orchid, fresh bean and gentle sweetness. One of the Ten Famous Teas of China.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "80 °C, скляний ґайвань або висока склянка. 3 г на 150 мл, перший настій 30 секунд. Витримує 4–6 проливів; чай не любить надто гарячої води — інакше зникає квіткова нота.",
    brewingEn:
        "80 °C, glass gaiwan or tall glass. 3 g per 150 ml, 30-second first infusion. Yields 4–6 brews; the tea dislikes hotter water, which kills its floral note.",
  ),
  "Тай Пін Хоу Куй": TeaVariety(
    infoUk:
        "Зелений чай із повіту Тайпін в Аньхой, виготовлений із крупнолистого культивара Шіда Ча. Унікальний тим, що має пласкі довгі (5–7 см) листочки з двома брунечками в обіймах розкритого листа — їх притискають марлею і тиснуть, щоб закріпити форму. Смак м'який, з вираженою орхідейною нотою, без жодної гіркоти; післясмак довгий і прохолодний. Найкращий терруар — село Хоу Кен біля Хуан Шан.",
    infoEn:
        "A green tea from Taiping county in Anhui, made from the large-leaf Shida Cha cultivar. It is unique for its long flat leaves (5–7 cm) with two buds embraced by an opening leaf — they are pressed beneath gauze to fix the shape. The cup is soft, distinctly orchid-scented and entirely free of bitterness, with a long, cooling aftertaste. The best terroir is Houkeng village near Huangshan.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "80–85 °C, висока скляна склянка (щоб бачити вертикальний танець листя) або порцеляновий ґайвань. 4 г на 200 мл, перший настій 40 секунд. 4–5 проливів.",
    brewingEn:
        "80–85 °C, a tall glass (to watch the vertical leaf dance) or porcelain gaiwan. 4 g per 200 ml, 40-second first infusion. 4–5 brews.",
  ),

  // ─── Білі чаї ────────────────────────────────────────────────────────────
  "Бай Хао Інь Чжень": TeaVariety(
    infoUk:
        "«Срібні голки з білими ворсинками» — найвищий ґатунок білого чаю з повітів Фудін і Чженхе у Фуцзяні. Виготовляється лише з нерозкритих бруньок культивара Да Бай (Велика Біла), вкритих густим сріблястим пушком. Виробництво мінімальне: природне в'ялення під сонцем і слабке досушування, без скручування і смаження. Смак ніжний, медовий, з нотами свіжого сіна, динного м'якуша і легким кокосом; з роками набуває повноти та смаку сухофруктів.",
    infoEn:
        "'Silver Needles with White Down' — the top grade of white tea from Fuding and Zhenghe counties in Fujian. It is made exclusively from unopened buds of the Da Bai (Great White) cultivar, sheathed in dense silvery down. Processing is minimal: natural sun-withering and a light final dry, with no rolling and no firing. The cup is delicate, honeyed, with notes of fresh hay, melon flesh and a faint coconut sweetness, deepening with age into dried-fruit richness.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "85–90 °C м'якої води. Ґайвань або висока склянка. 5 г на 150 мл, перший настій 60 секунд (бруньки розкриваються повільно). Витримує 6–8 проливів; можна також варити витримані голки в чаєварці.",
    brewingEn:
        "85–90 °C soft water. Gaiwan or tall glass. 5 g per 150 ml, 60-second first infusion (buds open slowly). 6–8 brews; aged needles can also be simmered in a kettle.",
  ),
  "Бай Му Дань": TeaVariety(
    infoUk:
        "«Біла півонія» — другий за статусом білий чай Фуцзяні, з однієї бруньки і двох наймолодших листочків. Назва походить від форми завареного листа, що розкривається в чашці, як квітка півонії. Природне в'ялення триває 36–60 годин залежно від погоди. Смак повніший, ніж у Срібних голок: персик, абрикос, медова свіжість і легка трав'яниста нота, з роками переходить у компот із сушених фруктів.",
    infoEn:
        "'White Peony' — Fujian's second-rank white tea, made from one bud and the two youngest leaves. The name comes from the shape of the brewed leaf opening in the bowl like a peony flower. Natural withering lasts 36–60 hours depending on the weather. The cup is fuller than Silver Needle: peach, apricot, honeyed freshness and a light grassy note, deepening over the years into a stewed-dried-fruit register.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "90 °C, ґайвань 100 мл. 5 г на 100 мл, перший настій 30–40 секунд. 6–8 проливів. Витриманий (3+ роки) пресований млинець добре розкривається у глиняному чайнику й любить варіння.",
    brewingEn:
        "90 °C, 100 ml gaiwan. 5 g per 100 ml, 30–40-second first infusion. 6–8 brews. Aged (3+ years) pressed cakes open well in a clay pot and respond well to simmering.",
  ),
  "Шоу Мей": TeaVariety(
    infoUk:
        "«Брова довголіття» — білий чай із зрілих листків і небагатьох бруньок, зібраних у пізніший період весни (зазвичай після 10 квітня) або влітку. Найскромніший за зовнішнім виглядом серед фуцзяньських білих, але з потенціалом до тривалого зберігання — після 7–10 років він перетворюється на густий медово-фініковий настій із нотами сухих трав і теплої деревини. Часто пресують у круги для зручного зберігання.",
    infoEn:
        "'Longevity Eyebrow' — a white tea made from mature leaves with a few buds, plucked later in spring (usually after April 10) or in summer. It is the humblest-looking of Fujian whites but has remarkable ageing potential — after 7–10 years it becomes a thick honey-and-date liquor with notes of dried herbs and warm wood. Often pressed into cakes for convenient storage.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95–100 °C — старший і грубіший лист любить окріп. Ґайвань або глиняний чайник, 6 г на 100 мл, перший настій 20 секунд. 8–10 проливів; останні 2–3 проливи можна доварити на плиті.",
    brewingEn:
        "95–100 °C — the older, coarser leaves want fully boiling water. Gaiwan or clay pot, 6 g per 100 ml, 20-second first infusion. 8–10 brews; the last two or three steeps can be simmered on the stove.",
  ),
  "Ґун Мей": TeaVariety(
    infoUk:
        "«Бровиста данина» — білий чай із культивара Цай Ча (місцевий дрібнолистий куст), а не з Да Бай, як інші фуцзяньські білі. Раніше це був чай, що йшов як данина імператорському двору, звідси «Гун». За якістю стоїть між Бай Му Дань і Шоу Мей; характер — медовий, з нотами фініка, дикої груші та легкої димності. Часто пресують у пласкі круги по 357 г.",
    infoEn:
        "'Tribute Eyebrow' — a white tea made from the local small-leaf Cai Cha cultivar rather than Da Bai. Historically it was sent as tribute to the imperial court, hence the 'Gong'. In quality it sits between Bai Mu Dan and Shou Mei; the character is honeyed, with notes of date, wild pear and a faint smokiness. Often pressed into 357 g flat cakes.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95 °C, ґайвань або глиняний чайник. 6 г на 100 мл, перший настій 25 секунд. 7–9 проливів. Витриманий пресований Ґун Мей чудово розкривається при варінні з кількома фініками.",
    brewingEn:
        "95 °C, gaiwan or clay pot. 6 g per 100 ml, 25-second first infusion. 7–9 brews. Aged pressed Gong Mei opens beautifully when simmered together with a few jujubes.",
  ),
  "Юе Ґуан Бай": TeaVariety(
    infoUk:
        "«Місячне сяйво» — білий чай з юньнаньського великолистого культивара (того самого, що й для пуера), а не з фуцзяньського Да Бай. В'ялиться вночі при місячному світлі — звідси назва. Лист характерно двоколірний: верхня сторона темна, нижня — срібляста, як неповний місяць. Смак інтенсивно медовий, з нотами хризантеми, сухої сливи та легкого пороху какао; тіло щільне, післясмак довгий.",
    infoEn:
        "'Moonlight White' — a white tea made from the Yunnan large-leaf cultivar (the same used for pu-erh), not the Fujian Da Bai. It is withered overnight in moonlight — hence the name. Each leaf is distinctly two-toned: dark on top, silvery underneath, like a half-moon. The cup is intensely honeyed, with notes of chrysanthemum, dried plum and a faint cocoa dust; the body is thick and the aftertaste long.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "90 °C, ґайвань. 5 г на 100 мл, перший настій 20 секунд. 6–8 проливів. На відміну від фуцзяньських білих, любить трохи коротші проливи через щільне юньнаньське листя.",
    brewingEn:
        "90 °C, gaiwan. 5 g per 100 ml, 20-second first infusion. 6–8 brews. Unlike Fujian whites, it prefers slightly shorter steeps because of the denser Yunnan leaf.",
  ),

  // ─── Жовті чаї ───────────────────────────────────────────────────────────
  "Цзюньшань Іньчжень": TeaVariety(
    infoUk:
        "«Срібні голки з гори Цзюнь» — рідкісний жовтий чай з невеликого острова Цзюньшань на озері Дунтін у провінції Хунань. Виготовляється лише з бруньок навесні; ключовий етап — «мень-хуан» (томління в жовтому), коли загорнутий у папір лист повільно ферментується власним теплом. Завдяки цьому зникає трав'яниста різкість зеленого чаю, з'являється м'яка солодкість кукурудзяного зерна і теплий аромат сухого сіна. Колись данина імператорського двору.",
    infoEn:
        "'Silver Needles from Junshan Mountain' — a rare yellow tea from the small Junshan island in Lake Dongting, Hunan province. Made exclusively from spring buds; the defining step is men-huang ('yellow smothering'), in which paper-wrapped leaves slowly ferment in their own heat. This removes the grassy edge of green tea and introduces a soft sweet-corn note and warm dry-hay aroma. Once an imperial tribute tea.",
    legendUk:
        "За легендою, тих самих бруньок, які заварила собі імператриця династії Тан, було стільки, що вони тричі піднялися й опустилися в склянці — кожна, мов риба, що тричі дякувала за честь бути зірваною. Цзюньшань Іньчжень досі цінують саме за цей «танець голок» у високій склянці.",
    legendEn:
        "Legend says that when a Tang-dynasty empress brewed these very buds, the needles rose and sank three times in her glass — each one a small fish bowing thrice in thanks for the honour of being plucked. Junshan Yinzhen is still prized for this 'dance of needles' in a tall glass.",
    brewingUk:
        "85 °C, висока скляна склянка для спостереження за «танцем голок». 3 г на 200 мл, перший настій 60 секунд. 3–4 проливи; чай ніжний і не любить агресивної експлуатації.",
    brewingEn:
        "85 °C, a tall glass to watch the 'dance of needles'. 3 g per 200 ml, 60-second first infusion. 3–4 brews; the tea is delicate and does not stand up to aggressive steeping.",
  ),
  "Хошань Хуан Я": TeaVariety(
    infoUk:
        "«Жовті бруньки з гори Хо» — жовтий чай з повіту Хошань у провінції Аньхой, історично знаний з часів династії Тан. Виготовляється з бруньки і одного-двох листочків, з обов'язковим етапом мень-хуан. Смак м'якший і землистіший за зелений: смажена кукурудза, цукрова тростина, легкий каштановий тон і ледь помітна мінеральна нота. У 1972 році чай був включений до особливого подарунка китайської делегації під час візиту президента Ніксона.",
    infoEn:
        "'Yellow Buds of Mount Huo' — a yellow tea from Huoshan county in Anhui, historically known since the Tang dynasty. Made from a bud and one or two leaves, with the defining men-huang step. The cup is softer and earthier than green tea: roasted corn, cane sugar, a faint chestnut tone and a barely-there mineral note. In 1972 it was included in a special gift from the Chinese delegation during President Nixon's visit.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "85 °C, ґайвань або скляна склянка. 4 г на 150 мл, перший настій 40 секунд. 5–6 проливів.",
    brewingEn:
        "85 °C, gaiwan or glass. 4 g per 150 ml, 40-second first infusion. 5–6 brews.",
  ),

  // ─── Червоні (чорні) чаї ─────────────────────────────────────────────────
  "Цзінь Цзюнь Мей": TeaVariety(
    infoUk:
        "«Золота брова жвавого коня» — порівняно молодий (створений 2005 року) преміальний червоний чай із заповідника Тонму в Уішанських горах, серце старого Лапсан Сушона. Виготовляється лише з ранніх весняних бруньок; на 500 г готового чаю йде до 100 000 бруньок. На відміну від класичного Чжен Шан Сяочжуна, не коптиться. Смак — мускатна квітка, дикий мед, ноти ліжчі, какао і теплої смоли; настій яскраво-золотий.",
    infoEn:
        "'Golden Steed Eyebrow' — a relatively new (created in 2005) premium red tea from the Tongmu reserve in the Wuyi mountains, the heartland of the original Lapsang Souchong. Made exclusively from early-spring buds; up to 100,000 buds go into 500 g of finished tea. Unlike classic Zhengshan Xiaozhong, it is not smoked. The cup tastes of muscat flower, wild honey, lychee, cocoa and warm resin; the liquor is vivid gold.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "90 °C — більш висока температура задушить тонкі бруньки. Порцеляновий ґайвань 100–120 мл, 5 г на 100 мл, перший настій 5–8 секунд гонгфу-стилем. 8–10 проливів.",
    brewingEn:
        "90 °C — higher temperatures kill the delicate buds. Porcelain gaiwan of 100–120 ml, 5 g per 100 ml, 5–8 second first infusion gong-fu style. 8–10 brews.",
  ),
  "Лапсан Сушон": TeaVariety(
    infoUk:
        "Перший у світі чорний чай, винайдений у горах Уішань (заповідник Тонму, Фуцзянь) у XVI–XVII столітті. Сушиться над сосновими дровами Pinus massoniana — звідси характерний дим. Класичний експортний варіант насичено-копчений (саме він став «лапсангом» англійської традиції); внутрішній китайський Чжен Шан Сяочжун — тонший, з нотами лонгана, сосни і теплого солоду. Прародитель усіх китайських червоних чаїв.",
    infoEn:
        "The world's first black tea, invented in the Wuyi mountains (Tongmu reserve, Fujian) in the 16th–17th century. It is dried over Pinus massoniana pine wood — hence the signature smoke. The classic export version is heavily smoked (this is what became 'lapsang' in the English tradition); the domestic Chinese Zhengshan Xiaozhong is more refined, with notes of longan, pine and warm malt. The ancestor of every Chinese red tea.",
    legendUk:
        "Кажуть, що в епоху Мін біля заповідника Тонму проходило військо, яке отримало накази стати на ніч у чайних коморах. Селяни, повернувшись, побачили, що зібрані бруньки задушилися й почорніли; щоб не втратити врожай, вони висушили їх над вогнищами з соснових дров. Так несподівано народився перший у світі чорний чай — і його миттєво розкупили європейські купці у Сяменю.",
    legendEn:
        "During the Ming-Qing transition an army marched through the Tongmu reserve and was billeted overnight in the tea storehouses. When the villagers returned, the picked leaves had oxidised and turned black; to save the harvest they dried them over pine-wood fires. The world's first black tea was born by accident — and was bought up almost instantly by European traders in Xiamen.",
    brewingUk:
        "95 °C, порцеляновий ґайвань або глиняний чайник. 5 г на 100 мл, перший настій 10 секунд гонгфу-стилем. 6–8 проливів. Класичний копчений варіант також прекрасно тримається в європейському заварнику з молоком.",
    brewingEn:
        "95 °C, porcelain gaiwan or clay pot. 5 g per 100 ml, 10-second first infusion gong-fu style. 6–8 brews. The classic smoked version also holds up beautifully in a Western pot with milk.",
  ),
  "Ці Мень Хун Ча": TeaVariety(
    infoUk:
        "«Цихун» — червоний чай з повіту Ці Мень в Аньхой, створений 1875 року. Один із трьох «світових ароматичних чорних чаїв» поряд з індійським Дарджилінгом і цейлонським Уві. Характерний «Цимінський аромат» (Ці Мень Сян) — складна композиція троянди, какао, орхідеї та сухофруктів. Найкращі партії (Хао Я і Мао Фен) виготовляються з найдрібніших бруньок ранньої весни. Колись улюблений чорний чай британської королівської родини.",
    infoEn:
        "'Qihong' — a red tea from Qimen county in Anhui, created in 1875. One of the three 'great aromatic black teas of the world' alongside Indian Darjeeling and Ceylon Uva. Its signature 'Qimen aroma' (Qi Men Xiang) is a complex weave of rose, cocoa, orchid and dried fruit. The top grades (Hao Ya and Mao Feng) are made from the smallest early-spring buds. Once the favourite black tea of the British royal family.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "90–95 °C, порцеляновий ґайвань. 4 г на 100 мл, перший настій 8 секунд. 6–8 проливів. У європейському стилі: 1 чайна ложка на чашку 250 мл, 4 хвилини, можна з молоком.",
    brewingEn:
        "90–95 °C, porcelain gaiwan. 4 g per 100 ml, 8-second first infusion. 6–8 brews. Western style: 1 teaspoon per 250 ml cup, 4 minutes, takes milk well.",
  ),
  "Дянь Хун": TeaVariety(
    infoUk:
        "Юньнаньський червоний чай із великолистого культивара (того самого, що й для пуера), створений 1939 року як заміна перерваним поставкам Цихуна під час війни. Грубі золотаві бруньки дають насичений настій кольору червоного бурштину з вираженим смаком батату, темного меду, какао та чорносливу. Найвищі ґатунки — Дянь Хун Цзинь Я (Золоті бруньки) і Дянь Хун Сун Чжень («Соснові голки»). Тіло щільне, без терпкості.",
    infoEn:
        "A Yunnan red tea made from the large-leaf cultivar (the same as pu-erh's), created in 1939 to replace Qimen exports cut off by the war. The thick golden buds yield a deep amber liquor with marked notes of sweet potato, dark honey, cocoa and prune. The top grades are Dian Hong Jin Ya (Golden Buds) and Dian Hong Song Zhen ('Pine Needles'). The body is dense, without astringency.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95 °C, ґайвань або глиняний чайник. 5 г на 100 мл, перший настій 8 секунд. 6–8 проливів. Витримує жорсткішу воду і з молоком стає схожим на класичний асам.",
    brewingEn:
        "95 °C, gaiwan or clay pot. 5 g per 100 ml, 8-second first infusion. 6–8 brews. Tolerates harder water and turns into something like a classic Assam with milk.",
  ),
  "Іcін Хун Ча": TeaVariety(
    infoUk:
        "Червоний чай з повіту Іcін у провінції Цзянсу — з тих самих місць, де видобувають фіолетову глину для знаменитих чайників. Виготовляється з місцевого культивара, в більш м'якому й солодкому стилі, ніж юньнаньський Дянь Хун. Смак — теплий хліб, сушений абрикос, легкий какаовий тон, ноти зерна і сухого сіна; настій каштаново-червоний, без різкості. Серед китайських червоних — найбільш «домашнього» характеру.",
    infoEn:
        "A red tea from Yixing in Jiangsu — the same county that yields the famous purple clay for teapots. It is made from a local cultivar in a softer, sweeter style than Yunnan's Dian Hong. The cup tastes of warm bread, dried apricot, a light cocoa register and notes of grain and hay; the liquor is chestnut-red, without any edge. Of all Chinese reds, it is the most 'domestic' in character.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "90 °C, порцеляновий ґайвань або, доречно, іcінський чайник із фіолетової глини. 5 г на 100 мл, перший настій 10 секунд. 5–7 проливів.",
    brewingEn:
        "90 °C, porcelain gaiwan or — fittingly — a Yixing purple-clay pot. 5 g per 100 ml, 10-second first infusion. 5–7 brews.",
  ),

  // ─── Північнофуцзянські улуни (Уішанські скельні) ────────────────────────
  "Да Хун Пао": TeaVariety(
    infoUk:
        "«Великий червоний халат» — найвідоміший серед скельних улунів Уішаню в провінції Фуцзянь, найзнаменитіший із «Сі Да Мін Цун» (Чотирьох знаменитих кущів). Сучасний Да Хун Пао — це або чистий культивар Бей Доу/Ці Дань, або купаж із Шуй Сяня, Жоу Ґуя і Ці Даня. Виготовляється з обов'язковою середньою-сильною обжаркою на деревному вугіллі. Смак — тостована кора, темний шоколад, кориця, сушена слива і характерний «янь юнь» — мінеральна скельна нота. Шість материнських кущів на скелі Цзюлунь Ке досі живі, але листя з них уже не збирають.",
    infoEn:
        "'Big Red Robe' — the most famous of the Wuyi cliff oolongs in Fujian and the king of the Si Da Ming Cong (Four Famous Bushes). Modern Da Hong Pao is either a pure Bei Dou / Qi Dan cultivar or a blend of Shui Xian, Rou Gui and Qi Dan, with mandatory medium-to-heavy charcoal roast. The cup tastes of toasted bark, dark chocolate, cinnamon, dried plum and the unmistakable 'yan yun' — the mineral cliff-rock register. The six mother bushes on the Jiulongke cliff are still alive, but they are no longer harvested.",
    legendUk:
        "За легендою династії Мін, бідний учений на шляху до імператорських іспитів захворів і впав біля підніжжя Уішаню. Чернець із храму Тяньсінь напоїв його настоєм з листя кущів на скелі — учений одужав і склав іспит на найвищий бал. Повернувшись, він прислав свій великий червоний халат як подяку, і чернець накинув його на чайні кущі — звідси «Да Хун Пао». В іншій версії учений зцілив свою хвору матір цим самим чаєм, і імператор сам пожалував кущам червоний халат.",
    legendEn:
        "A Ming-dynasty legend tells of a poor scholar who fell ill on his way to the imperial exams at the foot of Wuyi. A monk from Tianxin Temple revived him with a brew from cliff-side bushes; the scholar passed at the top of the rolls and returned to drape his big red robe over the bushes in thanks — hence 'Big Red Robe'. In another version it is his sick mother who is healed, and the emperor himself bestows a red robe upon the bushes.",
    brewingUk:
        "100 °C — окріп, бо лист грубий і просмажений. Порцеляновий ґайвань 110 мл або іcінський чайник. 7–8 г на 100 мл, перший настій 10–12 секунд гонгфу-стилем. 8–12 проливів; найкраще починає звучати з третього-четвертого проливу.",
    brewingEn:
        "100 °C boiling water — the leaf is coarse and roasted. 110 ml porcelain gaiwan or a Yixing pot. 7–8 g per 100 ml, 10–12-second first infusion gong-fu style. 8–12 brews; the tea really begins to sing on the third or fourth steep.",
  ),
  "Уї Шуй Сянь": TeaVariety(
    infoUk:
        "«Уішанський Водяний Безсмертний» — улун зі старого культивара Шуй Сянь, посадженого в Уішанських горах ще в епоху Цін. Кущ дає крупний, м'ясистий лист, що добре переносить сильну обжарку. Окрема категорія — Лао Цун Шуй Сянь («старі кущі»), якщо рослині понад 60 років; такий чай має глибоку нарцис-мохову ноту і густу мінеральність. У стилі — теплі квіти нарциса, орхідея, мокре каміння і легка деревна солодкість.",
    infoEn:
        "'Wuyi Water Sprite' — an oolong from the old Shui Xian cultivar planted in the Wuyi mountains during the Qing dynasty. The bush yields a large fleshy leaf that takes a heavy roast well. A separate category, Lao Cong Shui Xian ('old bushes'), applies when the plants are over 60 years old; such tea has a deep narcissus-moss register and a dense minerality. In style: warm narcissus flower, orchid, wet stone and a soft wood sweetness.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, ґайвань або іcінський чайник. 7 г на 100 мл, перший настій 10 секунд гонгфу-стилем. 8–10 проливів. Старі кущі (Лао Цун) витримують ще довше експлуатацію.",
    brewingEn:
        "100 °C, gaiwan or Yixing pot. 7 g per 100 ml, 10-second first infusion gong-fu style. 8–10 brews. Lao Cong (old bush) versions stand up to even longer steeping.",
  ),
  "Жоу Ґуй": TeaVariety(
    infoUk:
        "«Коричник» — уішанський улун, відомий потужною коричною нотою. Культивар створений у 1940-х на основі місцевих кущів, але набув популярності лише в 1980-х і тепер ділить трон з Шуй Сянем. Найкращі терруари — Ню Лань Кен, Ма Тоу Янь і Сан Кен Лян Цзянь. Смак — кориця, чорний перець, тостована скоринка, темна вишня і яскрава скельна мінеральність. Вищий за Шуй Сянь рівень обжарки додає характерної смолистої гостроти.",
    infoEn:
        "'Cinnamon Cliff Tea' — a Wuyi oolong famous for its piercing cinnamon note. The cultivar was bred from local bushes in the 1940s but only rose to prominence in the 1980s; it now shares the throne with Shui Xian. The top terroirs are Niu Lan Keng, Ma Tou Yan and the Three Pits & Two Streams. The cup tastes of cinnamon, black pepper, toasted crust, dark cherry and bright cliff-rock minerality. A heavier roast than Shui Xian gives it a characteristic resinous edge.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, ґайвань або іcінський чайник. 7–8 г на 100 мл, перший настій 8 секунд гонгфу-стилем. 8–10 проливів. Чим вища ціна, тим тонший має бути перший пролив, інакше задушиться корична нота.",
    brewingEn:
        "100 °C, gaiwan or Yixing pot. 7–8 g per 100 ml, 8-second first infusion gong-fu style. 8–10 brews. The pricier the leaf, the shorter the first steep — otherwise the cinnamon note collapses.",
  ),
  "Бай Цзі Ґуань": TeaVariety(
    infoUk:
        "«Білий півнячий гребінь» — один з чотирьох «знаменитих кущів» Уішаню, унікальний серед скельних улунів своїм блідо-жовтим, майже білим листям. Виготовляється з мінімальною обжаркою (або взагалі без неї), щоб зберегти ніжний характер культивара. Смак тонкий, з нотами кукурудзяних рилець, медового пряника, легкої трав'янистості і тихої мінеральності. Найрідкісніший і найделікатніший серед уішанських улунів.",
    infoEn:
        "'White Cockscomb' — one of the four 'famous bushes' of Wuyi, unique among cliff oolongs for its pale yellow, almost white leaves. Processed with minimal roast (or none at all) to preserve the delicate cultivar character. The cup is fine, with notes of corn silk, honey-cake, light grassiness and a quiet minerality. The rarest and most delicate of the Wuyi oolongs.",
    legendUk:
        "За легендою, чернець знайшов на скелі мертвого півня, який, помираючи, прикрив крилами своє пташеня. Чернець поховав птаха під чайним кущем, і наступного року на тому місці виріс особливий кущ із жовто-білим листям, що формою нагадує півнячий гребінь — звідси й назва.",
    legendEn:
        "A monk is said to have found a dead rooster on the cliff, its wings still spread to shelter a chick. He buried the bird beneath a tea bush, and the following year that very plant produced unusual yellow-white leaves shaped like a cockscomb — and the name was born.",
    brewingUk:
        "95 °C — нижча, ніж для іншого скельного улуну, бо лист тонший. Порцеляновий ґайвань 100 мл, 6 г на 100 мл, перший настій 10 секунд. 6–8 проливів.",
    brewingEn:
        "95 °C — lower than for the other cliff oolongs, as the leaf is finer. 100 ml porcelain gaiwan, 6 g per 100 ml, 10-second first infusion. 6–8 brews.",
  ),

  // ─── Південнофуцзянські улуни (Анксі) ────────────────────────────────────
  "Теґуаньїнь сильної обжарки": TeaVariety(
    infoUk:
        "«Залізна Гуаньїнь» класичного стилю — улун із повіту Анксі (Фуцзянь), скручений у щільні кульки і просмажений на деревному вугіллі (Нунсян, «густого аромату»). Це історичний стиль до 1990-х, який відродився у 2010-х. Смак — карамель, смажений горіх, темний абрикос, какао і теплий орхідейний фон, що ховається під смаженою корою. Чим довша й глибша обжарка (іноді до 3–4 разів), тим довше тримається тіло настою.",
    infoEn:
        "'Iron Goddess of Mercy' in the classical style — an Anxi oolong (Fujian), rolled into tight balls and finished over charcoal (Nong Xiang, 'thick fragrance'). This is the pre-1990s historical style that came back into favour in the 2010s. The cup tastes of caramel, roasted nut, dark apricot, cocoa and a warm orchid undertone hidden beneath toasted bark. The longer and deeper the roast (sometimes three or four passes), the longer the body holds.",
    legendUk:
        "У XVIII столітті бідний селянин на ім'я Вей Інь з Анксі щодня запалював пахощі біля занедбаної статуї Гуаньїнь у місцевому храмі. Уві сні богиня вказала йому на печеру за храмом, де ріс єдиний кущ з блискучим, наче залізо, листом. Вей Інь висадив кущ, і той дав чай небаченої якості — звідси назва «Залізна Гуаньїнь».",
    legendEn:
        "In the 18th century a poor Anxi farmer named Wei Yin lit incense every day at a neglected Guanyin statue in his village temple. The goddess appeared to him in a dream and led him to a cave behind the temple where a single tea bush grew with leaves shining like iron. Wei Yin planted it, and it yielded a tea of unprecedented quality — hence 'Iron Goddess of Mercy'.",
    brewingUk:
        "100 °C, іcінський чайник або порцеляновий ґайвань 100 мл. 7 г на 100 мл, перший настій 10–15 секунд гонгфу-стилем. 8–10 проливів; кульки розкриваються повільно, тож третій-четвертий пролив — пік смаку.",
    brewingEn:
        "100 °C, Yixing pot or 100 ml porcelain gaiwan. 7 g per 100 ml, 10–15-second first infusion gong-fu style. 8–10 brews; the balls open slowly, so the third or fourth steep is the peak.",
  ),
  "Теґуаньїнь слабкої обжарки": TeaVariety(
    infoUk:
        "Сучасний «зелений» стиль Теґуаньїні (Цінсян, «свіжого аромату»), що домінує з 1990-х. Кульки скручені туго, обжарка мінімальна або відсутня; настій яскраво-жовто-зеленого кольору. Смак — свіжа орхідея, бузок, маслянистий бобовий тон, легка молочна солодкість і тривалий квітковий «хуйгань». Зберігається гірше, ніж сильна обжарка, тому традиційно п'ється протягом року після збору.",
    infoEn:
        "The modern 'green' Tieguanyin style (Qing Xiang, 'fresh fragrance'), dominant since the 1990s. Tightly rolled balls, minimal or no roast; the liquor is a vivid yellow-green. The cup is fresh orchid, lilac, a buttery bean note, a faint creamy sweetness and a long floral hui-gan. Keeps less well than the heavy-roast style and is traditionally drunk within a year of harvest.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95 °C — нижча, ніж для смаженої версії, щоб не задушити квіти. Порцеляновий ґайвань 100 мл, 7 г на 100 мл, перший настій 15 секунд гонгфу-стилем. 6–8 проливів.",
    brewingEn:
        "95 °C — lower than for the roasted version, to keep the flowers alive. 100 ml porcelain gaiwan, 7 g per 100 ml, 15-second first infusion gong-fu style. 6–8 brews.",
  ),

  // ─── Гуандунські улуни (Феньхуан Дань Цун) ───────────────────────────────
  "Сон Чжун": TeaVariety(
    infoUk:
        "«Сонський кущ» — найдавніша лінія Феньхуан Дань Цун, родом із гори Удун у повіті Чаочжоу (Гуандун). Окремі дерева датуються династією Південна Сон (XIII століття), що робить їх найстарішими культивованими чайними деревами в Китаї. Аромат складний, важко однозначно класифікується: мед, орхідея, гірська трава, дика слива і характерна «сонська ноткова» соковитість. Усі інші 11 ароматів Дань Цун походять від Сон Чжуна.",
    infoEn:
        "'Song-dynasty Mother Bush' — the oldest lineage of Phoenix Dan Cong, from Wudong mountain in Chaozhou prefecture (Guangdong). Individual trees date back to the Southern Song dynasty (13th century), making them the oldest cultivated tea trees in China. The aroma is complex and resists single classification: honey, orchid, mountain herbs, wild plum and the signature 'Song-bush' juiciness. All eleven other Dan Cong aromas descend from Song Zhong.",
    legendUk:
        "За легендою, останній імператор Південної Сон, тікаючи від монголів, перетнув гори Удун, де його загін мучила спрага. Місцеві ченці заварили йому чай із дикого куща на схилі — імператор пив і сказав, що такий чай гідний лише імператорського столу. Той самий кущ і його нащадки дали початок усій лінії Сон Чжун.",
    legendEn:
        "According to legend, the last emperor of the Southern Song fled the Mongol advance through the Wudong mountains and his party was wracked with thirst. The local monks brewed him tea from a wild bush on the slope, and the emperor declared the leaf fit for the imperial table. That bush and its descendants gave rise to the entire Song Zhong line.",
    brewingUk:
        "95–100 °C, порцеляновий ґайвань 100 мл (кераміка краще, ніж глина — щоб не «вкрала» аромат). 5–6 г на 100 мл, перший настій 5–8 секунд гонгфу-стилем. 10–12 проливів. Перший пролив максимально короткий, інакше «гірко».",
    brewingEn:
        "95–100 °C, 100 ml porcelain gaiwan (porcelain is better than clay here — clay would steal the aroma). 5–6 g per 100 ml, 5–8-second first infusion gong-fu style. 10–12 brews. The first steep should be very short, otherwise the cup turns bitter.",
  ),
  "Мі Лань Сян": TeaVariety(
    infoUk:
        "«Аромат медової орхідеї» — найвідоміший і найпопулярніший серед 12 ароматичних типів Феньхуан Дань Цун. Походить з гори Удун у Чаочжоу (Гуандун). Назва точно описує смак: дозрілий лонганний мед, орхідея, ноти зрілого манго і теплого карамельного абрикоса. Лист скручений у довгі тверді стрічки, обжарка середньо-сильна. Один з найдоступніших шляхів до світу Дань Цунів.",
    infoEn:
        "'Honey-Orchid Aroma' — the most famous and popular of the 12 aromatic types of Phoenix Dan Cong. From Wudong mountain in Chaozhou (Guangdong). The name says it: ripe longan honey, orchid, notes of mango flesh and warm caramelised apricot. Long twisted leaves with a medium-to-heavy roast. One of the most accessible entry points into the world of Dan Cong.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95–100 °C, порцеляновий ґайвань 100 мл. 5–6 г на 100 мл, перший настій 5–8 секунд гонгфу-стилем. 10–12 проливів. Дань Цуни не прощають довгих перших проливів — починайте з блискавки.",
    brewingEn:
        "95–100 °C, 100 ml porcelain gaiwan. 5–6 g per 100 ml, 5–8-second first infusion gong-fu style. 10–12 brews. Dan Cong does not forgive long first steeps — start fast.",
  ),
  "Чжи Лань Сян": TeaVariety(
    infoUk:
        "«Аромат орхідеї чжи» — Феньхуан Дань Цун із виразною прохолодною орхідейно-ірисовою нотою, без медової теплоти Мі Лань Сян. Походить з гори Удун; найкращі партії — з висоти понад 800 м. Смак — гірська орхідея, конвалія, легка свіжа зелень і прохолодний мінеральний хвіст; післясмак довгий і прохолодний у горлі (так зване «шен цзинь»). Цінується за чисту ботанічну точність.",
    infoEn:
        "'Zhi Orchid Aroma' — a Phoenix Dan Cong with a distinct cool orchid-iris note, without Mi Lan Xiang's honeyed warmth. From Wudong mountain; the best lots come from above 800 m. The cup tastes of mountain orchid, lily-of-the-valley, a faint fresh greenness and a cool mineral tail; the aftertaste is long and cooling in the throat (the prized 'sheng jin'). Valued for its clean botanical precision.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95 °C, порцеляновий ґайвань 100 мл. 5–6 г на 100 мл, перший настій 5–8 секунд. 10–12 проливів. Трохи нижча температура за Мі Лань Сян допомагає зберегти прохолодну орхідейну ноту.",
    brewingEn:
        "95 °C, 100 ml porcelain gaiwan. 5–6 g per 100 ml, 5–8-second first infusion. 10–12 brews. Slightly lower temperature than Mi Lan Xiang helps preserve the cool orchid note.",
  ),
  "Я Ши Сян": TeaVariety(
    infoUk:
        "«Качиний аромат» (буквально «качачий послід») — Феньхуан Дань Цун із гори Удун, чий легкий жартівливий назвисько прикриває чистий і потужний аромат гарденії, мигдалю та білих квітів. За легендою, селянин-власник особливого куща боявся, що сусіди його викрадуть, тому навмисно дав чаю огидну назву. Смак — пишна гарденія, мигдаль, легка білоквіткова кремовість і ясна мінеральна холодність.",
    infoEn:
        "'Duck-Shit Aroma' — a Phoenix Dan Cong from Wudong mountain whose deliberately disgusting nickname hides a pure, powerful aroma of gardenia, almond and white flowers. Legend says the farmer who owned the unusual bush feared his neighbours would steal cuttings, so he gave the tea a repulsive name to discourage them. The cup is lush gardenia, almond, a faint white-flower creaminess and a bright mineral coolness.",
    legendUk:
        "Стара історія розповідає: селянин з гори Удун виявив на своїй ділянці кущ із надзвичайним ароматом і боявся, що односельці виноситимуть із нього живці. Тоді він пустив чутку, що його чай росте «на качачому посліді» — так і прижилося шкідливе ім'я. Лише через кілька десятиліть, коли якість стала очевидною, автентична назва закріпилася як комерційний бренд.",
    legendEn:
        "An old story tells of a Wudong farmer who found a bush on his plot with an extraordinary aroma and feared his neighbours would steal cuttings. He spread the rumour that his tea grew 'on duck droppings' — and the unflattering name stuck. Only decades later, when the quality became impossible to deny, did 'duck-shit' become an accepted trade name.",
    brewingUk:
        "95–100 °C, порцеляновий ґайвань 100 мл. 5–6 г на 100 мл, перший настій 5 секунд. 10–12 проливів. Гарденійна нота розкривається на 2–4 проливі.",
    brewingEn:
        "95–100 °C, 100 ml porcelain gaiwan. 5–6 g per 100 ml, 5-second first infusion. 10–12 brews. The gardenia note opens on the second to fourth steep.",
  ),
  "Хуан Чжи Сян": TeaVariety(
    infoUk:
        "«Жовтогарденієвий аромат» — один з 10 «класичних» ароматичних типів Феньхуан Дань Цун із гори Удун. Назва «Хуан Чжи» (Жовта Чжи) натякає на стиглу гарденію жовтого кольору. Смак — стиглий мед, тепла гарденія, кремові нотки золотавого манго і ясна мінеральна нота. Важливий культивар у каноні Дань Цунів — тримається між пишним Мі Лань Сян і прохолодним Чжи Лань Сян.",
    infoEn:
        "'Yellow-Gardenia Aroma' — one of the ten 'classical' aromatic types of Phoenix Dan Cong from Wudong mountain. The name 'Huang Zhi' (Yellow Zhi) hints at a fully ripe yellow gardenia. The cup is ripe honey, warm gardenia, creamy notes of golden mango and a bright mineral lift. An important cultivar in the Dan Cong canon, sitting between the lush Mi Lan Xiang and the cool Zhi Lan Xiang.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95 °C, порцеляновий ґайвань 100 мл. 5–6 г на 100 мл, перший настій 5–8 секунд гонгфу-стилем. 10–12 проливів.",
    brewingEn:
        "95 °C, 100 ml porcelain gaiwan. 5–6 g per 100 ml, 5–8-second first infusion gong-fu style. 10–12 brews.",
  ),
  "Сін Жень Сян": TeaVariety(
    infoUk:
        "«Мигдалевий аромат» — рідкісний серед Феньхуан Дань Цун культивар з виразним тоном гіркого мигдалю, абрикосової кісточки і легкою марципановою солодкістю. Походить з гори Удун у Чаочжоу. Тіло настою щільне, мінеральне, з характерним «гірко-в-солодке» переходом, особливо вираженим у партіях зі старих кущів. Один з улюблених профілів серед знавців Дань Цуну.",
    infoEn:
        "'Almond Aroma' — a rare Phoenix Dan Cong cultivar with a distinct bitter-almond, apricot-kernel and faint marzipan sweetness. From Wudong mountain in Chaozhou. The body is dense and mineral, with the characteristic 'bitter-into-sweet' shift especially marked in old-bush lots. One of the connoisseur favourites of the Dan Cong family.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95–100 °C, порцеляновий ґайвань 100 мл. 5–6 г на 100 мл, перший настій 5–8 секунд гонгфу-стилем. 10–12 проливів.",
    brewingEn:
        "95–100 °C, 100 ml porcelain gaiwan. 5–6 g per 100 ml, 5–8-second first infusion gong-fu style. 10–12 brews.",
  ),

  // ─── Тайванські світлі улуни ─────────────────────────────────────────────
  "Дун Дін": TeaVariety(
    infoUk:
        "«Замерзла вершина» — класичний тайванський улун з гори Дун Дін у повіті Наньтоу, на висоті 600–1200 м. Виготовляється з культивара Цін Сінь («Зелене серце»), скручений у щільні кульки із середньою обжаркою (традиційно). Смак — масляниста смажена орхідея, печений каштан, теплий фруктовий нюанс і м'якa солодкість зі смаженою деревною нотою. Прародитель усього сучасного тайванського стилю улунів.",
    infoEn:
        "'Frozen Peak' — the classic Taiwanese oolong from Dong Ding mountain in Nantou county, at 600–1200 m elevation. Made from the Qing Xin ('Green Heart') cultivar, rolled into tight balls with a traditional medium roast. The cup tastes of buttery roasted orchid, baked chestnut, a warm fruit nuance and a soft sweetness with a roasted-wood register. The ancestor of every modern Taiwanese oolong style.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95 °C, порцеляновий ґайвань 100 мл або іcінський чайник. 6–7 г на 100 мл, перший настій 30 секунд (потрібен час, щоб кульки розкрилися). 6–8 проливів.",
    brewingEn:
        "95 °C, 100 ml porcelain gaiwan or Yixing pot. 6–7 g per 100 ml, 30-second first infusion (the balls need time to open). 6–8 brews.",
  ),
  "Цзінь Сюань": TeaVariety(
    infoUk:
        "Тайванський «молочний улун» — створений 1980 року на основі схрещування у проєкті TRES (культивар №12). Природний аромат містить ноти молока і вершків без жодних ароматизаторів — це особливість самого культивара. Виготовляється у світлому стилі, з мінімальною обжаркою, скручений у щільні кульки. Смак — молочна карамель, варене згущене молоко, легкий бузок і тепла трав'яна свіжість. Дешеві варіанти на ринку часто ароматизують штучно — справжній Цзінь Сюань має тонкий природний молочний нюанс.",
    infoEn:
        "Taiwan's 'milk oolong' — bred in 1980 in the TRES (Tea Research and Extension Station) program as cultivar #12. Its natural aroma contains milk and cream notes without any flavouring — this is a feature of the cultivar itself. Made in the light style, with minimal roast, rolled into tight balls. The cup tastes of milky caramel, condensed-milk sweetness, light lilac and a warm grassy freshness. Cheap market versions are often artificially flavoured — true Jin Xuan has a delicate natural milk nuance, not a buttery hammer.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "90 °C — нижча температура зберігає молочну ноту. Порцеляновий ґайвань 100 мл, 6 г на 100 мл, перший настій 30 секунд. 5–7 проливів.",
    brewingEn:
        "90 °C — a lower temperature keeps the milk note alive. 100 ml porcelain gaiwan, 6 g per 100 ml, 30-second first infusion. 5–7 brews.",
  ),

  // ─── Тайванський темний улун ─────────────────────────────────────────────
  "Дун Фан Мей Жень": TeaVariety(
    infoUk:
        "«Східна красуня» (також Бай Хао Улун, «улун із білим пушком») — унікальний тайванський улун з повіту Сіньчжу, ферментований на 60–75 % (найвищий рівень окислення серед улунів). Ключова особливість: лист має бути покусаний дрібною цикадкою Jacobiasca formosana — у відповідь рослина виробляє ароматичні сполуки, що дають характерний медовий і виноградний смак. Збір лише раз на рік, у середині літа. Смак — мускатний виноград, дикий мед, зрілий персик і легка корична нота.",
    infoEn:
        "'Oriental Beauty' (also Bai Hao Oolong, 'white-tip oolong') — a unique Taiwanese oolong from Hsinchu county, oxidised to 60–75 % (the highest oxidation among oolongs). Its defining feature: the leaves must be bitten by the tiny leafhopper Jacobiasca formosana — the plant's defensive response generates the aroma compounds that give the tea its honeyed-grape signature. Plucked only once a year, in midsummer. The cup tastes of muscat grape, wild honey, ripe peach and a faint cinnamon note.",
    legendUk:
        "За легендою, фермер привіз цей чай у Лондон і продав на аукціоні за фантастичною ціною. Ніхто не повірив його розповідям про вкушений лист, доки сама королева Вікторія, скуштувавши настій, не нарекла його «Oriental Beauty» — і нова назва пішла світом. Історія, ймовірно, апокрифічна, але зміцнила репутацію чаю в Європі.",
    legendEn:
        "As the legend goes, a farmer took this tea to London and sold it at auction for a fantastical price. No one believed his story about the leafhopper-bitten leaves until Queen Victoria herself tasted the brew and christened it 'Oriental Beauty', and the new name spread the world over. The story is probably apocryphal, but it cemented the tea's European reputation.",
    brewingUk:
        "85–90 °C — нижче за решту улунів, бо лист сильно окислений і ніжний. Порцеляновий ґайвань або скляний заварник, 5 г на 100 мл, перший настій 20 секунд. 5–7 проливів.",
    brewingEn:
        "85–90 °C — lower than for other oolongs, as the leaf is heavily oxidised and tender. Porcelain gaiwan or glass pot, 5 g per 100 ml, 20-second first infusion. 5–7 brews.",
  ),

  // ─── Шен пуери ───────────────────────────────────────────────────────────
  "Лао Бань Чжан": TeaVariety(
    infoUk:
        "Шен пуер з села Лао Бань Чжан у регіоні Менхай (Сішуанбаньна, Юньнань) — найдорожчий і найпрестижніший терруар сирого пуера на сьогодні. Розташоване на висоті понад 1700 м серед гір народу Хані; чайні дерева тут переважно стародавні (200+ років). Стиль смаку — потужна, концентрована «гірко-солодка» атака, густе тіло, грозова свіжість, камфорна холодність у горлі і знаменита «тигрова ці» — енергійна тілесна реакція. З витримкою (10+ років) гіркота йде, поступаючись місцем глибокій деревній солодкості.",
    infoEn:
        "Sheng pu-erh from Lao Ban Zhang village in the Menghai region (Xishuangbanna, Yunnan) — today's most expensive and prestigious raw pu-erh terroir. The village sits above 1700 m among the Hani people's mountains; the trees are mostly ancient (200+ years old). The signature is a powerful, concentrated 'bitter-into-sweet' attack, a dense body, stormy freshness, a camphor coolness in the throat and the famous 'tiger qi' — a strong bodily response. With age (10+ years) the bitterness recedes into a deep wood-and-honey sweetness.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, ґайвань 120 мл або іcінський чайник. 7–8 г на 100 мл. Обов'язковий короткий промив 5 секунд для пробудження листа. Перші 3 проливи 5–8 секунд, потім поступово додавайте. 12–15 проливів — Лао Бань Чжан надзвичайно витривалий.",
    brewingEn:
        "100 °C, 120 ml gaiwan or Yixing pot. 7–8 g per 100 ml. A brief 5-second rinse is essential to wake the leaf. The first three steeps run 5–8 seconds, then gradually lengthen. 12–15 brews — Lao Ban Zhang is extraordinarily long-lived in the cup.",
  ),
  "Бінь Дао": TeaVariety(
    infoUk:
        "Шен пуер із села Бінь Дао (Bingdao, «крижаний острів») у регіоні Лінь Цан (Юньнань) — другий за престижем терруар сирого пуера після Лао Бань Чжана. Назва не випадкова: чай має знаменитий «крижано-солодкий» (бін тань) післясмак — холодна цукрова свіжість у горлі. Стиль — м'який, ніжний, без агресивної гіркоти Бань Чжана; квіткова делікатність, медова цукрова тростина і прохолодний мінеральний шлейф. Стародавні дерева села Лао Чжай — найвищий рівень.",
    infoEn:
        "Sheng pu-erh from Bingdao village ('Ice Island') in the Lincang region (Yunnan) — the second most prestigious raw pu-erh terroir after Lao Ban Zhang. The name is no accident: the tea has its famous 'ice-sweet' (bing tan) aftertaste — a cold sugar freshness in the throat. The style is soft and delicate, without Ban Zhang's aggressive bitterness; floral finesse, honey-cane sweetness and a cool mineral trail. Trees from Lao Zhai (the old hamlet) are the top tier.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95–100 °C, ґайвань 120 мл. 7 г на 100 мл, короткий промив 5 секунд. Перші проливи 5–10 секунд гонгфу-стилем. 12–14 проливів. Делікатний характер не любить надто довгих проливів — пропустіть момент і втратите шар цукрової прохолоди.",
    brewingEn:
        "95–100 °C, 120 ml gaiwan. 7 g per 100 ml, brief 5-second rinse. First steeps 5–10 seconds gong-fu style. 12–14 brews. The delicate character does not tolerate long steeps — overshoot and you lose the sugar-cool layer.",
  ),
  "І У": TeaVariety(
    infoUk:
        "Шен пуер з гірського масиву І У (Сішуанбаньна, Юньнань) — історичне серце «Шести знаменитих чайних гір», звідки походив імператорський пуер епохи Цін. Стиль виразно жіночний: ніжний, ароматний, з квітковою медовістю, відсутністю агресивної гіркоти і характерним довгим солодким післясмаком. Ідеальний для тривалого зберігання — І У-пуери з 1990-х сьогодні вважаються еталоном витриманого шена. Найкращі мікротерруари — Ма Хей, Гао Шань Чжай, Ман Сон.",
    infoEn:
        "Sheng pu-erh from the Yiwu mountain range (Xishuangbanna, Yunnan) — the historical heart of the 'Six Famous Tea Mountains', the source of imperial Qing-dynasty pu-erh. The style is markedly feminine: soft, aromatic, floral-honeyed, without aggressive bitterness, with a long sweet aftertaste. Ideal for long ageing — Yiwu cakes from the 1990s are today's benchmark for aged sheng. The top micro-terroirs are Mahei, Gaoshan Zhai and Mansong.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, ґайвань 120 мл. 7 г на 100 мл, короткий промив. Перші проливи 5–10 секунд. 10–12 проливів. І У можна також варити в чаєварці після 8-го проливу — розкривається друга хвиля солодкості.",
    brewingEn:
        "100 °C, 120 ml gaiwan. 7 g per 100 ml, short rinse. First steeps 5–10 seconds. 10–12 brews. After the eighth steep Yiwu can be transferred to a kettle for simmering — a second wave of sweetness emerges.",
  ),
  "Цзінмай": TeaVariety(
    infoUk:
        "Шен пуер з гори Цзінмай у регіоні Пуер (Юньнань) — одного з найбільших у світі масивів стародавніх чайних дерев, у 2023 році занесеного до списку Всесвітньої спадщини ЮНЕСКО. Дерева ростуть в природному лісі впереміж із квітами і деревами — звідси характерна орхідейна нота. Стиль — стримана гіркота, виражена квіткова свіжість (орхідея, османтус), легка деревинна теплота і довга солодкість. З роками чай набуває складної камфорної глибини.",
    infoEn:
        "Sheng pu-erh from Jingmai mountain in the Pu'er region (Yunnan) — one of the world's largest stands of ancient tea trees and a UNESCO World Heritage site since 2023. The trees grow in mixed natural forest interplanted with flowers and other species — hence the signature orchid note. The style: restrained bitterness, marked floral freshness (orchid, osmanthus), a soft wood warmth and a long sweetness. With age the tea develops a complex camphor depth.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95–100 °C, ґайвань 120 мл. 7 г на 100 мл, короткий промив. Перші проливи 5–10 секунд. 10–12 проливів. Орхідейна нота найкраще звучить на 2–4 проливі.",
    brewingEn:
        "95–100 °C, 120 ml gaiwan. 7 g per 100 ml, short rinse. First steeps 5–10 seconds. 10–12 brews. The orchid note sings loudest on the second to fourth steep.",
  ),
  "Булан": TeaVariety(
    infoUk:
        "Шен пуер з гірського масиву Булан (Сішуанбаньна, Юньнань) — найпотужніший і найгіркіший серед юньнаньських терруарів. Власне, Лао Бань Чжан адміністративно належить до Булану, але стиль ширший: будь-який Булан означає густу, м'ясисту гіркоту, що швидко перетворюється на сильну солодкість, потужне тіло і довгу енергетичну дію. Молоді блини (1–3 роки) часом надто агресивні — традиційно Булан розкривається після 5–7 років витримки.",
    infoEn:
        "Sheng pu-erh from the Bulang mountain range (Xishuangbanna, Yunnan) — the most muscular and bitterest of all Yunnan terroirs. Strictly speaking Lao Ban Zhang sits administratively inside Bulang, but the style is broader: any Bulang means a thick, fleshy bitterness that turns quickly into strong sweetness, a powerful body and a long energetic finish. Young cakes (1–3 years) can be too aggressive — Bulang traditionally opens up after 5–7 years of rest.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, ґайвань 120 мл або іcінський чайник. 7–8 г на 100 мл, обов'язковий промив 5 секунд. Перші проливи 5–8 секунд (молодий Булан гіркіший — пийте короткими порціями). 12–14 проливів.",
    brewingEn:
        "100 °C, 120 ml gaiwan or Yixing pot. 7–8 g per 100 ml, mandatory 5-second rinse. First steeps 5–8 seconds (young Bulang is bitter — drink in short bursts). 12–14 brews.",
  ),

  // ─── Шу пуери ────────────────────────────────────────────────────────────
  "Менхайський 7572": TeaVariety(
    infoUk:
        "Класичний рецепт шу пуера заводу Менхай (Дайі), створений 1975 року і досі один з найпопулярніших у Китаї. Цифри: 75 — рік, 7 — середньокрупний листовий бленд, 2 — індекс заводу Менхай. Виготовляється шляхом «во дуй» — мокрого купного бродіння протягом 45–60 днів. Смак — мокра земля, гриби, чорнослив, темне какао і ноти кори; настій густо-каштановий, тіло щільне, дим відсутній. Еталон стилю шу: те, з чого починається знайомство з категорією.",
    infoEn:
        "The classic shu pu-erh recipe of the Menghai (Dayi) factory, created in 1975 and still one of the most popular in China. The numerals: 75 — year, 7 — medium-large leaf blend, 2 — Menghai factory code. Produced via wo dui — wet-pile fermentation over 45–60 days. The cup tastes of wet earth, mushrooms, prune, dark cocoa and notes of bark; the liquor is deep chestnut, the body dense, with no smoke. The benchmark of the shu style: the cake every shu drinker starts with.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, ґайвань 120 мл або іcінський чайник (саме шу любить глину). 7 г на 100 мл, обов'язковий промив 10 секунд. Перші проливи 5–8 секунд. 10–12 проливів; останні 2–3 можна доварити в чаєварці.",
    brewingEn:
        "100 °C, 120 ml gaiwan or Yixing pot (shu loves clay). 7 g per 100 ml, mandatory 10-second rinse. First steeps 5–8 seconds. 10–12 brews; the last two or three can be simmered in a kettle.",
  ),
  "Гун Тін": TeaVariety(
    infoUk:
        "«Палацовий» — найвищий ґатунок шу пуера, складений лише з найдрібніших золотавих бруньок (а не цілого листа). Ферментується делікатніше і коротше за стандартний рецепт, щоб не зруйнувати тонкий лист. Смак чистіший за звичайний шу: солодке какао, темний шоколад, ноти жареного зерна і фініка, без болотної землистості; післясмак довгий і солодкий. Назва натякає на історичний імператорський рівень якості.",
    infoEn:
        "'Imperial Palace' — the top grade of shu pu-erh, made exclusively from the smallest golden buds (not whole leaves). Fermentation is gentler and shorter than for the standard recipe, to spare the delicate buds. The cup is cleaner than ordinary shu: sweet cocoa, dark chocolate, notes of roasted grain and date, with none of the swampy-earth register; the aftertaste is long and sweet. The name evokes a historic imperial-level grade.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "95–100 °C, порцеляновий ґайвань 120 мл (тонкий лист краще проявляє себе в порцеляні, ніж у глині). 6 г на 100 мл, короткий промив 5 секунд. Перші проливи 5–8 секунд. 8–10 проливів.",
    brewingEn:
        "95–100 °C, 120 ml porcelain gaiwan (the fine bud shows better in porcelain than in clay). 6 g per 100 ml, brief 5-second rinse. First steeps 5–8 seconds. 8–10 brews.",
  ),
  "Лао Ча Тоу": TeaVariety(
    infoUk:
        "«Старі чайні голівки» — щільні грудки, що утворюються природним чином під час «во дуй» ферментації шу пуера: пектини склеюють листя у тверді самородки, які потім відсортовують. Ферментуються довше за решту купи, тому смак дуже солодкий і насичений, з нотами чорносливу, інжиру, темної патоки і шкіряної м'якості. Тіло густе, ледь в'язке. Один з найекономічніших чаїв — голівки витримують надзвичайно багато проливів.",
    infoEn:
        "'Old Tea Heads' — dense nuggets that form naturally during shu pu-erh wet-piling: pectins glue the leaves into hard lumps that are sorted out afterwards. Because they ferment longer than the surrounding pile, they taste exceptionally sweet and rich, with notes of prune, fig, dark molasses and a leathery softness. The body is thick, almost viscous. Among the most economical of teas — the nuggets stand up to extraordinary numbers of steeps.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, іcінський чайник (тверді грудки потребують часу і тепла, щоб розкритися). 7 г на 100 мл, промив 15 секунд. Перші проливи 30 секунд — голівки розкриваються повільно. 12–15 проливів; чудово варяться на плиті.",
    brewingEn:
        "100 °C, Yixing pot (the hard nuggets need time and heat to open). 7 g per 100 ml, 15-second rinse. First steeps 30 seconds — the nuggets open slowly. 12–15 brews; they simmer beautifully on the stove.",
  ),
  "Чень Пі Пуер": TeaVariety(
    infoUk:
        "Шу пуер, набитий усередину висушеної шкірки мандарина сорту чень пі (Citrus reticulata Blanco) з повіту Сіньхуей у Гуандуні. Шкірку традиційно витримують від 3 до 30 років — чим старіша, тим цінніша. Чай і шкірка дозрівають разом, обмінюючись ароматами: пуер набуває цитрусової свіжості, шкірка — землистої глибини. У китайській медицині цінується за гармонійний вплив на травлення і дихання. Класичний домашній зимовий чай Гуандуну.",
    infoEn:
        "Shu pu-erh stuffed inside the dried peel of the chen pi mandarin (Citrus reticulata Blanco) from Xinhui county in Guangdong. The peel is traditionally aged from 3 up to 30 years — the older, the more prized. Tea and peel ripen together, swapping aromas: the pu-erh acquires citrus brightness, the peel an earthy depth. Chinese medicine values it for its balancing action on digestion and breathing. The classic domestic winter tea of Guangdong.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, іcінський чайник або ґайвань 150 мл. Один цілий мандарин на чайник або 5 г розламаного на 100 мл. Промив 15 секунд. Перші проливи 15–20 секунд. 10–12 проливів; чудово розкривається при варінні.",
    brewingEn:
        "100 °C, Yixing pot or 150 ml gaiwan. One whole mandarin per pot, or 5 g of broken pieces per 100 ml. 15-second rinse. First steeps 15–20 seconds. 10–12 brews; opens beautifully when simmered.",
  ),

  // ─── Хей-ча (темні чаї) ──────────────────────────────────────────────────
  "Аньхуа Хей Чжуань": TeaVariety(
    infoUk:
        "«Хунаньська чорна цегла» — пресований хей-ча з повіту Аньхуа в провінції Хунань, історично один з основних «прикордонних чаїв», який караванами везли до Тибету і Монголії. Виготовляється з грубого літнього листя, яке ферментується природним способом, потім пресується у тверді цегли. Смак — солодкі сухофрукти, чорнослив, легка димка соснового вогню, ноти зернового хліба і теплої деревини. Витриманий 10+ років стає глибоко солодким, без землистості шу.",
    infoEn:
        "'Hunan Dark Brick' — a pressed hei cha from Anhua county in Hunan, historically one of the major 'frontier teas' carried by caravan to Tibet and Mongolia. Made from coarse summer leaves that ferment naturally, then pressed into hard bricks. The cup tastes of sweet dried fruit, prune, a faint pine-fire smoke, notes of grain bread and warm wood. After 10+ years it grows deeply sweet, without the earthiness of shu.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, іcінський чайник або ґайвань 150 мл. 6 г на 100 мл, промив 15 секунд. Перші проливи 10 секунд. 10–12 проливів. Традиційно аньхуаські чаї варять у казані з молоком і сіллю — як це роблять у Тибеті.",
    brewingEn:
        "100 °C, Yixing pot or 150 ml gaiwan. 6 g per 100 ml, 15-second rinse. First steeps 10 seconds. 10–12 brews. Traditionally, Anhua teas are simmered in a cauldron with milk and salt — Tibet style.",
  ),
  "Фу Чжуань": TeaVariety(
    infoUk:
        "«Фу-цегла» — хунаньський пресований хей-ча, унікальний наявністю «золотих квітів» (jīn huā) — корисного грибка Eurotium cristatum, який цілеспрямовано культивується всередині цегли в умовах контрольованої вологості. Грибок створює характерний аромат сушеного грибу, м'якого зерна, легкої горіхово-кокосової солодкості. Історично — основний чай Шовкового шляху до Сіньцзяну і Центральної Азії. Без «золотих квітів» Фу Чжуань не вважається автентичним.",
    infoEn:
        "'Fu Brick' — a Hunan pressed hei cha distinguished by its 'golden flowers' (jīn huā) — the beneficial fungus Eurotium cristatum, deliberately cultivated inside the brick under controlled humidity. The fungus develops the signature aroma of dried mushroom, soft grain and a gentle nut-and-coconut sweetness. Historically the staple Silk Road tea of Xinjiang and Central Asia. Without the golden flowers, a Fu brick is not considered authentic.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, іcінський чайник або ґайвань 150 мл. 6 г на 100 мл, промив 15 секунд. Перші проливи 10 секунд. 10–12 проливів. Чудово витримує тривале варіння.",
    brewingEn:
        "100 °C, Yixing pot or 150 ml gaiwan. 6 g per 100 ml, 15-second rinse. First steeps 10 seconds. 10–12 brews. Stands up to long simmering.",
  ),
  "Цянь Лян Ча": TeaVariety(
    infoUk:
        "«Чай у тисячу лянів» — найбільш видовищна форма аньхуаського хей-ча: пресовані циліндри вагою близько 36,25 кг (тисяча старих китайських лянів), упаковані в плетений бамбук, очерет і пальмове листя. Виготовляються вручну: лист трамбують у форму спеціальними дерев'яними стовпами. Дозрівають десятиліттями просто неба. Смак — глибокий, із нотами лісової деревини, бамбукового листя, темного меду і тривалої сухофруктової солодкості. Уламок такого стовпа — серйозний інвестиційний об'єкт.",
    infoEn:
        "'Thousand-Tael Tea' — the most theatrical form of Anhua hei cha: pressed cylinders weighing about 36.25 kg (a thousand old Chinese tael), wrapped in plaited bamboo, reed and palm leaf. Hand-made: the leaf is tamped into the mould with heavy wooden poles. They age outdoors for decades. The cup is deep, with notes of forest wood, bamboo leaf, dark honey and a long dried-fruit sweetness. A slice off such a pillar is a serious collector's piece.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, іcінський чайник 150 мл. 6 г на 100 мл, обов'язковий промив 15 секунд. Перші проливи 10 секунд. 10–12 проливів. Старіший Цянь Лян (15+ років) краще варити на плиті — настій густішає, як патока.",
    brewingEn:
        "100 °C, 150 ml Yixing pot. 6 g per 100 ml, mandatory 15-second rinse. First steeps 10 seconds. 10–12 brews. Aged Qian Liang (15+ years) is best simmered on the stove — the liquor thickens like molasses.",
  ),

  // ─── Лю Бао ──────────────────────────────────────────────────────────────
  "Молодий Лю Бао": TeaVariety(
    infoUk:
        "Лю Бао («Шість фортець») — традиційний хей-ча з повіту Цаньу в Гуансі, історично основний чай малайських олов'яних шахт XIX століття. Молодий Лю Бао (1–3 роки) ще зберігає трав'янисту димну ноту після купної ферментації; смак — мокра деревина, легка камфора, землиста основа і ще трохи різкуватий післясмак. Через кілька років у вологому підвалі пом'якшується і набуває характерної арека-горіхової солодкості.",
    infoEn:
        "Liu Bao ('Six Fortresses') — a traditional hei cha from Cangwu county in Guangxi, historically the staple tea of 19th-century Malay tin miners. Young Liu Bao (1–3 years) still carries a grassy smoky edge from wet-pile fermentation; the cup tastes of wet wood, faint camphor, an earthy base and a still-slightly-sharp finish. After a few years in a humid cellar it softens and develops the signature areca-nut sweetness.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, іcінський чайник або ґайвань 120 мл. 6 г на 100 мл, промив 15 секунд. Перші проливи 10 секунд. 8–10 проливів.",
    brewingEn:
        "100 °C, Yixing pot or 120 ml gaiwan. 6 g per 100 ml, 15-second rinse. First steeps 10 seconds. 8–10 brews.",
  ),
  "Витриманий Лю Бао": TeaVariety(
    infoUk:
        "Витриманий Лю Бао (10+ років, традиційно у вологих підвалах Гуансі або Гонконгу) — еталон зрілого хей-ча. Молодий димно-землистий характер повністю переходить у глибоку солодкість арека-горіха, темної деревини, сушеного фініка і вологого підвалу. Тіло густе, маслянисте; післясмак довгий, з характерною «стільниковою» прохолодою. У південному Китаї та Малайзії вважається основним «чаєм здоров'я» — особливо для травлення і в дощові сезони.",
    infoEn:
        "Aged Liu Bao (10+ years, traditionally in the humid cellars of Guangxi or Hong Kong) is the benchmark mature hei cha. The young smoky-earthy character resolves entirely into a deep sweetness of areca nut, dark wood, dried date and damp cellar. The body is thick and oily; the aftertaste long, with a characteristic 'honeycomb' cool finish. In southern China and Malaysia it is considered a foundational 'health tea', particularly for digestion and during rainy seasons.",
    legendUk: "",
    legendEn: "",
    brewingUk:
        "100 °C, іcінський чайник 120 мл. 7 г на 100 мл, промив 15 секунд. Перші проливи 8 секунд. 12–15 проливів. Витриманий Лю Бао блискуче розкривається при тривалому варінні — його так традиційно п'ють у Малайзії в теракотовому глеку.",
    brewingEn:
        "100 °C, 120 ml Yixing pot. 7 g per 100 ml, 15-second rinse. First steeps 8 seconds. 12–15 brews. Aged Liu Bao opens brilliantly under long simmering — this is how it has traditionally been drunk in Malaysia, in a terracotta jug.",
  ),
};

/// Look up the tea variety details for a given subVariety key. Returns null
/// if the key is not present in [teaVarieties].
TeaVariety? varietyForSubVariety(String key) => teaVarieties[key];

/// Look up the tea pairing for a given kō index. Returns null if absent.
TeaPairing? teaForKo(int index) => teaPairings[index];
