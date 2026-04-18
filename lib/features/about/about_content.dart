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

/// Ukrainian content — primary reading experience.
const List<AboutSection> aboutSectionsUk = [
  AboutSection(
    title: 'Що таке 72 сезони',
    paragraphs: [
      "72 мікро-сезони (七十二候 Шічідзю́ні-ко́) — це традиційний японський спосіб ділити рік не на чотири чи дванадцять частин, а на сімдесят дві мініатюрні фази тривалістю приблизно по п'ять днів кожна.",
      "Кожен сезон має поетичну назву, що описує конкретне явище природи: «Солов'ї заспівали в горах», «Ластівки повертаються», «Перший іній», «Ведмеді лягають у сплячку». Ці образи — не абстракція: японці століттями уважно спостерігали за природою і записували, коли саме щось відбувається.",
    ],
  ),
  AboutSection(
    title: 'Триярусна структура календаря',
    paragraphs: [
      "Рік ділиться на чотири великі сезони (四季 Ші́кі) — весна, літо, осінь, зима.",
      "Кожен з них ділиться на шість секкі (二十四節気 Ні́дзю́ші-сеќкі) — «24 сонячні поділки». Вони позначають великі переходи: Початок весни (立春), Літнє сонцестояння (夏至), Перший іній (霜降), Великий холод (大寒).",
      "Кожен секкі, у свою чергу, ділиться на три кō (七十二候 Шічідзю́ні-ко́). Так з 4 → 24 → 72: рік стає напрочуд детальною мапою природних змін, де кожні п'ять днів — окрема мить року.",
    ],
    pullQuote: '4 сезони → 24 секкі → 72 кō',
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
      "Хайку — це трирядковий вірш з обов'язковим сезонним словом (季語 kigo). Без кіго вірш не вважається справжнім хайку, а називається senryū — «комічним віршем».",
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
  AboutSection(
    title: 'Джерела',
    paragraphs: [
      "• Nippon.com — «Japan's 72 Microseasons»",
      "• Kanpai Japan — «Koyomi: the 72 Seasons of Japan»",
      "• Maiko Japan — список усіх 72 кō з оригінальними назвами",
      "• Класичні збірки хайку Басьо (芭蕉), Бусона (蕪村), Ісси (一茶)",
    ],
  ),
];

/// English content — same sections, same order.
const List<AboutSection> aboutSectionsEn = [
  AboutSection(
    title: 'What are the 72 seasons',
    paragraphs: [
      "The 72 micro-seasons (七十二候 Shichijūni-kō) are a traditional Japanese way of dividing the year — not into four or twelve parts, but into seventy-two tiny phases roughly five days each.",
      "Every season carries a poetic name describing a specific natural phenomenon: \"Bush warblers start singing\", \"Swallows return\", \"First frost falls\", \"Bears start hibernating\". These images are not abstractions — Japanese people observed nature for centuries and recorded exactly when things happen.",
    ],
  ),
  AboutSection(
    title: 'A three-tier calendar',
    paragraphs: [
      "The year is divided into four great seasons (四季 Shiki) — spring, summer, autumn, winter.",
      "Each is split into six sekki (二十四節気 Nijūshi-sekki) — \"24 solar divisions\". These mark major transitions: Beginning of Spring (立春), Summer Solstice (夏至), Frost Descent (霜降), Greater Cold (大寒).",
      "Each sekki is further divided into three kō (七十二候 Shichijūni-kō). So 4 → 24 → 72: the year becomes a remarkably detailed map of natural change, where every five days is its own moment.",
    ],
    pullQuote: '4 seasons → 24 sekki → 72 kō',
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
  AboutSection(
    title: 'Sources',
    paragraphs: [
      "• Nippon.com — \"Japan's 72 Microseasons\"",
      "• Kanpai Japan — \"Koyomi: the 72 Seasons of Japan\"",
      "• Maiko Japan — full list of all 72 kō with original names",
      "• Classical haiku collections by Bashō (芭蕉), Buson (蕪村), Issa (一茶)",
    ],
  ),
];
