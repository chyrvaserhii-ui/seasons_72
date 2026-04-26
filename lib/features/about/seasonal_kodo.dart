/// Seasonal kōdō (香道) — incense pairings for each of the 72 kō.
///
/// The Heian court formalised six classical *neriko* (練香) seasonal
/// blends — baika (plum), kayō (lotus leaf), kikka (chrysanthemum),
/// rakuyō (fallen leaves), umemurasaki, and kurobō (dark blend) — and
/// later the Edo *kumikō* (組香) tradition catalogued dozens of named
/// scent themes such as Genji-kō, Yumeji, Hanagatami, Tsukimi-kō, and
/// Takasago. The pairings here use those historical anchors where they
/// fit, and otherwise compose a faithful seasonal blend from the
/// classical *rikkoku gomi* (六国五味) framework: six origins of
/// agarwood (kyara, rakoku, manaka, manaban, sumotara, sasora) crossed
/// with five flavour notes (sweet, sour, bitter, salty, pungent), plus
/// supporting woods and resins.
library seasonal_kodo;

/// One incense pairing for a single kō.
class KodoPairing {
  const KodoPairing({
    required this.japanese,
    required this.romaji,
    required this.nameUk,
    required this.nameEn,
    required this.ingredients,
    required this.themeUk,
    required this.themeEn,
    required this.noteUk,
    required this.noteEn,
  });

  /// Name of the blend in Japanese, e.g. "梅花", "黒方", "夢路香".
  final String japanese;

  /// Hepburn romaji, e.g. "baika", "kurobō", "yumeji-kō".
  final String romaji;

  /// Ukrainian gloss with brief explanation in parentheses.
  final String nameUk;

  /// English gloss.
  final String nameEn;

  /// Three to six classical incense ingredients in Hepburn romaji.
  /// Use canonical names: jinkō (沈香 agarwood), byakudan (白檀
  /// sandalwood), chōji (丁子 clove), kunroku (薫陸 frankincense),
  /// kanshō (甘松 spikenard), reiryōkō (零陵香 mat-grass), kyara (伽羅
  /// premium agarwood), rakoku (羅国), manaka (真那賀), manaban (真南蛮),
  /// sumotara (寸聞多羅), sasora (佐曾羅), kasshoku-kō, jakō (musk),
  /// hakkasshō (mint), etc.
  final List<String> ingredients;

  /// One-line emotional or imagistic theme in Ukrainian, e.g.
  /// "пам'ять про того, кого вже немає поряд" / "memory of one no
  /// longer near". ≤80 chars.
  final String themeUk;

  /// English version of [themeUk].
  final String themeEn;

  /// 1–2 quietly poetic sentences linking the blend to the kō.
  final String noteUk;
  final String noteEn;
}

const Map<int, KodoPairing> seasonalKodo = {
  // ─── Spring ───

  // Kō 1 — East wind melts the ice (harukaze kōri o toku)
  1: KodoPairing(
    japanese: '梅が枝',
    romaji: 'umegae',
    nameUk: 'Умеґае (гілка сливи — варіація баіка)',
    nameEn: 'Umegae (plum branch, a baika variant)',
    ingredients: ['jinkō', 'kanshō', 'chōji', 'byakudan', 'kunroku'],
    themeUk: 'перший теплий подих, що торкається крижаної гілки',
    themeEn: 'the first warm breath touching an icebound branch',
    noteUk:
        'Класична варіація баіка, з ноткою прянощів, що обіцяє цвіт. Сухий лід ще тримає річку, але дим уже знає сливу.',
    noteEn:
        'A classical baika variation, spice-edged with the promise of bloom. The river is still ice, but the smoke already knows the plum.',
  ),

  // Kō 2 — Bush warbler starts singing (uguisu naku)
  2: KodoPairing(
    japanese: '鶯香',
    romaji: 'uguisu-kō',
    nameUk: 'Уґуісу-ко (вівчарик — едо-комбінація)',
    nameEn: 'Uguisu-kō (bush warbler, Edo kumikō game)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'reiryōkō'],
    themeUk: 'голос, що вгадується раніше за самого співака',
    themeEn: 'a voice guessed at before the singer is seen',
    noteUk:
        'Едоська комбінаційна гра наслідує співака серед гілок: легкий дзинко (агар) з прохолодним сандалом, без важких смол.',
    noteEn:
        'An Edo incense game traces the singer among branches: light jinkō (agarwood) over cool sandalwood, no heavy resins.',
  ),

  // Kō 3 — Fish emerge from the ice (uo kōri o izuru)
  3: KodoPairing(
    japanese: '魚香',
    romaji: 'uo-kō',
    nameUk: 'Уо-ко (риба, що сходить з-під криги — сучасна композиція)',
    nameEn: 'Uo-kō (fish from beneath ice, modern composition)',
    ingredients: ['manaka', 'byakudan', 'kanshō', 'hakkasshō'],
    themeUk: 'рух під сріблом, який чути раніше, ніж видно',
    themeEn: 'a movement under silver, heard before it is seen',
    noteUk:
        'Сучасна композиція в реєстрі кодо: манака (солодкий агар) без солодощі, з прохолодою м’яти — щоб чулася течія, а не риба.',
    noteEn:
        'A modern composition in the kōdō register: manaka (sweet agar) without sweetness, mint-cool, so the current shows rather than the fish.',
  ),

  // Kō 4 — Rain moistens the soil (tsuchi no shō uruoi okoru)
  4: KodoPairing(
    japanese: '土香',
    romaji: 'tsuchi-kō',
    nameUk: 'Цуті-ко (вологий ґрунт — сучасна композиція)',
    nameEn: 'Tsuchi-kō (moistened earth, modern composition)',
    ingredients: ['rakoku', 'kanshō', 'kunroku', 'byakudan'],
    themeUk: 'запах землі, що згадала, як бути живою',
    themeEn: 'the smell of earth remembering it is alive',
    noteUk:
        'Сучасна композиція: ракоку (тайський агар) з гірчинкою, мускатна канше (нард), ладан-кунроку — глибокий, низовий, як перший дощ по полю.',
    noteEn:
        'A modern composition in kōdō register: bitter rakoku (Thai agar), musky kanshō (spikenard), kunroku (frankincense) frankincense — low, deep, the first rain over a field.',
  ),

  // Kō 5 — Mist begins to linger (kasumi hajimete tanabiku)
  5: KodoPairing(
    japanese: '霞香',
    romaji: 'kasumi-kō',
    nameUk: 'Касумі-ко (весняна імла — сучасна композиція)',
    nameEn: 'Kasumi-kō (spring haze, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'reiryōkō', 'kanshō'],
    themeUk: 'тонкий шар, крізь який світ виглядає м’якшим',
    themeEn: 'a thin layer through which the world looks softer',
    noteUk:
        'Сучасна композиція: білий сандал переважає над дзинко (агар), рейрьоко (трав’яниста матка) додає прохолодну траву — імла, а не дим.',
    noteEn:
        'A modern composition: byakudan (sandalwood) dominates over jinkō (agarwood); reiryōkō (sweet-flag grass) adds cool meadow grass. Haze, not smoke.',
  ),

  // Kō 6 — Grasses sprout, trees bud (sōmoku mebae izuru)
  6: KodoPairing(
    japanese: '萌香',
    romaji: 'moe-kō',
    nameUk: 'Мое-ко (зелений пагін — сучасна композиція)',
    nameEn: 'Moe-kō (sprouting green, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'manaka', 'reiryōkō'],
    themeUk: 'крихкість, що тримається на власному світлі',
    themeEn: 'a fragility that holds itself up by its own light',
    noteUk:
        'Сучасна композиція: ясний сандал з ноткою свіжого пагона. Жодних важких смол — тільки те, що щойно прокинулося.',
    noteEn:
        'A modern composition: bright sandalwood with a young-shoot edge. No heavy resins — only what has just woken.',
  ),

  // Kō 7 — Hibernating insects open (sugomori mushi to o hiraku)
  7: KodoPairing(
    japanese: '蟄香',
    romaji: 'chitsu-kō',
    nameUk: 'Тіцу-ко (комахи виходять — сучасна композиція)',
    nameEn: 'Chitsu-kō (insects emerging, modern composition)',
    ingredients: ['rakoku', 'kanshō', 'chōji', 'byakudan'],
    themeUk: 'двері відчиняються зсередини землі',
    themeEn: 'a door opening from inside the earth',
    noteUk:
        'Сучасна композиція: ракоку (тайський агар) з пряним гвоздичним краєм, низова канше (нард) — землиста, прокидлива, ще не радісна.',
    noteEn:
        'A modern composition: rakoku (Thai agar) with a clove-spiced edge over earthy kanshō (spikenard) — earthen, waking, not yet glad.',
  ),

  // Kō 8 — First peach blossoms (momo hajimete saku)
  8: KodoPairing(
    japanese: '花競香',
    romaji: 'hanakurabe-kō',
    nameUk: 'Ханакурабе-ко (змагання квітів — едо-гра)',
    nameEn: 'Hanakurabe-kō (flower-comparing, Edo kumikō)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'chōji'],
    themeUk: 'дві квітки, які ніколи не побачать одна одну',
    themeEn: 'two blossoms that will never see each other',
    noteUk:
        'Едоська гра порівняння квітів: збалансований дзинко (агар) з солодкою канше (нард) — пишно, але стримано, як перський персиковий цвіт.',
    noteEn:
        'An Edo flower-comparing game: balanced jinkō (agarwood) with sweet kanshō (spikenard) — lush yet restrained, like the first peach flower.',
  ),

  // Kō 9 — Caterpillars become butterflies (namushi chō to naru)
  9: KodoPairing(
    japanese: '蝶香',
    romaji: 'chō-kō',
    nameUk: 'Тьо-ко (метелик — сучасна композиція)',
    nameEn: 'Chō-kō (butterfly, modern composition)',
    ingredients: ['byakudan', 'manaka', 'kanshō', 'jinkō'],
    themeUk: 'тіло, яке несподівано вміє літати',
    themeEn: 'a body that quite suddenly knows how to fly',
    noteUk:
        'Сучасна композиція в стилі кодо: легка манака (солодкий агар) над сандалом, із крапелькою дзинко (агар) — крило торкається повітря і нічого не важить.',
    noteEn:
        'A modern composition in kōdō register: light manaka (sweet agar) over sandalwood with a drop of jinkō (agarwood) — a wing meets the air and weighs nothing.',
  ),

  // Kō 10 — Sparrows begin to nest (suzume hajimete sukuu)
  10: KodoPairing(
    japanese: '巣香',
    romaji: 'su-kō',
    nameUk: 'Су-ко (гніздо — сучасна композиція)',
    nameEn: 'Su-kō (the nest, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'reiryōkō', 'kunroku'],
    themeUk: 'мала кругла кімнатка, зроблена з трави й волосся',
    themeEn: 'a small round room made of grass and hair',
    noteUk:
        'Сучасна композиція: тепла канше (нард) і трав’яна рейрьоко (трав’яниста матка) довкола сандала — затишок, без надмірної солодкості.',
    noteEn:
        'A modern composition: warm kanshō (spikenard) and grassy reiryōkō (sweet-flag grass) around sandalwood — a small warmth, without too much sweetness.',
  ),

  // Kō 11 — First cherry blossoms (sakura hajimete hiraku)
  11: KodoPairing(
    japanese: '桜花',
    romaji: 'ōka',
    nameUk: 'Ока (вишневий цвіт — реконструкція)',
    nameEn: 'Ōka (cherry blossom, reconstructed neriko)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'chōji', 'kunroku'],
    themeUk: 'миттєвість, яку домовилися називати красою',
    themeEn: 'a brief instant agreed upon as beauty',
    noteUk:
        'Реконструйований неріко в традиції баіка: дзинко (агар) й сандал у рівних долях, прянощі лише натяком, щоб не заглушити білого цвіту.',
    noteEn:
        'A reconstructed neriko in the baika lineage: jinkō (agarwood) and byakudan (sandalwood) in equal measure, spice only as hint, lest it muffle the white bloom.',
  ),

  // Kō 12 — Distant thunder (kaminari sunawachi koe o hassu)
  12: KodoPairing(
    japanese: '雷香',
    romaji: 'kaminari-kō',
    nameUk: 'Камінарі-ко (далекий грім — едо-комбінація)',
    nameEn: 'Kaminari-kō (distant thunder, Edo kumikō)',
    ingredients: ['kyara', 'rakoku', 'kunroku', 'jakō'],
    themeUk: 'звук, що дозволяє розрізнити, скільки до нього миль',
    themeEn: 'a sound that lets you measure miles by listening',
    noteUk:
        'Едоська гра грому: глибока кяра (преміум-агар) з ладаном і мускусом — низькі ноти, що відлунюють у грудях, мов гул за горизонтом.',
    noteEn:
        'An Edo thunder game: deep kyara (premium agar) with kunroku (frankincense) and jakō (musk) — low notes echoing in the chest like a rumble past the horizon.',
  ),

  // Kō 13 — Swallows return (tsubame kitaru)
  13: KodoPairing(
    japanese: '燕香',
    romaji: 'tsubame-kō',
    nameUk: 'Цубаме-ко (ластівка — сучасна композиція)',
    nameEn: 'Tsubame-kō (swallow, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'manaka'],
    themeUk: 'двічі за рік — дім, удвічі віддалений',
    themeEn: 'twice a year, a home held at double distance',
    noteUk:
        'Сучасна композиція: швидкі ноти манаки (солодкого агару) над сандалом, дзинко (агар) лиш як тихе підкладдя — політ, який щойно повернувся.',
    noteEn:
        'A modern composition: quick manaka (sweet agar) over sandalwood, jinkō (agarwood) only as quiet ground — a flight only just returned.',
  ),

  // Kō 14 — Wild geese fly north (kōgan kaeru)
  14: KodoPairing(
    japanese: '帰雁香',
    romaji: 'kigan-kō',
    nameUk: 'Кіґан-ко (гуси відлітають — сучасна композиція)',
    nameEn: 'Kigan-kō (geese departing, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'reiryōkō'],
    themeUk: 'клин, який знає шлях, не бачивши карти',
    themeEn: 'a wedge that knows the road without a map',
    noteUk:
        'Сучасна композиція: рівний дзинко (агар) з трав’яною прохолодою — небо без жалю, тільки рівний рух на північ.',
    noteEn:
        'A modern composition: even jinkō (agarwood) with grassy coolness — a sky without regret, just steady motion northward.',
  ),

  // Kō 15 — First rainbows (niji hajimete arawaru)
  15: KodoPairing(
    japanese: '虹香',
    romaji: 'niji-kō',
    nameUk: 'Ніджі-ко (перша веселка — сучасна композиція)',
    nameEn: 'Niji-kō (first rainbow, modern composition)',
    ingredients: ['byakudan', 'manaka', 'kanshō', 'reiryōkō', 'jinkō'],
    themeUk: 'міст із світла над водою, що його не перейти',
    themeEn: 'a bridge of light over water that no foot can cross',
    noteUk:
        'Сучасна композиція: прозорі шари сандала, манаки (солодкого агару) й трави — кожен інгредієнт окремо чути, як кожен колір у дузі.',
    noteEn:
        'A modern composition: transparent layers of byakudan (sandalwood), manaka (sweet agar) and grass — each ingredient audible separately, like every band in the arc.',
  ),

  // Kō 16 — First reeds sprout (ashi hajimete shōzu)
  16: KodoPairing(
    japanese: '葦香',
    romaji: 'ashi-kō',
    nameUk: 'Аші-ко (молодий очерет — сучасна композиція)',
    nameEn: 'Ashi-kō (young reed, modern composition)',
    ingredients: ['byakudan', 'reiryōkō', 'kanshō', 'manaka'],
    themeUk: 'тонке зелене лезо, яке вже стоїть прямо',
    themeEn: 'a thin green blade already standing straight',
    noteUk:
        'Сучасна композиція: трав’яна рейрьоко (трав’яниста матка) з прохолодним сандалом — повітря над весняним озером, без важкої деревини.',
    noteEn:
        'A modern composition: grassy reiryōkō (sweet-flag grass) with cool sandalwood — air above a spring lake, no heavy wood.',
  ),

  // Kō 17 — Last frost, rice seedlings rise (shimo yamite nae izuru)
  17: KodoPairing(
    japanese: '苗香',
    romaji: 'nae-kō',
    nameUk: 'Нае-ко (рисове розсадне поле — сучасна композиція)',
    nameEn: 'Nae-kō (rice seedling, modern composition)',
    ingredients: ['byakudan', 'manaka', 'kanshō', 'kunroku'],
    themeUk: 'обіцянка, дана від поля до людини',
    themeEn: 'a promise given from a field to a person',
    noteUk:
        'Сучасна композиція: лагідна манака (солодкий агар) з тихою канше (нард) — родюча, без жодної темряви, як перший зелений ряд на воді.',
    noteEn:
        'A modern composition: gentle manaka (sweet agar) with quiet kanshō (spikenard) — fertile, with no darkness, like the first green row on water.',
  ),

  // Kō 18 — Peonies bloom (botan hana saku)
  18: KodoPairing(
    japanese: '春日香',
    romaji: 'kasuga-kō',
    nameUk: 'Касуґа-ко (весняна оленяча гора — едо-комбінація)',
    nameEn: 'Kasuga-kō (spring deer at Kasuga, Edo kumikō)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'chōji', 'kunroku'],
    themeUk: 'останній день, коли ще можна сказати «весна»',
    themeEn: 'the last day on which "spring" can still be said',
    noteUk:
        'Едоська гра святого касузького лугу: повний неріко-стиль із дзинко (агар), сандалом і пряностями — тепло на порозі літа.',
    noteEn:
        'An Edo Kasuga-meadow game: full neriko style with jinkō (agarwood), sandalwood and spice — warmth on the threshold of summer.',
  ),

  // ─── Summer ───

  // Kō 19 — Frogs begin to sing (kawazu hajimete naku)
  19: KodoPairing(
    japanese: '蛙香',
    romaji: 'kawazu-kō',
    nameUk: 'Кавазу-ко (весняна жаба — сучасна композиція)',
    nameEn: 'Kawazu-kō (frog song, modern composition)',
    ingredients: ['byakudan', 'reiryōkō', 'manaka', 'hakkasshō'],
    themeUk: 'хор, що починається з однієї горлянки в осоці',
    themeEn: 'a chorus that begins with one throat in the sedge',
    noteUk:
        'Сучасна композиція: водяний сандал, болотна рейрьоко (трав’яниста матка) й крапля м’яти — чути не жабу, а вологу темряву довкола неї.',
    noteEn:
        'A modern composition: watery byakudan (sandalwood), marsh-grass reiryōkō (sweet-flag grass) and a drop of mint — what is heard is not the frog but the wet dark around it.',
  ),

  // Kō 20 — Worms surface (mimizu izuru)
  20: KodoPairing(
    japanese: '蚯香',
    romaji: 'kyū-kō',
    nameUk: 'Кю-ко (дощовий черв’як — сучасна композиція)',
    nameEn: 'Kyū-kō (earthworm, modern composition)',
    ingredients: ['rakoku', 'byakudan', 'kanshō', 'kunroku'],
    themeUk: 'тихий ткач, що лагодить ґрунт',
    themeEn: 'a quiet weaver mending the soil',
    noteUk:
        'Сучасна композиція: гірчинка ракоку (тайський агар) у фоні землистого сандала — без героїки, лише невидима робота під ногами.',
    noteEn:
        'A modern composition: the bitter edge of rakoku (Thai agar) in earthy sandalwood — no heroism, only the invisible labour under foot.',
  ),

  // Kō 21 — Bamboo shoots emerge (takenoko shōzu)
  21: KodoPairing(
    japanese: '筍香',
    romaji: 'takenoko-kō',
    nameUk: 'Такеноко-ко (паросток бамбука — сучасна композиція)',
    nameEn: 'Takenoko-kō (bamboo shoot, modern composition)',
    ingredients: ['byakudan', 'manaka', 'reiryōkō', 'hakkasshō'],
    themeUk: 'вертикаль, що вирішила існувати за один день',
    themeEn: 'a vertical that decided to exist in a day',
    noteUk:
        'Сучасна композиція: майже зелений сандал, трав’яний дим, прохолодна м’ята — швидкий і чистий пагін.',
    noteEn:
        'A modern composition: almost-green sandalwood, grassy smoke, cool mint — a swift, clean shoot.',
  ),

  // Kō 22 — Silkworms feast on mulberry (kaiko okite kuwa o hamu)
  22: KodoPairing(
    japanese: '蚕香',
    romaji: 'kaiko-kō',
    nameUk: 'Кайко-ко (шовкопряд — сучасна композиція)',
    nameEn: 'Kaiko-kō (silkworm, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'manaka', 'reiryōkō'],
    themeUk: 'тиша, з якої вже виходить нитка',
    themeEn: 'a silence from which a thread is already coming',
    noteUk:
        'Сучасна композиція: лагідний сандал з шовковистою канше (нард) — мирне жування шовковичних листків у кошику.',
    noteEn:
        'A modern composition: gentle sandalwood with silky kanshō (spikenard) — the peaceful chewing of mulberry leaves in a basket.',
  ),

  // Kō 23 — Safflowers bloom (benibana sakau)
  23: KodoPairing(
    japanese: '紅花香',
    romaji: 'benibana-kō',
    nameUk: 'Бенібана-ко (сафлор — сучасна композиція)',
    nameEn: 'Benibana-kō (safflower, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'chōji'],
    themeUk: 'жовте, що знає, що буде червоним',
    themeEn: 'a yellow that knows it will become red',
    noteUk:
        'Сучасна композиція: сандал із крапелькою дзинко (агар) й гвоздики — теплий пігмент, з якого жінки колись фарбували уста.',
    noteEn:
        'A modern composition: sandalwood with a touch of jinkō (agarwood) and clove — the warm pigment with which women once dyed their lips.',
  ),

  // Kō 24 — Wheat ripens and is harvested (mugi no toki itaru)
  24: KodoPairing(
    japanese: '麦香',
    romaji: 'mugi-kō',
    nameUk: 'Муґі-ко (стиглий ячмінь — сучасна композиція)',
    nameEn: 'Mugi-kō (ripening wheat, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'kunroku', 'reiryōkō'],
    themeUk: 'золоте поле, що шумить, як спокійне море',
    themeEn: 'a golden field that sounds like a quiet sea',
    noteUk:
        'Сучасна композиція: сухий сандал, медова канше (нард) й трав’янистий ладан — спокійна повнота перед серпом.',
    noteEn:
        'A modern composition: dry sandalwood, honeyed kanshō (spikenard) and grassy kunroku (frankincense) — a calm fullness before the sickle.',
  ),

  // Kō 25 — Praying mantis hatches (kamakiri shōzu)
  25: KodoPairing(
    japanese: '蟷螂香',
    romaji: 'tōrō-kō',
    nameUk: 'Торо-ко (богомол — сучасна композиція)',
    nameEn: 'Tōrō-kō (mantis hatching, modern composition)',
    ingredients: ['byakudan', 'manaka', 'reiryōkō', 'hakkasshō'],
    themeUk: 'хижак на висоті стебла',
    themeEn: 'a predator at the height of a stem',
    noteUk:
        'Сучасна композиція: різкуватий сандал з нотою свіжої трави й м’яти — увага, що склалася в тонке зелене тіло.',
    noteEn:
        'A modern composition: keen sandalwood with fresh grass and mint — attention folded into a thin green body.',
  ),

  // Kō 26 — Rotten grass becomes fireflies (kusaretaru kusa hotaru to naru)
  26: KodoPairing(
    japanese: '蛍香',
    romaji: 'hotaru-kō',
    nameUk: 'Хотару-ко (світлячок — сучасна композиція)',
    nameEn: 'Hotaru-kō (firefly, modern composition)',
    ingredients: ['byakudan', 'manaka', 'reiryōkō', 'hakkasshō'],
    themeUk: 'крапля світла, що пам’ятає, як бути живою',
    themeEn: 'a drop of light that remembers being alive',
    noteUk:
        'Сучасна композиція: водянисто-прохолодний сандал з ноткою м’яти й вологої трави — без жодного диму, лише сяйво.',
    noteEn:
        'A modern composition: water-cool sandalwood with mint and wet grass — no smoke at all, only glow.',
  ),

  // Kō 27 — Plums turn yellow (ume no mi kibamu)
  27: KodoPairing(
    japanese: '熟梅香',
    romaji: 'jukubai-kō',
    nameUk: 'Дзюкубай-ко (стигла слива — сучасна композиція)',
    nameEn: 'Jukubai-kō (ripening plum, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'chōji'],
    themeUk: 'кислий запах, що солодшає, не помічаючи цього',
    themeEn: 'a sourness that turns sweet without noticing',
    noteUk:
        'Сучасна композиція: дзинко (агар) з сандалом і дрібкою гвоздики — кисло-солодка зрілість плоду під літнім сонцем.',
    noteEn:
        'A modern composition: jinkō (agarwood) and sandalwood with a pinch of clove — sour-sweet ripeness in summer light.',
  ),

  // Kō 28 — Self-heal grass withers (natsukarekusa karuru)
  28: KodoPairing(
    japanese: '夏枯香',
    romaji: 'natsugare-kō',
    nameUk: 'Нацуґаре-ко (літня посуха трав — сучасна композиція)',
    nameEn: 'Natsugare-kō (summer-wilted herb, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'reiryōkō', 'kunroku'],
    themeUk: 'те, що відцвіло раніше, ніж літо стало літом',
    themeEn: 'what fades before summer is fully summer',
    noteUk:
        'Сучасна композиція: сухий сандал з ладаном і пожухлою травою — чесний запах сезону, який мало хто помічає.',
    noteEn:
        'A modern composition: dry sandalwood with kunroku (frankincense) and parched grass — the honest smell of a season few notice.',
  ),

  // Kō 29 — Irises bloom (ayame hana saku)
  29: KodoPairing(
    japanese: '菖蒲香',
    romaji: 'shōbu-kō',
    nameUk: 'Сьобу-ко (ірис, свято Танґо — едо-комбінація)',
    nameEn: 'Shōbu-kō (iris, Tango-no-Sekku, Edo kumikō)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'reiryōkō'],
    themeUk: 'листя, з якого виходить запах, важливіший за квітку',
    themeEn: 'a leaf whose scent matters more than its flower',
    noteUk:
        'Едоська гра святого ірису: сандал-веде, дзинко (агар) як тінь, рейрьоко (трав’яниста матка) — як зелене листя над купіллю п’ятого місяця.',
    noteEn:
        'An Edo iris game: sandalwood leads, jinkō (agarwood) shadows, reiryōkō (sweet-flag grass) stands as the green leaf over a fifth-month bath.',
  ),

  // Kō 30 — Crow-dipper sprouts (hange shōzu)
  30: KodoPairing(
    japanese: '半夏香',
    romaji: 'hange-kō',
    nameUk: 'Ханґе-ко (середина літа — сучасна композиція)',
    nameEn: 'Hange-kō (mid-summer pinellia, modern composition)',
    ingredients: ['byakudan', 'reiryōkō', 'kanshō', 'manaka'],
    themeUk: 'мить, у яку рік розламується надвоє',
    themeEn: 'the moment when the year breaks in two',
    noteUk:
        'Сучасна композиція: трав’яний сандал із низовою канше (нард) — стиха, як день, від якого почнеться спад.',
    noteEn:
        'A modern composition: grassy sandalwood with low kanshō (spikenard) — quiet, like the day from which the year begins to descend.',
  ),

  // Kō 31 — Warm winds blow (atsukaze itaru)
  31: KodoPairing(
    japanese: '南風香',
    romaji: 'minamikaze-kō',
    nameUk: 'Мінамікадзе-ко (південний вітер — сучасна композиція)',
    nameEn: 'Minamikaze-kō (warm south wind, modern composition)',
    ingredients: ['byakudan', 'manaka', 'kanshō', 'hakkasshō'],
    themeUk: 'повітря, яке несе сіль і ще щось ласкаве',
    themeEn: 'air that carries salt and something kindly besides',
    noteUk:
        'Сучасна композиція: легка манака (солодкий агар) над сандалом, прохолодна м’ята — солоний бриз з півдня без важких ноток.',
    noteEn:
        'A modern composition: light manaka (sweet agar) over sandalwood, cool mint — a salt-laced south breeze, no heavy weight.',
  ),

  // Kō 32 — Lotus blossoms open (hasu hajimete hiraku)
  32: KodoPairing(
    japanese: '荷葉',
    romaji: 'kayō',
    nameUk: 'Каьо (лотосовий лист — класичний неріко)',
    nameEn: 'Kayō (lotus leaf, classical Heian neriko)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'chōji'],
    themeUk: 'квітка, що піднімається з мулу, але не пахне ним',
    themeEn: 'a flower that rises from mud yet does not smell of it',
    noteUk:
        'Класичний літній неріко двору Хейан: прохолодний дзинко (агар) з сандалом — менше солодощі, більше водянистої тиші.',
    noteEn:
        'A classical Heian summer neriko: cool jinkō (agarwood) with sandalwood — less sweetness, more watery stillness.',
  ),

  // Kō 33 — Hawks learn to fly (taka sunawachi waza o narau)
  33: KodoPairing(
    japanese: '鷹香',
    romaji: 'taka-kō',
    nameUk: 'Така-ко (молодий сокіл — сучасна композиція)',
    nameEn: 'Taka-kō (fledgling hawk, modern composition)',
    ingredients: ['jinkō', 'rakoku', 'byakudan', 'kanshō'],
    themeUk: 'перший круг, який обминає землю',
    themeEn: 'a first circle that just clears the ground',
    noteUk:
        'Сучасна композиція: дзинко (агар) з ракоку (тайський агар) і гострим краєм сандала — висота, ще не звична до власного імені.',
    noteEn:
        'A modern composition: jinkō (agarwood) with rakoku (Thai agar) and a keen sandalwood edge — altitude not yet used to its own name.',
  ),

  // Kō 34 — Paulownia trees produce seeds (kiri no hana musubu)
  34: KodoPairing(
    japanese: '桐香',
    romaji: 'kiri-kō',
    nameUk: 'Кірі-ко (павловнія — сучасна композиція)',
    nameEn: 'Kiri-kō (paulownia seed, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'kunroku'],
    themeUk: 'герб, що став насінням, і насіння, що стало гербом',
    themeEn: 'a crest become a seed, and the seed become a crest',
    noteUk:
        'Сучасна композиція: світлий сандал з тихим дзинко (агар) й ладаном — гідне дерево імператорського герба, без пафосу.',
    noteEn:
        'A modern composition: bright sandalwood with quiet jinkō (agarwood) and kunroku (frankincense) — the imperial-crest tree, without pomp.',
  ),

  // Kō 35 — Earth is damp, air is humid (tsuchi uruōte mushiatsushi)
  35: KodoPairing(
    japanese: '蒸香',
    romaji: 'jō-kō',
    nameUk: 'Дзьо-ко (паркий день — сучасна композиція)',
    nameEn: 'Jō-kō (humid heat, modern composition)',
    ingredients: ['byakudan', 'manaka', 'reiryōkō', 'hakkasshō'],
    themeUk: 'повітря, схоже на воду, у якій залишили рушник',
    themeEn: 'air that resembles water with a towel left in it',
    noteUk:
        'Сучасна композиція: водянисто-прохолодний сандал, м’ята і трава — намір зробити саме повітря менш важким.',
    noteEn:
        'A modern composition: watery sandalwood, mint and grass — an attempt to make the air itself lighter.',
  ),

  // Kō 36 — Great rains sometimes fall (taiu tokidoki furu)
  36: KodoPairing(
    japanese: '驟雨香',
    romaji: 'shū-u-kō',
    nameUk: 'Сюу-ко (раптова злива — сучасна композиція)',
    nameEn: 'Shū-u-kō (sudden rainstorm, modern composition)',
    ingredients: ['rakoku', 'byakudan', 'kunroku', 'kanshō'],
    themeUk: 'небо, яке вирішує одне за іншим',
    themeEn: 'a sky deciding things one after another',
    noteUk:
        'Сучасна композиція: ракоку (тайський агар) з мокрим сандалом і ладаном — холодний удар по черепиці, потім тихе крапання з даху.',
    noteEn:
        'A modern composition: rakoku (Thai agar) with damp sandalwood and kunroku (frankincense) — a cold rap on the tiles, then a slow drip from the eaves.',
  ),

  // ─── Autumn ───

  // Kō 37 — Cool winds blow (suzukaze itaru)
  37: KodoPairing(
    japanese: '涼風香',
    romaji: 'suzukaze-kō',
    nameUk: 'Судзукадзе-ко (прохолодний вітер — сучасна композиція)',
    nameEn: 'Suzukaze-kō (cooling wind, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'reiryōkō'],
    themeUk: 'перший рух повітря, у якому розчулюєшся',
    themeEn: 'the first stir of air that softens you',
    noteUk:
        'Сучасна композиція: рівний дзинко (агар) з сандалом і трав’яною прохолодою — натяк на осінь у середині спекотного дня.',
    noteEn:
        'A modern composition: even jinkō (agarwood) with sandalwood and grassy cool — a hint of autumn inside a hot day.',
  ),

  // Kō 38 — Evening cicadas sing (higurashi naku)
  38: KodoPairing(
    japanese: '蜩香',
    romaji: 'higurashi-kō',
    nameUk: 'Хіґураші-ко (вечірня цикада — сучасна композиція)',
    nameEn: 'Higurashi-kō (evening cicada, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kunroku', 'kanshō'],
    themeUk: 'дзвін без металу, від якого темніє раніше',
    themeEn: 'a bell without metal that brings the dark sooner',
    noteUk:
        'Сучасна композиція: дзинко (агар) з ладаном і теплим сандалом — дзвінкий, тонкий запах, який не закінчується разом із днем.',
    noteEn:
        'A modern composition: jinkō (agarwood) with kunroku (frankincense) and warm sandalwood — a bright, thin scent that outlasts the day.',
  ),

  // Kō 39 — Thick fog descends (fukaki kiri matō)
  39: KodoPairing(
    japanese: '霧香',
    romaji: 'kiri-kō',
    nameUk: 'Кірі-ко (густий туман — сучасна композиція)',
    nameEn: 'Kiri-kō (thick fog, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kunroku', 'kanshō'],
    themeUk: 'кімната, у якій усі стіни — пара',
    themeEn: 'a room whose every wall is steam',
    noteUk:
        'Сучасна композиція: дзинко (агар) й сандал, заглушені ладаном — обриси розчиняються, лишається лише вологий запах.',
    noteEn:
        'A modern composition: jinkō (agarwood) and sandalwood muted by kunroku (frankincense) — outlines dissolve, only a damp scent remains.',
  ),

  // Kō 40 — Bush clover blooms (hagi no hana saku)
  40: KodoPairing(
    japanese: '萩香',
    romaji: 'hagi-kō',
    nameUk: 'Хаґі-ко (леспедеца — сучасна композиція)',
    nameEn: 'Hagi-kō (bush clover, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'kunroku'],
    themeUk: 'ніжна гілка, що схиляється до землі',
    themeEn: 'a tender branch leaning to the ground',
    noteUk:
        'Сучасна композиція: лагідний сандал з тихим дзинко (агар) й канше (нард) — кущ, з якого пелюстки вже спадають у росу.',
    noteEn:
        'A modern composition: gentle sandalwood with quiet jinkō (agarwood) and kanshō (spikenard) — a bush whose petals are already falling into dew.',
  ),

  // Kō 41 — Hot winds calm (atsuki kaze yamu)
  41: KodoPairing(
    japanese: '侍従',
    romaji: 'jijū',
    nameUk: 'Дзідзю (придворний осінній неріко)',
    nameEn: 'Jijū (Heian court neriko, balanced autumn)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'chōji', 'kunroku'],
    themeUk: 'спокій, якого вже ніхто не боїться',
    themeEn: 'a calm no one is wary of any longer',
    noteUk:
        'Класичний дзідзю: вирівняний неріко двору, без надмірності, із всіма основними компонентами в малих долях — урівноважений, як двір у тиші.',
    noteEn:
        'A classical jijū: a balanced court neriko, no excess, with all core components in small measure — composed, like a quiet court.',
  ),

  // Kō 42 — Cotton bolls open (wata no hana shibe hiraku)
  42: KodoPairing(
    japanese: '綿香',
    romaji: 'wata-kō',
    nameUk: 'Вата-ко (бавовна — сучасна композиція)',
    nameEn: 'Wata-kō (cotton bolls, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'reiryōkō', 'jinkō'],
    themeUk: 'білі грудочки, у яких ховається наступна зима',
    themeEn: 'white tufts in which next winter is hidden',
    noteUk:
        'Сучасна композиція: м’який сандал з солодкою канше (нард) — м’якість, що готується стати тканиною й теплом.',
    noteEn:
        'A modern composition: soft sandalwood with sweet kanshō (spikenard) — softness preparing itself to become cloth and warmth.',
  ),

  // Kō 43 — Heavens turn cool, earth turns cool (tenchi hajimete samushi)
  43: KodoPairing(
    japanese: '初冷香',
    romaji: 'hatsuhie-kō',
    nameUk: 'Хацухіе-ко (перша прохолода — сучасна композиція)',
    nameEn: 'Hatsuhie-kō (first chill, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kunroku', 'kanshō'],
    themeUk: 'перша ніч, коли тіло пам’ятає про ковдру',
    themeEn: 'the first night the body remembers a quilt',
    noteUk:
        'Сучасна композиція: ясний дзинко (агар) з тихим ладаном — повітря, що переступає невидиму смугу від літа до осені.',
    noteEn:
        'A modern composition: clear jinkō (agarwood) with quiet kunroku (frankincense) — air crossing the invisible line from summer into autumn.',
  ),

  // Kō 44 — Rice ripens (kokumono sunawachi minoru)
  44: KodoPairing(
    japanese: '稲香',
    romaji: 'ine-kō',
    nameUk: 'Іне-ко (стиглий рис — сучасна композиція)',
    nameEn: 'Ine-kō (ripening rice, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'kunroku', 'reiryōkō'],
    themeUk: 'поле, що схилило голову на знак згоди',
    themeEn: 'a field bowing its head in agreement',
    noteUk:
        'Сучасна композиція: тепла канше (нард) з сандалом і трав’янистою рейрьоко (трав’яниста матка) — пряний, добрий запах житниці перед серпом.',
    noteEn:
        'A modern composition: warm kanshō (spikenard) with sandalwood and grassy reiryōkō (sweet-flag grass) — the spicy, kindly smell of granary before the sickle.',
  ),

  // Kō 45 — White dew (kusa no tsuyu shiroshi)
  45: KodoPairing(
    japanese: '白露香',
    romaji: 'hakuro-kō',
    nameUk: 'Хакуро-ко (біла роса — сучасна композиція)',
    nameEn: 'Hakuro-kō (white dew, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'reiryōkō'],
    themeUk: 'крапля, що тримає ціле небо до сходу сонця',
    themeEn: 'a drop that holds the whole sky until sunrise',
    noteUk:
        'Сучасна композиція: прозорий сандал з тонким дзинко (агар) й трав’яною свіжістю — нічого важкого, лише блиск світанку.',
    noteEn:
        'A modern composition: transparent sandalwood with thin jinkō (agarwood) and grass-fresh edge — nothing heavy, only dawn-shine.',
  ),

  // Kō 46 — Wagtails sing (sekirei naku)
  46: KodoPairing(
    japanese: '鶺鴒香',
    romaji: 'sekirei-kō',
    nameUk: 'Секірей-ко (плиска — сучасна композиція)',
    nameEn: 'Sekirei-kō (wagtail, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'manaka'],
    themeUk: 'птаха, що пише на воді короткими рисами',
    themeEn: 'a bird that writes on water with short strokes',
    noteUk:
        'Сучасна композиція: легка манака (солодкий агар) з прохолодним сандалом — ритмічна, мінлива, як рух хвоста по гальці.',
    noteEn:
        'A modern composition: light manaka (sweet agar) with cool sandalwood — rhythmic and shifting, like a tail-flick on river stone.',
  ),

  // Kō 47 — Swallows leave (tsubame saru)
  47: KodoPairing(
    japanese: '夢路香',
    romaji: 'yumeji-kō',
    nameUk: 'Юмеджі-ко (стежка снів — едо-комбінація)',
    nameEn: 'Yumeji-kō (dream path, Edo kumikō)',
    ingredients: ['kyara', 'jinkō', 'kanshō', 'kunroku', 'jakō'],
    themeUk: 'дорога, якою повертаються тільки уві сні',
    themeEn: 'a road one returns by only in dream',
    noteUk:
        'Едоська гра «стежка снів»: глибока кяра (преміум-агар) з ладаном і мускусом — ностальгія, у якій ще лишився солодкий слід.',
    noteEn:
        'An Edo "dream path" game: deep kyara with kunroku and jakō — nostalgia in which a sweet trace still lingers.',
  ),

  // Kō 48 — Thunder ceases (kaminari sunawachi koe o osamu)
  48: KodoPairing(
    japanese: '止雷香',
    romaji: 'shirai-kō',
    nameUk: 'Шірай-ко (грім стихає — сучасна композиція)',
    nameEn: 'Shirai-kō (thunder ceasing, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kunroku', 'kanshō'],
    themeUk: 'небо, що нарешті закрило свій рот',
    themeEn: 'a sky that has finally closed its mouth',
    noteUk:
        'Сучасна композиція: спокійний дзинко (агар) з ладаном і сандалом — глуха тиша після останнього дальнього гуркоту.',
    noteEn:
        'A modern composition: calm jinkō (agarwood) with kunroku (frankincense) and sandalwood — the dull silence after a last distant roll.',
  ),

  // Kō 49 — Insects burrow into earth (mushi kakurete to o fusagu)
  49: KodoPairing(
    japanese: '虫隠香',
    romaji: 'mushikakure-kō',
    nameUk: 'Мушікакуре-ко (комахи ховаються — сучасна композиція)',
    nameEn: 'Mushikakure-kō (insects retiring, modern composition)',
    ingredients: ['rakoku', 'jinkō', 'kunroku', 'kanshō'],
    themeUk: 'двері в землю, що зачиняються до весни',
    themeEn: 'a door into the earth, closing till spring',
    noteUk:
        'Сучасна композиція: ракоку (тайський агар) з ладаном і дзинко (агар) — землиста, оберігаюча, без жалю до того, що йде під ґрунт.',
    noteEn:
        'A modern composition: rakoku (Thai agar) with kunroku (frankincense) and jinkō (agarwood) — earthen, protective, with no sorrow for what slips under soil.',
  ),

  // Kō 50 — Farmers drain fields (mizu hajimete karuru)
  50: KodoPairing(
    japanese: '田水香',
    romaji: 'tamizu-kō',
    nameUk: 'Тамідзу-ко (зливання поля — сучасна композиція)',
    nameEn: 'Tamizu-kō (draining the rice field, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'kunroku', 'reiryōkō'],
    themeUk: 'землі повертають її форму без води',
    themeEn: 'the land is given back its shape without water',
    noteUk:
        'Сучасна композиція: сухий сандал з ладаном і трав’янистою канше (нард) — спокійна робота, після якої залишається стерня.',
    noteEn:
        'A modern composition: dry sandalwood with kunroku (frankincense) and grassy kanshō (spikenard) — quiet labour, leaving stubble behind.',
  ),

  // Kō 51 — Wild geese return (kōgan kitaru)
  51: KodoPairing(
    japanese: '雁来香',
    romaji: 'gankō-kō',
    nameUk: 'Ґанко-ко (повернення гусей — сучасна композиція)',
    nameEn: 'Gankō-kō (returning geese, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kunroku', 'kanshō'],
    themeUk: 'літери, написані на сірому небі',
    themeEn: 'letters written across a grey sky',
    noteUk:
        'Сучасна композиція: рівний дзинко (агар) з ладаном — без зайвого, як клин, який знає, де його зимовий притулок.',
    noteEn:
        'A modern composition: even jinkō (agarwood) with kunroku (frankincense) — nothing extra, like a wedge that knows its winter quarters.',
  ),

  // Kō 52 — Chrysanthemums bloom (kiku no hana hiraku)
  52: KodoPairing(
    japanese: '菊花',
    romaji: 'kikka',
    nameUk: 'Кікка (хризантема — класичний неріко)',
    nameEn: 'Kikka (chrysanthemum, classical Heian neriko)',
    ingredients: ['byakudan', 'chōji', 'kanshō', 'jinkō'],
    themeUk: 'квітка, що ходить по дворі під вечір',
    themeEn: 'a flower that walks the courtyard at evening',
    noteUk:
        'Класичний осінній неріко двору Хейан: сандал-веде, з сухими нотками гвоздики й тонким дзинко (агар) — стримана повага до пори року.',
    noteEn:
        'A classical Heian autumn neriko: sandalwood leads, with dry clove and thin jinkō (agarwood) — restrained respect for the season.',
  ),

  // Kō 53 — Crickets chirp by the door (kirigirisu to ni ari)
  53: KodoPairing(
    japanese: '蛩香',
    romaji: 'kōrogi-kō',
    nameUk: 'Короґі-ко (цвіркун біля порога — сучасна композиція)',
    nameEn: 'Kōrogi-kō (cricket at the door, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'kunroku'],
    themeUk: 'співрозмовник, що завжди говорить однаково',
    themeEn: 'a companion who always speaks the same way',
    noteUk:
        'Сучасна композиція: дзинко (агар) з тихим сандалом і ладаном — рівне, спокійне дзижчання осінньої ночі біля паперової стіни.',
    noteEn:
        'A modern composition: jinkō (agarwood) with quiet sandalwood and kunroku (frankincense) — the even hum of an autumn night beyond the paper wall.',
  ),

  // Kō 54 — Frost first falls (shimo hajimete furu)
  54: KodoPairing(
    japanese: '初霜香',
    romaji: 'hatsushimo-kō',
    nameUk: 'Хацушімо-ко (перший іній — сучасна композиція)',
    nameEn: 'Hatsushimo-kō (first frost, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kunroku', 'jakō'],
    themeUk: 'ніч, після якої трава біла, як аркуш',
    themeEn: 'a night after which the grass is paper-white',
    noteUk:
        'Сучасна композиція: дзинко (агар) з ладаном і краплею мускусу — стриманий, але вже зимуватий запах ранкового подвір’я.',
    noteEn:
        'A modern composition: jinkō (agarwood) with kunroku (frankincense) and a drop of jakō (musk) — restrained yet already wintered, like a courtyard at first light.',
  ),

  // ─── Winter ───

  // Kō 55 — Light rain sometimes falls (kosame tokidoki furu)
  55: KodoPairing(
    japanese: '時雨香',
    romaji: 'shigure-kō',
    nameUk: 'Шіґуре-ко (моросячий дощ — сучасна композиція)',
    nameEn: 'Shigure-kō (passing winter rain, modern composition)',
    ingredients: ['kyara', 'jinkō', 'kunroku', 'kanshō'],
    themeUk: 'дощ, що знаходить, кому скаржитися',
    themeEn: 'a rain that finds someone to complain to',
    noteUk:
        'Сучасна композиція: глибока кяра (преміум-агар) з дзинко (агар) й ладаном — короткий, темний потік, що тут же стихає під дахом.',
    noteEn:
        'A modern composition: deep kyara (premium agar) with jinkō (agarwood) and kunroku (frankincense) — a short, dark current that quiets under the eaves.',
  ),

  // Kō 56 — Maple leaves and ivy turn yellow (momiji tsuta kibamu)
  56: KodoPairing(
    japanese: '紅葉香',
    romaji: 'momiji-kō',
    nameUk: 'Моміджі-ко (жовтий клен — едо-комбінація)',
    nameEn: 'Momiji-kō (autumn maple, Edo kumikō)',
    ingredients: ['jinkō', 'byakudan', 'chōji', 'kunroku', 'jakō'],
    themeUk: 'листя, яке прощається яскравіше за квіти',
    themeEn: 'leaves that bid farewell brighter than blossoms',
    noteUk:
        'Едоська гра кленового листя: повний неріко-стиль із гвоздикою й мускусом — теплий, прощальний колір зайнятого вогню.',
    noteEn:
        'An Edo maple-leaf game: full neriko style with clove and jakō (musk) — the warm, farewell colour of a held fire.',
  ),

  // Kō 57 — Camellias bloom (tsubaki hajimete hiraku)
  57: KodoPairing(
    japanese: '椿香',
    romaji: 'tsubaki-kō',
    nameUk: 'Цубакі-ко (камелія — сучасна композиція)',
    nameEn: 'Tsubaki-kō (camellia, modern composition)',
    ingredients: ['kyara', 'byakudan', 'kanshō', 'chōji'],
    themeUk: 'квітка, що падає цілою, не розпадаючись',
    themeEn: 'a flower that falls whole, without scattering',
    noteUk:
        'Сучасна композиція: кяра (преміум-агар) з сандалом і дрібкою гвоздики — насичена, темно-червона, мовчазна, як саме падіння квітки.',
    noteEn:
        'A modern composition: kyara (premium agar) with sandalwood and a touch of clove — saturated, dark-red and silent, like the fall of the flower itself.',
  ),

  // Kō 58 — Land begins to freeze (chi hajimete kōru)
  58: KodoPairing(
    japanese: '凍香',
    romaji: 'itefuyu-kō',
    nameUk: 'Ітефую-ко (земля сковується кригою — сучасна композиція)',
    nameEn: 'Itefuyu-kō (earth freezing, modern composition)',
    ingredients: ['kyara', 'jinkō', 'kunroku', 'jakō'],
    themeUk: 'твердість, яку ще треба прийняти',
    themeEn: 'a hardness still to be accepted',
    noteUk:
        'Сучасна композиція: щільна кяра (преміум-агар) з ладаном і мускусом — ущільнення повітря, від якого голос звучить ясніше.',
    noteEn:
        'A modern composition: dense kyara (premium agar) with kunroku (frankincense) and jakō (musk) — a thickening of air that sharpens every voice.',
  ),

  // Kō 59 — Daffodils bloom (kinsenka saku)
  59: KodoPairing(
    japanese: '水仙香',
    romaji: 'suisen-kō',
    nameUk: 'Суйсен-ко (нарцис — сучасна композиція)',
    nameEn: 'Suisen-kō (daffodil, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'reiryōkō'],
    themeUk: 'білість, що пахне ясніше за зимове сонце',
    themeEn: 'a whiteness brighter-scented than winter sun',
    noteUk:
        'Сучасна композиція: чистий сандал із тонким дзинко (агар) — ясний, прохолодний, як квітка, що цвіте серед снігу.',
    noteEn:
        'A modern composition: pure sandalwood with thin jinkō (agarwood) — clear and cool, like a flower blooming in snow.',
  ),

  // Kō 60 — Rainbows hide (niji kakurete miezu)
  60: KodoPairing(
    japanese: '隠虹香',
    romaji: 'kakureniji-kō',
    nameUk: 'Какуреніджі-ко (схована веселка — сучасна композиція)',
    nameEn: 'Kakureniji-kō (hidden rainbow, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kunroku', 'kanshō'],
    themeUk: 'кольори, що згадають про себе аж навесні',
    themeEn: 'colours that will remember themselves in spring',
    noteUk:
        'Сучасна композиція: рівний дзинко (агар) з ладаном і прохолодним сандалом — сіра, але не сумна тиша зимового неба.',
    noteEn:
        'A modern composition: even jinkō (agarwood) with kunroku (frankincense) and cool sandalwood — a grey, not sad, silence of winter sky.',
  ),

  // Kō 61 — North wind blows leaves down (kitakaze ko no ha o harau)
  61: KodoPairing(
    japanese: '落葉',
    romaji: 'rakuyō',
    nameUk: 'Ракуьо (опале листя — класичний неріко)',
    nameEn: 'Rakuyō (fallen leaves, classical Heian neriko)',
    ingredients: ['kyara', 'jinkō', 'kunroku', 'jakō', 'kasshoku-kō'],
    themeUk: 'покривало, що зробив за тебе вітер',
    themeEn: 'a coverlet the wind has made for you',
    noteUk:
        'Класичний пізньо-осінній неріко двору Хейан: глибока кяра (преміум-агар) з ладаном, мускусом і кашшоку (темна смола) — щільна теплота землі під листям.',
    noteEn:
        'A classical Heian late-autumn neriko: deep kyara (premium agar) with kunroku (frankincense), jakō (musk) and kasshoku-kō (dark resin) — the dense warmth of earth beneath leaves.',
  ),

  // Kō 62 — Tachibana citrus turns yellow (tachibana hajimete kibamu)
  62: KodoPairing(
    japanese: '橘香',
    romaji: 'tachibana-kō',
    nameUk: 'Татібана-ко (цитрус татібана — сучасна композиція)',
    nameEn: 'Tachibana-kō (golden tachibana, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kanshō', 'chōji'],
    themeUk: 'плід, що зберігає літо до самого Нового року',
    themeEn: 'a fruit that keeps summer until New Year',
    noteUk:
        'Сучасна композиція: дзинко (агар) з сандалом і теплою канше (нард) — золотиста, кисло-солодка нота на тлі холоду сезону.',
    noteEn:
        'A modern composition: jinkō (agarwood) with sandalwood and warm kanshō (spikenard) — a golden, sour-sweet note against the season’s cold.',
  ),

  // Kō 63 — First snow falls (sora samuku fuyu to naru)
  63: KodoPairing(
    japanese: '雪月花',
    romaji: 'setsugekka-kō',
    nameUk: 'Сецуґекка-ко (сніг-місяць-квіти — едо-комбінація)',
    nameEn: 'Setsugekka-kō (snow-moon-flower, Edo kumikō)',
    ingredients: ['kyara', 'jinkō', 'byakudan', 'jakō', 'kunroku'],
    themeUk: 'три краси, з яких зимі дісталася перша',
    themeEn: 'three beauties; winter takes the first',
    noteUk:
        'Едоська гра трьох пейзажів: глибока кяра (преміум-агар) з мускусом і сандалом — повне, глибоке зимове повітря, що містить у собі весь рік.',
    noteEn:
        'An Edo three-vista game: deep kyara (premium agar) with jakō (musk) and sandalwood — a full, deep winter air that holds the whole year within.',
  ),

  // Kō 64 — Bears retire to their dens (kuma ana ni komoru)
  64: KodoPairing(
    japanese: '熊穴香',
    romaji: 'kumaana-kō',
    nameUk: 'Кумаана-ко (ведмежий барліг — сучасна композиція)',
    nameEn: 'Kumaana-kō (bear in its den, modern composition)',
    ingredients: ['kyara', 'rakoku', 'kunroku', 'kasshoku-kō'],
    themeUk: 'кімнатка з листя, землі й волохатого тіла',
    themeEn: 'a small room of leaves, earth and warm fur',
    noteUk:
        'Сучасна композиція: щільна кяра (преміум-агар) з ракоку (тайський агар) і кашшоку (темна смола) — землиста, тепла, як дихання у глибокій печері.',
    noteEn:
        'A modern composition: dense kyara (premium agar) with rakoku (Thai agar) and kasshoku-kō (dark resin) — earthen, warm, like breath inside a deep cave.',
  ),

  // Kō 65 — Salmon swim upstream (sake no uo muragaru)
  65: KodoPairing(
    japanese: '鮭香',
    romaji: 'sake-kō',
    nameUk: 'Саке-ко (лосось проти течії — сучасна композиція)',
    nameEn: 'Sake-kō (upstream salmon, modern composition)',
    ingredients: ['jinkō', 'rakoku', 'kunroku', 'kanshō'],
    themeUk: 'тіла, що їх веде назад те саме, що колись винесло',
    themeEn: 'bodies led back by the same thing that once bore them away',
    noteUk:
        'Сучасна композиція: дзинко (агар) з гірчастим ракоку (тайський агар) й ладаном — холодна вода й намір, який не пояснюють.',
    noteEn:
        'A modern composition: jinkō (agarwood) with bitter rakoku (Thai agar) and kunroku (frankincense) — cold water and an intent that does not explain itself.',
  ),

  // Kō 66 — Self-heal sprouts under snow (natsukarekusa shōzu)
  66: KodoPairing(
    japanese: '雪下香',
    romaji: 'sekka-kō',
    nameUk: 'Секка-ко (під снігом — сучасна композиція)',
    nameEn: 'Sekka-kō (under-snow sprout, modern composition)',
    ingredients: ['byakudan', 'jinkō', 'kanshō', 'reiryōkō'],
    themeUk: 'життя, яке вже знає, що сніг закінчиться',
    themeEn: 'a life that already knows the snow will end',
    noteUk:
        'Сучасна композиція: світлий сандал із тонким дзинко (агар) й трав’янистою свіжістю — несподівана зелень під білим покривалом.',
    noteEn:
        'A modern composition: bright sandalwood with thin jinkō (agarwood) and grass-fresh edge — surprise greenery under white cover.',
  ),

  // Kō 67 — Solstice — sun returns (waki izuru kuru)
  67: KodoPairing(
    japanese: '冬至香',
    romaji: 'tōji-kō',
    nameUk: 'Тоджі-ко (зимовий сонцеворот — сучасна композиція)',
    nameEn: 'Tōji-kō (winter solstice, modern composition)',
    ingredients: ['kyara', 'jinkō', 'jakō', 'kunroku', 'kasshoku-kō'],
    themeUk: 'найкоротший день, у якому повертається довжина',
    themeEn: 'the shortest day with length already returning',
    noteUk:
        'Сучасна композиція: щільна кяра (преміум-агар) з мускусом і кашшоку (темна смола) — теплий, тлумаки темряви, в якій уже є насіння наступного дня.',
    noteEn:
        'A modern composition: dense kyara (premium agar) with jakō (musk) and kasshoku-kō (dark resin) — a warm, deep darkness already holding the seed of the next day.',
  ),

  // Kō 68 — Deer shed antlers (sawashika no tsuno otsuru)
  68: KodoPairing(
    japanese: '鹿角香',
    romaji: 'rokkaku-kō',
    nameUk: 'Роккаку-ко (роги оленя — сучасна композиція)',
    nameEn: 'Rokkaku-kō (deer-antler shedding, modern composition)',
    ingredients: ['jinkō', 'byakudan', 'kunroku', 'jakō'],
    themeUk: 'гідне відпускання, після якого знову росте',
    themeEn: 'a dignified letting-go that grows back',
    noteUk:
        'Сучасна композиція: дзинко (агар) з ладаном і мускусом — стримана, чоловіча нота лісу, що скидає вагу зими.',
    noteEn:
        'A modern composition: jinkō (agarwood) with kunroku (frankincense) and jakō (musk) — a restrained, antlered note of forest letting winter weight go.',
  ),

  // Kō 69 — Wheat sprouts under snow (yuki watarite mugi nobiru)
  69: KodoPairing(
    japanese: '雪麦香',
    romaji: 'setsubaku-kō',
    nameUk: 'Сецубаку-ко (озимий ячмінь під снігом — сучасна композиція)',
    nameEn: 'Setsubaku-kō (wheat under snow, modern composition)',
    ingredients: ['byakudan', 'kanshō', 'jinkō', 'reiryōkō'],
    themeUk: 'ряд зеленого, що пише по білому',
    themeEn: 'a green line writing across the white',
    noteUk:
        'Сучасна композиція: лагідний сандал з канше (нард) й трав’янистою рейрьоко (трав’яниста матка) — обіцянка, що проростає нечутно під крижаною кіркою.',
    noteEn:
        'A modern composition: gentle sandalwood with kanshō (spikenard) and grassy reiryōkō (sweet-flag grass) — a promise sprouting silently under ice-crust.',
  ),

  // Kō 70 — Parsley flourishes (seri sunawachi sakau)
  70: KodoPairing(
    japanese: '芹香',
    romaji: 'seri-kō',
    nameUk: 'Сері-ко (зимова петрушка — сучасна композиція)',
    nameEn: 'Seri-kō (winter parsley, modern composition)',
    ingredients: ['byakudan', 'reiryōkō', 'kanshō', 'manaka'],
    themeUk: 'зелень, на якій тримається весь сім-травний суп',
    themeEn: 'a green that holds the whole seven-herb broth',
    noteUk:
        'Сучасна композиція: трав’янистий сандал з рейрьоко (трав’яниста матка) й манакою (солодким агаром) — холодний, ясний, водянистий, як зимовий струмок.',
    noteEn:
        'A modern composition: grassy sandalwood with reiryōkō (sweet-flag grass) and manaka (sweet agar) — cold, clear and watery, like a winter brook.',
  ),

  // Kō 71 — Springs run warm (shimizu atataka o fukumu)
  71: KodoPairing(
    japanese: '高砂香',
    romaji: 'takasago-kō',
    nameUk: 'Такасаґо-ко (сосна довголіття — едо-комбінація)',
    nameEn: 'Takasago-kō (pines of longevity, Edo kumikō)',
    ingredients: ['kyara', 'jinkō', 'byakudan', 'jakō', 'kunroku'],
    themeUk: 'тепло, що жило весь час під льодом',
    themeEn: 'a warmth that lived all along under the ice',
    noteUk:
        'Едоська гра «Такасаґо»: щільна кяра (преміум-агар) з сандалом і мускусом — урочистий, але теплий запах джерела, що ніколи не замерзає.',
    noteEn:
        'An Edo Takasago game: dense kyara (premium agar) with sandalwood and jakō (musk) — a solemn yet warm scent of a spring that never freezes.',
  ),

  // Kō 72 — Hens begin to lay (niwatori hajimete toya ni tsuku)
  72: KodoPairing(
    japanese: '黒方',
    romaji: 'kurobō',
    nameUk: 'Куробо (темний неріко — класичний)',
    nameEn: 'Kurobō (deep-winter neriko, Heian classical)',
    ingredients: ['kyara', 'jinkō', 'jakō', 'kasshoku-kō', 'kunroku'],
    themeUk: 'найглибша темрява, у якій уже зачато світло',
    themeEn: 'the deepest dark in which light is already begun',
    noteUk:
        'Класичний зимовий неріко двору Хейан: важка кяра (преміум-агар) з мускусом і кашшоку (темна смола) — повна, землиста ніч перед самим повертанням весни.',
    noteEn:
        'A classical Heian deep-winter neriko: heavy kyara (premium agar) with jakō (musk) and kasshoku-kō (dark resin) — a full, earthen night just before spring turns back.',
  ),
};

KodoPairing? kodoForKo(int koIndex) => seasonalKodo[koIndex];
