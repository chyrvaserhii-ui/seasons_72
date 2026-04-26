/// Seasonal practice notes — one per kō.
///
/// These notes are not medical advice; they are the kind of small, sane
/// suggestions a Japanese herbalist, a Heian poet, and a modern wellness
/// writer would all agree on if they sat down together. Each kō gets
/// three short prompts:
///
/// • body — what to eat, drink, or rest, drawing on yōjō (養生) tradition
///   and the shun (旬) calendar of peak ingredients;
/// • activity — what to do or where to go in those five days;
/// • contemplation — what to notice, write down, or sit with.
///
/// Sources: Kaibara Ekiken's *Yōjōkun* (1713), the kigo (季語) saijiki
/// dictionaries used by haiku poets, the Tsukimi / Hanami / Setsubun
/// calendars, and the lived-practice books of modern teachers like
/// Tatsumi Yoshiko and Murayama Yuko.
library seasonal_practice;

/// One block of three short prompts paired to a single kō.
class PracticeNote {
  const PracticeNote({
    required this.mottoUk,
    required this.mottoEn,
    required this.bodyUk,
    required this.bodyEn,
    required this.activityUk,
    required this.activityEn,
    required this.contemplationUk,
    required this.contemplationEn,
  });

  /// One-line distilled invitation for the kō — used as the hero title
  /// of the practice details sheet. Captures body + activity +
  /// contemplation as a single focused tagline.
  final String mottoUk;
  final String mottoEn;

  /// Body — food, drink, sleep, warmth, posture, breath.
  final String bodyUk;
  final String bodyEn;

  /// Activity — what to do or where to go.
  final String activityUk;
  final String activityEn;

  /// Contemplation — what to notice, write, sit with.
  final String contemplationUk;
  final String contemplationEn;
}

const Map<int, PracticeNote> seasonalPractice = {
  // ─── Spring ───
  1: PracticeNote(
    mottoUk: "Зустрінь зміну вітру вухом, не календарем.",
    mottoEn: "Catch the wind shifting, before the calendar tells you.",
    bodyUk:
        "Лід тане першим — печінці теж потрібен рух: спробуй замість кави ранковий настій з молодих листочків бамбука чи зеленого ячменю.",
    bodyEn:
        "The ice is loosening — your liver wants the same; trade the morning coffee for a warm infusion of young bamboo leaves or barley grass.",
    activityUk:
        "Відчини вікно на північ хоча б на десять хвилин — хочу, щоб саме ти впіймав перший східний вітер, який ще пахне снігом.",
    activityEn:
        "Open the north-facing window for ten minutes; you want to be the one who catches the first east wind, still smelling of snow.",
    contemplationUk:
        "Запиши перший знак, що вітер змінив напрямок: куди гнеться дим, куди летить пил, куди дивиться кіт біля порога.",
    contemplationEn:
        "Write down the first sign the wind has turned: which way the smoke leans, where the dust drifts, what direction the cat at the door is facing.",
  ),
  2: PracticeNote(
    mottoUk: "Соловейко співає до десятої — встигни на голодний шлунок.",
    mottoEn: "The warbler sings only until ten — meet it on an empty stomach.",
    bodyUk:
        "Уґуйсу співає на голодний шлунок — тіло теж: спробуй легку ранкову кашу з пшоном і слабко підсмаженим кунжутом замість важкого сніданку.",
    bodyEn:
        "The bush warbler sings on an empty stomach; your body wants the same — a light millet porridge with lightly toasted sesame instead of a heavy breakfast.",
    activityUk:
        "Якщо є парк зі сливою-уме — піди туди вранці. Уґуйсу-моті п'ється з гарячим ходжічею, але співає тільки до десятої.",
    activityEn:
        "If there is a plum grove nearby, go in the early morning; the warbler sings only until ten, and uguisu-mochi tastes best with hot hojicha after.",
    contemplationUk:
        "Сядь біля вікна і слухай, скільки разів за хвилину чути голос — будь-який, людський чи пташиний. Запиши це число одне разочок.",
    contemplationEn:
        "Sit by the window and count, for one minute, how many distinct voices reach you — human, bird, or thing. Write the number down once.",
  ),
  3: PracticeNote(
    mottoUk: "Темна вода вже рухається — щось у тобі також.",
    mottoEn: "The dark water is already moving — something in you, too.",
    bodyUk:
        "Риба піднімається з-під криги — внутрішнє тепло теж проситься назовні: спробуй гарячий місо-суп із молодою цибулею-неґі і кубиком тофу.",
    bodyEn:
        "Fish rise from under the ice; your inner warmth wants to do the same — a hot miso soup with young leek and a single cube of tofu is enough.",
    activityUk:
        "Зайди до ставка чи річки і подивись хвилину на воду — там, де течія темніша, риба вже рухається, навіть якщо око не одразу її ловить.",
    activityEn:
        "Stop by a pond or slow river for one minute; where the current darkens, the fish are already moving, even if your eye doesn't catch them at first.",
    contemplationUk:
        "Подумай: що в тобі цієї зими спало під льодом і тепер починає рухатися? Не відповідай — просто познач для себе.",
    contemplationEn:
        "Ask: what in you slept under the ice this winter and is starting to move now? Don't answer — just mark the question for yourself.",
  ),
  4: PracticeNote(
    mottoUk: "Земля будиться знизу — пий теплу воду і помацай ґрунт.",
    mottoEn: "The earth wakes from below — drink water warm and touch the soil.",
    bodyUk:
        "Ґрунт п'є першу теплу воду — і ти теж: пий її ледь теплою, не з холодильника, з ложкою меду уме чи злегка солону вранці.",
    bodyEn:
        "The earth is drinking its first warm water; drink yours the same way — barely warm, not chilled, with a spoon of plum honey or a pinch of salt.",
    activityUk:
        "Перевір ґрунт у горщиках — пора пересаджувати, поки дощ м'який. Кімнатні рослини вловлюють весну швидше за людей.",
    activityEn:
        "Check the soil in your pots — repotting season is now, while the rain is still soft. Houseplants feel spring earlier than we do.",
    contemplationUk:
        "Помацай землю на балконі чи в парку — холодна, волога, жива. У японських саджалок є приказка: земля будиться знизу, не зверху.",
    contemplationEn:
        "Touch the soil on the balcony or in a park — cold, damp, alive. Japanese gardeners say the earth wakes from below, not from above.",
  ),
  5: PracticeNote(
    mottoUk: "Денний серпанок має ім'я — впізнай касумі до обіду.",
    mottoEn: "Daytime mist has a name of its own — meet kasumi before noon.",
    bodyUk:
        "Серпанок над полями — натяк, що повітря робиться вологим: спробуй додати до вечері ложку рисового оцту, він допомагає печінці на вологу пору.",
    bodyEn:
        "Mist hangs over the fields, a hint the air is gathering moisture — a small spoon of rice vinegar at supper helps the liver through the soft season.",
    activityUk:
        "Вийди на світанку до того моменту, коли видно далеко, але не дуже чітко — це і є касумі. Шукай у ньому контури знайомих дерев.",
    activityEn:
        "Step outside at dawn into that hour when distances are visible but not sharp — that is kasumi. Look for the outlines of trees you already know.",
    contemplationUk:
        "Японці розрізняли касумі (вдень) і обороґумо (вночі). Запам'ятай, який саме серпанок ти бачив сьогодні — і коли.",
    contemplationEn:
        "The Japanese named day-mist (kasumi) and night-haze (oborogumo) differently. Remember which one you saw today, and at what hour.",
  ),
  6: PracticeNote(
    mottoUk: "Перша гіркота року розв'язує зимовий вузол — нагнись по неї.",
    mottoEn: "The year's first bitterness loosens winter — bend down for it.",
    bodyUk:
        "Перші паростки гіркуваті — і це не випадковість: фукіното, удо, цуруна. Додай дрібно посіченими у яєчню, гіркота розв'язує зимовий застій.",
    bodyEn:
        "Early sprouts are slightly bitter on purpose — fukinotō, udo, tsuruna. Chop them fine into an omelette; bitterness loosens the winter sluggishness.",
    activityUk:
        "Якщо є двір чи парк — нагнись і знайди три зелені паростки. Не зривай, просто запам'ятай, де вони. За тиждень повернись і порівняй.",
    activityEn:
        "Find three green sprouts in a yard or park; don't pick them, just note where they are. Come back in a week and see how much they have grown.",
    contemplationUk:
        "Сосекі писав, що весна починається не з квітів, а з того моменту, коли ти вперше нахилився до землі без пальта.",
    contemplationEn:
        "Sōseki wrote that spring begins not with flowers but with the first moment you bend toward the ground without a coat on.",
  ),
  7: PracticeNote(
    mottoUk: "Розгорни тіло, як зимовий згорток — і провітри куртку на сонці.",
    mottoEn: "Unfold yourself like a winter parcel — and air the heavy coat.",
    bodyUk:
        "Комахи прокидаються — тіло теж: спробуй ранковий потяг (десять хвилин повільних стретчів від щиколоток до плечей), наче розгортаєш зимовий згорток.",
    bodyEn:
        "The insects are waking; your body wants the same — ten slow stretches from ankle to shoulder in the morning, like unfolding a winter parcel.",
    activityUk:
        "Якщо є зимова куртка, провітри її на сонці. У японських родинах це називається муші-боші — обов'язкове прощання з зимовим шаром.",
    activityEn:
        "Hang the winter coat in the sun for an afternoon; the Japanese call this mushi-boshi, the formal farewell to the heavy layer.",
    contemplationUk:
        "Подивись на стіну, де є тріщина чи щілина — десь там сьогодні щось ворухнеться. Не лякайся, привітайся.",
    contemplationEn:
        "Look at a wall with a crack or seam in it — something is moving in there today. Don't startle; greet it.",
  ),
  8: PracticeNote(
    mottoUk: "Постав одну рожеву квітку у воду — це і є привіт сезону.",
    mottoEn: "Set one pink flower in water — that is greeting enough.",
    bodyUk:
        "Перший персиковий цвіт — час чаю з пелюстками момо. Якщо немає — додай у воду тонкий шматочок свіжого імбиру, він теж відкриває груди.",
    bodyEn:
        "First peach blossoms call for momo-tea; if you can't find petals, a thin slice of fresh ginger in hot water opens the chest in the same way.",
    activityUk:
        "Третього березня — Хіна-мацурі, день дівчат. Постав одну рожеву квітку у воду, навіть якщо в домі немає дитини — це жест до самого сезону.",
    activityEn:
        "March third is Hina-matsuri, the girls' festival. Set a single pink flower in water, even with no child in the house — it is a greeting to the season.",
    contemplationUk:
        "Кобаясі Ісса писав про персиковий цвіт як про сміх дерева. Подумай, від чого ти давно не сміявся такою повною мірою.",
    contemplationEn:
        "Issa wrote of peach blossoms as the tree's laughter. Think about what you have not laughed at fully in a while.",
  ),
  9: PracticeNote(
    mottoUk: "Перевернись тихіше за метелика — і поглянь під лист капусти.",
    mottoEn: "Turn as quietly as a butterfly — and check beneath the leaf.",
    bodyUk:
        "Гусениці перетворюються — травлення теж шукає легкості: спробуй один день без м'яса, з вареним рисом, тушкованою редькою і трохи умебоші.",
    bodyEn:
        "Caterpillars are turning — your digestion wants the same lightness; try one day with rice, simmered daikon, and a single umeboshi instead of meat.",
    activityUk:
        "Подивись на капусту чи редис на грядці або в магазині — на нижніх листках вже починається життя, метелики белянки відкладають яйця саме зараз.",
    activityEn:
        "Look at the underside of cabbage or radish leaves at the market or garden; cabbage-white butterflies are laying eggs there right now.",
    contemplationUk:
        "Запиши одну річ, яку ти робив рік тому в цей самий тиждень — і одну, в якій ти за рік перетворився.",
    contemplationEn:
        "Write down one thing you were doing this same week last year, and one thing in which you have, over the year, quietly become someone else.",
  ),
  10: PracticeNote(
    mottoUk: "Залиш горобцям нитку на підвіконні — і провітри постіль на сонці.",
    mottoEn: "Leave a sparrow a thread on the sill — and sun the bedding.",
    bodyUk:
        "Горобці в'ють гнізда — хатня справа на часі: провітри постіль на сонці, у Японії це називається футон-боші і рахується як весняна гігієна.",
    bodyEn:
        "Sparrows are building nests; the household wants the same — air the bedding in the sun, what the Japanese call futon-boshi, a proper spring hygiene.",
    activityUk:
        "Підкладеш на підвіконня дрібку сухої трави чи нитку — горобці рознесуть. Це маленьке співавторство з весною, без жодних обов'язків.",
    activityEn:
        "Leave a pinch of dry grass or a short thread on the windowsill; sparrows will carry it away — a small co-authorship with spring, no obligations.",
    contemplationUk:
        "Подумай, що в твоєму домі цьогоріч проситься на нове місце: лампа, книжка, рослина. Гнізда теж завжди трохи переробляють.",
    contemplationEn:
        "Notice what in your home is asking to move this year — a lamp, a book, a plant. Nests are always slightly rebuilt, never copied.",
  ),
  11: PracticeNote(
    mottoUk: "Двадцять хвилин під квітучим деревом — рівно стільки, щоб зрозуміти дзен.",
    mottoEn: "Twenty minutes under a flowering tree is enough to learn the lesson.",
    bodyUk:
        "Сезон сакури — короткий, тіло теж легке: спробуй перейти з зимового жирного супу на весняний з молодим бамбуком і молодою цибулею.",
    bodyEn:
        "Cherry-blossom days are brief; your body wants the same lightness — switch the winter pork-bone broth for a clear soup with bamboo shoot and spring onion.",
    activityUk:
        "Ханамі під сакурою з кимось важливим — навіть 20 хвилин достатньо. Японське ханамі — не туристичний ритуал, а перебування.",
    activityEn:
        "Sit beneath a flowering tree with someone you'd want to sit with — twenty minutes is enough. Hanami is not a tour, it's a way of being there.",
    contemplationUk:
        "Сакура — символ того, що краса нічого нікому не винна. Помітьте, скільки пелюсток встигнуть упасти за один ваш видих.",
    contemplationEn:
        "The cherry tree is the classical lesson that beauty owes you nothing. Notice how many petals fall during a single one of your exhalations.",
  ),
  12: PracticeNote(
    mottoUk: "Сон неба — перший грім без блискавки. Послухай.",
    mottoEn: "The sky's dream is silent thunder — stop and listen.",
    bodyUk:
        "Перший весняний грім бентежить нерви — спробуй перед сном чай з куромаме (чорних соєвих бобів) або просто гарячу воду з ложечкою меду.",
    bodyEn:
        "The first spring thunder unsettles the nerves; try kuromame tea before bed, or simply hot water with a small spoon of honey, nothing more.",
    activityUk:
        "Якщо почув грім далеко — на хвилину вийди надвір і просто послухай. Шунрай (春雷) — повноцінне явище календаря, не фон.",
    activityEn:
        "If you hear thunder in the distance, step outside for one minute and listen. Shunrai is a proper calendar event, not background noise.",
    contemplationUk:
        "Прислухайся вночі — перший весняний грім часто тиша до тиші, без блискавки. Японці казали, що це 'сон неба'.",
    contemplationEn:
        "Listen at night — the first spring thunder is often silence-into-silence, no lightning. The Japanese called it 'the sky's dream'.",
  ),
  13: PracticeNote(
    mottoUk: "Ластівка повертається у те саме місце — приготуй кут і небо.",
    mottoEn: "The swallow returns to the exact place — ready a corner and the sky.",
    bodyUk:
        "Ластівки повертаються — дім готовий до повітря: спробуй прибрати один кут (полицю, шухляду) і провітрити простір, як це робиться перед гостями.",
    bodyEn:
        "Swallows are returning; ready the house for air — clear one corner, a shelf or a drawer, and let the wind through, the way one prepares for guests.",
    activityUk:
        "Підведи голову на світанку — ластівки летять низько, описуючи дуги над дахом. Це найточніший знак, що зима вже не повернеться.",
    activityEn:
        "Look up at dawn — swallows fly low, drawing arcs over the rooftops. It is the most reliable sign that winter will not come back.",
    contemplationUk:
        "Хто або що цього року повертається до тебе після довгої відсутності? Ластівки прилітають у те ж саме місце, де вилупились — без винятку.",
    contemplationEn:
        "Who or what is returning to you this year after a long absence? Swallows always come back to the place they were born, without exception.",
  ),
  14: PracticeNote(
    mottoUk: "Гуси летять на північ — залиш їм один сон, який ти проводжаєш.",
    mottoEn: "Geese fly north — give them one dream of yours to carry off.",
    bodyUk:
        "Гуси летять на північ — і повітря над ними сухе. Додай у вечерю трохи кунжутної олії або пасту з білого кунжуту: вона тримає легені м'якими.",
    bodyEn:
        "The wild geese head north under dry, cool air; a small drizzle of sesame oil or a touch of white-sesame paste at supper keeps the lungs supple.",
    activityUk:
        "Якщо випаде тепле вікно — повісь сорочки на вулиці, а не на батареї. Сонце і вітер цього тижня одночасно теплі й сухі, рідкісне поєднання.",
    activityEn:
        "If a warm window opens up, hang the laundry outside, not on a radiator. This week's sun and wind are warm and dry at once, a rare combination.",
    contemplationUk:
        "Кобаясі Ісса писав про гусей, що летять на північ: 'Залишай нам сни про себе.' Запиши, кого ти проводжаєш цієї весни — людину, місце, звичку.",
    contemplationEn:
        "Issa wrote of the geese flying north: 'leave us your dreams.' Note who or what you are sending off this spring — a person, a place, a habit.",
  ),
  15: PracticeNote(
    mottoUk: "Залишся під дощем зайві десять хвилин — нідзі не любить поспіху.",
    mottoEn: "Stay outside ten minutes after the rain — niji doesn't reward hurry.",
    bodyUk:
        "Перші райдуги — повітря тепліше, але вологе: спробуй замість важкого молочного — рисове молоко з амадзаке, воно зігріває і не гасить весну.",
    bodyEn:
        "First rainbows mean warmer, wetter air; instead of heavy dairy, try amazake — fermented rice drink that warms without dampening the spring lift.",
    activityUk:
        "Після короткого дощу затримайся на вулиці на десять хвилин — нідзі (虹) показуються тільки тим, хто не побіг одразу під дах.",
    activityEn:
        "Linger outside for ten minutes after a brief shower; niji, the rainbow, only shows itself to those who don't bolt for cover at once.",
    contemplationUk:
        "Перша райдуга року в саадзіки рахується окремим кіґо. Запитай себе тихо: чи помітив ти її, чи просто сфотографував і пішов.",
    contemplationEn:
        "The year's first rainbow is its own kigo in the saijiki. Ask quietly: did you notice it, or did you only photograph it and walk on.",
  ),
  16: PracticeNote(
    mottoUk: "Один лист очерету — все паперове поле для речення про сьогодні.",
    mottoEn: "A single reed-blade is the whole paper for today's one sentence.",
    bodyUk:
        "Молодий очерет показує, що вода вже прогрілась: спробуй один теплий день без шкарпеток вдома — стопи прокидаються, як коріння в м'якому ґрунті.",
    bodyEn:
        "Young reeds tell you the water is warm enough; try one indoor day without socks — feet wake up like roots in soft ground.",
    activityUk:
        "Підійди до ставка чи каналу і подивись на воду під берегом — там, де торік був сухий очерет, цьогоріч уже з'являється тонкий зелений штрих.",
    activityEn:
        "Walk to a pond or canal and look at the bank — where last year's reeds stood dry, this year's first green thread is already up.",
    contemplationUk:
        "Очерет ріже воду тонко, як перо. Запиши одне речення про сьогодні так, ніби в тебе є на нього лише цей один лист очерету.",
    contemplationEn:
        "A reed cuts the water like a fine pen. Write one sentence about today as if a single reed-blade were all the paper you had.",
  ),
  17: PracticeNote(
    mottoUk: "Подивись на дах удосвіта — чи ще лежить срібло.",
    mottoEn: "Walk out at dawn and check whether silver still lies on the roof.",
    bodyUk:
        "Останні приморозки відступають — рисова розсада йде в ґрунт. На столі: молодий зелений чай (шинча) і трохи варених стручків гороху.",
    bodyEn:
        "Last frosts slip away as rice seedlings go in; on the table now: shincha — first-flush green tea — and a small dish of simmered young pea pods.",
    activityUk:
        "Вийди увечері без верхнього шару — повітря вже не кусає. Це той рідкісний тиждень, коли можна вгадати, чи буде рік прохолодним.",
    activityEn:
        "Step out in the evening without the top layer — the air no longer bites. This is the rare week when one can guess whether the year will be cool.",
    contemplationUk:
        "Селянин раніше виходив до поля на світанку і дивився, чи лежить срібло. Подивись і ти — на дах, на машину, на траву.",
    contemplationEn:
        "Farmers used to walk out at dawn to see whether silver lay on the fields. Look once at a roof, a car, a patch of grass — same question.",
  ),
  18: PracticeNote(
    mottoUk: "Стебло півонії гнеться під вагою цвіту, але не ламається — як і ти.",
    mottoEn: "The peony stem bends under its bloom and does not break — like you.",
    bodyUk:
        "Півонії розкриваються великими — тіло теж розгортається: переходь з підсмажених страв на тушковані, з міцного чаю — на світлий банча.",
    bodyEn:
        "Peonies open wide; your body wants to do the same — shift from fried dishes to simmered ones, from strong tea to a lighter bancha.",
    activityUk:
        "Постав одну півонію або велику тюльпанову квітку у вузьку вазу. Боан (牡丹) у японській культурі — символ королівської ваги, а не пишноти.",
    activityEn:
        "Place a single peony or large tulip in a narrow vase. Botan stands in Japanese culture for kingly weight, not for showiness.",
    contemplationUk:
        "Подивись, як півонія тримає вагу власного цвіту — стебло гнеться, але не ламається. Згадай, що саме тебе цьогоріч теж не зламало.",
    contemplationEn:
        "Notice how a peony holds the weight of its own bloom — the stem bends but does not break. Recall what bent you this year and held.",
  ),
  // ─── Summer ───
  19: PracticeNote(
    mottoUk: "Жаб'ячий хор починається з одного голосу — постій біля води ввечері.",
    mottoEn: "The frog chorus starts with one voice — stand by water at dusk.",
    bodyUk:
        "Жаби починають співати — повітря тепле і вологе: спробуй замість холодних напоїв муґі-ча (ячмінний чай) кімнатної температури, він охолоджує без шоку.",
    bodyEn:
        "Frogs start to sing in warm, damp air; trade iced drinks for room-temperature mugi-cha — barley tea cools without shocking the gut.",
    activityUk:
        "Увечері постій біля води — каналу, ставка, поливаного газону. Жаб'ячий хор завжди починається з одного голосу, потім підхоплюють.",
    activityEn:
        "Stand near water in the evening — a canal, a pond, a wet lawn. The frog chorus always starts with one voice, the rest answer.",
    contemplationUk:
        "Басьо: 'Старий ставок, жаба стрибнула — звук води.' Просто послухай вечір без музики п'ять хвилин і запиши, що почув першим.",
    contemplationEn:
        "Bashō: 'Old pond, a frog jumps in — sound of water.' Just listen for five evening minutes without music; write down what you heard first.",
  ),
  20: PracticeNote(
    mottoUk: "Черв'як перевертає ґрунт у власному темпі — наслідуй цю повільність.",
    mottoEn: "The worm turns the earth at its own pace — borrow that slowness.",
    bodyUk:
        "Дощові черв'яки виходять — ґрунт ожив, тіло шукає коріння: на столі цього тижня — варена редька, морква з кунжутом, і трохи ґобо (лопуха).",
    bodyEn:
        "Earthworms surface and the soil is alive; your body wants roots — simmered daikon, sesame carrot, a little gobo (burdock) on the table this week.",
    activityUk:
        "Після дощу пройдись стежкою у парку. Там, де земля темна і м'яка, видно сліди черв'яків — крихітні горбочки, як невидимі підписи.",
    activityEn:
        "After rain, walk a park path; where the soil is dark and soft, you'll see worm traces — tiny mounds, like invisible signatures.",
    contemplationUk:
        "Черв'як перевертає ґрунт у власному темпі, не питаючи себе, чи доцільно. Подумай про одну справу, яку ти робиш повільно і добре.",
    contemplationEn:
        "A worm turns the soil at its own pace, not asking whether it makes sense. Think of one slow, good thing you keep doing.",
  ),
  21: PracticeNote(
    mottoUk: "Бамбук росте по метру за добу і не оглядається — наслідуй один день.",
    mottoEn: "Bamboo grows a meter a day without looking back — try one such day.",
    bodyUk:
        "Бамбукові паростки на піку — їх беруть свіжими, варять у рисових висівках з перцем санчо. Це класична страва шун — більше ніяких приправ не треба.",
    bodyEn:
        "Bamboo shoots are at peak shun; boiled in rice bran with sanshō pepper, they need nothing else — the classic seasonal lesson in restraint.",
    activityUk:
        "Якщо знайдеш такеноко на ринку — купи маленький. Після варіння тонкі скибки спробуй з місо і темним кунжутом, без інших овочів на тарілці.",
    activityEn:
        "If you find takenoko at a market, get a small one; after boiling, slice thin and serve with miso and dark sesame, alone on the plate.",
    contemplationUk:
        "Бамбук росте до метра за добу і ніколи не оглядається. Запиши одну річ, на яку ти за цей тиждень не озирався — і не пожалів.",
    contemplationEn:
        "Bamboo grows a meter a day and never looks back. Note one thing this week you did not look back at, and did not regret.",
  ),
  22: PracticeNote(
    mottoUk: "Хтось зараз їсть листя і скоро стане шовком — тиша, в якій це відбувається, важлива.",
    mottoEn: "Something is eating leaves right now and will soon become silk — the silence around it matters.",
    bodyUk:
        "Шовкопряди їдять без перерви — людина в цей тиждень навпаки шукає легкості: спробуй два дні з варенням каякурі-ґохан (рис з дрібно нарізаними овочами).",
    bodyEn:
        "Silkworms eat without pause; we want the opposite this week — try two days of kayakuri-gohan, rice cooked with finely chopped seasonal vegetables.",
    activityUk:
        "Якщо є шовкова річ у шафі — провітри її на тіні. Шовк дихає не гірше за бавовну, але вологу не любить, як і саме шовкопрядство.",
    activityEn:
        "If you keep silk in the closet, air it in the shade. Silk breathes as well as cotton but hates humidity, much like the worms it comes from.",
    contemplationUk:
        "Японська приказка: тутове листя одне й те саме, шовк виходить різний. Подумай, як один і той самий день перетворюється тобою.",
    contemplationEn:
        "Mulberry leaves are all alike; the silk comes out different. Reflect on how the same kind of day passes through you and emerges altered.",
  ),
  23: PracticeNote(
    mottoUk: "Сафлор червоний — невипадковий: помітьте, який саме червоний вас сьогодні зачепив.",
    mottoEn: "Safflower red is never accidental — notice which red caught you today.",
    bodyUk:
        "Сафлор цвіте червоним — кров рухається. Спробуй замість міцної кави короткий настій із сушених пелюсток шафрану або просто з квіток ромашки.",
    bodyEn:
        "Safflower blooms red — blood likes the metaphor; trade strong coffee for a short infusion of saffron petals, or simply chamomile, nothing more.",
    activityUk:
        "Зайди у магазин тканин чи нитей — навіть на 5 хвилин. Червоний з сафлору — традиційний колір кімоно невісти, а не випадковий вибір.",
    activityEn:
        "Step into a fabric or thread shop, even for five minutes. Safflower red is the traditional bridal kimono colour, never an accidental choice.",
    contemplationUk:
        "Запиши, який саме червоний тебе сьогодні зачепив — мак, ягода, дах. Суджіко (саджалі квіти) розрізняли двадцять відтінків червоного.",
    contemplationEn:
        "Note which red caught you today — a poppy, a berry, a roof. The old kasane palette named twenty distinct reds; we have lost most of them.",
  ),
  24: PracticeNote(
    mottoUk: "Не все мусить чекати своєї осені — пшениця дозріває серед літа.",
    mottoEn: "Not everything waits for autumn — wheat ripens in the middle of summer.",
    bodyUk:
        "Пшениця колоситься — почалася 'осінь у літі' (麦秋). Спробуй свіжий хліб з трохи солоного мисо-масла, це їжа на той рідкісний тиждень.",
    bodyEn:
        "Wheat ripens in early summer — the Japanese call this 'autumn-in-summer' (mugi-aki); fresh bread with a thin layer of salted miso-butter fits perfectly.",
    activityUk:
        "Поглянь у напрямку поля чи навіть газону — вітер по злакових іде смугами. Це сама хвиля, через яку колись говорили зі стихіями.",
    activityEn:
        "Look toward a field or even a long lawn; wind moves through grain in clear stripes. That wave is how people once spoke with the elements.",
    contemplationUk:
        "Подумай, що в твоєму році 'дозріває раніше за термін'. Не все мусить чекати свого осіннього часу.",
    contemplationEn:
        "Consider what in your year is ripening ahead of schedule. Not everything needs to wait for its proper autumn.",
  ),
  25: PracticeNote(
    mottoUk: "Богомол стоїть нерухомо, як послушник — будь повністю там, де ти стоїш.",
    mottoEn: "The mantis stands still as a novice monk — be wholly where you stand.",
    bodyUk:
        "Богомоли вилуплюються — увага загострюється: спробуй один день без екранів після восьмої вечора, очі знайдуть, на чому затриматись.",
    bodyEn:
        "Praying mantises hatch — attention sharpens; try one screen-free day after eight in the evening, the eyes will find where to settle.",
    activityUk:
        "На листі рослин (особливо троянд, малини) шукай крихітних богомолів — менші за нігтик. Вони стоять нерухомо, як буддистські послушники.",
    activityEn:
        "On rose or raspberry leaves, look for newborn mantises smaller than a fingernail; they stand still as monks in their first robes.",
    contemplationUk:
        "Богомол у дзен-традиції — символ повної присутності в моменті удару. Запиши, де сьогодні ти був повністю — і скільки це тривало.",
    contemplationEn:
        "In Zen lore, the mantis stands for total presence in the strike. Note where today you were fully here, and for how long.",
  ),
  26: PracticeNote(
    mottoUk: "Світлячок — душа, що шукає, кому себе подарувати: посидь у темряві, не поспішай.",
    mottoEn: "A firefly is a soul looking for a recipient — sit in the dark, don't hurry.",
    bodyUk:
        "Перші світлячки — повітря тепле, ніч м'яка: спробуй вечеряти трохи раніше, легке холодне сомен з тертим імбиром і дрібно нарізаним мьоґа.",
    bodyEn:
        "First fireflies, soft warm night — eat a little earlier, try cold somen noodles with grated ginger and thin slivers of myōga (Japanese ginger).",
    activityUk:
        "Якщо є водойма за містом — поїдь увечері без ліхтарика. Хотару показуються тільки в темряві, і завжди поблизу чистої повільної води.",
    activityEn:
        "If you can reach a slow stream outside the city, go after dark without a torch — fireflies show only in true darkness, near clean still water.",
    contemplationUk:
        "Старе японське вірування: світлячок — душа, що ще не знайшла, кому себе подарувати. Просто посидь і подивись, не поспішай із роздумом.",
    contemplationEn:
        "An old Japanese belief: a firefly is a soul still looking for someone to give itself to. Just sit and watch — no need to think it through.",
  ),
  27: PracticeNote(
    mottoUk: "Уме цвіте першою, зріє останньою — поряд із тобою хтось живе так само.",
    mottoEn: "Plum blooms first and ripens last — someone near you lives like that.",
    bodyUk:
        "Сливи уме жовтіють — пора умебоші і умешу. Якщо немає під рукою, додай у воду одну солону уме на день — мудрі баби казали, що це від літа.",
    bodyEn:
        "Plums turn yellow — umeboshi and umeshu season; if you have neither, drop one salty plum in your water each day, the old wisdom for the heat ahead.",
    activityUk:
        "Зайди на ринок у пошуках свіжих жовтих слив. У японській родині цей тиждень — обов'язкова заготовка, ритм важливіший за результат.",
    activityEn:
        "Look for fresh yellow plums at the market; in a Japanese household this week is the canonical preserving week, where rhythm matters more than yield.",
    contemplationUk:
        "Уме йде з зимою, цвіте першою, а зріє останньою з весняних. Згадай людей, що теж так живуть у тебе поряд — повільні, але точні.",
    contemplationEn:
        "Plum walks with winter, blooms first, ripens last of the spring fruits. Recall the people in your life who live like that — slow but exact.",
  ),
  28: PracticeNote(
    mottoUk: "Найдовший день нічого не обіцяє — окрім того, що далі коротше.",
    mottoEn: "The longest day promises nothing but shorter ones from here on.",
    bodyUk:
        "Сонцестояння — день найдовший, тіло проситься у тінь: спробуй денну сієсту 20 хвилин і легку вечерю з тофу, шісо і огірком.",
    bodyEn:
        "Solstice — the longest day, the body wants shade; take a twenty-minute afternoon rest and a light supper of tofu, shiso, and cucumber.",
    activityUk:
        "На ґе-ші запалюють тиху лампу і відмічають момент полудня. Зроби це у себе — навіть просто помітивши, де сонце о 12-й, через місяць буде зсув.",
    activityEn:
        "On geshi, a quiet lamp is lit and noon is marked. Even just noting where the sun stands at twelve today — in a month, the shift will be visible.",
    contemplationUk:
        "Найдовший день не обіцяє нічого, крім того, що далі дні скорочуються. Подумай тихо, що в тебе цього літа вже на піку.",
    contemplationEn:
        "The longest day promises nothing except that days will shorten from here. Quietly consider what in your summer is already at its peak.",
  ),
  29: PracticeNote(
    mottoUk: "Поклади лист ірису під подушку — ірис означає і м'якість, і доблесть.",
    mottoEn: "Slip an iris leaf under the pillow — shōbu means both softness and valour.",
    bodyUk:
        "Іриси розкриваються — пора шобу-ю, ванни з листям ірису. Якщо немає листя, додай у воду кілька крапель кедрової олії, ефект схожий на свіжість.",
    bodyEn:
        "Irises open — shōbu-yu time, baths with iris leaves; if you can't find them, a few drops of cypress oil give the same kind of freshness.",
    activityUk:
        "Поклади один лист ірису або довгий зелений лист під подушку. У Хейан це робили проти лихих снів — і тому що пахне неймовірно.",
    activityEn:
        "Place a single iris leaf or any long green blade under the pillow. In Heian times this was done against bad dreams — and because it smells wonderful.",
    contemplationUk:
        "Шобу (菖蒲) і шобу (尚武, доблесть) пишуться по-різному, але звучать однаково. Подумай, де у твоєму житті м'якість і твердість збігаються.",
    contemplationEn:
        "Shōbu (iris) and shōbu (martial valour) are different kanji with the same sound. Think where in your life softness and firmness rhyme.",
  ),
  30: PracticeNote(
    mottoUk: "Земля наполовину перетворилась — і ти за півроку також.",
    mottoEn: "The earth is half-transformed — so are you, by mid-year.",
    bodyUk:
        "Хан-ґе-шо — у Кансаї цього дня їдять восьминога: 'щоб рис тримався землі, як його присоски'. Якщо ні — варений редис, він теж заземлює.",
    bodyEn:
        "Hange-shō — in Kansai people eat octopus today, 'so that rice clings to the earth like its suckers'; otherwise simmered daikon does the grounding.",
    activityUk:
        "Цей день селяни закінчували садити рис і брали тиждень повного відпочинку. Спробуй один день без планування — і подивись, що настане.",
    activityEn:
        "Farmers finished rice planting today and took a full week of rest. Try one day without scheduling anything, and see what arrives instead.",
    contemplationUk:
        "Хан-ґе-шо — день, коли земля 'наполовину перетворилась'. Запиши, що в тобі за перше півріччя теж стало іншим — не гірше, не краще, інше.",
    contemplationEn:
        "Hange-shō means 'the earth half-transformed'. Note what in you, by mid-year, has also turned — not worse, not better, simply other.",
  ),
  31: PracticeNote(
    mottoUk: "Прив'яжи бажання до гілки — на Танабату навіть кімнатна рослина годиться.",
    mottoEn: "Tie a wish to a branch — for Tanabata even a houseplant will do.",
    bodyUk:
        "Танабата — теплий вітер несе зірки. На вечерю: сомен холодне, як тонкі сріблясті нитки молочного шляху. Пара ложок соусу цую — і досить.",
    bodyEn:
        "Tanabata — a warm wind carries the stars. For supper: cold somen noodles, thin as the silvery threads of the Milky Way; a couple of spoons of tsuyu, no more.",
    activityUk:
        "Напиши одне бажання на смужці кольорового паперу і прив'яжи до гілки чи рослини. Це не магія, а форма уважності, як Хей’анська традиція.",
    activityEn:
        "Write one wish on a strip of coloured paper and tie it to a branch or houseplant. Not magic — a form of attention, the way the Heian court did it.",
    contemplationUk:
        "Орихіме і Хіко-боші зустрічаються раз на рік. Подумай, з ким у тебе теж 'річний' формат зустрічі — і чи це достатньо.",
    contemplationEn:
        "Orihime and Hikoboshi meet once a year. Consider who in your life you also see in a 'once-a-year' format — and whether that is enough.",
  ),
  32: PracticeNote(
    mottoUk: "Лотос виходить чистим із мулу — приходь до ставка до сьомої ранку.",
    mottoEn: "Lotus rises clean from mud — be at the pond before seven.",
    bodyUk:
        "Лотос розкривається на світанку — година ранкової легкості: спробуй сніданок з варених листочків шпинату, тофу і трохи лотосового кореня (рекон).",
    bodyEn:
        "Lotus opens at dawn — the hour of light food; a breakfast of simmered spinach, tofu, and a little lotus root (renkon) fits this short window.",
    activityUk:
        "У містах є ставки з лотосами в парках. Прийди до 7-ї ранку — лотос розкривається з тихим звуком, який чули тільки ранні буддисти.",
    activityEn:
        "City parks often hide a lotus pond; come before seven — lotus blooms with a faint sound, one only the early monks ever wrote about hearing.",
    contemplationUk:
        "Лотос росте з мулу і виходить чистим. Не як метафора — як факт: брудна вода справді потрібна для його чистого цвіту.",
    contemplationEn:
        "Lotus rises from mud and emerges clean — not as metaphor but as fact: dirty water is genuinely required for the clear bloom.",
  ),
  33: PracticeNote(
    mottoUk: "Молодий яструб робить коло, дорослий поряд виправляє — вчись малими кроками.",
    mottoEn: "The young hawk circles, the elder corrects — learn in small movements.",
    bodyUk:
        "Молоді яструби вчаться літати — рух треба точно дозувати: спробуй один тиждень коротких прогулянок до сніданку, не довгих — дрібніший крок зараз корисніший.",
    bodyEn:
        "Young hawks learn to fly — small precise movements matter; try a week of short walks before breakfast, not long ones — small steps serve you better now.",
    activityUk:
        "Якщо побачиш хижого птаха в небі — простеж за ним до кінця кола. Зараз молоді яструби вчаться, дорослі ширяють поряд і виправляють.",
    activityEn:
        "If you see a raptor overhead, follow it to the end of one circle. Now is when young hawks learn and the adults glide alongside, correcting.",
    contemplationUk:
        "Запиши, чого ти зараз вчишся — без іронії, без 'звичайно нічого'. Кажуть, у середньому людина вчиться чомусь новому раз на сім років.",
    contemplationEn:
        "Note what you are currently learning — no irony, no 'nothing really'. The average person, they say, learns something new once every seven years.",
  ),
  34: PracticeNote(
    mottoUk: "Павловнію садять на народження доньки — згадай, що ти посадив надовго.",
    mottoEn: "Paulownia is planted at a daughter's birth — recall what you planted to last.",
    bodyUk:
        "Павловнія в'яже плоди — це знак, що літо в зеніті, але вже з нахилом до осені. Додай до раціону сезонні білі огірки і тонкі скибки гарбуза.",
    bodyEn:
        "Paulownia sets seed — summer is at zenith but already leans toward autumn; add to your table seasonal white cucumbers and thin slices of squash.",
    activityUk:
        "Подивись на велике листя в парку чи дворі — павловнія, ясен, платан. Воно вже трохи запилене, з першими крайовими сухинками. Літо втомилось.",
    activityEn:
        "Look at the largest leaves in a park or yard — paulownia, plane, ash; they are already faintly dusty, with their first crisp edges. Summer is tired.",
    contemplationUk:
        "Дерево кірі (павловнія) садили на народження доньки і робили з нього скриню для приданого. Подумай, що ти посадив колись наперед.",
    contemplationEn:
        "Kiri (paulownia) was planted at a daughter's birth and made into her dowry chest. Reflect on what, in your life, you planted long-term.",
  ),
  35: PracticeNote(
    mottoUk: "Доьо — шов між сезонами: не вимагай від себе ясності, лише доброти.",
    mottoEn: "Doyō is the seam between seasons — ask for kindness, not clarity.",
    bodyUk:
        "Шлунок страждає від вологи: уникай сирого і холодного, обери варені страви, рисову кашу з імбиром, гарячий мугі-ча. Це класичний доьо-режим.",
    bodyEn:
        "The stomach suffers in the damp; avoid raw and cold dishes, prefer cooked food — rice porridge with ginger, hot barley tea. Classic doyō care.",
    activityUk:
        "Цього тижня японці їдять вугра (унаґі) у день уши-но-хі — щоб витримати спеку. Якщо ні — досить смаженої жирної риби з рисом і пастою умебоші.",
    activityEn:
        "This week the Japanese eat eel (unagi) on the day of the ox to endure the heat; otherwise grilled oily fish with rice and umeboshi paste does it.",
    contemplationUk:
        "Доьо — момент між порами, коли тіло і світ переходять. Не чекай від себе ясності цього тижня. Достатньо просто триматись доброти до себе.",
    contemplationEn:
        "Doyō is the seam between seasons, when both body and world cross over. Don't expect clarity this week — small kindness toward yourself is enough.",
  ),
  36: PracticeNote(
    mottoUk: "Юдачі ніколи не довша за чверть години — переждеш під дахом, нічого не пиши.",
    mottoEn: "A yūdachi never lasts past fifteen minutes — wait under cover, write nothing.",
    bodyUk:
        "Великі дощі — повітря важке: пий гарячу воду, не холодну, додай у супи трохи кудзу. Кудзу і шмат свіжого імбиру — сімейний антидот липню в Кьото.",
    bodyEn:
        "Great rains, heavy air; drink hot water, not cold, and slip a little kudzu into soups. Kudzu with fresh ginger is the Kyoto household antidote to July.",
    activityUk:
        "Якщо настав час сильної зливи — не біжи, переждеш п'ять хвилин під дахом. Японці кажуть, така злива (юдачі) ніколи довша за чверть години.",
    activityEn:
        "If a real downpour starts, don't run — wait five minutes under cover. Japanese say a yūdachi shower is never longer than a quarter of an hour.",
    contemplationUk:
        "Хайку Бусона: 'Раптовий дощ — водорізи побігли по даху коня.' Сядь біля вікна під дощ і просто дивись на воду, нічого не пиши.",
    contemplationEn:
        "Buson's haiku: 'Sudden rain — the horse's mane streaks like rivulets.' Sit by a window in the rain and just watch water, write nothing.",
  ),
  // ─── Autumn ───
  37: PracticeNote(
    mottoUk: "Перший прохолодний вітер каже легеням більше, ніж календар.",
    mottoEn: "The first cool wind tells the lungs more than the calendar will.",
    bodyUk:
        "Перший прохолодний вітер — це сигнал, що легені прокидаються до осені: вранці ложечка білого кунжуту або жменя смажених гарбузових насінин.",
    bodyEn:
        "The first cool wind tells your lungs autumn is starting; in the morning, a teaspoon of white sesame or a small handful of toasted pumpkin seeds.",
    activityUk:
        "Вийди ввечері без верхнього одягу — і ти впіймаєш суджі-кадзе, той вітер, який з'являється першим увечері й говорить більше, ніж календар.",
    activityEn:
        "Step outside in the evening without an extra layer — you'll catch suzu-kaze, the first cool wind, which speaks earlier than the calendar.",
    contemplationUk:
        "У саджікі цей вітер називається 'першим звуком осені'. Запиши одне відчуття, яке з'явилось саме сьогодні — і не було вчора.",
    contemplationEn:
        "In the saijiki this wind is called 'autumn's first sound'. Write down one sensation that arrived today and was not present yesterday.",
  ),
  38: PracticeNote(
    mottoUk: "Сядь надворі під вечір — хіґураші співає тільки в ту коротку годину.",
    mottoEn: "Be outside at dusk — the evening cicada sings only in that one short hour.",
    bodyUk:
        "Хіґураші — вечірня цикада: тіло у режимі переходу. Спробуй не їсти після восьмої, гарячий чай ходжіча перед сном краще за пізню вечерю.",
    bodyEn:
        "Higurashi — the evening cicada — and the body is between modes; skip food after eight, a cup of hot hojicha at night beats a late supper.",
    activityUk:
        "Сядь на сходах при заході сонця; пізні цикади (хіґураші) починають співати саме тоді — їхній спів коротший за літній.",
    activityEn:
        "Sit on a step at sunset; the late cicadas begin singing just then — their chorus is shorter than the high-summer one, and stranger.",
    contemplationUk:
        "Це тиждень обону — японці поминають предків. Запали маленьку свічку біля фотографії або просто подумки скажи ім'я когось, хто пішов.",
    contemplationEn:
        "This is Obon week — the Japanese remember the dead. Light a small candle by a photograph, or simply name in your mind someone who is gone.",
  ),
  39: PracticeNote(
    mottoUk: "Дерева в тумані — це чорнильні портрети самих себе. Прийди до сходу.",
    mottoEn: "Trees in fog become their own ink portraits — be there before the lift.",
    bodyUk:
        "Густий туман — повітря холоднішає різко: спробуй гарячий банча з трохи соєвого молока і шматочком сушеного імбиру, це класичний переходний напій.",
    bodyEn:
        "Thick morning fog and a sharper chill; try hot bancha with a splash of soy milk and a slice of dried ginger — the classic in-between drink.",
    activityUk:
        "Якщо вранці туман — вийди до парку за двадцять хвилин до того, як він розсіється. Дерева в тумані виглядають як їхні власні чорнильні портрети.",
    activityEn:
        "If a fog rolls in at dawn, walk into the park twenty minutes before it lifts; the trees look like their own ink portraits then.",
    contemplationUk:
        "Старе японське слово 'сазаре-ґірі' — туман, що осідає краплями. Подивись, на чому саме осідає сьогоднішній туман — на павутині, на металі.",
    contemplationEn:
        "An old word, sazare-giri — fog settling as small droplets. Watch where today's fog actually settles: on a spiderweb, on a railing, on hair.",
  ),
  40: PracticeNote(
    mottoUk: "Бавовняна квітка триває два дні — щось у тебе так само тихо зав'язало плід.",
    mottoEn: "A cotton bloom lasts two days — something in you set fruit just as quietly.",
    bodyUk:
        "Бавовник цвіте — зайве тепло виходить: спробуй один день у літньому одязі, але з шарфом на шиї. Класичне правило 'шия закрита — горло чисте'.",
    bodyEn:
        "Cotton blooms — surplus heat is leaving; try one day still in summer clothes but with a scarf at the neck. Old rule: the neck guarded, the throat stays clean.",
    activityUk:
        "Якщо є старі бавовняні речі — зараз пора оновити їх легким пранням і висушити на сонці. Цей тиждень ідеальний для цього — повітря сухе.",
    activityEn:
        "If you have old cotton clothes, this is the week to refresh them with a gentle wash and a sun-dry — the air is finally dry enough.",
    contemplationUk:
        "Бавовняна квітка триває два дні, потім перетворюється на коробочку. Подумай, що в тебе цього року 'відцвіло і зав'язало плід' тихо.",
    contemplationEn:
        "A cotton flower lasts two days before becoming a boll. Think of what in your year quietly bloomed and went on to set fruit, unannounced.",
  ),
  41: PracticeNote(
    mottoUk: "Небо і земля починають шанувати тишу — дозволь одній тиші триматись довше.",
    mottoEn: "Heaven and earth start honouring silence — let one of yours last longer.",
    bodyUk:
        "Спека стихає — апетит повертається: можна додати трохи більше вареної їжі, але повільно. Перші печені солодкі картоплі (сацумаімо) — добрий знак.",
    bodyEn:
        "The heat fades and appetite returns; ease back into cooked food, slowly. The first roasted sweet potatoes (satsumaimo) of the year are a fine sign.",
    activityUk:
        "Цього тижня вночі вже добре відчиняти вікно. Звуки змінюються — менше комах, більше шурхоту листя. Просто послухай 5 хвилин у темряві.",
    activityEn:
        "This week the night window is good to open again; the soundscape shifts — fewer insects, more leaf rustle. Just listen five minutes in the dark.",
    contemplationUk:
        "Японці кажуть: 'небо і земля починають шанувати тишу'. Запиши одну тишу, яку ти сьогодні дозволив тривати довше за зазвичай.",
    contemplationEn:
        "The Japanese phrase: 'heaven and earth begin to honour silence'. Note one silence today that you let last longer than you usually would.",
  ),
  42: PracticeNote(
    mottoUk: "Миска нового рису з однією уме — увесь зміст тижня хацу-хо.",
    mottoEn: "A bowl of new rice with one umeboshi is the whole week of hatsu-ho.",
    bodyUk:
        "Рис достигає — це тиждень першого нового рису (хацу-хо). Спробуй просту вечерю — миска білого рису з солоною уме і шматочком норі. Більше нічого.",
    bodyEn:
        "Rice ripens — the week of hatsu-ho, the first new rice; a simple supper of white rice with one umeboshi and a piece of nori is the whole point.",
    activityUk:
        "Зайди в магазин з крупами і подивись, чи є новий рис цього сезону — він має ледь зеленуватий відтінок і пахне сильніше за минулорічний.",
    activityEn:
        "Stop at a rice shop and check whether the new harvest is in; this year's grain has a faint green tinge and a stronger fragrance than last year's.",
    contemplationUk:
        "Шинто-обряд кан-наме-сай у листопаді присвячений саме новому рису. Подумай, чим би ти подякував цьому році, якби писав листа землі.",
    contemplationEn:
        "The Shinto kan-name-sai rite in November is dedicated to new rice. Think of what you would thank the year for, if you wrote a letter to the soil.",
  ),
  43: PracticeNote(
    mottoUk: "Дивись на одну краплину довше, ніж зазвичай — це і є практика хакуро.",
    mottoEn: "Watch one drop longer than usual — that is the whole practice of hakuro.",
    bodyUk:
        "Біла роса — ранки прохолодні: для легень додай тушковану японську грушу (наші) з медом або запечене яблуко з корицею. Це класичні моістифікатори.",
    bodyEn:
        "White dew, cool mornings; for the lungs, simmer a Japanese pear (nashi) with honey, or bake an apple with cinnamon — classical moisteners.",
    activityUk:
        "Вийди до 7-ї ранку і знайди справжню росу — на траві, на павутині, на машині. Цього сезону вона вже біла, а не прозора, як влітку.",
    activityEn:
        "Walk out before seven and find real dew — on grass, on a spider's web, on a car bonnet; this season's dew is already white, not summer's clear.",
    contemplationUk:
        "Сайґьо: 'на траві біла роса, як перлина — і теж зникає'. Подивись на одну краплю довше, ніж зазвичай. Це і є практика хакуро.",
    contemplationEn:
        "Saigyō: 'white dew on grass, like a pearl — and equally vanishes'. Watch one droplet longer than you usually would; that is the practice of hakuro.",
  ),
  44: PracticeNote(
    mottoUk: "Трясогузка біля води відраховує ритм — повертайся до того самого столу.",
    mottoEn: "The wagtail at the water counts a rhythm — come back to the same table.",
    bodyUk:
        "Трясогузки повертаються до дому — настрій теж шукає устрою: спробуй вечеряти за тим самим столом усі п'ять днів, без екранів, без 'у дорозі'.",
    bodyEn:
        "Wagtails come back to settled places; the mood asks the same — try eating supper at the same table all five days, no screens, no 'on the go'.",
    activityUk:
        "Дивись на тонкого птаха з довгим хвостом біля води — він труситься, наче відраховує. Японці казали, що трясогузка навчила людей рухам у любові.",
    activityEn:
        "Watch a thin long-tailed bird near water; it bobs as if counting. Old Japanese myth: the wagtail taught humans the rhythms of love.",
    contemplationUk:
        "Запиши, що у твоєму тілі цього сезону знайшло свій ритм. Не серце — а той менший рух, який стає частиною тебе непомітно.",
    contemplationEn:
        "Note what in your body has, this season, found its rhythm; not the heart but the smaller movement that quietly becomes part of you.",
  ),
  45: PracticeNote(
    mottoUk: "Постій під останньою ластівкою — вона повернеться у квітні до тієї ж стріхи.",
    mottoEn: "Stand under the last swallow — the same bird will return to the same eaves.",
    bodyUk:
        "Ластівки відлітають — повітря різке: добав до раціону білі продукти, що в'яжуть осінню сухість — рисове молоко, біла редька, груша, тофу.",
    bodyEn:
        "Swallows leave, the air sharpens; turn to white foods that hold autumn's dryness — rice milk, daikon, pear, tofu, the lung-quieting palette.",
    activityUk:
        "Останні ластівки зустрічаються над дахом ще тиждень-два. Якщо побачиш — постій під ними хвилину. Це той самий птах, що вернеться у квітні.",
    activityEn:
        "Last swallows still circle the rooftops a week or two. If you see one, stand beneath it a minute — it is the same bird that will return in April.",
    contemplationUk:
        "Японські діти писали ластівкам адресу свого дому, щоб вернулись. Чи є у тебе кому залишити адресу цієї осені?",
    contemplationEn:
        "Japanese children used to write their home address for the swallows so the birds would return. Whom would you leave your address with this autumn?",
  ),
  46: PracticeNote(
    mottoUk: "Хіґан — день і ніч рівні: відправ тиху думку тому, кого вже немає.",
    mottoEn: "Higan balances day and night — send a quiet thought to someone gone.",
    bodyUk:
        "Грім стихає — час осіннього хіґану. На столі — оханаґі (рисові кульки в червонобобовій пасті). Не як солодке, а як ритуал переходу.",
    bodyEn:
        "Thunder stops — autumn higan; on the table, ohagi (rice balls in red bean paste), not as sweet but as a rite of crossing.",
    activityUk:
        "Хіґан — тиждень, коли день і ніч рівні. Цього тижня японці провідують могили, ти можеш просто згадати тиху людину з минулого і передати їй думку.",
    activityEn:
        "Higan is the week of equal day and night; the Japanese visit graves, you can simply hold one quiet person from the past in mind and send a thought.",
    contemplationUk:
        "Подумай, що в тобі цієї осені нарешті стихає, як грім. Не з сумом — з полегшенням, що сюжет завершився.",
    contemplationEn:
        "Reflect on what in you, this autumn, finally quiets like thunder; not with sadness, with the relief of a storyline closing.",
  ),
  47: PracticeNote(
    mottoUk: "Стопи холонуть першими — закрий шпарину у вікні і одну справу в собі.",
    mottoEn: "Feet cool first — seal a window gap, and one matter inside you too.",
    bodyUk:
        "Комахи ховаються — і нам пора вкривати поперек і ноги: дістань теплі шкарпетки, навіть якщо ще не холодно. Стопи завжди холонуть першими.",
    bodyEn:
        "Insects withdraw and the lower back wants the same care; pull out the warm socks, even if it isn't cold yet. Feet always cool first.",
    activityUk:
        "Якщо у домі є тріщини, щілини у віконних рамах — цього тижня зачини. Японські хатні господарі робили це у точно той самий тиждень.",
    activityEn:
        "If there are gaps around your window frames, this is the week to close them. Japanese households did the same work at exactly this point in the year.",
    contemplationUk:
        "Запиши одну річ, яку ти теж 'закриваєш' цієї осені — проєкт, спілкування, тему. Не як втрату, а як підготовку до зими.",
    contemplationEn:
        "Note one thing you, too, are 'closing' this autumn — a project, a conversation, a topic. Not as loss but as preparation for winter.",
  ),
  48: PracticeNote(
    mottoUk: "Поле без води стоїть тихо — чи ця тиша в тобі порожнеча, чи спокій?",
    mottoEn: "A drained field stands quietly — is yours emptiness or peace?",
    bodyUk:
        "Поля осушують перед збором — апетит до коренеплодів: тушкована редька з кунжутом, варений лопух (кінпіра ґобо), морква. Це осіння міцність.",
    bodyEn:
        "Fields drain before harvest — root foods call; simmered daikon with sesame, kinpira gobō, slow carrot — that's the autumn ground tone.",
    activityUk:
        "Зайди до магазину з овочами і просто подивись, які корені тут уже з'явились — морква з гудиною, лопух, дайкон з листям. Колір повертається.",
    activityEn:
        "Stop in at a vegetable shop and look at which roots have appeared — carrots with greens, burdock, daikon with leaves; the colour is returning.",
    contemplationUk:
        "Поле, з якого спустили воду, стоїть тихо. Подумай, де у тобі стало тихіше за останній місяць — і чи це порожнеча, чи спокій.",
    contemplationEn:
        "A drained field stands quietly. Reflect on where in you it has gone quieter this last month — and whether that's emptiness or peace.",
  ),
  49: PracticeNote(
    mottoUk: "Гуси століттями летять одним маршрутом — який твій тримає тебе в формі?",
    mottoEn: "Geese hold one route for centuries — which of yours keeps your shape?",
    bodyUk:
        "Дикі гуси повертаються — приходять справжні холодні ранки: спробуй гарячий мізо-суп з кабочою (японським гарбузом) і шматочком тофу.",
    bodyEn:
        "Wild geese return as real cold mornings begin; a hot miso soup with kabocha and a piece of tofu fits the week perfectly.",
    activityUk:
        "Поглянь у небо приблизно за годину до заходу — клин гусей пролітає завжди в цей час. Один навіть здалеку виглядає, як стрілка компасу.",
    activityEn:
        "Look up at the sky an hour before sunset; the geese fly then. From far away even a single one moves like a compass needle.",
    contemplationUk:
        "Гуси прилітають точно за тим самим маршрутом століттями. Подумай, який твій постійний маршрут, який тебе тримає у формі.",
    contemplationEn:
        "Geese return along the same route for centuries. Consider what consistent route in your life keeps you in the shape you want to be in.",
  ),
  50: PracticeNote(
    mottoUk: "Поглянь на хризантему: вона знає, як квітнути в холоді.",
    mottoEn: "Watch the chrysanthemum — it knows how to bloom into the cold.",
    bodyUk:
        "Хризантеми цвітуть — Чьоьо, день дев'ятого. Налий чашку гарячого саке з пелюсткою кіку (їстівної хризантеми) або просто додай у чай ромашку.",
    bodyEn:
        "Chrysanthemums bloom — Chōyō, the ninth day; pour hot sake with an edible kiku petal, or simply drop chamomile into your tea.",
    activityUk:
        "Постав у вазі гілочку хризантеми; тиждень дивись, як вона змінює колір з ранку до вечора — особливо в момент, коли світло стає косим.",
    activityEn:
        "Place a sprig of chrysanthemum in a vase; for a week, watch its colour shift from morning to evening — especially as the light goes slanted.",
    contemplationUk:
        "Хризантема — символ тривалого життя і тихої гідності. Подумай, на чому ти стоїш так само непомітно, як хризантема в осінньому вазоні.",
    contemplationEn:
        "Chrysanthemum stands for long life and quiet dignity. Consider what you stand on, this autumn, as quietly as a kiku in its pot.",
  ),
  51: PracticeNote(
    mottoUk: "Цвіркун співає під вікном — не зачиняй, з ним ти зимуєш.",
    mottoEn: "A cricket sings under the window — leave it open, you winter together.",
    bodyUk:
        "Цвіркуни біля дверей — будинок проситься в порядок: розбери одну полицю, що шурхотіла усе літо. Уважна осіння господарка — це теж ё-дзо.",
    bodyEn:
        "Crickets at the door, the house wants tidying; clear one shelf that has rustled all summer. Quiet autumn housekeeping is yōjō too.",
    activityUk:
        "Вночі цвіркун співає під самим вікном. Не закривай — просто послухай. Стародавні японці тримали цвіркунів у клітках спеціально на зиму.",
    activityEn:
        "A cricket sings right under the window at night; don't close it — just listen. Old Japanese kept crickets in tiny cages all through winter.",
    contemplationUk:
        "У вірші Сею: 'у моєму домі цвіркун і я — двоє самотніх старих'. Запиши, з ким ти зимуєш цього року, навіть якщо це лише голос за стіною.",
    contemplationEn:
        "Seibi's poem: 'in my house, a cricket and I — two lonely old men'. Note who you are wintering with this year, even if only a voice through a wall.",
  ),
  52: PracticeNote(
    mottoUk: "Хацу-шімо тримається чверть години після сходу — встань раніше за неї.",
    mottoEn: "Hatsu-shimo lasts fifteen minutes after sunrise — be up earlier.",
    bodyUk:
        "Перший паморозок — нирки шукають тепла: переходь на варені, тушковані страви, ввечері трохи кудзу-юу (кудзу з гарячою водою і солодом).",
    bodyEn:
        "First frost — the kidneys want warmth; shift to simmered dishes, and in the evening a little kuzu-yu (kudzu thickened with hot water and malt).",
    activityUk:
        "Вранці перевір машину чи перила — паморозок зникає за чверть години після сходу. Тільки той, хто рано встав, бачить її повну форму.",
    activityEn:
        "In the morning check the car or a railing — frost vanishes within fifteen minutes of sunrise. Only the early riser sees its full pattern.",
    contemplationUk:
        "Перший паморозок — у саджікі окремий кіґо: 'хацу-шімо'. Запиши день, коли ти його побачив — наступного року порівняєш.",
    contemplationEn:
        "First frost is its own kigo in the saijiki — 'hatsu-shimo'. Note the day you first saw it; next year you'll compare.",
  ),
  53: PracticeNote(
    mottoUk: "Шіґуре — мерехтливий дощ: спостережи думку, яка приходить і йде так само.",
    mottoEn: "Shigure is a flickering rain — watch a thought that arrives and leaves the same way.",
    bodyUk:
        "Раптові короткі дощі (шіґуре) — повітря двоїсте: спробуй гарячий ходжічя з обсмаженими паличками рису (генмайчя), він зігріває без важкості.",
    bodyEn:
        "Sudden short rains (shigure) — the air is split; try hot hojicha or genmaicha with toasted rice grains, warming without weight.",
    activityUk:
        "Якщо застав шіґуре — не біжи, постій під дахом, послухай ритм. Японські хайдзіни вважали такий дощ найвиразнішим звуком осені.",
    activityEn:
        "If a shigure catches you, don't run — stand under cover and listen. Japanese haijin held this rain to be autumn's most expressive sound.",
    contemplationUk:
        "Шіґуре — слово, від якого пішло 'шігурер кокоро', 'мерехтливе серце'. Подивись, яка думка сьогодні приходить і зникає, як цей дощ.",
    contemplationEn:
        "Shigure gave us 'shigure-kokoro' — a flickering heart. Watch which thought today arrives and leaves you the way this rain does.",
  ),
  54: PracticeNote(
    mottoUk: "Зайди в один парк двічі за тиждень — між двома візитами проявляться характери.",
    mottoEn: "Visit one park twice this week — characters show in the gap between visits.",
    bodyUk:
        "Клен і плющ жовтіють — у саду йде період моміджі. На столі: смажений ґінкго (іньо) у мисо-юдзу або печене яблуко з місо-карамеллю.",
    bodyEn:
        "Maple and ivy yellow — momiji time; on the table, roasted ginkgo nuts in miso-yuzu, or baked apple with miso caramel.",
    activityUk:
        "Моміджі-ґарі — традиційний 'полювання на червоне листя'. Сходи в один парк двічі за тиждень, з різницею у три дні. Колір зміниться.",
    activityEn:
        "Momiji-gari, the 'hunt for red leaves' — visit one park twice this week, three days apart. The colour will have moved.",
    contemplationUk:
        "Запиши одне дерево, яке ти раніше не помічав, бо влітку воно було таким самим зеленим, як решта. Восени проявляються характери.",
    contemplationEn:
        "Note one tree you never noticed before — in summer it was as green as the rest; autumn lets characters show through.",
  ),
  // ─── Winter ───
  55: PracticeNote(
    mottoUk: "Цубакі падає одразу цілою — відпусти не повільно, а одним рухом.",
    mottoEn: "Tsubaki falls whole, never petal by petal — let go in one gesture.",
    bodyUk:
        "Цубакі (камелія) розкривається — час потовщувати супи: спробуй густіший мізо з кабочою, чорними соєвими бобами і шматочком водорості комбу.",
    bodyEn:
        "Tsubaki (camellia) opens — soups want body; a thicker miso with kabocha, kuromame, and a small piece of kombu does the work this week.",
    activityUk:
        "Подивись, чи квітне камелія в дворі чи парку — вона відкривається саме коли інше вже завмерло. Червона на голій гілці — головний знак ріттто.",
    activityEn:
        "Look for camellia in a yard or park — it opens just as everything else has stopped. Red on a bare branch is the central sign of ritto.",
    contemplationUk:
        "У дзен квітка цубакі падає не пелюстками, а одразу цілою — миттєво. Подумай, що ти теж, можливо, відпускаєш не повільно, а одним рухом.",
    contemplationEn:
        "In Zen, a tsubaki blossom falls whole, never petal by petal. Reflect on what you, too, might let go of in one gesture, not slowly.",
  ),
  56: PracticeNote(
    mottoUk: "Земля твердіє сама — згадай, де за рік ти теж затвердів у доброму сенсі.",
    mottoEn: "The earth hardens by itself — recall where you, too, firmed in a good way.",
    bodyUk:
        "Земля промерзає — стопи стигнуть першими: перед сном теплі ванни для ніг (асі-юу) з ложкою солі та шматочком імбиру. Це класичне зимове ё-дзо.",
    bodyEn:
        "The ground freezes and feet cool first; before bed, an ashi-yu — foot bath with a spoonful of salt and a slice of ginger. Winter yōjō at its quietest.",
    activityUk:
        "Цього тижня перевір, як одягнено хвору або стару людину поряд. Зимова турбота починається не з слів, а з шкарпеток і шарфа.",
    activityEn:
        "This week, check whether anyone elderly or unwell nearby is dressed warmly. Winter care begins not with words but with socks and a scarf.",
    contemplationUk:
        "Земля сама стає твердою, без чужих рук. Подумай, де ти за рік 'затвердів' у доброму сенсі — у звичках, у ясності.",
    contemplationEn:
        "The earth hardens by itself, without anyone's help. Consider where in the year you have 'firmed' in a good way — in habits, in clarity.",
  ),
  57: PracticeNote(
    mottoUk: "Нарцис гострішає в нічній тиші — хтось у твоєму колі теж відкривається лише в ній.",
    mottoEn: "Narcissus sharpens in night silence — someone in your circle opens only there too.",
    bodyUk:
        "Нарциси цвітуть на тлі холоду — додай у вечерю трохи мейно (японської гірчиці) або тонкі скибки рідьки з ферментованим місо. Сезонна різкість.",
    bodyEn:
        "Daffodils bloom against the cold; add a little Japanese mustard greens or thin radish slices with fermented miso to supper — seasonal sharpness.",
    activityUk:
        "Постав один нарцис у вузьку вазу. Кінсенка (金盞 — золота чарка) — старе ім'я нарциса, що передбачає його силует на голому столі.",
    activityEn:
        "Set a single narcissus in a narrow vase; kinsenka, 'golden cup', is the old name for it, anticipating that lone silhouette on a bare table.",
    contemplationUk:
        "Нарцис не пахне сильно вдень, але вночі його запах гострішає. Подумай, хто з твого оточення відкривається лише в тиші.",
    contemplationEn:
        "Narcissus smells faintly in the day; at night the scent sharpens. Reflect on who in your circle opens only in silence.",
  ),
  58: PracticeNote(
    mottoUk: "Звичка дивитися в небо переживе саму райдугу.",
    mottoEn: "The habit of looking up outlives the rainbows themselves.",
    bodyUk:
        "Райдуги ховаються — небо стає тьмянішим: на столі темні кольори. Чорний рис, чорний кунжут, чорні соєві боби — це класична зимова палітра жень.",
    bodyEn:
        "Rainbows hide and the sky dulls; the table goes dark — black rice, black sesame, black soybeans, the classic winter kidney palette.",
    activityUk:
        "Коли вийде сонце після короткого дощу — все одно подивись угору. Райдуг більше не буде до весни, але слід досі впізнавати небо вище за справи.",
    activityEn:
        "When the sun returns after a brief rain, still look up. There will be no rainbow until spring, but the habit of looking up outlives the rainbows.",
    contemplationUk:
        "Запиши одну річ, що зникла з твого пейзажу і ти ще не помітив. У саджікі це називається 'утратити кіґо' — і це нормальна частина року.",
    contemplationEn:
        "Note one thing that has left your landscape and you haven't noticed; in the saijiki this is 'losing a kigo' — a normal part of the year.",
  ),
  59: PracticeNote(
    mottoUk: "Не змітай листя — це тиха ковдра саду, а в тарілці гаряче набе.",
    mottoEn: "Don't sweep the leaves — they are the garden's quiet quilt, and on the plate, hot nabe.",
    bodyUk:
        "Північний вітер здуває листя — час щільної їжі: спробуй каракі-набе з рідькою, шіітаке і тофу, гарячий і простий, краще за фастфуд у будь-яких умовах.",
    bodyEn:
        "North wind strips leaves — dense food season; a simple yose-nabe with daikon, shiitake, and tofu beats any takeaway.",
    activityUk:
        "Не змітай листя з балкона одразу — вони грають роль ізоляції для горщиків. Японські садівники називають це 'тихою ковдрою саду'.",
    activityEn:
        "Don't sweep the balcony leaves at once — they insulate the pots. Japanese gardeners call this 'the quiet quilt of the garden'.",
    contemplationUk:
        "Сакімадзе (朔風) — назва 'першого нового вітру місяця'. Запиши, який звук приніс цей вітер у твоє вікно сьогодні.",
    contemplationEn:
        "Sakimaze, 'the new moon's first wind' — write down what sound it brought to your window today.",
  ),
  60: PracticeNote(
    mottoUk: "Один цитрус біля ліжка лікує кашель краще за гарячий напій.",
    mottoEn: "A single citrus by the bed eases a cough better than any hot drink.",
    bodyUk:
        "Тачібана жовтіють — пора цитрусу. Юдзу, мікан, кіноту: поклади один цитрус біля ліжка, його запах гасить кашель краще за гарячий напій.",
    bodyEn:
        "Tachibana yellows — citrus season; yuzu, mikan, kinotō. Set a single citrus by the bed; its scent calms a cough better than a hot drink.",
    activityUk:
        "Зайди в крамницю і вибери один цитрус, який пахне найгостріше. Японці кажуть: запах юдзу заходить у кров швидше за вітамін С.",
    activityEn:
        "At the market, pick the single sharpest-smelling citrus. The Japanese say yuzu's scent enters the blood faster than its vitamin C ever could.",
    contemplationUk:
        "Тачібана у мифах — вічно зелене дерево, символ безсмертя. Подумай, що в тебе залишається зеленим серед загального жовтого.",
    contemplationEn:
        "Tachibana in myth is the evergreen, the tree of immortality. Reflect on what in you stays green within the general yellow.",
  ),
  61: PracticeNote(
    mottoUk: "Сезон 'закрилось і стало зимою' — не все відкрите мусить лишатись таким.",
    mottoEn: "Season 'sealed, become winter' — not everything you opened needs to stay open.",
    bodyUk:
        "Холод осідає — зимова втома підкрадається. Спробуй вечеряти раніше і додавай у супи злегка обсмажений імбир, він тепло утримує до ночі.",
    bodyEn:
        "Cold settles in and winter fatigue follows; eat supper earlier, add lightly toasted ginger to soups — it carries warmth into the night.",
    activityUk:
        "Цей тиждень японці називають 'хейсоку наре фуйю' — 'закрилось і стало зимою'. Перевір замки, ущільнювачі, теплі ковдри. Ритуал важливий.",
    activityEn:
        "This week, called heisoku-nare-fuyū — 'sealed, become winter' — check locks, draughts, warm bedding. The ritual matters as much as the result.",
    contemplationUk:
        "Подумай, що ти за цей рік відкрив, і чи готовий тепер тримати закритим. Не все з того, що відкривав, повинно лишатись відкритим назавжди.",
    contemplationEn:
        "Consider what you have opened this year, and whether some of it can now be kept closed. Not everything you opened needs to stay open.",
  ),
  62: PracticeNote(
    mottoUk: "Серце ведмедя сповільнюється, не вимикається — обери одну книжку на зиму.",
    mottoEn: "A bear's heart slows, it does not stop — choose one book to winter with.",
    bodyUk:
        "Ведмеді у барлогу — нам теж пора більше сну: спробуй один тиждень лягати на годину раніше. Зимова темрява — не діагноз, а сигнал.",
    bodyEn:
        "Bears go into the den — we want more sleep too; try one week of going to bed an hour earlier. Winter dark is not a diagnosis but a cue.",
    activityUk:
        "Зайди в книжкову крамницю і знайди книгу, з якою хочеш провести зиму. У японських родинах є тиха практика — 'фую-но иссацу', одна книжка на зиму.",
    activityEn:
        "Find one book you want to winter with; Japanese households have a quiet practice — fuyu-no-issatsu, 'one book for the winter'.",
    contemplationUk:
        "Ведмідь спить, але у нього сповільнюється серце, не зникає. Подумай, що в тобі цієї зими сповільнюється — а не вмикається на повну.",
    contemplationEn:
        "A bear sleeps but his heart only slows, it doesn't stop. Reflect on what in you slows this winter rather than switching off entirely.",
  ),
  63: PracticeNote(
    mottoUk: "Лосось іде проти власної течії — чи варто йти проти твоєї цієї зими?",
    mottoEn: "Salmon swims against its own current — is yours worth swimming against this winter?",
    bodyUk:
        "Лосось іде на нерест — час жирної риби: запечений лосось з рідькою, мисо-юдзу і трохи шісо. Це сезонне ё-дзо для нирок і шкіри.",
    bodyEn:
        "Salmon spawn upstream — oily fish week; baked salmon with daikon, miso-yuzu, and a leaf or two of shiso, the seasonal yōjō for kidneys and skin.",
    activityUk:
        "Якщо є річка чи навіть струмок — сходи на нього подивитись. Лосось не у кожній воді, але форма руху в холодній течії схожа.",
    activityEn:
        "If there's a river or even a stream nearby, go look at it; salmon won't be there, but the shape of movement in cold water is the same.",
    contemplationUk:
        "Лосось іде проти течії, не проти чужих, проти своєї. Подумай, проти якої власної течії ти йдеш цією зимою — і чи варто.",
    contemplationEn:
        "Salmon swims upstream — not against others, against its own current. Consider which of your own currents you're swimming against this winter, and whether it's worth it.",
  ),
  64: PracticeNote(
    mottoUk: "Найдовша ніч у році не вимагає від тебе нічого, окрім ванни з юдзу.",
    mottoEn: "The longest night asks nothing of you but a yuzu bath.",
    bodyUk:
        "Зимове сонцестояння — на воду додай шкірки юдзу, ваніль ванну на 10 хвилин. Юдзу-ю — не легенда, а практика очищення тіла перед новим роком.",
    bodyEn:
        "Winter solstice — drop yuzu peel in your bath, soak ten minutes; yuzu-yu is not a legend but the body's cleansing rite before the new year.",
    activityUk:
        "На тоджі їдять кабочу — варену з трохи азукі. Це класичний 'тоджі-кабоча'. Якщо немає — звичайний печений гарбуз з мисо теж робить справу.",
    activityEn:
        "On tōji one eats kabocha simmered with azuki — the classic tōji-kabocha. If you can't do that, baked squash with miso does the same work.",
    contemplationUk:
        "Найдовша ніч року. Нічого не вимагай від цього вечора, окрім ванни з юдзу. День лише один, темрява важлива не менше.",
    contemplationEn:
        "The longest night of the year. Demand nothing of this evening except the yuzu bath. One day matters less than this dark.",
  ),
  65: PracticeNote(
    mottoUk: "Олень скидає роги — запиши одне зайве слово, нехай випаде до 31-го.",
    mottoEn: "The deer sheds its antlers — write one excess word and let it fall by the thirty-first.",
    bodyUk:
        "Олені скидають роги — і нам пора скинути зайве: розбери одну шухляду, не цілу шафу. Зайвина у будинку плодить зайвину в голові.",
    bodyEn:
        "Deer shed their antlers — let yourself shed too; clear one drawer, not a whole closet. Excess at home breeds excess in the head.",
    activityUk:
        "Якщо знайдеш у лісі гілку, схожу на ріг — забери. Колись казали, що рік, що скинутий оленем, приносить тиху удачу до Нового року.",
    activityEn:
        "If you find a branch shaped like an antler, take it home; old custom said a shed antler brings quiet luck before the new year.",
    contemplationUk:
        "Що ти за цей рік носив, що було колись потрібним, а тепер тільки тяжкістю? Запиши одне слово — і нехай воно випаде до 31-го.",
    contemplationEn:
        "What did you carry this year that was once needed and is now only weight? Write one word, and let it drop before the thirty-first.",
  ),
  66: PracticeNote(
    mottoUk: "Котодама: тихо промовлене слово має силу — встань на десять хвилин раніше.",
    mottoEn: "Kotodama: a whispered word still has power — rise ten minutes earlier.",
    bodyUk:
        "Шьоґацу — пшениця тихо росте під снігом. На столі озоні (новорічна юшка з моті) і трохи нанакуса-ґаю на наступному тижні. Все робиться повільно.",
    bodyEn:
        "Shōgatsu — wheat grows quietly under snow; on the table, ozōni (a New Year mochi soup), and nanakusa-gayu coming next week. Everything done slowly.",
    activityUk:
        "Перший день року — хацу-хіноде, перший схід сонця. Постань на 10 хвилин раніше і подивись, як світло заходить у твою кімнату — це і є початок.",
    activityEn:
        "First day of the year — hatsu-hinode, the first sunrise. Get up ten minutes earlier and watch the light enter your room; that is the actual beginning.",
    contemplationUk:
        "Запиши одне тихе побажання — не для опублікування. Старе японське слово 'котодама' означає, що промовлене слово має силу, навіть пошепки.",
    contemplationEn:
        "Write one quiet wish, not for posting. The old Japanese word kotodama means a word holds power even when whispered.",
  ),
  67: PracticeNote(
    mottoUk: "Після свят шлунок просить сім весняних трав — більше нічого.",
    mottoEn: "After the holidays the stomach asks for seven spring herbs and nothing more.",
    bodyUk:
        "Сьомого січня — нанакуса-но-секку. Якщо є можливість — звари ранкову кашу з сімома весняними травами. Шлунок дякує після свят.",
    bodyEn:
        "January seventh, nanakusa-no-sekku — if you can, make the morning porridge with the seven spring herbs. The stomach thanks you after the feast week.",
    activityUk:
        "Знайди на ринку чи у магазині хоча б шпинат, кріп і петрушку. Класичний нанакуса — це сім видів, але дух — у поверненні до зеленого після білого.",
    activityEn:
        "Find at least spinach, parsley, and chervil at the market; the classical nanakusa lists seven, but the spirit is the return to green after the white week.",
    contemplationUk:
        "Каша нанакуса — це повернення тіла до буднів. Запиши одну буденність, до якої ти повертаєшся з полегшенням, не з втомою.",
    contemplationEn:
        "Nanakusa-gayu marks the body's return to ordinary days. Note one ordinariness you come back to with relief, not fatigue.",
  ),
  68: PracticeNote(
    mottoUk: "Послухай воду під льодом — звук, що приходить раніше за весну.",
    mottoEn: "Listen for water beneath the ice — a sound that arrives before spring.",
    bodyUk:
        "Підземні струмки розморожуються — нирки ще тримають зиму. Спробуй гарячий настій з трохи кудзу, імбиру і ложкою темного меду перед сном.",
    bodyEn:
        "Underground springs thaw, but the kidneys still keep winter; try a hot drink of kudzu, ginger, and a spoon of dark honey before bed.",
    activityUk:
        "Якщо є джерело чи струмок поряд — піди подивись на лід. Там, де він тонший, чути воду під льодом — звук, що приходить раніше за весну.",
    activityEn:
        "If a stream or spring is nearby, go look at the ice; where it thins, you can already hear water beneath — a sound that arrives before spring.",
    contemplationUk:
        "Подумай, що в тобі цього січня тихо рухається під льодом — і не вимагай від нього виходу зараз. Ще зарано.",
    contemplationEn:
        "Reflect on what in you, this January, moves quietly under the ice — and don't ask it to surface yet. Still too early.",
  ),
  69: PracticeNote(
    mottoUk: "Фазан кричить, навіть коли ніхто не чує — це теж форма здоров'я.",
    mottoEn: "The pheasant calls whether anyone hears or not — that, too, is health.",
    bodyUk:
        "Фазани кричать — повітря різке, але ясне: спробуй гарячий рисовий бульйон (одзоюу) з паличкою у-меу-боші і шматочком імбиру.",
    bodyEn:
        "Pheasants call — the air is sharp but clear; try a hot rice broth (ozōyu) with a single umeboshi and a slice of ginger.",
    activityUk:
        "У саду чи парку послухай зимових птахів — у січні вони голосні, бо немає листя. Кажен звук іде далі, ніж улітку.",
    activityEn:
        "In a yard or park, listen to winter birds; in January their calls travel farther because there are no leaves to soften the air.",
    contemplationUk:
        "Самець фазана кричить, навіть коли його ніхто не чує. Запиши, де ти сьогодні висловився, не очікуючи відповіді — це теж форма здоров'я.",
    contemplationEn:
        "A cock pheasant calls whether anyone hears or not. Note where today you spoke without expecting an answer — that, too, is a form of health.",
  ),
  70: PracticeNote(
    mottoUk: "Тіло прокидається через гіркоту, не через солодке — шукай зелене на чорній землі.",
    mottoEn: "The body wakes through bitterness, not sweetness — find green on the black earth.",
    bodyUk:
        "Фукіното (брунька білокопитника) проривається з-під снігу — перша гірка зелень. Дрібно посічена в тенпуру або у місо-суп — пробудник печінки.",
    bodyEn:
        "Fukinotō pushes through the snow — the first bitter green; finely chopped into tempura or miso soup, it wakens the liver.",
    activityUk:
        "Підійди до снігового острівця в дворі — там, де є чорна земля, дивись уважно, чи нема зеленого. Іноді фукіното з'являється раніше за календар.",
    activityEn:
        "Walk to a melted patch in the yard; where black earth shows, look closely for green. Fukinotō sometimes arrives before the calendar.",
    contemplationUk:
        "Перша гірка зелень — це смак переходу: тіло прокидається через гіркоту, не через солодке. Подумай, де гіркота тобі цьогоріч послужила.",
    contemplationEn:
        "The first bitter green is the taste of transition; the body wakes through bitterness, not sweetness. Reflect on where bitterness has served you this year.",
  ),
  71: PracticeNote(
    mottoUk: "Лід тримає форму, бо стиснений — який тиск зараз робить тебе чіткішим?",
    mottoEn: "Ice holds shape because it is pressed — which pressure now is sharpening you?",
    bodyUk:
        "Лід найтовщий — це не привід замерзати: вечеря з гарячим набе, з рідькою, тофу, лососем чи курятиною. Нікого не залишити голодним цього тижня.",
    bodyEn:
        "Ice is at its thickest — no reason for you to be cold; supper as a hot nabe with daikon, tofu, salmon, or chicken. No one goes hungry this week.",
    activityUk:
        "Цей тиждень називається 'дайкан'. Японці кажуть: вода, набрана у дайкан, не псується довго. Налий собі склянку звечора і подивись її вранці.",
    activityEn:
        "This week is daikan, the great cold; Japanese say water drawn now keeps unspoiled for a long time. Pour yourself a glass tonight and look at it in the morning.",
    contemplationUk:
        "Лід тримає форму, бо сильно стиснений. Подумай, чи є у тебе тиск, який зараз робить тебе чіткішим, а не зламує.",
    contemplationEn:
        "Ice holds shape because it's tightly compressed. Consider whether some pressure on you right now is sharpening you, rather than breaking you.",
  ),
  72: PracticeNote(
    mottoUk: "Звук соєвих бобів за дверима важливіший за слова — оні-ва-сото.",
    mottoEn: "The sound of beans at the door matters more than the words — oni-wa-soto.",
    bodyUk:
        "Курки знов несуться — світло повертається. На сецубун — еха-маки, цілий ролл суші, який їдять мовчки, дивлячись на щасливий напрямок року.",
    bodyEn:
        "Hens lay again — light is returning; on Setsubun, ehō-maki, a whole sushi roll eaten in silence facing the year's lucky direction.",
    activityUk:
        "Кинь жменю смажених соєвих бобів за двері зі словами 'оні-ва-сото, фуку-ва-учі' — 'демони геть, щастя у дім'. Звук бобів важливіший за слова.",
    activityEn:
        "Toss a handful of roasted soybeans out the door with 'oni-wa-soto, fuku-wa-uchi' — 'demons out, fortune in'. The sound of the beans matters more than the words.",
    contemplationUk:
        "Сецубун — буквально 'ділення сезонів'. Старий рік завершується, новий — теплий — починається завтра. Запиши одне 'оні', якого вже не пускаєш.",
    contemplationEn:
        "Setsubun literally means 'dividing the seasons'. The old year closes; the warm one starts tomorrow. Write down one 'oni' you no longer let in.",
  ),
};

PracticeNote? practiceForKo(int koIndex) => seasonalPractice[koIndex];
