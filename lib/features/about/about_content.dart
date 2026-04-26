/// Rich About/Tradition content for the 72 seasons.
///
/// Kept as Dart constants rather than ARB entries because the text is
/// long-form prose — putting 5 × 300-word sections into .arb files makes
/// them unreadable. Editing this file is the preferred way to tune copy.
///
/// Double quotes are intentional: Ukrainian text contains apostrophes
/// ("п'ять", "Солов'ї", ...) which would need escaping in single-quoted
/// strings, hurting readability.
// ignore_for_file: prefer_single_quotes
library;

class AboutSection {
  final String title;
  final List<String> paragraphs;
  final String? pullQuote;
  const AboutSection({
    required this.title,
    required this.paragraphs,
    this.pullQuote,
  });
}

/// One row in the "Seven traditions" overview rendered after the prose
/// sections in the Tradition tab. Each entry mirrors a deep-dive card
/// from the home / detail screens so the reader can recognise it at
/// a glance.
class CardTradition {
  final String emoji;
  final String name;
  final String tradition;  // 1–2 sentences — what tradition this draws on
  final String contents;   // 1 sentence — what the user finds inside
  const CardTradition({
    required this.emoji,
    required this.name,
    required this.tradition,
    required this.contents,
  });
}

/// Ukrainian — seven card-tradition overviews, in the order they appear
/// on the season screen.
const List<CardTradition> cardTraditionsUk = [
  CardTradition(
    emoji: '🌱',
    name: 'Сезонний чай',
    tradition: 'З китайської чайної традиції 茶道. Кожному кō підібрано один із 13 базових типів — зелений, білий, жовтий, червоний, улун, шен-пуер і шу-пуер, хей-ча, лю-бао — з конкретним сортом, що пасує характеру тих п’яти днів.',
    contents: 'Усередині — назва ієрогліфом, поетична нота-підбір, інфо про терруар і виробництво, легенда (для відомих сортів) і спосіб заварювання.',
  ),
  CardTradition(
    emoji: '🍱',
    name: 'Сезонна їжа',
    tradition: 'З японської концепції 旬 (шун) — пік сезонності інгредієнта, і традиції 和菓子 (ваґаші) — сезонних солодощів. Святкові якорі (ехо-макі, сакура-мочі, нанакуса-ґаю, одзоні) збігаються зі справжніми датами.',
    contents: 'Японська назва, ромаджі, переклад з глосою, категорія (сакана/ґохан/ваґаші/...), і нота, що пов’язує страву з природою кō.',
  ),
  CardTradition(
    emoji: '🌸',
    name: 'Сезонна квітка',
    tradition: 'З 花暦 (хана-ґойомі) — японського квіткового календаря, і традиції 花言葉 (ханакотоба) — мови квітів. Кожному кō відповідає квітка на піку цвітіння в центральному Хонсю.',
    contents: 'Японська і латинська ботанічна назва, символіка ханакотоба, і нота про місце квітки в храмових садах, ікебані або поезії доби Хейан.',
  ),
  CardTradition(
    emoji: '🎨',
    name: 'Сезонні кольори одягу',
    tradition: 'З придворної традиції 襲の色目 (касане-но-іроме) — пошарового поєднання прозорих шовкових кімоно, що носили дами Хейан. 72 унікальні комбінації — справжні касане з джерел або композиції з автентичних японських кольорів.',
    contents: 'Назва касане (наприклад «сакура-ґасане», «корі-ґасане»), 2–3 кольорові шари з японськими назвами, і нота, що в’яже палітру до природного явища.',
  ),
  CardTradition(
    emoji: '🌫️',
    name: 'Сезонні пахощі kōdō',
    tradition: 'З придворного шляху пахощів 香道. Класичні хейанські неріко (баіка, кайо, кікка, ракуйо, куробо) і едо-кумікō (ґенджі-кō, юмеджі-кō, цукімі-кō) — там, де підходять; для решти — сучасні композиції в тому ж кōдō-регістрі.',
    contents: 'Назва суміші, тема (одне-рядкове образне твердження), 4–5 канонічних інгредієнтів (агар, сандал, гвоздика, нард, мускус...) з перекладом.',
  ),
  CardTradition(
    emoji: '📜',
    name: 'Сезонні слова',
    tradition: 'Із сайдзікі (歳時記) — словників сезонних слів кіґо, навколо яких поети Басьо, Бусон, Ісса, Сікі будували хайку. Кожне слово закріплено за конкретним 5-денним вікном року.',
    contents: '3–5 кіґо для кō (кандзі + ромаджі + глоса + літературна нота), плюс summary-фраза, що задає колективний настрій усіх слів цього кō.',
  ),
  CardTradition(
    emoji: '🪷',
    name: 'Практика',
    tradition: 'З японської філософії 養生 (йоджо) — «плекання життя», що йде від трактату Кайбари Екікена (1713). У її традиції кожна пора року тісно пов’язана з одним внутрішнім органом, який саме тоді найвразливіший і потребує підтримки: весна — печінка, літо — серце, кінець літа — селезінка-шлунок, осінь — легені, зима — нирки. Звідси й конкретика порад нижче — що їсти, чим зігрітися, як рухатися.',
    contents: 'Одне-рядкове мотто кō, потім три блоки: ТІЛО (їжа/тепло/сон), ДІЯ (що зробити цими днями), СПОГЛЯДАННЯ (що помітити чи занотувати).',
  ),
];

/// English — same seven card traditions, same order.
const List<CardTradition> cardTraditionsEn = [
  CardTradition(
    emoji: '🌱',
    name: 'Seasonal tea',
    tradition: 'From the Chinese way of tea 茶道. Each kō is paired with one of 13 base types — green, white, yellow, red, oolong, raw and ripe pu-erh, hei-cha, liu-bao — with a specific cultivar matching the character of those five days.',
    contents: 'Inside: Chinese name in kanji, a poetic pairing note, terroir and processing notes, an origin legend for famous teas, and brewing instructions.',
  ),
  CardTradition(
    emoji: '🍱',
    name: 'Seasonal food',
    tradition: 'From the Japanese concept of 旬 (shun) — the peak ripeness of an ingredient — and the 和菓子 (wagashi) confection tradition. Festival anchors (ehō-maki, sakura-mochi, nanakusa-gayu, ozōni) align with their real calendar dates.',
    contents: 'Japanese name, romaji, translation with gloss, category (sakana / gohan / wagashi / ...), and a sensory note tying the dish to the kō.',
  ),
  CardTradition(
    emoji: '🌸',
    name: 'Seasonal flower',
    tradition: 'From the 花暦 (hana-goyomi) flower calendar and the 花言葉 (hanakotoba) flower-language tradition. Each kō pairs with a flower at peak bloom in central Honshu in those five days.',
    contents: 'Japanese and Latin botanical names, hanakotoba symbolism, and a note placing the flower in temple gardens, ikebana, or Heian poetry.',
  ),
  CardTradition(
    emoji: '🎨',
    name: 'Seasonal robe colours',
    tradition: 'From the Heian court practice of 襲の色目 (kasane-no-irome) — layering translucent silk robes in named seasonal combinations. The 72 entries use documented kasane where they fit, plus extensions composed from authentic Japanese colour names.',
    contents: 'Kasane name (e.g. "sakura-gasane", "kōri-gasane"), 2–3 layered colour swatches with Japanese names, and a note linking the palette to the kō.',
  ),
  CardTradition(
    emoji: '🌫️',
    name: 'Seasonal kōdō incense',
    tradition: 'From the courtly way of incense 香道. Classical Heian neriko (baika, kayō, kikka, rakuyō, kurobō) and Edo kumikō games (Genji-kō, Yumeji-kō, Tsukimi-kō) where they fit; modern compositions in the same kōdō register elsewhere.',
    contents: 'Blend name, evocative one-line theme, and 4–5 canonical ingredients (agarwood, sandalwood, clove, spikenard, musk…) translated for non-specialists.',
  ),
  CardTradition(
    emoji: '📜',
    name: 'Seasonal words',
    tradition: 'From the saijiki (歳時記) — dictionaries of kigo seasonal words around which Bashō, Buson, Issa, Shiki built their haiku. Each kigo is anchored to a specific 5-day window of the year.',
    contents: '3–5 kigo for the kō (kanji + romaji + gloss + literary note), plus a summary line framing the collective mood the words summon.',
  ),
  CardTradition(
    emoji: '🪷',
    name: 'Practice',
    tradition: 'From the Japanese philosophy of 養生 (yōjō) — "cultivating life", rooted in Kaibara Ekiken\'s Yōjōkun (1713). In its tradition each season is tied to one internal organ that\'s especially vulnerable and in need of support: spring the liver, summer the heart, late summer the spleen-stomach, autumn the lungs, winter the kidneys. That\'s where the specifics below come from — what to eat, what to keep warm, how to move.',
    contents: 'A one-line motto for the kō, then three blocks: BODY (food, warmth, sleep), ACTIVITY (what to do these days), CONTEMPLATION (what to notice or write down).',
  ),
];

/// Ukrainian content — primary reading experience.
const List<AboutSection> aboutSectionsUk = [
  AboutSection(
    title: 'Що таке 72 сезони',
    paragraphs: [
      "72 сезони (七十二候 Шічідзю́ні-ко́) — це традиційний японський спосіб ділити рік не на чотири чи дванадцять частин, а на сімдесят два короткі сезони тривалістю приблизно по п'ять днів кожен.",
      "Кожен сезон має поетичну назву, що описує конкретне явище природи: «Солов'ї заспівали в горах», «Ластівки повертаються», «Перший іній», «Ведмеді лягають у сплячку». Ці образи — не абстракція: японці століттями уважно спостерігали за природою і записували, коли саме щось відбувається.",
    ],
  ),
  AboutSection(
    title: 'Триярусна структура календаря',
    paragraphs: [
      "Рік ділиться на чотири пори року (四季 Ші́кі) — весна, літо, осінь, зима.",
      "Кожна пора ділиться на шість фаз — секкі (二十四節気 Ні́дзю́ші-сеќкі), «24 сонячні поділки». Фази позначають великі переходи: Початок весни (立春), Літнє сонцестояння (夏至), Перший іній (霜降), Великий холод (大寒).",
      "Кожна фаза, у свою чергу, ділиться на три сезони — кō (七十二候 Шічідзю́ні-ко́). Так з 4 → 24 → 72: рік стає напрочуд детальною мапою природних змін, де кожні п'ять днів — окрема мить року.",
    ],
    pullQuote: '4 пори → 24 фази → 72 сезони',
  ),
  AboutSection(
    title: 'Звідки це прийшло',
    paragraphs: [
      "Система сонячних поділок має китайське коріння — її вперше задокументували в епоху династії Хань (II ст. до н.е.) для потреб сільського господарства. Селянам треба було знати, коли саджати рис, коли збирати врожай, коли готуватися до заморозків.",
      "До Японії система потрапила через Корею у VI столітті разом із китайською писемністю та буддизмом. Проте китайські назви сезонів описували клімат Північного Китаю, тому в Японії вони погано збігалися з реальністю.",
      "У 1685 році астроном сьогуна Сібукава Сюнкай (渋川春海) зробив історичне — переписав усі 72 назви, спираючись на спостереження за японською природою. Його версія, відома як «Хонтьо-шічідзюні-ко» (本朝七十二候, «72 сезони нашої країни»), — саме та, що ти бачиш у цьому застосунку.",
    ],
  ),
  AboutSection(
    title: 'Зв\'язок з хайку',
    paragraphs: [
      "Хайку — це трирядковий вірш з обов'язковим сезонним словом (季語 kigo). Без кіґо вірш не вважається справжнім хайку, а називається senryū — «комічним віршем».",
      "Майстри хайку XVII–XIX століть — Мацуо Басьо, Йоса Бусон, Кобаясі Ісса, Масаока Сікі — будували свої вірші саме навколо образів з календаря 72 сезонів. «Старий став — жаба стрибає у воду, сплеск» Басьо точно вказує на сезон #19 — «Жаби починають співати» (кінець травня).",
      "Тож календар 72 сезонів — це не тільки аграрний інструмент. Це поетична мова природи, якою віками говорили японські поети.",
    ],
    pullQuote: 'Один сезон — один образ — одне хайку',
  ),
  AboutSection(
    title: 'Навіщо це сьогодні',
    paragraphs: [
      "Сучасне життя витіснило з щоденної уваги дрібні зміни природи. Ми знаємо «весна / літо / осінь / зима», а між ними — місяці одного й того самого.",
      "Календар 72 сезонів пропонує повернути погляд до деталей: помітити, коли саме першого разу закувала зозуля, коли листя клена почало жовтіти, коли земля почала мерзнути. П'ятиденний цикл — досить короткий, щоб встигнути побачити зміну на власні очі.",
      "Зрозуміло, що японські kō описують японський клімат — сакура цвіте у нас пізніше, ведмеді в Україні не впадають у зимову сплячку в ті самі дати. Але дух календаря універсальний: природа говорить з тобою мовою малих подій, якщо дивишся уважно.",
    ],
  ),
];

/// English content — same sections, same order.
const List<AboutSection> aboutSectionsEn = [
  AboutSection(
    title: 'What are the 72 seasons',
    paragraphs: [
      "The 72 seasons (七十二候 Shichijūni-kō) are a traditional Japanese way of dividing the year — not into four or twelve parts, but into seventy-two short seasons roughly five days each.",
      "Every season carries a poetic name describing a specific natural phenomenon: \"Bush warblers start singing\", \"Swallows return\", \"First frost falls\", \"Bears start hibernating\". These images are not abstractions — Japanese people observed nature for centuries and recorded exactly when things happen.",
    ],
  ),
  AboutSection(
    title: 'A three-tier calendar',
    paragraphs: [
      "The year is divided into four great seasons (四季 Shiki) — spring, summer, autumn, winter.",
      "Each season is split into six phases — sekki (二十四節気 Nijūshi-sekki), \"24 solar divisions\". The phases mark major transitions: Beginning of Spring (立春), Summer Solstice (夏至), Frost Descent (霜降), Greater Cold (大寒).",
      "Each phase, in turn, holds three kō (七十二候 Shichijūni-kō). So 4 → 24 → 72: the year becomes a remarkably detailed map of natural change, where every five days is its own moment.",
    ],
    pullQuote: '4 seasons → 24 phases → 72 kō',
  ),
  AboutSection(
    title: 'Where it came from',
    paragraphs: [
      "The system of solar divisions has Chinese roots — first documented during the Han dynasty (2nd century BCE) for agriculture. Farmers needed to know when to plant rice, when to harvest, when to prepare for frost.",
      "It reached Japan via Korea in the 6th century, together with the Chinese writing system and Buddhism. But the Chinese names described the climate of Northern China and fit Japanese reality poorly.",
      "In 1685, the shogun's astronomer Shibukawa Shunkai (渋川春海) did something historic — he rewrote all 72 names based on observation of Japanese nature. His version, known as \"Honchō Shichijūni-kō\" (本朝七十二候, \"The 72 seasons of our country\"), is exactly what you see in this app.",
    ],
  ),
  AboutSection(
    title: 'Connection to haiku',
    paragraphs: [
      "Haiku is a three-line poem with a required seasonal word (季語 kigo). Without a kigo the verse isn't considered a real haiku — it's called senryū, a \"comic verse\".",
      "The haiku masters of the 17th–19th centuries — Matsuo Bashō, Yosa Buson, Kobayashi Issa, Masaoka Shiki — built their poems around imagery from the 72-season calendar. Bashō's \"Old pond — a frog leaps in, sound of water\" points precisely at season #19, \"Frogs start singing\" (late May).",
      "So the 72-season calendar is not only an agricultural tool. It is the poetic language of nature that Japanese poets spoke for centuries.",
    ],
    pullQuote: 'One season — one image — one haiku',
  ),
  AboutSection(
    title: 'Why it matters today',
    paragraphs: [
      "Modern life has pushed the smaller rhythms of nature out of daily attention. We know \"spring / summer / autumn / winter\", and between them — months of sameness.",
      "The 72-season calendar invites a return to detail: to notice when the cuckoo first called, when maple leaves started yellowing, when the ground started to freeze. A five-day cycle is short enough that you can catch the change with your own eyes.",
      "Japanese kō describe Japanese climate — cherries bloom later here, bears in other countries don't hibernate on the same dates. But the spirit of the calendar is universal: nature speaks to you in the language of small events, if you are watching closely.",
    ],
  ),
];
