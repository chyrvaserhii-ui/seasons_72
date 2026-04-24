/// Two-locale prose descriptions for each of the 24 sekki (二十四節気).
///
/// Kept in Dart rather than JSON because the text is editorial — the
/// `about_content.dart` precedent. Edit here when tone needs polishing.
///
/// Double-quoted strings on purpose: Ukrainian apostrophes ('п'ятиденні')
/// would otherwise need escaping inside single-quoted literals.
// ignore_for_file: prefer_single_quotes
library;

class SekkiDescription {
  const SekkiDescription({required this.uk, required this.en});
  final String uk;
  final String en;
}

/// Looks up descriptions by sekki `id` (matches `seasons.json`).
const Map<String, SekkiDescription> sekkiDescriptions = {
  "risshun": SekkiDescription(
    uk: "Початок весни. За старим календарем — справжній старт нового року: лютневий мороз тримає, але вже відчувається, що сонце повертає на літо.",
    en: "Beginning of spring. In the old calendar, this was the real start of the new year — frost still holds, but the sun has clearly turned toward summer.",
  ),
  "usui": SekkiDescription(
    uk: "Дощова вода. Сніг тане, ріки наповнюються, верба випускає бруньки. Перший період, коли земля «п'є», а не «спить».",
    en: "Rainwater. Snow melts, rivers swell, willows put out buds. The first stretch where the earth drinks instead of sleeping.",
  ),
  "keichitsu": SekkiDescription(
    uk: "Пробудження комах. Жуки, метелики й земляні створіння виходять із зимового сховку. Назва буквально — «відкриття вугілля», коли тепло доходить до землі.",
    en: "Awakening of hibernators. Insects and burrowing creatures stir from winter hiding. The name literally means \"opening the burrows\" — heat finally reaches the soil.",
  ),
  "shunbun": SekkiDescription(
    uk: "Весняне рівнодення. День і ніч однакові. У Японії відзначається як національне свято — час відвідати могили предків і помилуватися сакурою.",
    en: "Spring equinox. Day and night equal length. In Japan it's a national holiday — time to visit ancestral graves and watch the cherry blossoms open.",
  ),
  "seimei": SekkiDescription(
    uk: "Чистота і ясність. Найкрасивіший час року: повітря прозоре, листя яскраве, природа «чиста, як після купання». Кращий час для прогулянок горами.",
    en: "Pure and clear. The most luminous time of year — clean air, vivid foliage, nature \"as if freshly washed\". The classical time for mountain walks.",
  ),
  "kokuu": SekkiDescription(
    uk: "Хлібний дощ. Останній сезон весни, кінець квітня — початок травня. Теплі дощі живлять щойно посаджений рис, поля наповнюються водою. Селяни чекали саме цих дощів — від них залежав урожай. Назва дослівно: «дощ для зерна».",
    en: "Grain rains. The last sekki of spring, late April through early May. Warm rains nourish newly-planted rice; paddies fill with water. Farmers waited specifically for these rains — the harvest depended on them. The name literally means \"rain for the grain\".",
  ),
  "rikka": SekkiDescription(
    uk: "Початок літа. Зелень густішає, перші теплі ночі, у горах прокидаються змії. Чай нового збору вже готовий до дегустації.",
    en: "Beginning of summer. Greens deepen, first warm nights arrive, snakes wake in the mountains. The new tea is ready to drink.",
  ),
  "shoman": SekkiDescription(
    uk: "Маленьке достатнє. Рослини «достатньо виросли», але ще не повністю — звідси назва. Шовкопряди починають їсти листя шовковиці.",
    en: "Lesser ripening. Plants have grown \"enough but not fully\" — hence the name. Silkworms begin feeding on mulberry leaves.",
  ),
  "boshu": SekkiDescription(
    uk: "Колосіння. Зернові культури викидають остюки, час сівби тих рослин, що ростуть з остями (рис, ячмінь). Початок сезону дощів.",
    en: "Ear-bearing grain. Cereal crops form awns, and farmers sow rice and barley — plants that grow with bristles. The rainy season begins.",
  ),
  "geshi": SekkiDescription(
    uk: "Літнє сонцестояння. Найдовший день року. У народному календарі — пік життєвої сили природи, після нього сонце повільно йде на спад.",
    en: "Summer solstice. Longest day of the year. In folk tradition this is the peak of nature's vitality — afterward the sun slowly recedes.",
  ),
  "shosho1": SekkiDescription(
    uk: "Малі спеки. Перші справжні гарячі дні — але справжня сильна спека ще попереду. Цикади починають співати.",
    en: "Lesser heat. The first genuinely hot days arrive — but the real summer heat is still ahead. Cicadas begin to sing.",
  ),
  "taisho": SekkiDescription(
    uk: "Великі спеки. Найжаркіший час року. Назва каже сама за себе — друга половина липня в Японії — це випробування.",
    en: "Greater heat. The hottest stretch of the year. The name says it all — late July in Japan is an endurance test.",
  ),
  "risshu": SekkiDescription(
    uk: "Початок осені. За календарем уже осінь, а на вулиці ще +35. Але вечорами вже відчувається перший прохолодний вітер. Цикади змінюють тон.",
    en: "Beginning of autumn. The calendar says autumn, the thermometer says +35°C. But evenings carry the first cool breeze. Cicadas shift their tune.",
  ),
  "shosho2": SekkiDescription(
    uk: "Спадання спеки. Денна спека потроху відступає, ночі стають свіжішими. Час, коли можна знову вийти з кондиціонера.",
    en: "Manageable heat. The daytime heat eases, nights grow cooler. The time you can finally step away from the air conditioner.",
  ),
  "hakuro": SekkiDescription(
    uk: "Білі роси. Ранки прохолодні настільки, що на траві лишається роса. Перший справжній знак того, що осінь — серйозно.",
    en: "White dew. Mornings cool enough that dew settles on grass. The first real sign that autumn is here for real.",
  ),
  "shubun": SekkiDescription(
    uk: "Осіннє рівнодення. День знов дорівнює ночі. Японське національне свято — як і весняне. Час «дзо-меі», поваги до предків.",
    en: "Autumn equinox. Day equals night again. A Japanese national holiday, like the spring one — time for \"higan\", honoring ancestors.",
  ),
  "kanro": SekkiDescription(
    uk: "Холодні роси. Роса на світанку вже майже замерзає. Хризантеми у повному цвіту, листя клена починає жовтіти.",
    en: "Cold dew. The morning dew almost freezes. Chrysanthemums in full bloom; maple leaves start turning.",
  ),
  "soko": SekkiDescription(
    uk: "Іній спадає. Перший іній — у горах і на півночі. Класичний сезон любування момідзі (червоним листям клена).",
    en: "Frost descends. First frost arrives — in the mountains and the north. The classical season for momiji-viewing — the red maple leaves.",
  ),
  "ritto": SekkiDescription(
    uk: "Початок зими. Сонце низько, тіні довгі, перший сніг у горах. Камакура та інші зимові ритуали готуються до сезону.",
    en: "Beginning of winter. Sun low, shadows long, first mountain snow. Kamakura and other winter rituals begin their season.",
  ),
  "shosetsu": SekkiDescription(
    uk: "Малий сніг. Перші снігопади — на півночі вже регулярні, на півдні ще рідкість. Початок сезону хот-поту і саке-токоро.",
    en: "Lesser snow. First snowfalls — regular in the north, still rare in the south. Hot-pot and warm-sake season begins.",
  ),
  "taisetsu": SekkiDescription(
    uk: "Великий сніг. Сніг лежить серйозно, ріки замерзають. Ведмеді залазять у сплячку, мисливці перевіряють ставки.",
    en: "Greater snow. Snow lies in earnest, rivers freeze. Bears retreat to hibernation; fishermen check their traps.",
  ),
  "toji": SekkiDescription(
    uk: "Зимове сонцестояння. Найкоротший день року. Японці традиційно купаються в гарячій ванні з юдзу та їдять гарбуз — для здоров'я.",
    en: "Winter solstice. Shortest day of the year. Japanese tradition calls for a hot bath with yuzu citrus and a meal of pumpkin — for the year's health.",
  ),
  "shokan": SekkiDescription(
    uk: "Малий холод. Перша половина січня. Холод тільки починається, але вже відчувається серйозно. Час традиційних новорічних страв.",
    en: "Lesser cold. The first half of January. The cold is just starting but already serious. Time for traditional New Year's dishes.",
  ),
  "daikan": SekkiDescription(
    uk: "Великий холод. Найхолодніший період року, кінець січня. Назва каже все. Натомість найясніше зоряне небо — для тих, хто витримує мороз.",
    en: "Greater cold. The coldest stretch, late January. The name says it all. The trade-off: the clearest starry skies — if you can stand the freeze.",
  ),
};

SekkiDescription? sekkiDescriptionFor(String id) => sekkiDescriptions[id];
