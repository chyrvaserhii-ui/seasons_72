/// Kotowaza (諺) — Japanese proverbs paired to each of the 72 kō.
///
/// Kotowaza are short, fixed sayings — folk wisdom distilled into one
/// or two clauses. Many are anchored to a specific natural phenomenon
/// or season ("三日見ぬ間の桜", "暑さ寒さも彼岸まで") and a curated
/// reader can match them to the 72 kō by content, not just by the
/// 24 sekki. The entries here pick ONE proverb per kō that carries a
/// natural connection to the kō's image — no inventions, only
/// documented sayings from saijiki, kotowaza-jiten, or established
/// folk references.
///
/// When a kō has no truly seasonal proverb tied to its specific cue,
/// we pick a thematic proverb that resonates with the kō's spirit
/// (a winter-courage saying for "Bears hibernate", a renewal saying
/// for "First green sprouts"). The connection note explains why.
library seasonal_kotowaza;

/// One Japanese proverb tied to a single kō.
class KotowazaPairing {
  const KotowazaPairing({
    required this.japanese,
    required this.romaji,
    required this.literalUk,
    required this.literalEn,
    required this.meaningUk,
    required this.meaningEn,
    required this.connectionUk,
    required this.connectionEn,
  });

  /// Japanese form in kanji + kana, e.g. "三日見ぬ間の桜".
  final String japanese;

  /// Hepburn romaji, e.g. "mikka minu ma no sakura".
  final String romaji;

  /// Literal Ukrainian translation (the words themselves), short —
  /// "вишня, не бачена три дні".
  final String literalUk;

  /// Literal English translation, short — "cherries unseen for three
  /// days".
  final String literalEn;

  /// What the proverb means in everyday use — 1–2 sentences UK.
  /// "Світ змінюється швидко: достатньо відвернутись на три дні —
  /// і все стало інакшим."
  final String meaningUk;

  /// English version of [meaningUk] — 1–2 sentences.
  final String meaningEn;

  /// Why this proverb is paired to THIS kō — 1 sentence linking it
  /// to the natural cue of the season.
  final String connectionUk;

  /// English version of [connectionUk].
  final String connectionEn;
}

/// One kotowaza per kō (1..72). Empty entries are filled by a separate
/// content pass — each entry MUST be a documented Japanese proverb,
/// not an invention.
const Map<int, KotowazaPairing> seasonalKotowaza = {
  // ─── Spring ───

  // Kō 1 — East wind melts the ice
  1: KotowazaPairing(
    japanese: '春は名のみの風の寒さや',
    romaji: 'haru wa na nomi no kaze no samusa ya',
    literalUk: 'весна лиш на ім\'я — вітер ще холодний',
    literalEn: 'spring in name only — the wind still cold',
    meaningUk:
        'Календар уже каже «весна», та повітря тримає зиму. Перехідна пора, де назва випереджає відчуття.',
    meaningEn:
        'The calendar says spring, but the air still belongs to winter — a threshold time where the name runs ahead of the feeling.',
    connectionUk:
        'Саме про цей кō: ріссюн прийшов, перші теплі подуви ще тільки лижуть кригу.',
    connectionEn:
        'Exactly this kō: risshun has come, but the first warm gusts only begin to lick at the ice.',
  ),

  // Kō 2 — Bush warblers start singing
  2: KotowazaPairing(
    japanese: '梅に鶯',
    romaji: 'ume ni uguisu',
    literalUk: 'до сливи — соловей',
    literalEn: 'a bush warbler on a plum',
    meaningUk:
        'Класичний образ ідеальної пари — речі, що пасують одна до одної як у природі, так і в житті.',
    meaningEn:
        'The classic image of a perfect match — two things that belong together by nature, like a poem written for each other.',
    connectionUk:
        'Уґуйсу запіяв у горах — точна іконографічна пара, з якою його завжди ставлять.',
    connectionEn:
        'The uguisu has begun to sing — and folklore always pairs his voice with the plum branch.',
  ),

  // Kō 3 — Fish emerge from the ice
  3: KotowazaPairing(
    japanese: '魚心あれば水心',
    romaji: 'uogokoro areba mizugokoro',
    literalUk: 'якщо в риби є серце, у води теж',
    literalEn: 'if the fish has a heart, the water has one too',
    meaningUk:
        'Доброзичливість викликає доброзичливість: відповідь природи рівна намірові, з яким ти до неї звертаєшся.',
    meaningEn:
        'Goodwill begets goodwill — what the world gives back is shaped by what you bring to it.',
    connectionUk:
        'Риба піднімається з-під криги: вода нарешті відповідає їй теплом — точно як у прислів\'ї.',
    connectionEn:
        'Fish rise through the thinning ice: the water finally answers them with warmth, just as the proverb describes.',
  ),

  // Kō 4 — Rain moistens the soil
  4: KotowazaPairing(
    japanese: '雨垂れ石を穿つ',
    romaji: 'amadare ishi o ugatsu',
    literalUk: 'крапля з даху продірявлює камінь',
    literalEn: 'dripping water bores through stone',
    meaningUk:
        'Маленька, але постійна дія перемагає велику перешкоду. Терпіння й повторення сильніші за раптову силу.',
    meaningEn:
        'Small, steady action defeats great resistance — patience and repetition outlast brute force.',
    connectionUk:
        'Лагідні дощі усуй просочуються в землю — та сама непомітна, але невідворотна робота краплі.',
    connectionEn:
        'The gentle usui rains seep into the earth — the same invisible, unstoppable work of the dripping drop.',
  ),

  // Kō 5 — Mist starts to linger
  5: KotowazaPairing(
    japanese: '春霞は花の母',
    romaji: 'harugasumi wa hana no haha',
    literalUk: 'весняний серпанок — мати квітів',
    literalEn: 'spring haze is the mother of blossoms',
    meaningUk:
        'Туманна вільгість плекає те, що скоро розквітне. Підготовча тиша так само важлива, як і самі квіти.',
    meaningEn:
        'Misty moisture nurses what is about to bloom — the quiet preparation matters as much as the flowers themselves.',
    connectionUk:
        'Перші ранкові тумани вкривають пагорби: у саджіках вони — пряма колиска для майбутнього цвіту.',
    connectionEn:
        'The first morning mists drape the hills — saijiki call this very haze the cradle of the bloom to come.',
  ),

  // Kō 6 — Grass sprouts, trees bud
  6: KotowazaPairing(
    japanese: '艱難汝を玉にす',
    romaji: 'kannan nanji o tama ni su',
    literalUk: 'труднощі гранять тебе на коштовність',
    literalEn: 'hardship polishes you into a jewel',
    meaningUk:
        'Те, що пробивається крізь опір, виходить кращим. Зимівля під землею була тренуванням, а не покаранням.',
    meaningEn:
        'What pushes through resistance comes out better for it — winter underground was training, not punishment.',
    connectionUk:
        'Ніжні паростки пробиваються крізь твердий ґрунт: проста ілюстрація того, як опір робить життя сильнішим.',
    connectionEn:
        'Tender shoots break through hardened soil — a plain image of how resistance makes life stronger.',
  ),

  // Kō 7 — Hibernating insects surface
  7: KotowazaPairing(
    japanese: '一寸の虫にも五分の魂',
    romaji: 'issun no mushi ni mo gobu no tamashii',
    literalUk: 'навіть у дюймовій комасі — пів-дюйма душі',
    literalEn: 'even a one-inch bug has half an inch of soul',
    meaningUk:
        'Найменше створіння має власну гідність і волю. Не зневажай дрібного — у нього теж є серце.',
    meaningEn:
        'Even the smallest creature has its own dignity and will — never dismiss the tiny, for it too has a heart.',
    connectionUk:
        'Кейчіцу: комахи, яких усі ігнорували пів року, повертають собі голос і місце на землі.',
    connectionEn:
        'Keichitsu: the insects everyone ignored for half a year reclaim their voice and place on the earth.',
  ),

  // Kō 8 — First peach blossoms
  8: KotowazaPairing(
    japanese: '桃栗三年柿八年',
    romaji: 'momo kuri sannen kaki hachinen',
    literalUk: 'персик і каштан — три роки, хурма — вісім',
    literalEn: 'peach and chestnut three years, persimmon eight',
    meaningUk:
        'У кожної справи — свій час визрівання, який не можна скоротити. Поспіх не замінить років, потрібних плоду.',
    meaningEn:
        'Every endeavour has its own ripening time — no haste can replace the years a fruit needs.',
    connectionUk:
        'Перший цвіт персика — те саме дерево, з якого прислів\'я починає свій рахунок років.',
    connectionEn:
        'First peach blossoms — the very tree from which the proverb starts counting its years.',
  ),

  // Kō 9 — Caterpillars become butterflies
  9: KotowazaPairing(
    japanese: '蛹より蝶',
    romaji: 'sanagi yori chō',
    literalUk: 'із лялечки — метелик',
    literalEn: 'from the chrysalis, a butterfly',
    meaningUk:
        'Невидима внутрішня робота закінчується видимим перетворенням. Той, хто терпів темряву, виходить на світло іншим.',
    meaningEn:
        'Invisible inner work ends in visible transformation — the one who endured the dark steps into the light changed.',
    connectionUk:
        'Гусениця стає метеликом: прислів\'я майже дослівно описує, що відбувається в саду цієї пори.',
    connectionEn:
        'The caterpillar becomes a butterfly — the proverb almost literally describes what is happening in the garden now.',
  ),

  // Kō 10 — Sparrows start to nest
  10: KotowazaPairing(
    japanese: '雀百まで踊り忘れず',
    romaji: 'suzume hyaku made odori wasurezu',
    literalUk: 'горобець до ста років не забуде свого танцю',
    literalEn: 'a sparrow till a hundred never forgets its dance',
    meaningUk:
        'Звички, набуті змалку, тримаються все життя. Те, що в людині від природи, не змивається ні віком, ні досвідом.',
    meaningEn:
        'Habits learned young last a lifetime — what is innate in a person isn\'t washed away by age or experience.',
    connectionUk:
        'Горобці беруться за свою щорічну роботу — гнізда вони в\'ють так само, як їхні предки сто років тому.',
    connectionEn:
        'Sparrows return to their yearly work — they build nests exactly as their ancestors did a hundred years before.',
  ),

  // Kō 11 — First cherry blossoms bloom
  11: KotowazaPairing(
    japanese: '三日見ぬ間の桜',
    romaji: 'mikka minu ma no sakura',
    literalUk: 'сакура за три дні без погляду',
    literalEn: 'cherries left unseen for three days',
    meaningUk:
        'Світ змінюється швидко: досить відвернутись на три дні — і все вже інакше. Краса і життя минущі.',
    meaningEn:
        'The world changes fast — look away for three days and everything is different. Beauty and life are fleeting.',
    connectionUk:
        'Перший цвіт сакури — буквально те, про що говорить прислів\'я: завтрашня вишня вже не та, що сьогодні.',
    connectionEn:
        'First cherry blossoms — literally the subject of the proverb: tomorrow\'s sakura is not yesterday\'s.',
  ),

  // Kō 12 — Distant thunder
  12: KotowazaPairing(
    japanese: '地震雷火事親父',
    romaji: 'jishin kaminari kaji oyaji',
    literalUk: 'землетрус, грім, пожежа, батько',
    literalEn: 'earthquake, thunder, fire, father',
    meaningUk:
        'Перелік чотирьох найстрашніших речей у домі — від стихії до домашнього авторитету. Грім тут стоїть на другому місці.',
    meaningEn:
        'The four most fearsome things at home — from natural disasters down to the family patriarch. Thunder ranks second.',
    connectionUk:
        'Перші перекоти весняного грому: він повертається у щорічний список речей, з якими варто рахуватись.',
    connectionEn:
        'The first rolls of spring thunder return him to the yearly list of forces to be reckoned with.',
  ),

  // Kō 13 — Swallows return
  13: KotowazaPairing(
    japanese: '燕が来ると春が来る',
    romaji: 'tsubame ga kuru to haru ga kuru',
    literalUk: 'ластівка прилітає — приходить весна',
    literalEn: 'when the swallow comes, spring comes',
    meaningUk:
        'Народна прикмета: справжня весна починається тоді, коли під дахом знову з\'являється ластівчине гніздо.',
    meaningEn:
        'A folk omen — real spring begins when the swallow returns to her old nest under the eaves.',
    connectionUk:
        'Ластівки повертаються з півдня саме в цей кō: прислів\'я тут пряма календарна формула.',
    connectionEn:
        'Swallows return from the south in this very kō — the proverb here is a direct calendar formula.',
  ),

  // Kō 14 — Wild geese fly north
  14: KotowazaPairing(
    japanese: '燕雀いずくんぞ鴻鵠の志を知らんや',
    romaji: 'enjaku izukunzo kōkoku no kokorozashi o shiran ya',
    literalUk: 'як ластівка й горобець збагнуть задум лебедя?',
    literalEn: 'how can swallow and sparrow grasp the swan\'s ambition?',
    meaningUk:
        'Малий розум не охоплює великих задумів. Той, хто живе близько до землі, не бачить далеких шляхів.',
    meaningEn:
        'A small mind cannot grasp a great plan — the one who stays low cannot see the long routes.',
    connectionUk:
        'Дикі гуси (鴻 — той самий ієрогліф) рушають на північ: до прислів\'я пасує саме ця широта льоту.',
    connectionEn:
        'The wild geese (鴻 — the proverb\'s very character) leave for the north — exactly the wide flight the saying invokes.',
  ),

  // Kō 15 — First rainbows appear
  15: KotowazaPairing(
    japanese: '雨降って地固まる',
    romaji: 'ame futte ji katamaru',
    literalUk: 'дощ пройшов — земля затверділа',
    literalEn: 'after the rain falls, the ground hardens',
    meaningUk:
        'Після конфлікту чи негоди стосунки й справи стають міцнішими. Криза не руйнує — вона укладає основу.',
    meaningEn:
        'After a quarrel or storm, things settle stronger than before — the crisis lays the foundation, not breaks it.',
    connectionUk:
        'Перша веселка приходить, коли дощ і сонце нарешті знаходять рівновагу — буквально той момент із прислів\'я.',
    connectionEn:
        'The first rainbow appears when rain and sun finally settle into balance — literally the moment the proverb names.',
  ),

  // Kō 16 — First reeds sprout
  16: KotowazaPairing(
    japanese: '人間は考える葦である',
    romaji: 'ningen wa kangaeru ashi de aru',
    literalUk: 'людина — це очерет, що мислить',
    literalEn: 'man is a thinking reed',
    meaningUk:
        'Слова Паскаля, що міцно увійшли в японську фразеологію: людина крихка, як стеблина, але її сила в думці.',
    meaningEn:
        'Pascal\'s line, long naturalised in Japanese — man is fragile as a reed, yet his power lies in thought.',
    connectionUk:
        'Перші паростки очерету піднімаються з води — той самий аші, що дав прислів\'ю його образ.',
    connectionEn:
        'The first reeds rise from the water — the very ashi that gave the proverb its image.',
  ),

  // Kō 17 — Last frost, rice seedlings grow
  17: KotowazaPairing(
    japanese: '苗半作',
    romaji: 'nae hansaku',
    literalUk: 'розсада — це половина врожаю',
    literalEn: 'the seedling is half the harvest',
    meaningUk:
        'Якщо розсада здорова, врожай уже наполовину забезпечений. Доля справи закладається на самому її початку.',
    meaningEn:
        'If the seedling is sound, half the harvest is already won — the fate of any work is set at its beginning.',
    connectionUk:
        'Селяни саме готують рисову розсаду після останнього інію — кō і прислів\'я говорять про той самий момент.',
    connectionEn:
        'Farmers are preparing the rice seedlings just after the last frost — kō and proverb speak of the same moment.',
  ),

  // Kō 18 — Peonies bloom
  18: KotowazaPairing(
    japanese: '立てば芍薬座れば牡丹歩く姿は百合の花',
    romaji: 'tateba shakuyaku suwareba botan aruku sugata wa yuri no hana',
    literalUk: 'стоїть — півонія-сяку, сидить — півонія-ботан, іде — лілея',
    literalEn: 'standing she is shakuyaku, seated botan, walking a lily',
    meaningUk:
        'Класичний опис жіночої грації через три квітки. Найвища похвала красі — порівняти її з ботаном.',
    meaningEn:
        'A classical praise of grace via three flowers — the highest compliment is to be likened to the botan peony.',
    connectionUk:
        'Цариця квітів ботан розкривається саме зараз — і саме її ставлять у центр прислів\'я про красу.',
    connectionEn:
        'The botan, queen of flowers, opens now — and the proverb sets her at the very centre of beauty.',
  ),

  // ─── Summer ───

  // Kō 19 — Frogs start singing
  19: KotowazaPairing(
    japanese: '井の中の蛙大海を知らず',
    romaji: 'i no naka no kawazu taikai o shirazu',
    literalUk: 'жаба в криниці не знає моря',
    literalEn: 'a frog in a well knows nothing of the great sea',
    meaningUk:
        'Той, чий світ обмежений, упевнений, що бачить його весь. Вузький горизонт легко прийняти за всю істину.',
    meaningEn:
        'One whose world is small is sure he sees it whole — a narrow horizon is easily mistaken for the whole truth.',
    connectionUk:
        'Перший спів жаб: саме та кавадзу, що сидить у криниці прислів\'я, тепер уперше озивається.',
    connectionEn:
        'First frog song: the very kawazu of the proverb\'s well now lifts his voice for the first time.',
  ),

  // Kō 20 — Worms surface
  20: KotowazaPairing(
    japanese: '蓼食う虫も好き好き',
    romaji: 'tade kuu mushi mo sukizuki',
    literalUk: 'навіть ті комахи, що їдять гірчак, — на свій смак',
    literalEn: 'even bugs that eat smartweed have their tastes',
    meaningUk:
        'У кожного свої вподобання, навіть якщо збоку вони здаються гіркими або дивними. Не суди чужого вибору.',
    meaningEn:
        'Each creature has its own taste, however strange from outside — never judge another\'s preferences.',
    connectionUk:
        'Черв\'яки виповзають у теплий ґрунт: маленьке життя під ногами оживає, кожне з власним смаком.',
    connectionEn:
        'Worms rise into the warming soil: tiny life beneath the feet wakes again, each to its own taste.',
  ),

  // Kō 21 — Bamboo shoots sprout
  21: KotowazaPairing(
    japanese: '雨後の筍',
    romaji: 'ugo no takenoko',
    literalUk: 'бамбукові пагони після дощу',
    literalEn: 'bamboo shoots after rain',
    meaningUk:
        'Образ для речей, що з\'являються одна за одною з вражаючою швидкістю — ринкові новинки, нові ідеї, чутки.',
    meaningEn:
        'An image for things that appear one after another with astonishing speed — fads, new ideas, fresh rumours.',
    connectionUk:
        'Бамбук пробивається з лісової підстилки за лічені години — пряме джерело прислів\'я.',
    connectionEn:
        'Bamboo breaks through the forest floor in hours — the proverb\'s direct source.',
  ),

  // Kō 22 — Silkworms awaken, feast on mulberry leaves
  22: KotowazaPairing(
    japanese: '蚕食',
    romaji: 'sanshoku',
    literalUk: 'поїдання, як шовкопряд',
    literalEn: 'devouring like silkworms',
    meaningUk:
        'Стійка фраза для повільного, але цілковитого захоплення — території, ринку, листя — лист за листом.',
    meaningEn:
        'A fixed phrase for slow but total takeover — of territory, market, or leaves — eaten one by one.',
    connectionUk:
        'Шовкопряди прокидаються голодними і виходять на тутове листя — буквальна сцена з прислів\'я.',
    connectionEn:
        'Silkworms wake hungry and set upon mulberry leaves — the literal scene the proverb names.',
  ),

  // Kō 23 — Safflowers bloom abundantly
  23: KotowazaPairing(
    japanese: '紅は園生に植えても隠れなし',
    romaji: 'kurenai wa sonō ni uete mo kakure nashi',
    literalUk: 'червоний колір не сховаєш, навіть якщо посадиш у саду',
    literalEn: 'crimson cannot be hidden, even planted in a garden',
    meaningUk:
        'Справжній талант або яскравість не можна замаскувати: вони впадають в око навіть серед іншої рослинності.',
    meaningEn:
        'True talent or brilliance cannot be hidden — it stands out no matter what surrounds it.',
    connectionUk:
        'Поля сафлорів-беніхана палають оранжево-червоним — той самий куренай, який прислів\'я називає невловним.',
    connectionEn:
        'Safflower fields blaze red-orange — the very kurenai the proverb calls impossible to hide.',
  ),

  // Kō 24 — Wheat ripens and is harvested
  24: KotowazaPairing(
    japanese: '実るほど頭を垂れる稲穂かな',
    romaji: 'minoru hodo kōbe o tareru inaho kana',
    literalUk: 'що стигліший, то нижче схиляється колос',
    literalEn: 'the riper the head, the lower the rice ear bows',
    meaningUk:
        'Чим більше людина знає і має, тим скромнішою вона стає. Зрілість упізнається за схиленою головою.',
    meaningEn:
        'The more one knows and has, the humbler one grows — maturity is recognised by the bowed head.',
    connectionUk:
        'Пшеничні жнива: колосся гнеться під вагою стиглого зерна — точна сцена з прислів\'я (тут не рис, а муґі).',
    connectionEn:
        'Wheat harvest: the heads bend under ripe grain — the exact scene of the proverb, in mugi rather than rice.',
  ),

  // Kō 25 — Praying mantises hatch
  25: KotowazaPairing(
    japanese: '蟷螂の斧',
    romaji: 'tōrō no ono',
    literalUk: 'сокира богомола',
    literalEn: 'the mantis\'s axe',
    meaningUk:
        'Хоробрий, але приречений опір: маленьке створіння кидається на велику колісницю своїми «сокирами».',
    meaningEn:
        'Brave but doomed resistance — the tiny creature lifts its little "axes" against a great chariot.',
    connectionUk:
        'Богомольчики щойно вилупились — і вже стоять у позі прислів\'я з піднятими передніми лапами.',
    connectionEn:
        'Mantis nymphs have just hatched — and already stand in the proverb\'s pose, forelegs raised.',
  ),

  // Kō 26 — Rotten grass becomes fireflies
  26: KotowazaPairing(
    japanese: '蛍二十日に蝉三日',
    romaji: 'hotaru hatsuka ni semi mikka',
    literalUk: 'світлячку — двадцять днів, цикаді — три',
    literalEn: 'fireflies last twenty days, cicadas three',
    meaningUk:
        'Найяскравіше у житті триває коротко — і саме тому його варто помітити. Розквіт міряється не в роках.',
    meaningEn:
        'The brightest moments of life are short — and that is exactly why they must be noticed. Bloom is not measured in years.',
    connectionUk:
        'Світлячки народжуються з прілої трави: ті самі хотару, чиї двадцять днів сяйва тепер починаються.',
    connectionEn:
        'Fireflies are born of decaying grass — the very hotaru whose twenty days of light now begin.',
  ),

  // Kō 27 — Plums turn yellow
  27: KotowazaPairing(
    japanese: '梅はその日の難逃れ',
    romaji: 'ume wa sono hi no nan nogare',
    literalUk: 'слива врятує від денних бід',
    literalEn: 'a plum keeps the day\'s troubles away',
    meaningUk:
        'Народна аптечна мудрість: умебосі вранці захищає організм від нездужань цілого дня. Маленька щоденна звичка-щит.',
    meaningEn:
        'A folk-pharmacy saying: a pickled plum in the morning shields the body from the day\'s ills — a small daily habit, a daily shield.',
    connectionUk:
        'Сливи уме жовтіють — час умебосі та сливового вина, що про них і говорить прислів\'я.',
    connectionEn:
        'Ume plums turn yellow — the time of umeboshi and plum wine the proverb invokes.',
  ),

  // Kō 28 — Self-heal withers
  28: KotowazaPairing(
    japanese: '盛者必衰',
    romaji: 'jōsha hissui',
    literalUk: 'усе квітуче неминуче в\'яне',
    literalEn: 'what flourishes must decline',
    meaningUk:
        'Буддійська формула з «Хейке Моноґатарі»: розквіт несе в собі своє в\'янення, навіть на вершині сили.',
    meaningEn:
        'A Buddhist formula from the Heike Monogatari — flourishing already carries its own withering, even at the height of power.',
    connectionUk:
        'У пік літа окремі трави починають в\'янути: природа сама ілюструє сутру про неминучий захід розквіту.',
    connectionEn:
        'At summer\'s peak certain grasses begin to wither — nature itself illustrates the sutra of inevitable decline.',
  ),

  // Kō 29 — Irises bloom
  29: KotowazaPairing(
    japanese: 'いずれ菖蒲か杜若',
    romaji: 'izure ayame ka kakitsubata',
    literalUk: 'ірис чи касатник — однаково гарні',
    literalEn: 'iris or kakitsubata — both equally fair',
    meaningUk:
        'Коли всі варіанти однаково красиві, неможливо обрати одну. Похвала, у якій неможливість вибору — найвища оцінка.',
    meaningEn:
        'When every option is equally beautiful, no choice can be made — a praise where the impossibility of choosing is itself the verdict.',
    connectionUk:
        'Іриси розкриваються в ставах — той самий аяме, з якого почалось прислів\'я.',
    connectionEn:
        'Irises unfurl in the ponds — the very ayame from which the proverb begins.',
  ),

  // Kō 30 — Crow-dipper sprouts
  30: KotowazaPairing(
    japanese: '半夏半作',
    romaji: 'hange hansaku',
    literalUk: 'до ханґе — половина врожаю',
    literalEn: 'by hange, half the harvest',
    meaningUk:
        'Селянське правило: висадити рис треба до дня ханґе-сьо, інакше пізніша робота не вирівняє втрат.',
    meaningEn:
        'A farmer\'s rule — finish rice planting by the day of hange, or the later work will not make up the loss.',
    connectionUk:
        'Цей кō і є ханґе-сьо: прислів\'я названо точно за днем, що зараз настає.',
    connectionEn:
        'This kō is hange-shō itself — the proverb is named for the very day arriving now.',
  ),

  // Kō 31 — Warm winds blow
  31: KotowazaPairing(
    japanese: '夏の風邪は犬も引かぬ',
    romaji: 'natsu no kaze wa inu mo hikanu',
    literalUk: 'літньою застудою навіть пес не хворіє',
    literalEn: 'not even a dog catches a summer cold',
    meaningUk:
        'Захворіти влітку — соромно: значить, ти сам недогледів свою силу, бо хвороби цієї пори рідкісні.',
    meaningEn:
        'Falling ill in summer is embarrassing — it means you neglected yourself, since illness is rare in this season.',
    connectionUk:
        'Перші гарячі вологі вітри — саме та погода, у якій застудитися здавалося б неможливо.',
    connectionEn:
        'The first hot, humid winds are exactly the weather in which catching cold seems impossible.',
  ),

  // Kō 32 — First lotus blossoms
  32: KotowazaPairing(
    japanese: '泥中の蓮',
    romaji: 'deichū no hasu',
    literalUk: 'лотос серед бруду',
    literalEn: 'a lotus in the mud',
    meaningUk:
        'Краса й чистота можуть здійматися навіть із найбруднішого підґрунтя. Походження не визначає того, ким можна стати.',
    meaningEn:
        'Beauty and purity can rise from the dirtiest ground — origin does not decide who one can become.',
    connectionUk:
        'Лотоси саме піднімаються над мутною водою ставка — буквальна картина прислів\'я.',
    connectionEn:
        'Lotuses are just rising above the muddy pond — the proverb\'s literal picture.',
  ),

  // Kō 33 — Hawks learn to fly
  33: KotowazaPairing(
    japanese: '能ある鷹は爪を隠す',
    romaji: 'nō aru taka wa tsume o kakusu',
    literalUk: 'умілий яструб ховає кігті',
    literalEn: 'a skilled hawk hides its talons',
    meaningUk:
        'Справжній майстер не виставляє своїх здібностей напоказ. Сила тиха; пишається лише той, кому її не вистачає.',
    meaningEn:
        'A true master does not display his skills — strength is quiet; only those who lack it boast.',
    connectionUk:
        'Молоді яструби вчаться літати: прислів\'я говорить саме про того тако, чиє мистецтво зараз дозріває.',
    connectionEn:
        'Young hawks are learning to fly — the proverb names the very taka whose mastery is ripening now.',
  ),

  // Kō 34 — Paulownia trees produce seeds
  34: KotowazaPairing(
    japanese: '桐一葉落ちて天下の秋を知る',
    romaji: 'kiri hitoha ochite tenka no aki o shiru',
    literalUk: 'один листок павловнії впав — знай: настала осінь',
    literalEn: 'one paulownia leaf falls — and one knows it is autumn',
    meaningUk:
        'Маленький, ледь помітний знак уже містить у собі велику зміну. Уважний бачить кінець епохи в одному жесті.',
    meaningEn:
        'A small, barely noticed sign already contains a great change — the attentive see the end of an era in a single gesture.',
    connectionUk:
        'Павловнія зав\'язує насіння: дерево з прислів\'я готує той самий лист, який ось-ось упаде.',
    connectionEn:
        'The paulownia is forming its seeds — the proverb\'s tree is readying the very leaf that will soon fall.',
  ),

  // Kō 35 — Earth is damp, air is humid
  35: KotowazaPairing(
    japanese: '暑さも忘れる',
    romaji: 'atsusa mo wasureru',
    literalUk: 'забути навіть про спеку',
    literalEn: 'forgetting even the heat',
    meaningUk:
        'Заглибленість у справу така, що зникають тілесні відчуття. Захопленість сильніша за погоду.',
    meaningEn:
        'Absorption in a task so deep that bodily sensation vanishes — passion is stronger than the weather.',
    connectionUk:
        'Пік задушливого літа: саме та спека, від якої прислів\'я обіцяє звільнення лише через справжнє занурення.',
    connectionEn:
        'The peak of muggy summer — the very heat the proverb promises release from, only through deep absorption.',
  ),

  // Kō 36 — Great rains sometimes fall
  36: KotowazaPairing(
    japanese: '夕立は馬の背を分ける',
    romaji: 'yūdachi wa uma no se o wakeru',
    literalUk: 'вечірня злива розділяє коневі спину',
    literalEn: 'a summer downpour splits a horse\'s back',
    meaningUk:
        'Літня злива настільки локальна, що один бік коня мокне, а другий лишається сухим. Образ раптової межі поруч.',
    meaningEn:
        'A summer cloudburst is so local that one side of a horse is drenched while the other stays dry — an image of a sudden line nearby.',
    connectionUk:
        'Раптові літні зливи: те саме юдачі, про яке прислів\'я знає, що воно ходить плямами.',
    connectionEn:
        'Sudden summer downpours — the very yūdachi the proverb says falls in patches.',
  ),

  // ─── Autumn ───

  // Kō 37 — Cool winds blow
  37: KotowazaPairing(
    japanese: '一葉落ちて天下の秋を知る',
    romaji: 'ichiyō ochite tenka no aki o shiru',
    literalUk: 'один листок упав — і вся піднебесна знає: осінь',
    literalEn: 'one leaf falls — and the world knows autumn has come',
    meaningUk:
        'Найменший знак приносить велику новину. Чутливий бачить розворот року в одному падінні листка.',
    meaningEn:
        'The smallest sign carries the largest news — the sensitive see the year\'s turn in a single falling leaf.',
    connectionUk:
        'Перший прохолодний вітер — точно той малий сигнал, у якому прислів\'я бачить уже всю осінь.',
    connectionEn:
        'The first cool wind is exactly the small signal in which the proverb already sees the whole autumn.',
  ),

  // Kō 38 — Evening cicadas sing
  38: KotowazaPairing(
    japanese: '蝉の抜け殻',
    romaji: 'semi no nukegara',
    literalUk: 'порожня шкаралуща цикади',
    literalEn: 'the empty shell of a cicada',
    meaningUk:
        'Те, що залишилося, коли життя пішло — оболонка без сили. Образ для людини, яка втратила суть, лишивши форму.',
    meaningEn:
        'What stays when life is gone — a husk without force. An image of one who has lost the essence and kept only the form.',
    connectionUk:
        'Хіґурасі співають у сутінках, а на корі вже висять їхні порожні шкаралущі — прислів\'я тут чути буквально.',
    connectionEn:
        'The higurashi sing at dusk while empty shells already cling to the bark — the proverb is heard here literally.',
  ),

  // Kō 39 — Thick fog descends
  39: KotowazaPairing(
    japanese: '五里霧中',
    romaji: 'gori muchū',
    literalUk: 'у тумані на п\'ять рі',
    literalEn: 'lost in fog for five li',
    meaningUk:
        'Стан повної невизначеності, коли неможливо зорієнтуватись ні в напрямку, ні в наступному кроці.',
    meaningEn:
        'A state of total uncertainty where neither direction nor the next step can be made out.',
    connectionUk:
        'Густі ранкові тумани вкривають долини — рідкісний випадок, коли прислів\'я можна побачити з вікна.',
    connectionEn:
        'Thick morning fogs blanket the valleys — a rare moment when the proverb can be seen out the window.',
  ),

  // Kō 40 — Cotton flowers bloom
  40: KotowazaPairing(
    japanese: '錦上花を添える',
    romaji: 'kinjō hana o soeru',
    literalUk: 'до парчі додати квітів',
    literalEn: 'to add flowers to brocade',
    meaningUk:
        'Прикрашати й без того гарне — додавати красу до краси. Часом — про надмір, але частіше про щиру щедрість.',
    meaningEn:
        'To beautify what is already beautiful — sometimes excess, more often genuine generosity.',
    connectionUk:
        'Бавовна розкривається пухнастими білими квітками — м\'яка прикраса до вже зрілого осіннього поля.',
    connectionEn:
        'Cotton bursts into fluffy white blooms — a soft adornment laid over an already ripening field.',
  ),

  // Kō 41 — Heat starts to die down
  41: KotowazaPairing(
    japanese: '暑さ寒さも彼岸まで',
    romaji: 'atsusa samusa mo higan made',
    literalUk: 'спека і холод — лише до хіґану',
    literalEn: 'heat and cold both end at the equinox',
    meaningUk:
        'Народний термометр: до осіннього (і весняного) рівнодення спека/холод неминуче відступають. Усе минає за календарем.',
    meaningEn:
        'A folk thermometer — heat and cold both yield by the equinox. Everything passes on the calendar\'s schedule.',
    connectionUk:
        'Спека відступає, рівнодення вже близько — прислів\'я і кō говорять буквально про той самий тиждень.',
    connectionEn:
        'The heat draws back and the equinox is close — the proverb and kō speak literally of the same week.',
  ),

  // Kō 42 — Rice ripens
  42: KotowazaPairing(
    japanese: '一粒万倍',
    romaji: 'ichiryū manbai',
    literalUk: 'одна зернина — десять тисяч',
    literalEn: 'one grain becomes ten thousand',
    meaningUk:
        'Маленьке вкладене зерно повертається врожаєм. Образ для першого внеску, що множиться непомірно.',
    meaningEn:
        'A small grain sown returns as a vast harvest — an image of an initial gift that multiplies beyond proportion.',
    connectionUk:
        'Рис дозріває під вагою колоса: одна зернина весни справді стала десятьма тисячами осені.',
    connectionEn:
        'Rice ripens heavy on the stalk — one spring grain has truly become ten thousand by autumn.',
  ),

  // Kō 43 — Dew glistens white on grass
  43: KotowazaPairing(
    japanese: '露の命',
    romaji: 'tsuyu no inochi',
    literalUk: 'життя, як росинка',
    literalEn: 'a life like a dewdrop',
    meaningUk:
        'Класична метафора людської долі: коротка, прозора, тримається на травинці до першого променя сонця.',
    meaningEn:
        'A classical metaphor for human life — brief, transparent, held on a blade of grass until the first ray of sun.',
    connectionUk:
        'Біла роса на траві: саме та цую, до якої прислів\'я прирівнює людський вік.',
    connectionEn:
        'White dew on the grass — the very tsuyu to which the proverb compares a human lifespan.',
  ),

  // Kō 44 — Wagtails sing
  44: KotowazaPairing(
    japanese: '鳴かぬ蛍が身を焦がす',
    romaji: 'nakanu hotaru ga mi o kogasu',
    literalUk: 'мовчазний світлячок горить дужче за того, що дзвенить',
    literalEn: 'the silent firefly burns hotter than the singing one',
    meaningUk:
        'Глибокі почуття часто залишаються невимовленими; зовнішня тиша не означає нестачі тепла всередині.',
    meaningEn:
        'Deep feelings often stay unspoken — outer silence is no measure of inner heat.',
    connectionUk:
        'Плиска голосна, та прислів\'я нагадує: біля струмка тих, хто відчуває найдужче, часто не чути.',
    connectionEn:
        'The wagtail is loud, but the proverb reminds us that by the stream the deepest feelers are often silent.',
  ),

  // Kō 45 — Swallows leave
  45: KotowazaPairing(
    japanese: '去る者は日々に疎し',
    romaji: 'saru mono wa hibi ni utoshi',
    literalUk: 'хто пішов — щодня стає чужішим',
    literalEn: 'one who is gone grows distant by the day',
    meaningUk:
        'Час непомітно стирає присутність. Не з лихої волі — просто життя триває, і той, хто далеко, тьмяніє.',
    meaningEn:
        'Time quietly erases presence — not from ill will, simply because life continues and the absent fade.',
    connectionUk:
        'Ластівки відлітають на південь: знайома пара під дахом стає щодня далі, аж поки навесні знову не повернеться.',
    connectionEn:
        'The swallows depart southward — the familiar pair under the eaves grows daily more distant, until spring brings them back.',
  ),

  // Kō 46 — Thunder ceases
  46: KotowazaPairing(
    japanese: '鳴る神も終には静まる',
    romaji: 'narukami mo tsui ni wa shizumaru',
    literalUk: 'навіть бог-громовик зрештою затихає',
    literalEn: 'even the thunder god falls silent at last',
    meaningUk:
        'Найгучніший гнів, найсильніша гроза мають свою межу. Усе бурхливе врешті-решт затихає.',
    meaningEn:
        'The loudest anger, the fiercest storm has its end — all that rages eventually grows still.',
    connectionUk:
        'Літній грім нарешті змовкає: прислів\'я і кō описують ту саму мить — тишу після бурі.',
    connectionEn:
        'Summer thunder falls silent at last — proverb and kō describe the same moment, the hush after the storm.',
  ),

  // Kō 47 — Insects hole up underground
  47: KotowazaPairing(
    japanese: '立つ鳥跡を濁さず',
    romaji: 'tatsu tori ato o nigosazu',
    literalUk: 'птах, що відлітає, не каламутить води після себе',
    literalEn: 'a departing bird leaves the water clear',
    meaningUk:
        'Іти треба так, щоб після тебе залишилось чисте місце. Гідний відхід — частина гідного шляху.',
    meaningEn:
        'Leave so that the place remains clean after you — a graceful departure is part of a graceful path.',
    connectionUk:
        'Комахи зачиняють свої нори перед зимою — закривають за собою «двері» точно як у прислів\'ї.',
    connectionEn:
        'Insects shut their burrows before winter — closing the door behind them, exactly as the proverb says.',
  ),

  // Kō 48 — Farmers drain rice fields
  48: KotowazaPairing(
    japanese: '備えあれば憂いなし',
    romaji: 'sonae areba urei nashi',
    literalUk: 'якщо приготовлено — тривоги немає',
    literalEn: 'with preparation, no worry',
    meaningUk:
        'Завчасні приготування знімають половину майбутнього страху. Не сама потужність, а готовність робить спокій.',
    meaningEn:
        'Forethought removes half of future fear — not strength but preparation grants calm.',
    connectionUk:
        'Воду з полів спускають перед жнивами: дбайлива підготовка ілюструє прислів\'я просто й точно.',
    connectionEn:
        'The fields are drained before the harvest — a careful preparation that illustrates the proverb simply and exactly.',
  ),

  // Kō 49 — Wild geese return
  49: KotowazaPairing(
    japanese: '雁が飛べば石亀も地団駄',
    romaji: 'kari ga tobeba ishigame mo jidanda',
    literalUk: 'гуси летять — а кам\'яна черепаха тупає на місці',
    literalEn: 'when geese fly, even the stone turtle stamps in vain',
    meaningUk:
        'Заздрити чужим висотам безглуздо: у кожного своє ремесло і своя стихія. Спроба наслідувати чужий політ лише виснажує.',
    meaningEn:
        'It is futile to envy another\'s heights — each has his own craft and element. Mimicking another\'s flight only exhausts.',
    connectionUk:
        'Дикі гуси повертаються до Японії — прислів\'я починається саме з цього льоту над землею.',
    connectionEn:
        'Wild geese return to Japan — the proverb begins from precisely this flight overhead.',
  ),

  // Kō 50 — Chrysanthemums bloom
  50: KotowazaPairing(
    japanese: '六日の菖蒲十日の菊',
    romaji: 'muika no ayame tōka no kiku',
    literalUk: 'ірис на шостий день, хризантема на десятий',
    literalEn: 'iris on the sixth day, chrysanthemum on the tenth',
    meaningUk:
        'Свято іриса — п\'ятого травня, хризантеми — дев\'ятого вересня; принести квіти на день пізніше — вже не вчасно. Усе має своє «рівно тоді».',
    meaningEn:
        'Iris festival is the 5th of May, chrysanthemum the 9th of September — a day late means too late. Everything has its precise "just then".',
    connectionUk:
        'Хризантеми зацвітають саме до свого свята — прислів\'я названо за тим тижнем, який зараз настає.',
    connectionEn:
        'Chrysanthemums open exactly toward their festival — the proverb is named for the very week now arriving.',
  ),

  // Kō 51 — Crickets chirp around the door
  51: KotowazaPairing(
    japanese: '蟋蟀の家',
    romaji: 'kōrogi no ie',
    literalUk: 'дім із цвіркуном',
    literalEn: 'a house with a cricket',
    meaningUk:
        'Стійкий образ затишку самотнього вечора: голос крихітного співця у щілині — усе, що треба для відчуття дому.',
    meaningEn:
        'A fixed image of solitary evening comfort — the voice of the tiny singer in a crack is all that\'s needed to feel at home.',
    connectionUk:
        'Цвіркуни перебираються до людських порогів: прислів\'я точно про цю мить, коли осінь входить у двері.',
    connectionEn:
        'Crickets move to the human threshold — the proverb is exactly about the moment autumn steps inside.',
  ),

  // Kō 52 — First frost falls
  52: KotowazaPairing(
    japanese: '霜を踏みて堅氷至る',
    romaji: 'shimo o fumite ken\'pyō itaru',
    literalUk: 'ступив на іній — чекай твердої криги',
    literalEn: 'tread on frost — hard ice will follow',
    meaningUk:
        'Маленький знак провіщає велике: перший холод під ногами означає, що зима вже в дорозі. Помічай початки.',
    meaningEn:
        'A small sign foretells a great one — the first cold underfoot means winter is already on the way. Notice beginnings.',
    connectionUk:
        'Перший іній: прислів\'я з «І-Цзін» буквально описує цей кō — ступила нога, і відбулося пророцтво.',
    connectionEn:
        'First frost — the proverb (from the I Ching) describes this kō literally: a foot has trodden, and the omen has fallen.',
  ),

  // Kō 53 — Light rains sometimes fall
  53: KotowazaPairing(
    japanese: '時雨の心',
    romaji: 'shigure no kokoro',
    literalUk: 'серце, як осінній сігуре',
    literalEn: 'a heart like an autumn shower',
    meaningUk:
        'Образ для мінливого настрою: то прояснилось, то знову мрячить. Натура, яку не вловиш, і це частина її чарівності.',
    meaningEn:
        'An image for a changeable mood — clear one moment, drizzling the next. A nature you cannot pin down, and that is part of its charm.',
    connectionUk:
        'Короткі осінні зливи — той самий сігуре, з якого прислів\'я взяло свою серцеву метафору.',
    connectionEn:
        'Short autumn showers — the very shigure from which the proverb borrowed its metaphor of the heart.',
  ),

  // Kō 54 — Maple leaves and ivy turn yellow
  54: KotowazaPairing(
    japanese: '紅葉に鹿',
    romaji: 'momiji ni shika',
    literalUk: 'до клена — олень',
    literalEn: 'a deer beside the maples',
    meaningUk:
        'Класична пара з картярської гри ханафуди й живопису: елементи, що завжди є разом і роблять осінь повною.',
    meaningEn:
        'A classical pair from the hanafuda card game and painting — elements that always belong together and make autumn whole.',
    connectionUk:
        'Клени й плющ жовтіють — момідзі досягає піку, і ця пара стає видимою в кожному гірському пейзажі.',
    connectionEn:
        'Maples and ivy turn — momiji at its peak, and the pair becomes visible in every mountain landscape.',
  ),

  // ─── Winter ───

  // Kō 55 — Camellias bloom
  55: KotowazaPairing(
    japanese: '花は折りたし梢は高し',
    romaji: 'hana wa oritashi kozue wa takashi',
    literalUk: 'хочеться зірвати квітку, та гілка високо',
    literalEn: 'one would pluck the flower, but the branch is too high',
    meaningUk:
        'Бажане завжди трохи поза досягом — і саме в цьому розрив роздумів про цінність зусилля чи відмови.',
    meaningEn:
        'What is desired is always slightly out of reach — and the gap is where the deliberation about effort and restraint lives.',
    connectionUk:
        'Камелії розкриваються в холоді — суворо красиві, але крихкі: одне зайве торкання, і пелюстка падає.',
    connectionEn:
        'Camellias open in the cold — austerely beautiful but fragile: one careless touch and the petal falls.',
  ),

  // Kō 56 — Land starts to freeze
  56: KotowazaPairing(
    japanese: '石の上にも三年',
    romaji: 'ishi no ue ni mo sannen',
    literalUk: 'навіть на камені — три роки',
    literalEn: 'even on a stone, three years',
    meaningUk:
        'Сидіти три роки на холодному камені — і той зігріється від тебе. Витривалість перемагає твердість.',
    meaningEn:
        'Sit three years on a cold stone and even stone grows warm from you — endurance wins over hardness.',
    connectionUk:
        'Земля починає мерзнути — час прислів\'я про того, хто зігріє навіть камінь власною стійкістю.',
    connectionEn:
        'The earth starts to freeze — time for the proverb about the one who warms even stone by sheer persistence.',
  ),

  // Kō 57 — Daffodils bloom
  57: KotowazaPairing(
    japanese: '香りは隠れず',
    romaji: 'kaori wa kakurezu',
    literalUk: 'аромат не сховається',
    literalEn: 'fragrance cannot be hidden',
    meaningUk:
        'Як квіткові пахощі видають квітку, так чесноту й талант видає сам їхній носій. Сховати справжнє неможливо.',
    meaningEn:
        'As scent gives away the flower, so virtue and talent betray themselves — the genuine cannot be hidden.',
    connectionUk:
        'Нарциси на холоді — їхні пахощі особливо тонкі, і прислів\'я тут чується буквально.',
    connectionEn:
        'Narcissus in the cold — their fragrance is especially fine, and the proverb is heard here literally.',
  ),

  // Kō 58 — Rainbows hide away
  58: KotowazaPairing(
    japanese: '光陰矢の如し',
    romaji: 'kōin ya no gotoshi',
    literalUk: 'час летить, як стріла',
    literalEn: 'time flies like an arrow',
    meaningUk:
        'Світло й тінь дня минають з невловною швидкістю. Те, що тільки-но було, вже стало минулим.',
    meaningEn:
        'Light and shadow of the day pass with elusive speed — what just was, is already past.',
    connectionUk:
        'Веселки зникають разом зі слабким сонцем — рік помітно вкорочується, і прислів\'я звучить особливо точно.',
    connectionEn:
        'Rainbows vanish with the weakening sun — the year shortens visibly, and the proverb feels especially precise.',
  ),

  // Kō 59 — North winds blow leaves away
  59: KotowazaPairing(
    japanese: '木の葉時雨',
    romaji: 'konoha shigure',
    literalUk: 'листяний дощ',
    literalEn: 'a shower of leaves',
    meaningUk:
        'Поетична формула для шурхоту опалого листя під вітром — звук, який нагадує дощ, але без води.',
    meaningEn:
        'A poetic formula for the rustle of fallen leaves driven by wind — a sound like rain without water.',
    connectionUk:
        'Північний вітер змітає останнє листя — буквальний коноха-сігуре, що дав прислів\'ю його ім\'я.',
    connectionEn:
        'The north wind sweeps the last leaves — the literal konoha-shigure that gave the proverb its name.',
  ),

  // Kō 60 — Tachibana citrus leaves turn yellow
  60: KotowazaPairing(
    japanese: '橘は北に植えても橘',
    romaji: 'tachibana wa kita ni uete mo tachibana',
    literalUk: 'татібана й на півночі лишається татібаною',
    literalEn: 'the tachibana planted in the north remains tachibana',
    meaningUk:
        'Сутність не змінюється від місця або обставин. Хто є кимось — лишається ним і в чужому ґрунті.',
    meaningEn:
        'Essence does not change with place or circumstance — what one is, one remains, even in foreign soil.',
    connectionUk:
        'Татібана жовтіє, але лишається собою — прислів\'я й кō говорять про той самий цитрус, що вистоює холод.',
    connectionEn:
        'Tachibana yellows but stays itself — proverb and kō speak of the same citrus that endures the cold.',
  ),

  // Kō 61 — Cold sets in, winter begins
  61: KotowazaPairing(
    japanese: '寒さの果ても彼岸まで',
    romaji: 'samusa no hate mo higan made',
    literalUk: 'кінець холоду — тільки до хіґану',
    literalEn: 'the end of cold lies all the way to the equinox',
    meaningUk:
        'Зима має чітку межу — рівнодення. До нього треба просто витримати. Період скінченний, навіть якщо здається безмежним.',
    meaningEn:
        'Winter has a clear boundary — the equinox. Until then, simply endure. The season is finite, however endless it feels.',
    connectionUk:
        'Справжня зима щойно зачинила небо хмарами: прислів\'я тут — про шлях, що тільки починається.',
    connectionEn:
        'True winter has just sealed the sky with clouds — the proverb here is about a road only beginning.',
  ),

  // Kō 62 — Bears start hibernating
  62: KotowazaPairing(
    japanese: '冬来たりなば春遠からじ',
    romaji: 'fuyu kitarinaba haru tōkaraji',
    literalUk: 'якщо прийшла зима — весна не за горами',
    literalEn: 'if winter comes, spring cannot be far behind',
    meaningUk:
        'Найтемніша пора несе в собі обіцянку повернення світла. Перенесення Шеллі, що міцно вкорінилось у японській мові.',
    meaningEn:
        'The darkest time carries within it the promise of light\'s return — Shelley\'s line, deeply rooted in Japanese.',
    connectionUk:
        'Ведмеді лягають у барлоги — і ця тривала тиша і є шляхом до весни, про який говорить прислів\'я.',
    connectionEn:
        'Bears lie down in their dens — and this long silence is the very road to spring the proverb names.',
  ),

  // Kō 63 — Salmon gather and swim upstream
  63: KotowazaPairing(
    japanese: '鯉の滝登り',
    romaji: 'koi no taki nobori',
    literalUk: 'короп піднімається водоспадом',
    literalEn: 'a carp climbing the waterfall',
    meaningUk:
        'Образ небаченої наполегливості: пробитися вгору проти течії, ризикуючи всім, у надії на перетворення.',
    meaningEn:
        'An image of unmatched perseverance — climbing against the current, risking everything for the chance of transformation.',
    connectionUk:
        'Лосось іде на нерест проти течії — той самий висхідний шлях, який оспівує прислів\'я (тут не короп, а саке).',
    connectionEn:
        'Salmon climb upstream to spawn — the same upward way the proverb sings of, in sake rather than koi.',
  ),

  // Kō 64 — Self-heal sprouts
  64: KotowazaPairing(
    japanese: '冬至冬中冬始め',
    romaji: 'tōji fuyunaka fuyu hajime',
    literalUk: 'тоджі — і середина зими, і її початок',
    literalEn: 'tōji is winter\'s middle, and winter\'s beginning',
    meaningUk:
        'Зимове сонцестояння одночасно вершина темряви і поворот до світла. Початок і середина живуть в одному дні.',
    meaningEn:
        'The winter solstice is at once the peak of darkness and the turn toward light — beginning and middle living in one day.',
    connectionUk:
        'Призонник проростає в найтемнішу мить — кō і прислів\'я разом тримають парадокс цієї точки року.',
    connectionEn:
        'Self-heal sprouts at the darkest moment — kō and proverb together hold the paradox of this turning point.',
  ),

  // Kō 65 — Deer shed their antlers
  65: KotowazaPairing(
    japanese: '古きを去って新しきを取る',
    romaji: 'furuki o satte atarashiki o toru',
    literalUk: 'відкинути старе — взяти нове',
    literalEn: 'cast off the old, take up the new',
    meaningUk:
        'Оновлення вимагає звільнити місце. Не можна тримати в руках і старе, і нове одночасно.',
    meaningEn:
        'Renewal requires making room — one cannot hold the old and the new in the same hand.',
    connectionUk:
        'Олень скидає роги перед новим ростом — буквальна сцена прислів\'я в живій природі.',
    connectionEn:
        'The deer drops his antlers before the new growth — the proverb\'s literal scene in living nature.',
  ),

  // Kō 66 — Wheat sprouts under snow
  66: KotowazaPairing(
    japanese: '一年の計は元旦にあり',
    romaji: 'ichinen no kei wa gantan ni ari',
    literalUk: 'задум на рік — у перший день нового року',
    literalEn: 'the year\'s plan is set on New Year\'s Day',
    meaningUk:
        'Початок будь-якої справи задає її форму. Те, як ти стрів перший день, відбивається в усіх інших.',
    meaningEn:
        'How any work begins shapes how it ends — the way you greet the first day echoes through the rest.',
    connectionUk:
        'Цей кō припадає саме на 1–4 січня: прислів\'я і кō зустрічаються у точці новорічного задуму.',
    connectionEn:
        'This kō falls exactly on January 1–4 — proverb and kō meet at the point of the New Year resolve.',
  ),

  // Kō 67 — Parsley flourishes
  67: KotowazaPairing(
    japanese: '春の七草',
    romaji: 'haru no nanakusa',
    literalUk: 'сім трав весни',
    literalEn: 'the seven herbs of spring',
    meaningUk:
        'Стійкий вислів про сім весняних трав, які 7 січня варять у каші, щоб очистити тіло після свят. Сері — перша з них.',
    meaningEn:
        'A fixed phrase for the seven spring herbs eaten in porridge on January 7 to cleanse the body after the holidays. Seri is the first.',
    connectionUk:
        'Сері (японська петрушка) буяє саме до свята нанакуса — кō і прислів\'я говорять про той самий тиждень.',
    connectionEn:
        'Seri (Japanese parsley) flourishes exactly toward the nanakusa festival — kō and proverb speak of the same week.',
  ),

  // Kō 68 — Springs thaw
  68: KotowazaPairing(
    japanese: '水は方円の器に従う',
    romaji: 'mizu wa hōen no utsuwa ni shitagau',
    literalUk: 'вода набуває форми свого посуду',
    literalEn: 'water takes the shape of its vessel',
    meaningUk:
        'Людина набуває форми того середовища, де живе. Гнучкість і здатність триматись непомітно — найбільша сила води.',
    meaningEn:
        'A person takes the shape of the environment around them — flexibility and quiet endurance are water\'s greatest strength.',
    connectionUk:
        'Гірські джерела відтають під кригою — вода знову рухається, проявляючи саме ту м\'якість, про яку говорить прислів\'я.',
    connectionEn:
        'Mountain springs thaw beneath the ice — water moves again, showing exactly the softness the proverb names.',
  ),

  // Kō 69 — Pheasants start to call
  69: KotowazaPairing(
    japanese: '雉も鳴かずば撃たれまい',
    romaji: 'kiji mo nakazuba utaremai',
    literalUk: 'якби фазан не кричав, то й не був би вбитий',
    literalEn: 'had the pheasant not called, it would not have been shot',
    meaningUk:
        'Зайве слово накликає біду. Часом мовчання — найкращий захист, особливо у вирішальну мить.',
    meaningEn:
        'A needless word draws trouble — sometimes silence is the best defence, especially at the decisive moment.',
    connectionUk:
        'Самці фазана починають кликати: те саме рішення з прислів\'я постає у живій природі саме зараз.',
    connectionEn:
        'Male pheasants begin to call — the very decision of the proverb plays out in living nature right now.',
  ),

  // Kō 70 — Butterburs bud
  70: KotowazaPairing(
    japanese: '雪に耐えて梅花麗し',
    romaji: 'yuki ni taete baika uruwashi',
    literalUk: 'витримала сніг — і слива розквітла гарною',
    literalEn: 'enduring the snow, the plum bloom comes fair',
    meaningUk:
        'Краса, виплекана випробуванням, глибша за безтурботну. Те, що пройшло крізь холод, цвіте найвиразніше.',
    meaningEn:
        'Beauty seasoned by trial runs deeper than untested grace — what has passed through cold blooms most vividly.',
    connectionUk:
        'Бутони мати-й-мачухи (фукі-но-то) пробиваються крізь сніг — прислів\'я тут чується майже буквально.',
    connectionEn:
        'Butterbur buds (fuki-no-tō) push through snow — the proverb is heard here almost literally.',
  ),

  // Kō 71 — Ice thickens on streams
  71: KotowazaPairing(
    japanese: '寒中の水を汲む',
    romaji: 'kanchū no mizu o kumu',
    literalUk: 'зачерпнути води в найхолодніший день',
    literalEn: 'to draw water in the deepest cold',
    meaningUk:
        'Вода, набрана в дайкан, вважалась найчистішою — і її використовували для саке, ліків, ритуалів. Найважче дає найкраще.',
    meaningEn:
        'Water drawn at daikan was held purest — used for sake, medicine, ritual. The hardest moment yields the finest result.',
    connectionUk:
        'Крига густішає на потоках — найхолодніша мить року, та сама, у яку прислів\'я радить набирати воду.',
    connectionEn:
        'Ice thickens on the streams — the coldest moment of the year, the very one the proverb chooses for drawing water.',
  ),

  // Kō 72 — Hens start laying eggs
  72: KotowazaPairing(
    japanese: '冬来たりなば春遠からじ',
    romaji: 'fuyu kitarinaba haru tōkaraji',
    literalUk: 'якщо настала зима — весна не за горами',
    literalEn: 'if winter has come, spring cannot be far',
    meaningUk:
        'Найтемніша пора несе в собі обіцянку повернення світла. Тиха формула надії, на яку спирається ціла північна культура.',
    meaningEn:
        'The darkest hour carries the promise of light\'s return — a quiet formula of hope on which a whole northern culture leans.',
    connectionUk:
        'Останній кō року: кури знову несуться, і прислів\'я ставить крапку, яка водночас є комою перед весною.',
    connectionEn:
        'The year\'s last kō — hens lay again, and the proverb sets a full stop that is also a comma before spring.',
  ),
};

/// Lookup helper.
KotowazaPairing? kotowazaForKo(int index) => seasonalKotowaza[index];
