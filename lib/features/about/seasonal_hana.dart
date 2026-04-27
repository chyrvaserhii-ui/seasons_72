/// Seasonal flower pairings for each of the 72 kō.
///
/// The Japanese flower calendar (花暦 hana-goyomi) tracks bloom peaks
/// at much finer resolution than the four seasons — almost every kō has
/// a defining flower in temple gardens, ikebana practice, or the
/// hanakotoba (花言葉) tradition of flower symbolism. The entries here
/// pair each kō with the flower that would actually be at peak in
/// central Honshu during those five days, with a brief note on its
/// place in classical and modern Japanese horticulture.
library seasonal_hana;

/// One seasonal flower paired to a single kō.
class HanaPairing {
  const HanaPairing({
    required this.japanese,
    required this.romaji,
    required this.nameUk,
    required this.nameEn,
    required this.botanical,
    required this.hanakotobaUk,
    required this.hanakotobaEn,
    required this.noteUk,
    required this.noteEn,
  });

  /// Japanese name in kanji or kana, e.g. "桜", "椿", "蓮".
  final String japanese;

  /// Hepburn romaji, e.g. "sakura", "tsubaki", "hasu".
  final String romaji;

  /// Ukrainian name with light gloss in parentheses where useful.
  final String nameUk;

  /// English name with brief gloss.
  final String nameEn;

  /// Latin botanical name, e.g. "Prunus serrulata".
  final String botanical;

  /// Hanakotoba — flower-language meaning(s) in Ukrainian, ≤80 chars.
  final String hanakotobaUk;

  /// Hanakotoba — English version, ≤80 chars.
  final String hanakotobaEn;

  /// 1–2 sentences on why this flower for this kō: garden, temple,
  /// ikebana, or classical poetry context.
  final String noteUk;

  /// English version of [noteUk].
  final String noteEn;
}

const Map<int, HanaPairing> seasonalHana = {
  // ─── Spring ───
  1: HanaPairing(
    japanese: '梅',
    romaji: 'ume',
    nameUk: 'Уме (японська слива)',
    nameEn: 'Ume (Japanese plum)',
    botanical: 'Prunus mume',
    hanakotobaUk: 'стійкість у холоді, відданість, шляхетність',
    hanakotobaEn: 'endurance through cold, devotion, nobility',
    noteUk:
        'Білі пелюстки уме розкриваються над ще мерзлою землею — перший аромат весни, оспіваний у "Манйошу" задовго до того, як цвіт сакури став символом нації.',
    noteEn:
        'White ume petals open above still-frozen earth — spring\'s first fragrance, sung in the Manyōshū long before sakura became the nation\'s emblem.',
  ),
  2: HanaPairing(
    japanese: '紅梅',
    romaji: 'kōbai',
    nameUk: 'Кобай (червоний уме)',
    nameEn: 'Kōbai (red plum)',
    botanical: 'Prunus mume var. rubra',
    hanakotobaUk: 'витончена грація, чарівність',
    hanakotobaEn: 'refined grace, charm',
    noteUk:
        'Поки угуйсу пробує перший спів, рожевий кобай палає у садках храмів — улюблений мотив поетів епохи Хейан.',
    noteEn:
        'As the bush warbler tries its first song, pink kōbai blazes in temple courtyards — a favourite motif of Heian-era poets.',
  ),
  3: HanaPairing(
    japanese: '満作',
    romaji: 'mansaku',
    nameUk: 'Мансаку (гамамеліс)',
    nameEn: 'Mansaku (witch hazel)',
    botanical: 'Hamamelis japonica',
    hanakotobaUk: 'натхнення, таємнича принадність',
    hanakotobaEn: 'inspiration, mysterious charm',
    noteUk:
        'Жовті стрічкові пелюстки мансаку звиваються над голим гіллям — обіцянка, що крига відступає, а риба знов підіймається до поверхні.',
    noteEn:
        'Mansaku\'s yellow ribbon petals curl on bare branches — a promise that ice is loosening as fish rise toward open water.',
  ),
  4: HanaPairing(
    japanese: '沈丁花',
    romaji: 'jinchōge',
    nameUk: 'Джінчьоґе (зимовий дафне)',
    nameEn: 'Jinchōge (winter daphne)',
    botanical: 'Daphne odora',
    hanakotobaUk: 'безсмертя, безсмертна слава',
    hanakotobaEn: 'immortality, glory that endures',
    noteUk:
        'Густі суцвіття джінчьоґе пахнуть так, що аромат веде перехожого вулицею — перший справжній парфум весняного дощу.',
    noteEn:
        'Jinchōge clusters scent the lane so densely that passers-by follow the perfume — spring rain\'s first true fragrance.',
  ),
  5: HanaPairing(
    japanese: '土佐水木',
    romaji: 'tosamizuki',
    nameUk: 'Тосамідзукі (тосський горішник)',
    nameEn: 'Tosamizuki (Tosa winter hazel)',
    botanical: 'Corylopsis spicata',
    hanakotobaUk: 'тиха радість, скромна шляхетність',
    hanakotobaEn: 'quiet joy, modest grace',
    noteUk:
        'Бліді кетяги звисають крізь серпанок ранкової імли — улюблений матеріал для весняного тяному в чайних кімнатах Кіото.',
    noteEn:
        'Pale tassels hang through the morning haze — a favoured chabana for spring tea rooms in Kyoto.',
  ),
  6: HanaPairing(
    japanese: '菫',
    romaji: 'sumire',
    nameUk: 'Суміре (фіалка)',
    nameEn: 'Sumire (violet)',
    botanical: 'Viola mandshurica',
    hanakotobaUk: 'щирість, скромне кохання',
    hanakotobaEn: 'sincerity, modest love',
    noteUk:
        'Маленькі фіалки прокидаються між камінням огорож — Басьо помітив їх край стежки і зробив гайку справжнім хайку.',
    noteEn:
        'Tiny violets wake between hedge stones — Bashō glimpsed one beside the path and turned the moment into a haiku.',
  ),
  7: HanaPairing(
    japanese: '土筆',
    romaji: 'tsukushi',
    nameUk: 'Цукуші (паростки польового хвоща)',
    nameEn: 'Tsukushi (horsetail shoots)',
    botanical: 'Equisetum arvense',
    hanakotobaUk: 'наполегливість, прихована сила',
    hanakotobaEn: 'persistence, hidden strength',
    noteUk:
        'Коли комахи прокидаються, цукуші пробивають землю шеренгами маленьких списиків — діти збирають їх у кошики на узбіччях.',
    noteEn:
        'As insects stir, tsukushi push up in tidy ranks of little spears — children gather them in baskets along the verges.',
  ),
  8: HanaPairing(
    japanese: '桃',
    romaji: 'momo',
    nameUk: 'Момо (персик)',
    nameEn: 'Momo (peach)',
    botanical: 'Prunus persica',
    hanakotobaUk: 'я твоя полонянка, чарівність',
    hanakotobaEn: 'I am your captive, charm',
    noteUk:
        'Рожевий цвіт персика прикрашає Хіна-мацурі — свято дівчат: квітка, що оберігає від злих духів і обіцяє довге життя.',
    noteEn:
        'Pink peach blossom adorns Hina-matsuri, the girls\' festival — the flower that wards off evil and promises long life.',
  ),
  9: HanaPairing(
    japanese: '木蓮',
    romaji: 'mokuren',
    nameUk: 'Мокурен (магнолія)',
    nameEn: 'Mokuren (magnolia)',
    botanical: 'Magnolia kobus',
    hanakotobaUk: 'природна любов, шляхетна душа',
    hanakotobaEn: 'natural love, noble spirit',
    noteUk:
        'Білі чаші мокурен розкриваються над ще голими гілками саме тоді, коли гусениця стає метеликом — образ повного перетворення.',
    noteEn:
        'White mokuren cups open on bare branches just as caterpillars become butterflies — an image of complete transformation.',
  ),
  10: HanaPairing(
    japanese: '辛夷',
    romaji: 'kobushi',
    nameUk: 'Кобуші (зореподібна магнолія)',
    nameEn: 'Kobushi (kobushi magnolia)',
    botanical: 'Magnolia kobus var. borealis',
    hanakotobaUk: 'привітність, дружба',
    hanakotobaEn: 'friendliness, welcome',
    noteUk:
        'Селяни читали бутон кобуші як годинник для рисової сівби — горобці плетуть гнізда під його розкритим білим небом.',
    noteEn:
        'Farmers once read kobushi buds as a planting clock for rice — sparrows now weave nests beneath its open white canopy.',
  ),
  11: HanaPairing(
    japanese: '桜',
    romaji: 'sakura',
    nameUk: 'Сакура (вишня)',
    nameEn: 'Sakura (cherry blossom)',
    botanical: 'Prunus serrulata',
    hanakotobaUk: 'мимолітність, чистота, новий початок',
    hanakotobaEn: 'ephemeral beauty, purity, new beginnings',
    noteUk:
        'Перший цвіт сакури відкриває ханамі — національне споглядання краси, що триває лише тиждень і саме цим стає безсмертною.',
    noteEn:
        'The first sakura opens hanami — the nation\'s contemplation of beauty that lasts only a week, and is immortal for that reason.',
  ),
  12: HanaPairing(
    japanese: '連翹',
    romaji: 'rengyō',
    nameUk: 'Ренґьо (форзиція)',
    nameEn: 'Rengyō (forsythia)',
    botanical: 'Forsythia suspensa',
    hanakotobaUk: 'передчуття, надія',
    hanakotobaEn: 'anticipation, hope',
    noteUk:
        'Жовтий вогонь ренґьо горить уздовж огорож, поки далекий грім сповіщає, що небо нарешті прокидається.',
    noteEn:
        'Rengyō\'s yellow fire burns along hedgerows while distant thunder announces that the sky has finally woken.',
  ),
  13: HanaPairing(
    japanese: '山吹',
    romaji: 'yamabuki',
    nameUk: 'Ямабукі (керія японська)',
    nameEn: 'Yamabuki (Japanese kerria)',
    botanical: 'Kerria japonica',
    hanakotobaUk: 'благородство, очікування',
    hanakotobaEn: 'nobility, waiting',
    noteUk:
        'Помаранчево-жовті помпони ямабукі схиляються над струмками — улюблена пара ластівкам, що повертаються через море.',
    noteEn:
        'Yamabuki\'s orange-yellow pompoms lean over streams — a favoured companion to swallows returning across the sea.',
  ),
  14: HanaPairing(
    japanese: '花海棠',
    romaji: 'hanakaidō',
    nameUk: 'Ханакайдо (китайська яблуня)',
    nameEn: 'Hanakaidō (flowering crabapple)',
    botanical: 'Malus halliana',
    hanakotobaUk: 'ніжна краса, тиха насолода',
    hanakotobaEn: 'delicate beauty, quiet pleasure',
    noteUk:
        'Поки гуси прямують на північ, ханакайдо звішує рожеві дзвоники — китайський дарунок, обласканий садами Едо.',
    noteEn:
        'As wild geese head north, hanakaidō hangs its pink bells — a Chinese gift cherished by Edo-period gardens.',
  ),
  15: HanaPairing(
    japanese: '枝垂桜',
    romaji: 'shidarezakura',
    nameUk: 'Шідарезакура (плакуча вишня)',
    nameEn: 'Shidarezakura (weeping cherry)',
    botanical: 'Prunus pendula',
    hanakotobaUk: 'найвища краса, доброта',
    hanakotobaEn: 'finest beauty, kindness',
    noteUk:
        'Перші веселки сідають крізь завіси плакучої сакури — водограй пелюсток, що тече до землі у садах Кіото.',
    noteEn:
        'The first rainbows settle through curtains of weeping cherry — a fountain of petals streaming earthward in Kyoto gardens.',
  ),
  16: HanaPairing(
    japanese: '藤',
    romaji: 'fuji',
    nameUk: 'Фуджі (гліцинія)',
    nameEn: 'Fuji (wisteria)',
    botanical: 'Wisteria floribunda',
    hanakotobaUk: 'ласка, вірне кохання, привітання',
    hanakotobaEn: 'kindness, undying love, welcome',
    noteUk:
        'Лілові гірлянди фуджі звисають з пергол храму Бьодо-ін — кожен кетяг тримає аромат, як дзвін тримає звук.',
    noteEn:
        'Lavender chains of fuji drape Byōdō-in pergolas — each cluster holds its scent the way a bell holds sound.',
  ),
  17: HanaPairing(
    japanese: '躑躅',
    romaji: 'tsutsuji',
    nameUk: 'Цуцуджі (рододендрон)',
    nameEn: 'Tsutsuji (azalea)',
    botanical: 'Rhododendron kaempferi',
    hanakotobaUk: 'стриманість, перше кохання',
    hanakotobaEn: 'restraint, first love',
    noteUk:
        'Останній мороз відступає, і цуцуджі запалюють пагорби малиновим — той самий вогонь, що розгрівав поезію поетів Манйошу.',
    noteEn:
        'The last frost retreats and tsutsuji ignite the hills crimson — the same fire that warmed the verses of Manyōshū poets.',
  ),
  18: HanaPairing(
    japanese: '牡丹',
    romaji: 'botan',
    nameUk: 'Ботан (півонія)',
    nameEn: 'Botan (tree peony)',
    botanical: 'Paeonia suffruticosa',
    hanakotobaUk: 'багатство, шляхетність, царська велич',
    hanakotobaEn: 'wealth, nobility, royal grandeur',
    noteUk:
        'Півонія — цар серед квітів: важкі шовкові чаші розкриваються в храмі Хасе-дера, освячуючи кінець весни.',
    noteEn:
        'The peony is king of flowers: heavy silk cups open at Hase-dera temple, consecrating the close of spring.',
  ),

  // ─── Summer ───
  19: HanaPairing(
    japanese: '菖蒲',
    romaji: 'shōbu',
    nameUk: 'Шьобу (солодкий аїр)',
    nameEn: 'Shōbu (sweet flag)',
    botanical: 'Acorus calamus',
    hanakotobaUk: 'мужність, доблесть, оборона',
    hanakotobaEn: 'courage, valour, protection',
    noteUk:
        'На свято Танґо-но-секку листя шьобу занурюють у купіль — оберіг для синів, поки жаби починають співати на полях.',
    noteEn:
        'On Tango-no-Sekku, shōbu leaves steep in the bath — a charm for sons as frogs begin their chorus across the paddies.',
  ),
  20: HanaPairing(
    japanese: '鈴蘭',
    romaji: 'suzuran',
    nameUk: 'Судзуран (конвалія)',
    nameEn: 'Suzuran (lily of the valley)',
    botanical: 'Convallaria keiskei',
    hanakotobaUk: 'повернення щастя, чистота серця',
    hanakotobaEn: 'return of happiness, purity of heart',
    noteUk:
        'Перлинні дзвіночки судзуран дзвонять серед моху, поки дощові черв\'яки виходять на поверхню теплої землі.',
    noteEn:
        'Suzuran\'s pearl bells ring among the moss as earthworms surface from warm-turned soil.',
  ),
  21: HanaPairing(
    japanese: '芍薬',
    romaji: 'shakuyaku',
    nameUk: 'Шякуяку (трав\'яниста півонія)',
    nameEn: 'Shakuyaku (Chinese peony)',
    botanical: 'Paeonia lactiflora',
    hanakotobaUk: 'сором\'язлива краса, гостинність',
    hanakotobaEn: 'bashful beauty, welcome',
    noteUk:
        'Шякуяку розпускається повільно, як жіноча постава — давня приказка ставить її поряд з ботан і янаґі.',
    noteEn:
        'Shakuyaku unfolds slowly, like a graceful stance — an old saying ranks it beside botan and willow as feminine ideals.',
  ),
  22: HanaPairing(
    japanese: '空木',
    romaji: 'utsugi',
    nameUk: 'Уцуґі (дейція)',
    nameEn: 'Utsugi (deutzia)',
    botanical: 'Deutzia crenata',
    hanakotobaUk: 'старі узи, постійність',
    hanakotobaEn: 'old bonds, constancy',
    noteUk:
        'Білий уцуґі — улюблена живопліт селянських садиб, його цвіт сповіщає, що шовкопряди починають бенкет на тутовому листі.',
    noteEn:
        'White utsugi hedges farmsteads, its bloom announcing that silkworms have begun their feast of mulberry leaves.',
  ),
  23: HanaPairing(
    japanese: '紅花',
    romaji: 'benibana',
    nameUk: 'Бенібана (сафлор)',
    nameEn: 'Benibana (safflower)',
    botanical: 'Carthamus tinctorius',
    hanakotobaUk: 'витонченість, особлива пристрасть',
    hanakotobaEn: 'refinement, singular passion',
    noteUk:
        'Жовто-помаранчеві суцвіття бенібана збирали на світанку — з них варили кармінову барву для імператорських кімоно.',
    noteEn:
        'Yellow-orange benibana heads, harvested at dawn, once yielded the carmine that dyed imperial kimono.',
  ),
  24: HanaPairing(
    japanese: '矢車菊',
    romaji: 'yagurumagiku',
    nameUk: 'Яґурумаґіку (волошка)',
    nameEn: 'Yagurumagiku (cornflower)',
    botanical: 'Centaurea cyanus',
    hanakotobaUk: 'витонченість, щаслива зустріч',
    hanakotobaEn: 'delicacy, fortunate meeting',
    noteUk:
        'Сині зірки волошок займають край пшеничного поля саме тоді, коли колоски гнуться золотом — "осінь пшениці".',
    noteEn:
        'Blue cornflower stars line the wheat field just as ears bow with gold — the so-called "wheat autumn".',
  ),
  25: HanaPairing(
    japanese: '杜若',
    romaji: 'kakitsubata',
    nameUk: 'Какіцубата (півник мечоподібний)',
    nameEn: 'Kakitsubata (rabbit-ear iris)',
    botanical: 'Iris laevigata',
    hanakotobaUk: 'щаслива доля, тонке щастя',
    hanakotobaEn: 'good fortune, delicate happiness',
    noteUk:
        'Какіцубата стоять у воді мостових ставків — вісім пелюсток над дзеркалом, оспівані у "Ісе-моноґатарі".',
    noteEn:
        'Kakitsubata rise from bridge ponds — eight petals above their mirror, immortalised in the Tales of Ise.',
  ),
  26: HanaPairing(
    japanese: '梔子',
    romaji: 'kuchinashi',
    nameUk: 'Кучінаші (гарденія)',
    nameEn: 'Kuchinashi (gardenia)',
    botanical: 'Gardenia jasminoides',
    hanakotobaUk: 'я надто щасливий, аби говорити',
    hanakotobaEn: 'I am too happy to speak',
    noteUk:
        'Білі восковий чаші кучінаші пахнуть найгустіше у вечорах, коли світлячки починають свій танок над струмком.',
    noteEn:
        'Kuchinashi\'s waxy white cups release their heaviest perfume at dusk, just as fireflies begin their dance above the stream.',
  ),
  27: HanaPairing(
    japanese: '紫陽花',
    romaji: 'ajisai',
    nameUk: 'Аджісай (гортензія)',
    nameEn: 'Ajisai (hydrangea)',
    botanical: 'Hydrangea macrophylla',
    hanakotobaUk: 'вірність, щира емоція, мінливість',
    hanakotobaEn: 'devotion, heartfelt emotion, change',
    noteUk:
        'Поки сливи жовтіють, аджісай міняє блакит на лілове під дощем цую — храм Меіґецу-ін у Камакурі стає океаном кольору.',
    noteEn:
        'As plums yellow, ajisai shifts blue to lavender beneath the tsuyu rain — Meigetsu-in temple in Kamakura turns into an ocean of colour.',
  ),
  28: HanaPairing(
    japanese: '靫草',
    romaji: 'utsubogusa',
    nameUk: 'Уцубоґуса (звичайна самозцілювальна)',
    nameEn: 'Utsubogusa (self-heal)',
    botanical: 'Prunella vulgaris',
    hanakotobaUk: 'тихе зцілення, скромна милість',
    hanakotobaEn: 'quiet healing, modest grace',
    noteUk:
        'Фіолетові колоски уцубоґуса в\'януть саме у літнє сонцестояння — звідти стародавня назва "трава, що в\'яне у найдовший день".',
    noteEn:
        'Utsubogusa\'s violet spikes wither at the solstice itself — hence the old name "the grass that fades on the longest day".',
  ),
  29: HanaPairing(
    japanese: '菖蒲',
    romaji: 'ayame',
    nameUk: 'Аяме (півник японський)',
    nameEn: 'Ayame (Japanese iris)',
    botanical: 'Iris sanguinea',
    hanakotobaUk: 'добра звістка, надія',
    hanakotobaEn: 'good news, hopeful tidings',
    noteUk:
        'Аяме здіймає три сині знамена над сухішим ґрунтом — вістря, що приймали воїни Хейан як знак готовності.',
    noteEn:
        'Ayame raises three blue banners above drier ground — a blade-shaped flower that Heian warriors took as a sign of readiness.',
  ),
  30: HanaPairing(
    japanese: '半夏',
    romaji: 'hange',
    nameUk: 'Ханґе (пінелія)',
    nameEn: 'Hange (crow-dipper)',
    botanical: 'Pinellia ternata',
    hanakotobaUk: 'тиха стійкість, прихована сила',
    hanakotobaEn: 'quiet endurance, hidden strength',
    noteUk:
        'Зелений каптур ханґе пробивається на межі полів — селяни закінчували сівбу рису саме до її появи.',
    noteEn:
        'Hange\'s green hood pushes up at the field\'s edge — farmers traditionally finished rice planting by the day it appeared.',
  ),
  31: HanaPairing(
    japanese: '笹百合',
    romaji: 'sasayuri',
    nameUk: 'Сасаюрі (бамбукова лілея)',
    nameEn: 'Sasayuri (bamboo lily)',
    botanical: 'Lilium japonicum',
    hanakotobaUk: 'чистота, невинність, благородство',
    hanakotobaEn: 'purity, innocence, nobility',
    noteUk:
        'Рожеві сурми сасаюрі стоять серед бамбукових заростей у спеку Танабати — мрію про зустріч на ріці зірок.',
    noteEn:
        'Sasayuri\'s pink trumpets stand among bamboo thickets in the Tanabata heat — a dream of meeting across the river of stars.',
  ),
  32: HanaPairing(
    japanese: '蓮',
    romaji: 'hasu',
    nameUk: 'Хасу (лотос)',
    nameEn: 'Hasu (lotus)',
    botanical: 'Nelumbo nucifera',
    hanakotobaUk: 'чистота, духовне піднесення, святість',
    hanakotobaEn: 'purity, spiritual rising, sanctity',
    noteUk:
        'Перші лотоси розкриваються на світанку у ставках храмів — священний престол Будди, який підіймається з мулу до світла.',
    noteEn:
        'The first lotus opens at dawn in temple ponds — the sacred throne of the Buddha, rising from mud to light.',
  ),
  33: HanaPairing(
    japanese: '木槿',
    romaji: 'mukuge',
    nameUk: 'Мукуґе (китайська троянда Шарона)',
    nameEn: 'Mukuge (rose of Sharon)',
    botanical: 'Hibiscus syriacus',
    hanakotobaUk: 'віра, переконання, ніжність',
    hanakotobaEn: 'faith, conviction, gentleness',
    noteUk:
        'Мукуґе цвіте лише один день, але кущ дарує нову квітку щоранку — улюблена квітка Сена-но Рікю для літньої чабани.',
    noteEn:
        'Mukuge blooms for only a day, yet the shrub offers another each morning — Sen no Rikyū\'s favoured chabana for summer tea.',
  ),
  34: HanaPairing(
    japanese: '桐',
    romaji: 'kiri',
    nameUk: 'Кірі (павловнія)',
    nameEn: 'Kiri (paulownia)',
    botanical: 'Paulownia tomentosa',
    hanakotobaUk: 'шляхетність, безсмертна гідність',
    hanakotobaEn: 'nobility, enduring dignity',
    noteUk:
        'Тепер уже не цвіт, а зелені коробочки насіння кірі — знак, що з\'являється на гербі імператорського уряду.',
    noteEn:
        'No longer in bloom but in seed: kiri\'s green capsules form — the very emblem stamped on the imperial government\'s seal.',
  ),
  35: HanaPairing(
    japanese: '撫子',
    romaji: 'nadeshiko',
    nameUk: 'Надешіко (японська гвоздика)',
    nameEn: 'Nadeshiko (Japanese pink)',
    botanical: 'Dianthus superbus',
    hanakotobaUk: 'чиста любов, грайливість',
    hanakotobaEn: 'pure love, playfulness',
    noteUk:
        'Тонкі рожеві бахроми надешіко гойдаються у вологому повітрі — одна з семи трав осені, але цвіте з середини літа.',
    noteEn:
        'Nadeshiko\'s slender pink fringes sway in the humid air — one of the seven autumn grasses, though it blooms by midsummer.',
  ),
  36: HanaPairing(
    japanese: '朝顔',
    romaji: 'asagao',
    nameUk: 'Асаґао (берізка ранкова)',
    nameEn: 'Asagao (morning glory)',
    botanical: 'Ipomoea nil',
    hanakotobaUk: 'короткочасна любов, обіцянка ранку',
    hanakotobaEn: 'fleeting love, the promise of morning',
    noteUk:
        'Сині сурми асаґао розкриваються до сніданку, опадаючи до полудня — улюблений мотив базарів Ірія-ентай.',
    noteEn:
        'Asagao\'s blue trumpets open before breakfast and fall by noon — the central motif of the Iriya Asagao market in Tokyo.',
  ),

  // ─── Autumn ───
  37: HanaPairing(
    japanese: '芙蓉',
    romaji: 'fuyō',
    nameUk: 'Фуйо (мінливий гібіск)',
    nameEn: 'Fuyō (cotton rosemallow)',
    botanical: 'Hibiscus mutabilis',
    hanakotobaUk: 'делікатна краса, шляхетна жінка',
    hanakotobaEn: 'delicate beauty, refined lady',
    noteUk:
        'Фуйо змінює колір від білого ранку до рожевого вечора — поведінка, яку хейанські поетеси приписували витонченому серцю.',
    noteEn:
        'Fuyō shifts from white at dawn to pink by dusk — a habit Heian poets attributed to a refined heart.',
  ),
  38: HanaPairing(
    japanese: '女郎花',
    romaji: 'ominaeshi',
    nameUk: 'Омінаєші (золотарник)',
    nameEn: 'Ominaeshi (golden lace)',
    botanical: 'Patrinia scabiosifolia',
    hanakotobaUk: 'грація, краса, м\'яка обіцянка',
    hanakotobaEn: 'grace, beauty, gentle promise',
    noteUk:
        'Жовті мережива омінаєші тремтять серед сухоцвіту — одна з семи трав осені, оспівана Кокіншю у пізньоцикадні дні.',
    noteEn:
        'Ominaeshi\'s yellow lacework trembles among dry stalks — one of the seven autumn grasses, sung in the Kokinshū as cicadas fade.',
  ),
  39: HanaPairing(
    japanese: '桔梗',
    romaji: 'kikyō',
    nameUk: 'Кікьо (платикодон)',
    nameEn: 'Kikyō (balloon flower)',
    botanical: 'Platycodon grandiflorus',
    hanakotobaUk: 'вічне кохання, чесність',
    hanakotobaEn: 'everlasting love, honesty',
    noteUk:
        'П\'ятикутні сині зорі кікьо розкриваються з туго надутих бутонів — клановий герб самурайського роду Акечі.',
    noteEn:
        'Kikyō\'s five-pointed blue stars burst from puffed buds — the family crest of the Akechi samurai line.',
  ),
  40: HanaPairing(
    japanese: '棉',
    romaji: 'wata',
    nameUk: 'Вата (бавовник)',
    nameEn: 'Wata (cotton)',
    botanical: 'Gossypium herbaceum',
    hanakotobaUk: 'витонченість, корисність',
    hanakotobaEn: 'refinement, usefulness',
    noteUk:
        'Кремові квіти вати з\'являються перед тим, як коробочки розкриються пухом — стара осінь країни Кавачі.',
    noteEn:
        'Wata\'s cream flowers open before the bolls split into white tufts — the old autumn of Kawachi province.',
  ),
  41: HanaPairing(
    japanese: '薄',
    romaji: 'susuki',
    nameUk: 'Сусукі (мискантус)',
    nameEn: 'Susuki (Japanese pampas grass)',
    botanical: 'Miscanthus sinensis',
    hanakotobaUk: 'життєва сила, тиха витривалість',
    hanakotobaEn: 'vital force, quiet endurance',
    noteUk:
        'Срібні плюмажі сусукі ловлять перше прохолодне світло — скомпонована з данґо, вона стоїть під місяцем повного жнивного циклу.',
    noteEn:
        'Susuki\'s silver plumes catch the first cool light — set with dango, it stands beneath the harvest moon of mid-autumn.',
  ),
  42: HanaPairing(
    japanese: '稲',
    romaji: 'ine',
    nameUk: 'Іне (рисова квітка)',
    nameEn: 'Ine (rice flower)',
    botanical: 'Oryza sativa',
    hanakotobaUk: 'благословення, плодючість, вдячність',
    hanakotobaEn: 'blessing, fertility, gratitude',
    noteUk:
        'Бліді квіточки рису розкриваються у пообідню тишу — синтоїстські жерці підносять перші колоски в Іна-рі святилищах.',
    noteEn:
        'The pale rice florets open into the afternoon hush — Shintō priests offer the first ears at Inari shrines.',
  ),
  43: HanaPairing(
    japanese: '萩',
    romaji: 'hagi',
    nameUk: 'Хаґі (леспедеца, японська конюшина)',
    nameEn: 'Hagi (bush clover)',
    botanical: 'Lespedeza thunbergii',
    hanakotobaUk: 'задумлива елегантність, чутлива душа',
    hanakotobaEn: 'thoughtful elegance, sensitive heart',
    noteUk:
        'Малинові кетяги хаґі обтяжені росою — найчастіше згадувана квітка "Манйошу", провісниця осінньої туги.',
    noteEn:
        'Hagi\'s crimson sprays bend under dew — the most-mentioned flower in the Manyōshū, herald of autumn melancholy.',
  ),
  44: HanaPairing(
    japanese: '葛',
    romaji: 'kuzu',
    nameUk: 'Кудзу (пуерарія)',
    nameEn: 'Kuzu (kudzu vine)',
    botanical: 'Pueraria lobata',
    hanakotobaUk: 'оживлення, тривала прихильність',
    hanakotobaEn: 'revival, enduring affection',
    noteUk:
        'Пурпурові колоски кудзу пахнуть виноградом над насипами, поки трясогузки маркують границю літа й осені.',
    noteEn:
        'Kuzu\'s purple spikes scent the embankments like grape, while wagtails mark the seam between summer and autumn.',
  ),
  45: HanaPairing(
    japanese: '藤袴',
    romaji: 'fujibakama',
    nameUk: 'Фуджібакама (агератіна японська)',
    nameEn: 'Fujibakama (Japanese boneset)',
    botanical: 'Eupatorium japonicum',
    hanakotobaUk: 'нерішучість, спогади',
    hanakotobaEn: 'hesitation, remembrance',
    noteUk:
        'Сухий аромат фуджібакама нагадує сіно після дощу — ластівки відлітають саме у тиждень її повного цвіту.',
    noteEn:
        'Fujibakama\'s dry fragrance recalls hay after rain — swallows depart just as its bloom reaches its fullest.',
  ),
  46: HanaPairing(
    japanese: '彼岸花',
    romaji: 'higanbana',
    nameUk: 'Хіґанбана (червона лілея-павук)',
    nameEn: 'Higanbana (red spider lily)',
    botanical: 'Lycoris radiata',
    hanakotobaUk: 'знов побачимось, втрата, спогад',
    hanakotobaEn: 'we meet again, loss, remembrance',
    noteUk:
        'Червоні полум\'яні діадеми хіґанбана стоять без листя по краях полів саме у тиждень рівнодення Хіґан.',
    noteEn:
        'Higanbana\'s flame-red diadems stand leafless along field edges in the very week of the Higan equinox.',
  ),
  47: HanaPairing(
    japanese: '秋明菊',
    romaji: 'shūmeigiku',
    nameUk: 'Шюмеіґіку (японська анемона)',
    nameEn: 'Shūmeigiku (Japanese anemone)',
    botanical: 'Anemone hupehensis',
    hanakotobaUk: 'витривалість у негоду, тиха гідність',
    hanakotobaEn: 'endurance through hardship, quiet dignity',
    noteUk:
        'Бліді рожеві анемони хитаються над кам\'яними ліхтарями, поки комахи ховаються — Кіото входить у глибоку осінь.',
    noteEn:
        'Pale-pink anemones sway above stone lanterns as insects retreat — Kyoto eases into deep autumn.',
  ),
  48: HanaPairing(
    japanese: '杜鵑草',
    romaji: 'hototogisu',
    nameUk: 'Хототоґісу (триклапанник волосистий)',
    nameEn: 'Hototogisu (toad lily)',
    botanical: 'Tricyrtis hirta',
    hanakotobaUk: 'таємнича думка, постійне серце',
    hanakotobaEn: 'secret thought, constant heart',
    noteUk:
        'Цяточки на пелюстках хототоґісу нагадують грудку зозулі — улюблена квітка осушеного рисового поля у тіні.',
    noteEn:
        'Hototogisu\'s spotted petals echo the cuckoo\'s breast — a favourite of shaded edges around drained paddies.',
  ),
  49: HanaPairing(
    japanese: '金木犀',
    romaji: 'kinmokusei',
    nameUk: 'Кінмокусей (золотий османт)',
    nameEn: 'Kinmokusei (fragrant olive)',
    botanical: 'Osmanthus fragrans var. aurantiacus',
    hanakotobaUk: 'правда, шляхетність, чарівне покликання',
    hanakotobaEn: 'truth, nobility, alluring summons',
    noteUk:
        'Помаранчеві крихти кінмокусей видають себе ароматом за квартал до того, як їх побачиш — гуси повертаються у супроводі цього парфуму.',
    noteEn:
        'Kinmokusei\'s tiny orange clusters reveal themselves by scent a block away — wild geese return on this perfume.',
  ),
  50: HanaPairing(
    japanese: '菊',
    romaji: 'kiku',
    nameUk: 'Кіку (хризантема)',
    nameEn: 'Kiku (chrysanthemum)',
    botanical: 'Chrysanthemum morifolium',
    hanakotobaUk: 'довголіття, шляхетність, істина',
    hanakotobaEn: 'longevity, nobility, truth',
    noteUk:
        'Свято Тьойо: пелюстки кіку плавають у саке для довголіття — імператорський герб виставляють у храмах по всій країні.',
    noteEn:
        'Chōyō festival: kiku petals float in sake for long life — the imperial crest stands in shrines across the country.',
  ),
  51: HanaPairing(
    japanese: '竜胆',
    romaji: 'rindō',
    nameUk: 'Ріндо (тирлич)',
    nameEn: 'Rindō (Japanese gentian)',
    botanical: 'Gentiana scabra',
    hanakotobaUk: 'кохання у смутку, справедливість',
    hanakotobaEn: 'love in sorrow, justice',
    noteUk:
        'Темно-сині дзвоники ріндо розкриваються лише на сонці — дзеркало холоднішого синього неба, поки цвіркуни співають при дверях.',
    noteEn:
        'Rindō\'s deep-blue bells open only in sunlight — a mirror of the cooler sky, while crickets sing at the threshold.',
  ),
  52: HanaPairing(
    japanese: '紫式部',
    romaji: 'murasakishikibu',
    nameUk: 'Мурасакішікібу (японська каліка)',
    nameEn: 'Murasakishikibu (Japanese beautyberry)',
    botanical: 'Callicarpa japonica',
    hanakotobaUk: 'розум, кмітливість, скромна добра жінка',
    hanakotobaEn: 'wisdom, refinement, gentle goodness',
    noteUk:
        'Перлисто-фіолетові ягоди мурасакішікібу палають крізь перший іній — названа на честь авторки "Ґенджі-моноґатарі".',
    noteEn:
        'Murasakishikibu\'s pearl-violet berries glow through the first frost — named for the author of the Tale of Genji.',
  ),
  53: HanaPairing(
    japanese: '杜鵑花',
    romaji: 'tsuwabuki',
    nameUk: 'Цувабукі (леопардова квітка)',
    nameEn: 'Tsuwabuki (Japanese silver leaf)',
    botanical: 'Farfugium japonicum',
    hanakotobaUk: 'скромність, відданість, тихий вогник',
    hanakotobaEn: 'modesty, devotion, a quiet flame',
    noteUk:
        'Жовті розетки цувабукі засвічують найтемніший куток саду під легкими дощами — одна з небагатьох квіток пізньої осені.',
    noteEn:
        'Tsuwabuki\'s yellow rosettes light the garden\'s darkest corner under thin rains — one of late autumn\'s rare bloomers.',
  ),
  54: HanaPairing(
    japanese: '山茶花',
    romaji: 'sazanka',
    nameUk: 'Садзанка (камелія сасанква)',
    nameEn: 'Sazanka (sasanqua camellia)',
    botanical: 'Camellia sasanqua',
    hanakotobaUk: 'скромна привітність, ідеальне кохання',
    hanakotobaEn: 'modest welcome, ideal love',
    noteUk:
        'Перші рожеві садзанки розкриваються поряд з кленами, що горять — тиха пара палаючим листям, переддень зими.',
    noteEn:
        'The first pink sazanka open beside the burning maples — a quiet companion to flame-coloured leaves on winter\'s edge.',
  ),

  // ─── Winter ───
  55: HanaPairing(
    japanese: '椿',
    romaji: 'tsubaki',
    nameUk: 'Цубакі (камелія японська)',
    nameEn: 'Tsubaki (Japanese camellia)',
    botanical: 'Camellia japonica',
    hanakotobaUk: 'скромна гідність, шанобливість, ідеал',
    hanakotobaEn: 'modest reserve, ideal of perfection',
    noteUk:
        'Червона цубакі падає цілою чашею — самураї вважали це знаком чистого кінця, тому квітка стала душею зимової чабани.',
    noteEn:
        'Red tsubaki falls whole, never petal-by-petal — samurai read this as a clean end, and the flower became winter chabana\'s soul.',
  ),
  56: HanaPairing(
    japanese: '寒菊',
    romaji: 'kangiku',
    nameUk: 'Канґіку (зимова хризантема)',
    nameEn: 'Kangiku (winter chrysanthemum)',
    botanical: 'Chrysanthemum indicum',
    hanakotobaUk: 'спокій у холоді, тиха надія',
    hanakotobaEn: 'calm in the cold, quiet hope',
    noteUk:
        'Дрібні золоті канґіку тримаються на стеблах, поки земля скріплюється морозом — пам\'ять літа під першим льодом.',
    noteEn:
        'Small gold kangiku cling to stems as the land hardens with frost — a memory of summer under the first ice.',
  ),
  57: HanaPairing(
    japanese: '水仙',
    romaji: 'suisen',
    nameUk: 'Суйсен (нарцис тазетта)',
    nameEn: 'Suisen (paperwhite daffodil)',
    botanical: 'Narcissus tazetta var. chinensis',
    hanakotobaUk: 'самоповага, таємнича гідність',
    hanakotobaEn: 'self-respect, mysterious dignity',
    noteUk:
        'Білі сонця нарцисів пахнуть мускусно над снігом мису Ечізен — символ зимових садів від епохи Камакура.',
    noteEn:
        'Suisen\'s white suns scent the snow above Echizen\'s cape — the emblem of winter gardens since Kamakura times.',
  ),
  58: HanaPairing(
    japanese: '八手',
    romaji: 'yatsude',
    nameUk: 'Яцуде (фатсія японська)',
    nameEn: 'Yatsude (paperplant)',
    botanical: 'Fatsia japonica',
    hanakotobaUk: 'тиха міць, родинна привітність',
    hanakotobaEn: 'quiet power, family welcome',
    noteUk:
        'Кулясті білі суцвіття яцуде стоять у внутрішніх двориках — оберіг від злого, відомий як "рука, що відганяє".',
    noteEn:
        'Yatsude\'s ball-like white clusters stand in courtyards — known as "the warding hand", an apotropaic charm.',
  ),
  59: HanaPairing(
    japanese: '柊',
    romaji: 'hiiragi',
    nameUk: 'Хіїраґі (японський холодок)',
    nameEn: 'Hiiragi (false holly)',
    botanical: 'Osmanthus heterophyllus',
    hanakotobaUk: 'захист, далекоглядність',
    hanakotobaEn: 'protection, foresight',
    noteUk:
        'Дрібні білі квіти хіїраґі ховаються між колючим листям — їх вішають разом з головою сардини у Сецубун, аби відлякати демонів.',
    noteEn:
        'Hiiragi\'s tiny white flowers hide among prickly leaves — hung with a sardine head at Setsubun to scare off demons.',
  ),
  60: HanaPairing(
    japanese: '橘',
    romaji: 'tachibana',
    nameUk: 'Тачібана (татібановий цитрус)',
    nameEn: 'Tachibana (tachibana orange)',
    botanical: 'Citrus tachibana',
    hanakotobaUk: 'безсмертний аромат, чистота думки',
    hanakotobaEn: 'eternal fragrance, purity of mind',
    noteUk:
        'Маленькі жовті плоди тачібана висять на вічнозеленому дереві — одне з небесних рослин Хейанського палацу.',
    noteEn:
        'Tachibana\'s small yellow fruit hangs on evergreen branches — one of the sacred plants of the Heian palace courtyard.',
  ),
  61: HanaPairing(
    japanese: '蝋梅',
    romaji: 'rōbai',
    nameUk: 'Робай (зимовий жасмин)',
    nameEn: 'Rōbai (winter sweet)',
    botanical: 'Chimonanthus praecox',
    hanakotobaUk: 'ласкава душа, провідне світло',
    hanakotobaEn: 'gentle heart, guiding light',
    noteUk:
        'Воскові жовті чаші робай світяться, коли тиснеться справжній холод — у безлистому саду тільки цей аромат.',
    noteEn:
        'Rōbai\'s wax-yellow cups glow as the cold deepens — in the leafless garden, only this fragrance remains.',
  ),
  62: HanaPairing(
    japanese: '南天',
    romaji: 'nanten',
    nameUk: 'Нантен (небесний бамбук)',
    nameEn: 'Nanten (sacred bamboo)',
    botanical: 'Nandina domestica',
    hanakotobaUk: 'оберіг від нещастя, добрий поворот',
    hanakotobaEn: 'turning misfortune, good change',
    noteUk:
        'Грона багряних ягід нантен світяться біля вхідних дверей — гра слів "нан-тен" означає "обертання нещастя".',
    noteEn:
        'Nanten\'s scarlet berry clusters glow at entryways — the name puns on "turning misfortune away".',
  ),
  63: HanaPairing(
    japanese: '寒椿',
    romaji: 'kantsubaki',
    nameUk: 'Канцубакі (зимова камелія)',
    nameEn: 'Kantsubaki (winter camellia)',
    botanical: 'Camellia × hiemalis',
    hanakotobaUk: 'витривалість у морозі, спокійне серце',
    hanakotobaEn: 'endurance in frost, steady heart',
    noteUk:
        'Канцубакі тримає рожеві чаші тоді, коли лосось пробивається проти течії — два знаки, що сила тримається проти зими.',
    noteEn:
        'Kantsubaki holds its pink cups while salmon push upstream — two signs of strength holding against winter.',
  ),
  64: HanaPairing(
    japanese: '万両',
    romaji: 'manryō',
    nameUk: 'Манрьо (коралова ягода)',
    nameEn: 'Manryō (coral berry)',
    botanical: 'Ardisia crenata',
    hanakotobaUk: 'багатство десяти тисяч, здобуток',
    hanakotobaEn: 'ten thousand riches, gain',
    noteUk:
        'Червоні ягоди манрьо звисають під вічнозеленим листям — коли утсубоґуса знов проростає, цей кущ обіцяє статок у новому році.',
    noteEn:
        'Manryō\'s red berries hang beneath evergreen leaves — as utsubogusa sprouts anew, this shrub promises wealth in the new year.',
  ),
  65: HanaPairing(
    japanese: '寒桜',
    romaji: 'kanzakura',
    nameUk: 'Кандзакура (зимова сакура)',
    nameEn: 'Kanzakura (winter cherry)',
    botanical: 'Prunus × kanzakura',
    hanakotobaUk: 'тиха надія, передбачення весни',
    hanakotobaEn: 'quiet hope, foretaste of spring',
    noteUk:
        'Поодинокі рожеві кандзакура розкриваються між голих гілок — олені скидають роги, дерево скидає літо й починає знов.',
    noteEn:
        'A few pink kanzakura open on bare branches — as deer shed antlers, the tree sheds summer and begins again.',
  ),
  66: HanaPairing(
    japanese: '千両',
    romaji: 'senryō',
    nameUk: 'Сенрьо (хлоранта Японська)',
    nameEn: 'Senryō (Japanese sarcandra)',
    botanical: 'Sarcandra glabra',
    hanakotobaUk: 'тисячі багатств, святковий добробут',
    hanakotobaEn: 'a thousand riches, festive fortune',
    noteUk:
        'Помаранчеві ягоди сенрьо стоять на новорічному кадомацу — благословення для першого ранку Сьоґацу під снігом.',
    noteEn:
        'Senryō\'s orange berries stand in the New Year kadomatsu — a blessing for Shōgatsu\'s first morning under snow.',
  ),
  67: HanaPairing(
    japanese: '福寿草',
    romaji: 'fukujusō',
    nameUk: 'Фукуджусо (амурський горицвіт)',
    nameEn: 'Fukujusō (pheasant\'s eye)',
    botanical: 'Adonis ramosa',
    hanakotobaUk: 'щасливе довголіття, благословення',
    hanakotobaEn: 'happy long life, blessing',
    noteUk:
        'Золоті чаші фукуджусо ловлять перший зимовий промінь — назва означає "щаслива трава довгого життя".',
    noteEn:
        'Fukujusō\'s gold cups catch the first winter ray — the name means "the herb of happy long life".',
  ),
  68: HanaPairing(
    japanese: '蕗の薹',
    romaji: 'fukinotō',
    nameUk: 'Фукіното (бутон білокопитника)',
    nameEn: 'Fukinotō (butterbur bud)',
    botanical: 'Petasites japonicus',
    hanakotobaUk: 'справедливість, чекання навесні',
    hanakotobaEn: 'fairness, waiting on spring',
    noteUk:
        'Зеленувато-жовті бутони фукіното пробивають сніг біля гірських джерел — гірчинку весни, яку шеф-кухар включає в першу темпуру.',
    noteEn:
        'Fukinotō\'s yellow-green buds pierce the snow near mountain springs — spring\'s bitter note in the season\'s first tempura.',
  ),
  69: HanaPairing(
    japanese: '寒木瓜',
    romaji: 'kanboke',
    nameUk: 'Канбоке (зимова хеномелія)',
    nameEn: 'Kanboke (flowering quince)',
    botanical: 'Chaenomeles japonica',
    hanakotobaUk: 'провідник, рання вістка',
    hanakotobaEn: 'forerunner, early tidings',
    noteUk:
        'Малинові квіти канбоке тримаються на колючих гілках, поки фазани кричать у заростях — дві провісниці справжньої весни.',
    noteEn:
        'Kanboke\'s crimson flowers cling to thorny branches as pheasants call from the brake — twin heralds of true spring.',
  ),
  70: HanaPairing(
    japanese: '款冬',
    romaji: 'fuki',
    nameUk: 'Фукі (білокопитник)',
    nameEn: 'Fuki (butterbur)',
    botanical: 'Petasites japonicus',
    hanakotobaUk: 'справедливість, скромна щирість',
    hanakotobaEn: 'fairness, modest sincerity',
    noteUk:
        'Перші бруньки фукі прокидаються у тіні живоплоту — найхолодніша квітка року, проте її гірчина обіцяє ранню весну.',
    noteEn:
        'Fuki\'s first buds wake in the hedge\'s shadow — the year\'s coldest flower, yet its bitterness promises early spring.',
  ),
  71: HanaPairing(
    japanese: '節分草',
    romaji: 'setsubunsō',
    nameUk: 'Сецубунсо (весняна еранта)',
    nameEn: 'Setsubunsō (winter aconite)',
    botanical: 'Eranthis pinnatifida',
    hanakotobaUk: 'мікрожиття, тиха надія',
    hanakotobaEn: 'small life, quiet hope',
    noteUk:
        'Білі п\'ятипалі квіти сецубунсо розкриваються над товстою кригою у вапнякових долинах — обіцянка вже сформованої весни.',
    noteEn:
        'Setsubunsō\'s white five-finger blooms open above thickening ice in limestone valleys — a promise that spring is already formed.',
  ),
  72: HanaPairing(
    japanese: '白梅',
    romaji: 'hakubai',
    nameUk: 'Хакубай (білий уме)',
    nameEn: 'Hakubai (white plum)',
    botanical: 'Prunus mume f. alba',
    hanakotobaUk: 'чистота, відданість, ясне серце',
    hanakotobaEn: 'purity, devotion, clear heart',
    noteUk:
        'Білий хакубай випереджає весну у ніч Сецубун — зерно метається, демони відступають, а аромат уме обертає рік.',
    noteEn:
        'White hakubai outpaces spring on Setsubun night — beans are thrown, demons depart, and the scent of plum turns the year.',
  ),
};

HanaPairing? hanaForKo(int koIndex) => seasonalHana[koIndex];
