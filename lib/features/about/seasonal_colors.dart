/// Kasane-no-irome (襲の色目) seasonal colour pairings, one per kō.
///
/// Heian-period court ladies layered translucent silk robes (jūnihitoe,
/// 十二単) with specific colour combinations for specific weeks of the
/// year. The combinations are recorded in classical sources such as
/// Genji Monogatari, Makura no Sōshi, and the Eiga Monogatari, and have
/// been catalogued in modern times by dyers like Yoshioka Sachio.
///
/// Each entry below pairs a kō with a documented kasane combination
/// where one exists, or — for kō that fall between named combinations —
/// extends the system using authentic Japanese colour names from the
/// traditional irodori (色取り) palette so the cycle reads continuously
/// across the full year.
library seasonal_colors;

import 'package:flutter/painting.dart';

/// One named colour in a kasane stack — Japanese name + hex.
class ColorLayer {
  const ColorLayer({
    required this.hex,
    required this.nameJa,
    required this.nameRomaji,
    required this.nameUk,
    required this.nameEn,
  });

  /// Six-digit RGB hex (no `#`), e.g. "C0392B".
  final String hex;

  /// Japanese name in kanji / kana, e.g. "紅", "若苗色".
  final String nameJa;

  /// Hepburn romaji, e.g. "kurenai", "wakanae-iro".
  final String nameRomaji;

  /// Ukrainian name with light gloss, e.g. "Курені (яскраво-багряний)".
  final String nameUk;

  /// English name with gloss, e.g. "Kurenai (deep crimson)".
  final String nameEn;

  /// Returns a Dart [Color] from the hex string.
  Color toColor() => Color(int.parse('FF$hex', radix: 16));
}

/// A kasane combination — a named layered colour scheme for one kō.
class ColorPairing {
  const ColorPairing({
    required this.kasaneJa,
    required this.kasaneRomaji,
    required this.kasaneUk,
    required this.kasaneEn,
    required this.layers,
    required this.noteUk,
    required this.noteEn,
  });

  /// Kasane name in Japanese, e.g. "桜重ね", "氷襲".
  final String kasaneJa;

  /// Hepburn romaji, e.g. "sakura-gasane".
  final String kasaneRomaji;

  /// Ukrainian gloss, e.g. "Сакура-ґасане (вишневий шар)".
  final String kasaneUk;

  /// English gloss, e.g. "Sakura-gasane (cherry-blossom layering)".
  final String kasaneEn;

  /// Two or three [ColorLayer]s, ordered from outer (top) to inner (lining).
  final List<ColorLayer> layers;

  /// Why this combination for this kō — quietly poetic, 1–2 sentences.
  final String noteUk;

  /// English version of [noteUk].
  final String noteEn;
}

const Map<int, ColorPairing> seasonalColors = {
  // ─── Spring ───
  1: ColorPairing(
    kasaneJa: "雪の下",
    kasaneRomaji: "yuki-no-shita",
    kasaneUk: "Юкі-но-сіта (під снігом)",
    kasaneEn: "Yuki-no-shita (beneath the snow)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (сніжно-білий)",
        nameEn: "Yukijiro (snow white)",
      ),
      ColorLayer(
        hex: "C3272B",
        nameJa: "紅",
        nameRomaji: "kurenai",
        nameUk: "Куренай (глибокий багряний)",
        nameEn: "Kurenai (deep crimson)",
      ),
    ],
    noteUk: "Білий шовк зверху, темно-багряний знизу — снігова шапка на сливі, що цвіте, попри мороз східного вітру.",
    noteEn: "White silk over deep crimson — a cap of snow on the plum bough that blooms in spite of the east-wind frost.",
  ),
  2: ColorPairing(
    kasaneJa: "鴬",
    kasaneRomaji: "uguisu",
    kasaneUk: "Уґуїсу (солов'їний)",
    kasaneEn: "Uguisu (bush-warbler)",
    layers: [
      ColorLayer(
        hex: "6E7E54",
        nameJa: "海松",
        nameRomaji: "miru",
        nameUk: "Міру (морська сосна)",
        nameEn: "Miru (sea-pine olive)",
      ),
      ColorLayer(
        hex: "B96456",
        nameJa: "朽葉",
        nameRomaji: "kuchiba",
        nameUk: "Кутіба (зів'яле листя)",
        nameEn: "Kuchiba (decayed-leaf brown)",
      ),
    ],
    noteUk: "Олива зверху, жухлий лист під нею — оперення солов'я, що повертається співати на ще голу сливу.",
    noteEn: "Olive over fallen-leaf brown — the plumage of the warbler returning to sing on the still-bare plum.",
  ),
  3: ColorPairing(
    kasaneJa: "紅梅",
    kasaneRomaji: "kōbai",
    kasaneUk: "Кобай (червона слива)",
    kasaneEn: "Kōbai (red plum)",
    layers: [
      ColorLayer(
        hex: "F08F90",
        nameJa: "一斤染",
        nameRomaji: "ikkonzome",
        nameUk: "Іккондзоме (рожевий, фарбований шафраном)",
        nameEn: "Ikkonzome (pink dyed with safflower)",
      ),
      ColorLayer(
        hex: "C3272B",
        nameJa: "紅",
        nameRomaji: "kurenai",
        nameUk: "Куренай (глибокий багряний)",
        nameEn: "Kurenai (deep crimson)",
      ),
    ],
    noteUk: "Світло-рожевий шар над темно-багряним — пелюстки червоної сливи, в яких ховається крига талого струмка.",
    noteEn: "Pale pink over deep crimson — petals of the red plum opening above the thin ice as the fish stir beneath.",
  ),
  4: ColorPairing(
    kasaneJa: "雨重ね",
    kasaneRomaji: "ame-gasane",
    kasaneUk: "Аме-ґасане (дощовий шар)",
    kasaneEn: "Ame-gasane (rain layering)",
    layers: [
      ColorLayer(
        hex: "80AAB3",
        nameJa: "水浅葱",
        nameRomaji: "mizu-asagi",
        nameUk: "Мідзу-асаґі (водяна блакить)",
        nameEn: "Mizu-asagi (water-blue-green)",
      ),
      ColorLayer(
        hex: "6E7E54",
        nameJa: "海松",
        nameRomaji: "miru",
        nameUk: "Міру (морська сосна)",
        nameEn: "Miru (sea-pine olive)",
      ),
    ],
    noteUk: "Водяна блакить зверху, олива внизу — перший весняний дощ просочує темну, ще сонну землю.",
    noteEn: "Water-blue over olive — the first spring rain soaking into earth that is still half asleep.",
  ),
  5: ColorPairing(
    kasaneJa: "柳",
    kasaneRomaji: "yanagi",
    kasaneUk: "Янаґі (верба)",
    kasaneEn: "Yanagi (willow)",
    layers: [
      ColorLayer(
        hex: "C7DC68",
        nameJa: "若苗",
        nameRomaji: "wakanae",
        nameUk: "Ваканае (молодий рисовий паросток)",
        nameEn: "Wakanae (young-rice green)",
      ),
      ColorLayer(
        hex: "316745",
        nameJa: "千歳緑",
        nameRomaji: "chitose-midori",
        nameUk: "Чітосе-мідорі (тисячолітня зелень)",
        nameEn: "Chitose-midori (thousand-year green)",
      ),
    ],
    noteUk: "Блідий паросток зверху, темна вічна зелень знизу — гілки верби, що проступають крізь весняну імлу.",
    noteEn: "Pale shoot over evergreen — willow branches showing through the spring mist that begins to linger.",
  ),
  6: ColorPairing(
    kasaneJa: "萌黄",
    kasaneRomaji: "moegi",
    kasaneUk: "Моеґі (брунька)",
    kasaneEn: "Moegi (fresh bud)",
    layers: [
      ColorLayer(
        hex: "5DAC81",
        nameJa: "萌黄",
        nameRomaji: "moegi",
        nameUk: "Моеґі (зелень брунькування)",
        nameEn: "Moegi (fresh-bud green)",
      ),
      ColorLayer(
        hex: "F6BD2C",
        nameJa: "山吹",
        nameRomaji: "yamabuki",
        nameUk: "Ямабукі (золотисто-жовтий)",
        nameEn: "Yamabuki (golden yellow)",
      ),
    ],
    noteUk: "Свіжа зелень над теплим жовтком — трава пробивається, дерева наливаються бруньками одночасно.",
    noteEn: "Fresh green over warm yolk — grass and tree-buds quickening together in the same hour.",
  ),
  7: ColorPairing(
    kasaneJa: "若萌",
    kasaneRomaji: "waka-moe",
    kasaneUk: "Вака-мое (юна брунька)",
    kasaneEn: "Waka-moe (young bud)",
    layers: [
      ColorLayer(
        hex: "91AD70",
        nameJa: "鶸萌黄",
        nameRomaji: "hiwa-moegi",
        nameUk: "Хіва-моеґі (зелень синиці)",
        nameEn: "Hiwa-moegi (siskin-green)",
      ),
      ColorLayer(
        hex: "C7DC68",
        nameJa: "若苗",
        nameRomaji: "wakanae",
        nameUk: "Ваканае (молода розсада)",
        nameEn: "Wakanae (young-rice green)",
      ),
    ],
    noteUk: "Темніша молода зелень над світлішою — комахи виповзають із землі, що нарешті розм'якшилась.",
    noteEn: "Deeper young-green over a paler one — insects climbing from soil that has at last grown soft.",
  ),
  8: ColorPairing(
    kasaneJa: "桃",
    kasaneRomaji: "momo",
    kasaneUk: "Момо (персик)",
    kasaneEn: "Momo (peach)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
      ColorLayer(
        hex: "F596AA",
        nameJa: "桃色",
        nameRomaji: "momoiro",
        nameUk: "Момоїро (персиковий рожевий)",
        nameEn: "Momoiro (peach pink)",
      ),
    ],
    noteUk: "Білий шовк над персиковим — перші пелюстки персика розкриваються, начебто всміхаючись до сонця.",
    noteEn: "White over peach-pink — the first peach blossoms part their lips as if smiling at the new sun.",
  ),
  9: ColorPairing(
    kasaneJa: "蝶重ね",
    kasaneRomaji: "chō-gasane",
    kasaneUk: "Чо-ґасане (метелик)",
    kasaneEn: "Chō-gasane (butterfly)",
    layers: [
      ColorLayer(
        hex: "BDA9CA",
        nameJa: "若紫",
        nameRomaji: "waka-murasaki",
        nameUk: "Вака-мурасакі (юний пурпур)",
        nameEn: "Waka-murasaki (young purple)",
      ),
      ColorLayer(
        hex: "C7DC68",
        nameJa: "若苗",
        nameRomaji: "wakanae",
        nameUk: "Ваканае (молодий паросток)",
        nameEn: "Wakanae (young-rice green)",
      ),
    ],
    noteUk: "Юний пурпур над молодою зеленню — крила метелика, який щойно скинув гусеничну броню над молодим листом.",
    noteEn: "Young purple over young-rice green — the wings of the butterfly newly unfurled above the leaf it has just left.",
  ),
  10: ColorPairing(
    kasaneJa: "山吹",
    kasaneRomaji: "yamabuki",
    kasaneUk: "Ямабукі (керія японська)",
    kasaneEn: "Yamabuki (Japanese rose)",
    layers: [
      ColorLayer(
        hex: "F6BD2C",
        nameJa: "山吹",
        nameRomaji: "yamabuki",
        nameUk: "Ямабукі (золотисто-жовтий)",
        nameEn: "Yamabuki (golden yellow)",
      ),
      ColorLayer(
        hex: "D7B45C",
        nameJa: "黄朽葉",
        nameRomaji: "ki-kuchiba",
        nameUk: "Кі-кутіба (золотисте сухе листя)",
        nameEn: "Ki-kuchiba (golden decayed-leaf)",
      ),
    ],
    noteUk: "Яскраво-жовте над золотавою охрою — горобці носять у дзьобах суху траву й перші золоті пелюстки керії.",
    noteEn: "Bright yellow over golden ochre — sparrows weaving dry grass and the first yamabuki petals into their nests.",
  ),
  11: ColorPairing(
    kasaneJa: "桜重ね",
    kasaneRomaji: "sakura-gasane",
    kasaneUk: "Сакура-ґасане (шар сакури)",
    kasaneEn: "Sakura-gasane (cherry-blossom layering)",
    layers: [
      ColorLayer(
        hex: "FFFFFF",
        nameJa: "白",
        nameRomaji: "shiro",
        nameUk: "Сіро (білий)",
        nameEn: "Shiro (white)",
      ),
      ColorLayer(
        hex: "FCC9B9",
        nameJa: "桜色",
        nameRomaji: "sakura-iro",
        nameUk: "Сакура-іро (колір вишневого цвіту)",
        nameEn: "Sakura-iro (cherry-blossom pink)",
      ),
      ColorLayer(
        hex: "F08F90",
        nameJa: "一斤染",
        nameRomaji: "ikkonzome",
        nameUk: "Іккондзоме (рожевий, фарбований шафраном)",
        nameEn: "Ikkonzome (pink dyed with safflower)",
      ),
    ],
    noteUk: "Білий шовк зверху, рожеві пелюстки під ним, відлунок шафрану в підкладці — кімоно, в якому тіло прозирає крізь падаючі пелюстки.",
    noteEn: "White silk on top, petal-pink beneath, a flush of safflower at the lining — a robe through which the body shows like a body amid falling petals.",
  ),
  12: ColorPairing(
    kasaneJa: "雷重ね",
    kasaneRomaji: "kaminari-gasane",
    kasaneUk: "Камінарі-ґасане (грім)",
    kasaneEn: "Kaminari-gasane (thunder)",
    layers: [
      ColorLayer(
        hex: "594255",
        nameJa: "滅紫",
        nameRomaji: "kechi-murasaki",
        nameUk: "Кеті-мурасакі (приглушений пурпур)",
        nameEn: "Kechi-murasaki (faded purple)",
      ),
      ColorLayer(
        hex: "FCD53F",
        nameJa: "玉子色",
        nameRomaji: "tamago-iro",
        nameUk: "Тамаґо-іро (яєчно-жовтий)",
        nameEn: "Tamago-iro (egg-yolk yellow)",
      ),
    ],
    noteUk: "Приглушений пурпур над яєчним жовтком — далека грозова хмара і блискавка, яка її ще не розкрила.",
    noteEn: "Muted purple over egg-yolk — a far thundercloud, the lightning held still inside it like a folded sheet.",
  ),
  13: ColorPairing(
    kasaneJa: "燕重ね",
    kasaneRomaji: "tsubame-gasane",
    kasaneUk: "Цубаме-ґасане (ластівка)",
    kasaneEn: "Tsubame-gasane (swallow)",
    layers: [
      ColorLayer(
        hex: "211711",
        nameJa: "真っ黒",
        nameRomaji: "makkurō",
        nameUk: "Маккуро (вугільно-чорний)",
        nameEn: "Makkurō (jet black)",
      ),
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
    ],
    noteUk: "Чорний як спина ластівки, білий як її груди — повернення птаха, який перетинає двір блискавкою.",
    noteEn: "Black like the swallow's back, white like its breast — the bird returning, crossing the courtyard like a low flash.",
  ),
  14: ColorPairing(
    kasaneJa: "雁帰り",
    kasaneRomaji: "kari-gaeri",
    kasaneUk: "Карі-ґаері (повернення гусей)",
    kasaneEn: "Kari-gaeri (geese turning home)",
    layers: [
      ColorLayer(
        hex: "999999",
        nameJa: "鼠",
        nameRomaji: "nezumi",
        nameUk: "Незумі (мишачо-сірий)",
        nameEn: "Nezumi (mouse-grey)",
      ),
      ColorLayer(
        hex: "76B5DE",
        nameJa: "空色",
        nameRomaji: "sora-iro",
        nameUk: "Сора-іро (небесний)",
        nameEn: "Sora-iro (sky blue)",
      ),
    ],
    noteUk: "Сірий шар над небесною блакиттю — клин диких гусей, що тягнеться на північ через спокійне ранкове небо.",
    noteEn: "Grey over sky-blue — the wedge of wild geese drawn north across the quiet morning.",
  ),
  15: ColorPairing(
    kasaneJa: "虹重ね",
    kasaneRomaji: "niji-gasane",
    kasaneUk: "Нідзі-ґасане (веселка)",
    kasaneEn: "Niji-gasane (rainbow)",
    layers: [
      ColorLayer(
        hex: "76B5DE",
        nameJa: "空色",
        nameRomaji: "sora-iro",
        nameUk: "Сора-іро (небесний)",
        nameEn: "Sora-iro (sky blue)",
      ),
      ColorLayer(
        hex: "F596AA",
        nameJa: "桃色",
        nameRomaji: "momoiro",
        nameUk: "Момоїро (персиковий)",
        nameEn: "Momoiro (peach pink)",
      ),
    ],
    noteUk: "Небо зверху, рожевий відсвіт знизу — перша весняна веселка, тонка ниточка над свіжо вмитим садом.",
    noteEn: "Sky over peach-pink — the first spring rainbow, a thin thread laid over the freshly washed garden.",
  ),
  16: ColorPairing(
    kasaneJa: "葭萌え",
    kasaneRomaji: "ashi-moe",
    kasaneUk: "Асі-мое (паросток очерету)",
    kasaneEn: "Ashi-moe (reed-shoot)",
    layers: [
      ColorLayer(
        hex: "5DAC81",
        nameJa: "萌黄",
        nameRomaji: "moegi",
        nameUk: "Моеґі (бруньковий зелений)",
        nameEn: "Moegi (fresh-bud green)",
      ),
      ColorLayer(
        hex: "80AAB3",
        nameJa: "水浅葱",
        nameRomaji: "mizu-asagi",
        nameUk: "Мідзу-асаґі (водяний)",
        nameEn: "Mizu-asagi (water-blue-green)",
      ),
    ],
    noteUk: "Бруньковий зелений над водяним кольором — перші паростки очерету пробивають дзеркало мілководдя.",
    noteEn: "Bud-green over water-blue — the first reeds pushing through the mirror of the shallow pond.",
  ),
  17: ColorPairing(
    kasaneJa: "藤",
    kasaneRomaji: "fuji",
    kasaneUk: "Фудзі (гліцинія)",
    kasaneEn: "Fuji (wisteria)",
    layers: [
      ColorLayer(
        hex: "BDA9CA",
        nameJa: "若紫",
        nameRomaji: "waka-murasaki",
        nameUk: "Вака-мурасакі (юний пурпур)",
        nameEn: "Waka-murasaki (young purple)",
      ),
      ColorLayer(
        hex: "6E417C",
        nameJa: "紫",
        nameRomaji: "murasaki",
        nameUk: "Мурасакі (глибокий пурпур)",
        nameEn: "Murasaki (deep purple)",
      ),
    ],
    noteUk: "Світла лаванда над глибоким пурпуром — гліцинія звисає над останнім нічним приморозком, який покидає поле.",
    noteEn: "Pale lavender over deep purple — wisteria hanging over the last frost as it slips off the rice field.",
  ),
  18: ColorPairing(
    kasaneJa: "牡丹",
    kasaneRomaji: "botan",
    kasaneUk: "Ботан (півонія)",
    kasaneEn: "Botan (peony)",
    layers: [
      ColorLayer(
        hex: "A8497A",
        nameJa: "牡丹",
        nameRomaji: "botan",
        nameUk: "Ботан (півоніє-рожевий)",
        nameEn: "Botan (peony rose)",
      ),
      ColorLayer(
        hex: "C3272B",
        nameJa: "紅",
        nameRomaji: "kurenai",
        nameUk: "Куренай (багряний)",
        nameEn: "Kurenai (deep crimson)",
      ),
      ColorLayer(
        hex: "5DAC81",
        nameJa: "萌黄",
        nameRomaji: "moegi",
        nameUk: "Моеґі (зелень брунькування)",
        nameEn: "Moegi (fresh-bud green)",
      ),
    ],
    noteUk: "Півоніє-рожевий, темно-багряний і зелень — півонія розкривається важкою короною на тлі молодого листя.",
    noteEn: "Peony rose, crimson, and fresh-bud green — the heavy crown of the peony opening above the new leaves.",
  ),

  // ─── Summer ───
  19: ColorPairing(
    kasaneJa: "卯花",
    kasaneRomaji: "unohana",
    kasaneUk: "Унохана (квітка дейції)",
    kasaneEn: "Unohana (deutzia flower)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
      ColorLayer(
        hex: "91AD70",
        nameJa: "鶸萌黄",
        nameRomaji: "hiwa-moegi",
        nameUk: "Хіва-моеґі (зелень синиці)",
        nameEn: "Hiwa-moegi (siskin-green)",
      ),
    ],
    noteUk: "Білі грона дейції зверху, тепла зелень знизу — жаби починають співати в живоплоті, що цвіте.",
    noteEn: "White deutzia clusters over warm green — frogs starting to sing inside the hedge that has come into flower.",
  ),
  20: ColorPairing(
    kasaneJa: "卯重ね",
    kasaneRomaji: "u-gasane",
    kasaneUk: "У-ґасане (шар дейції)",
    kasaneEn: "U-gasane (deutzia layering)",
    layers: [
      ColorLayer(
        hex: "FFFFFF",
        nameJa: "白",
        nameRomaji: "shiro",
        nameUk: "Сіро (білий)",
        nameEn: "Shiro (white)",
      ),
      ColorLayer(
        hex: "586E48",
        nameJa: "松葉色",
        nameRomaji: "matsuba-iro",
        nameUk: "Мацуба-іро (соснова хвоя)",
        nameEn: "Matsuba-iro (pine-needle green)",
      ),
    ],
    noteUk: "Білий поверх темно-зеленого — паркі дощі, в яких черв'яки виходять на світло вологих стежок.",
    noteEn: "White over pine-needle green — the muggy rains that bring earthworms up onto the wet paths.",
  ),
  21: ColorPairing(
    kasaneJa: "竹重ね",
    kasaneRomaji: "take-gasane",
    kasaneUk: "Таке-ґасане (бамбук)",
    kasaneEn: "Take-gasane (bamboo)",
    layers: [
      ColorLayer(
        hex: "768D77",
        nameJa: "老竹",
        nameRomaji: "oitake",
        nameUk: "Ойтаке (старий бамбук)",
        nameEn: "Oitake (aged bamboo)",
      ),
      ColorLayer(
        hex: "C3D825",
        nameJa: "若草",
        nameRomaji: "wakakusa",
        nameUk: "Вакакуса (молода трава)",
        nameEn: "Wakakusa (young grass)",
      ),
    ],
    noteUk: "Старий бамбук над молодою травою — пагони бамбуку прориваються крізь землю поряд із материнським гаєм.",
    noteEn: "Aged bamboo over young-grass green — bamboo shoots breaking through the earth beside the mother grove.",
  ),
  22: ColorPairing(
    kasaneJa: "蚕重ね",
    kasaneRomaji: "kaiko-gasane",
    kasaneUk: "Кайко-ґасане (шовкопряд)",
    kasaneEn: "Kaiko-gasane (silkworm)",
    layers: [
      ColorLayer(
        hex: "E8C19D",
        nameJa: "砥粉色",
        nameRomaji: "tonoko-iro",
        nameUk: "Тоноко-іро (точильний камінь)",
        nameEn: "Tonoko-iro (whetstone tan)",
      ),
      ColorLayer(
        hex: "5DAC81",
        nameJa: "萌黄",
        nameRomaji: "moegi",
        nameUk: "Моеґі (бруньковий зелений)",
        nameEn: "Moegi (fresh-bud green)",
      ),
    ],
    noteUk: "Тепла кремова барва над зеленим — шовкопряди гризуть листя шовковиці, готуючи майбутній кокон.",
    noteEn: "Warm cream over fresh green — silkworms quietly chewing the mulberry leaves that will become their thread.",
  ),
  23: ColorPairing(
    kasaneJa: "紅花",
    kasaneRomaji: "benibana",
    kasaneUk: "Бенібана (сафлор)",
    kasaneEn: "Benibana (safflower)",
    layers: [
      ColorLayer(
        hex: "DC3023",
        nameJa: "朱",
        nameRomaji: "shu",
        nameUk: "Сю (кіноварний червоний)",
        nameEn: "Shu (vermilion)",
      ),
      ColorLayer(
        hex: "F6BD2C",
        nameJa: "山吹",
        nameRomaji: "yamabuki",
        nameUk: "Ямабукі (жовтий)",
        nameEn: "Yamabuki (golden yellow)",
      ),
    ],
    noteUk: "Кіновар зверху, золотавий жовток знизу — поле сафлору, де червоне і жовте збираються у мотузці фарби.",
    noteEn: "Vermilion over golden yellow — a field of safflower, where red and yellow are gathered into a single dye.",
  ),
  24: ColorPairing(
    kasaneJa: "麦秋",
    kasaneRomaji: "bakushū",
    kasaneUk: "Бакусю (пшенична осінь)",
    kasaneEn: "Bakushū (wheat autumn)",
    layers: [
      ColorLayer(
        hex: "DBB94C",
        nameJa: "鬱金",
        nameRomaji: "ukon",
        nameUk: "Укон (куркума)",
        nameEn: "Ukon (turmeric)",
      ),
      ColorLayer(
        hex: "C7B79E",
        nameJa: "白茶",
        nameRomaji: "shiracha",
        nameUk: "Сіратя (білий чай)",
        nameEn: "Shiracha (white-tea brown)",
      ),
    ],
    noteUk: "Куркумовий жовтий над тьмяно-чайним — пшениця жовтіє, наче в полі настала маленька осінь посеред літа.",
    noteEn: "Turmeric yellow over white-tea — the wheat ripening as if a small autumn had arrived in the middle of summer.",
  ),
  25: ColorPairing(
    kasaneJa: "蟷螂重ね",
    kasaneRomaji: "tōrō-gasane",
    kasaneUk: "Торо-ґасане (богомол)",
    kasaneEn: "Tōrō-gasane (mantis)",
    layers: [
      ColorLayer(
        hex: "C3D825",
        nameJa: "若草",
        nameRomaji: "wakakusa",
        nameUk: "Вакакуса (молода трава)",
        nameEn: "Wakakusa (young grass)",
      ),
      ColorLayer(
        hex: "2D6D4B",
        nameJa: "木賊",
        nameRomaji: "tokusa",
        nameUk: "Токуса (хвощ)",
        nameEn: "Tokusa (scouring-rush green)",
      ),
    ],
    noteUk: "Молода трава над темним хвощем — щойно виплодилися богомоли, тонкі як стебельця, в гущавині літа.",
    noteEn: "Young grass over dark scouring-rush — newly hatched mantises, thin as stems, hidden in the thickness of summer.",
  ),
  26: ColorPairing(
    kasaneJa: "蛍重ね",
    kasaneRomaji: "hotaru-gasane",
    kasaneUk: "Хотару-ґасане (світлячок)",
    kasaneEn: "Hotaru-gasane (firefly)",
    layers: [
      ColorLayer(
        hex: "0D0015",
        nameJa: "漆黒",
        nameRomaji: "shikkoku",
        nameUk: "Сіккоку (лаковий чорний)",
        nameEn: "Shikkoku (lacquer black)",
      ),
      ColorLayer(
        hex: "C7DC68",
        nameJa: "若苗",
        nameRomaji: "wakanae",
        nameUk: "Ваканае (молодий паросток)",
        nameEn: "Wakanae (young-rice green)",
      ),
    ],
    noteUk: "Лаковий чорний зовні, бліде зелене світіння всередині — світлячки спалахують над болотом у червневій ночі.",
    noteEn: "Lacquer black over a pale green glow — fireflies sparking above the marsh in the depth of the June night.",
  ),
  27: ColorPairing(
    kasaneJa: "梅子",
    kasaneRomaji: "umemi",
    kasaneUk: "Умемі (жовта слива)",
    kasaneEn: "Umemi (yellow plum)",
    layers: [
      ColorLayer(
        hex: "FCD53F",
        nameJa: "玉子色",
        nameRomaji: "tamago-iro",
        nameUk: "Тамаґо-іро (яєчно-жовтий)",
        nameEn: "Tamago-iro (egg-yolk yellow)",
      ),
      ColorLayer(
        hex: "586E48",
        nameJa: "松葉色",
        nameRomaji: "matsuba-iro",
        nameUk: "Мацуба-іро (соснова хвоя)",
        nameEn: "Matsuba-iro (pine-needle green)",
      ),
    ],
    noteUk: "Жовток зверху, темна хвоя знизу — плоди сливи наливаються золотом серед глянцевого літнього листя.",
    noteEn: "Egg-yolk over pine-needle green — plum fruits ripening to gold within the glossy summer foliage.",
  ),
  28: ColorPairing(
    kasaneJa: "夏枯",
    kasaneRomaji: "natsu-gare",
    kasaneUk: "Нацу-ґаре (літнє в'янення)",
    kasaneEn: "Natsu-gare (summer-wither)",
    layers: [
      ColorLayer(
        hex: "897F62",
        nameJa: "利休茶",
        nameRomaji: "rikyū-cha",
        nameUk: "Рікю-тя (чайний колір Рікю)",
        nameEn: "Rikyū-cha (Rikyū tea-brown)",
      ),
      ColorLayer(
        hex: "5DAC81",
        nameJa: "萌黄",
        nameRomaji: "moegi",
        nameUk: "Моеґі (бруньковий зелений)",
        nameEn: "Moegi (fresh-bud green)",
      ),
    ],
    noteUk: "Чайно-сіро-зелений над бруньковою зеленню — суховершки сушаться, тоді як решта саду все ще співає літом.",
    noteEn: "Tea-brown over fresh green — self-heal already drying while the rest of the garden still hums with summer.",
  ),
  29: ColorPairing(
    kasaneJa: "杜若",
    kasaneRomaji: "kakitsubata",
    kasaneUk: "Какіцубата (ірис водяний)",
    kasaneEn: "Kakitsubata (water iris)",
    layers: [
      ColorLayer(
        hex: "FFFFFF",
        nameJa: "白",
        nameRomaji: "shiro",
        nameUk: "Сіро (білий)",
        nameEn: "Shiro (white)",
      ),
      ColorLayer(
        hex: "745399",
        nameJa: "江戸紫",
        nameRomaji: "edo-murasaki",
        nameUk: "Едо-мурасакі (едо-пурпур)",
        nameEn: "Edo-murasaki (Edo purple)",
      ),
    ],
    noteUk: "Білий шовк над глибоким пурпуром — водяні іриси стоять рівними рядами, як гості у церемонійному залі.",
    noteEn: "White over deep purple — water irises standing in even rows like guests at a formal hall.",
  ),
  30: ColorPairing(
    kasaneJa: "半夏",
    kasaneRomaji: "hange",
    kasaneUk: "Ханґе (півліта)",
    kasaneEn: "Hange (mid-summer herb)",
    layers: [
      ColorLayer(
        hex: "D2D352",
        nameJa: "鶸",
        nameRomaji: "hiwa",
        nameUk: "Хіва (синичо-жовтий)",
        nameEn: "Hiwa (siskin yellow-green)",
      ),
      ColorLayer(
        hex: "2D6D4B",
        nameJa: "木賊",
        nameRomaji: "tokusa",
        nameUk: "Токуса (хвощ)",
        nameEn: "Tokusa (scouring-rush green)",
      ),
    ],
    noteUk: "Синичо-жовтий над темним хвощем — тінь лісу густішає, а на узліссі цвіте однопелюсткова пінелія.",
    noteEn: "Siskin-yellow over scouring-rush — the forest shadow thickening as crow-dipper opens at its edge.",
  ),
  31: ColorPairing(
    kasaneJa: "風重ね",
    kasaneRomaji: "kaze-gasane",
    kasaneUk: "Кадзе-ґасане (шар вітру)",
    kasaneEn: "Kaze-gasane (wind layering)",
    layers: [
      ColorLayer(
        hex: "76B5DE",
        nameJa: "空色",
        nameRomaji: "sora-iro",
        nameUk: "Сора-іро (небесний)",
        nameEn: "Sora-iro (sky blue)",
      ),
      ColorLayer(
        hex: "F596AA",
        nameJa: "桃色",
        nameRomaji: "momoiro",
        nameUk: "Момоїро (персиковий)",
        nameEn: "Momoiro (peach pink)",
      ),
    ],
    noteUk: "Небо над персиковим — теплий вітер вночі Танабати несе папірці бажань поміж бамбуковими гілками.",
    noteEn: "Sky-blue over peach-pink — the warm Tanabata wind carrying paper wishes between the bamboo branches.",
  ),
  32: ColorPairing(
    kasaneJa: "蓮",
    kasaneRomaji: "hasu",
    kasaneUk: "Хасу (лотос)",
    kasaneEn: "Hasu (lotus)",
    layers: [
      ColorLayer(
        hex: "FCC9B9",
        nameJa: "桜色",
        nameRomaji: "sakura-iro",
        nameUk: "Сакура-іро (рожевий)",
        nameEn: "Sakura-iro (cherry-blossom pink)",
      ),
      ColorLayer(
        hex: "316745",
        nameJa: "千歳緑",
        nameRomaji: "chitose-midori",
        nameUk: "Чітосе-мідорі (тисячолітня зелень)",
        nameEn: "Chitose-midori (thousand-year green)",
      ),
    ],
    noteUk: "Рожева пелюстка над темним зеленим — лотос підіймає голову над листям, що лежить колом на ставку.",
    noteEn: "Petal-pink over deep green — lotus lifting its head above the wide leaves that ring the pond.",
  ),
  33: ColorPairing(
    kasaneJa: "鷹重ね",
    kasaneRomaji: "taka-gasane",
    kasaneUk: "Така-ґасане (яструб)",
    kasaneEn: "Taka-gasane (hawk)",
    layers: [
      ColorLayer(
        hex: "B96456",
        nameJa: "朽葉",
        nameRomaji: "kuchiba",
        nameUk: "Кутіба (зів'яле листя)",
        nameEn: "Kuchiba (decayed-leaf brown)",
      ),
      ColorLayer(
        hex: "76B5DE",
        nameJa: "空色",
        nameRomaji: "sora-iro",
        nameUk: "Сора-іро (небесний)",
        nameEn: "Sora-iro (sky blue)",
      ),
    ],
    noteUk: "Брунатний зверху, небесний знизу — молодий яструб тренується падати на здобич з порожнього літнього неба.",
    noteEn: "Hawk-brown over sky-blue — the young hawk learning to stoop from the empty height of the summer sky.",
  ),
  34: ColorPairing(
    kasaneJa: "桐",
    kasaneRomaji: "kiri",
    kasaneUk: "Кірі (павловнія)",
    kasaneEn: "Kiri (paulownia)",
    layers: [
      ColorLayer(
        hex: "BDA9CA",
        nameJa: "若紫",
        nameRomaji: "waka-murasaki",
        nameUk: "Вака-мурасакі (юний пурпур)",
        nameEn: "Waka-murasaki (young purple)",
      ),
      ColorLayer(
        hex: "768D77",
        nameJa: "老竹",
        nameRomaji: "oitake",
        nameUk: "Ойтаке (старий бамбук)",
        nameEn: "Oitake (aged bamboo)",
      ),
    ],
    noteUk: "Юний пурпур над приглушеним бамбуковим — на павловнії дозрівають насінини, тверді й сухі.",
    noteEn: "Young purple over aged bamboo — paulownia setting seed, the pods turning hard and dry on the bough.",
  ),
  35: ColorPairing(
    kasaneJa: "撫子",
    kasaneRomaji: "nadeshiko",
    kasaneUk: "Надесіко (гвоздика)",
    kasaneEn: "Nadeshiko (pink dianthus)",
    layers: [
      ColorLayer(
        hex: "DC9FB4",
        nameJa: "撫子色",
        nameRomaji: "nadeshiko-iro",
        nameUk: "Надесіко-іро (рожевий гвоздики)",
        nameEn: "Nadeshiko-iro (dianthus pink)",
      ),
      ColorLayer(
        hex: "973C3F",
        nameJa: "蘇芳",
        nameRomaji: "suō",
        nameUk: "Суо (червоно-брунатний)",
        nameEn: "Suō (sappanwood red-brown)",
      ),
    ],
    noteUk: "М'який рожевий над темно-багряним — гвоздика стоїть у задушливій спеці, тримаючи серце в прохолоді кореня.",
    noteEn: "Soft pink over dark sappan-red — dianthus standing in the heavy heat, its heart kept cool in the root.",
  ),
  36: ColorPairing(
    kasaneJa: "朝顔",
    kasaneRomaji: "asagao",
    kasaneUk: "Асаґао (повитиця)",
    kasaneEn: "Asagao (morning glory)",
    layers: [
      ColorLayer(
        hex: "1E4D71",
        nameJa: "藍",
        nameRomaji: "ai",
        nameUk: "Ай (індиго)",
        nameEn: "Ai (indigo)",
      ),
      ColorLayer(
        hex: "76B5DE",
        nameJa: "空色",
        nameRomaji: "sora-iro",
        nameUk: "Сора-іро (небесний)",
        nameEn: "Sora-iro (sky blue)",
      ),
    ],
    noteUk: "Індиго над небом — повитиця відкриває темно-сині венчики, поки злива щойно стихла й парує з даху.",
    noteEn: "Indigo over sky-blue — morning glories opening their dark trumpets as the rain steam lifts off the roof.",
  ),
  37: ColorPairing(
    kasaneJa: "涼風",
    kasaneRomaji: "suzukaze",
    kasaneUk: "Судзукадзе (прохолодний вітер)",
    kasaneEn: "Suzukaze (cool wind)",
    layers: [
      ColorLayer(
        hex: "00A3AF",
        nameJa: "浅葱",
        nameRomaji: "asagi",
        nameUk: "Асаґі (бліда цибулева блакить)",
        nameEn: "Asagi (pale spring-onion blue)",
      ),
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
    ],
    noteUk: "Бліда цибулева блакить над білим — між дощів пробивається перший прохолодний вітер раннього серпня.",
    noteEn: "Pale spring-onion blue over white — the first cool wind slipping in between the heavy August showers.",
  ),

  // ─── Autumn ───
  38: ColorPairing(
    kasaneJa: "蝉重ね",
    kasaneRomaji: "semi-gasane",
    kasaneUk: "Семі-ґасане (цикада)",
    kasaneEn: "Semi-gasane (cicada)",
    layers: [
      ColorLayer(
        hex: "514B59",
        nameJa: "似せ紫",
        nameRomaji: "nise-murasaki",
        nameUk: "Нісе-мурасакі (псевдопурпур)",
        nameEn: "Nise-murasaki (pseudo-purple)",
      ),
      ColorLayer(
        hex: "897F62",
        nameJa: "利休茶",
        nameRomaji: "rikyū-cha",
        nameUk: "Рікю-тя (чайно-сірий)",
        nameEn: "Rikyū-cha (Rikyū tea-brown)",
      ),
    ],
    noteUk: "Притлумлений пурпур над тьмяним чайним — крик вечірньої цикади тоншає у сутінках кінця серпня.",
    noteEn: "Smoke-purple over Rikyū tea — the evening cicada's voice thinning in the late-summer dusk.",
  ),
  39: ColorPairing(
    kasaneJa: "霧重ね",
    kasaneRomaji: "kiri-gasane",
    kasaneUk: "Кірі-ґасане (туман)",
    kasaneEn: "Kiri-gasane (fog layering)",
    layers: [
      ColorLayer(
        hex: "AFAFAF",
        nameJa: "銀鼠",
        nameRomaji: "gin-nezu",
        nameUk: "Ґін-незу (срібно-мишачий)",
        nameEn: "Gin-nezu (silver-grey)",
      ),
      ColorLayer(
        hex: "888E7E",
        nameJa: "利休鼠",
        nameRomaji: "rikyū-nezu",
        nameUk: "Рікю-незу (зеленувато-сірий)",
        nameEn: "Rikyū-nezu (Rikyū grey)",
      ),
    ],
    noteUk: "Срібно-сірий над зеленуватим попелом — густий ранковий туман затоплює долину аж до вершків кедрів.",
    noteEn: "Silver-grey over Rikyū grey — heavy morning fog rising up the valley to the tops of the cedars.",
  ),
  40: ColorPairing(
    kasaneJa: "綿重ね",
    kasaneRomaji: "wata-gasane",
    kasaneUk: "Вата-ґасане (бавовна)",
    kasaneEn: "Wata-gasane (cotton)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
      ColorLayer(
        hex: "C7B79E",
        nameJa: "白茶",
        nameRomaji: "shiracha",
        nameUk: "Сіратя (білий чай)",
        nameEn: "Shiracha (white-tea brown)",
      ),
    ],
    noteUk: "Білий поверх теплого пісочного — коробочки бавовни розкриваються, висуваючи м'який пух у пізнє літо.",
    noteEn: "White over warm sand — cotton bolls splitting open, pushing out their soft floss into the late-summer field.",
  ),
  41: ColorPairing(
    kasaneJa: "天地",
    kasaneRomaji: "tenchi",
    kasaneUk: "Тенті (небо й земля)",
    kasaneEn: "Tenchi (heaven-and-earth)",
    layers: [
      ColorLayer(
        hex: "76B5DE",
        nameJa: "空色",
        nameRomaji: "sora-iro",
        nameUk: "Сора-іро (небесний)",
        nameEn: "Sora-iro (sky blue)",
      ),
      ColorLayer(
        hex: "B96456",
        nameJa: "朽葉",
        nameRomaji: "kuchiba",
        nameUk: "Кутіба (зів'яле листя)",
        nameEn: "Kuchiba (decayed-leaf brown)",
      ),
    ],
    noteUk: "Небо над брунатним — спека спадає, повітря вище й чистіше, земля темніє після врожаю.",
    noteEn: "Sky-blue over decayed-leaf brown — the heat letting go, the air rising clear, the soil darkening after harvest.",
  ),
  42: ColorPairing(
    kasaneJa: "稲穂",
    kasaneRomaji: "inaho",
    kasaneUk: "Інахо (рисовий колосок)",
    kasaneEn: "Inaho (rice ear)",
    layers: [
      ColorLayer(
        hex: "DBB94C",
        nameJa: "鬱金",
        nameRomaji: "ukon",
        nameUk: "Укон (куркумово-жовтий)",
        nameEn: "Ukon (turmeric)",
      ),
      ColorLayer(
        hex: "D7B45C",
        nameJa: "黄朽葉",
        nameRomaji: "ki-kuchiba",
        nameUk: "Кі-кутіба (золотисте сухе листя)",
        nameEn: "Ki-kuchiba (golden decayed-leaf)",
      ),
    ],
    noteUk: "Куркумовий жовтий над золотавою охрою — рис у колоску дозріває, нахиляючись від ваги зерна.",
    noteEn: "Turmeric over golden ochre — the rice ear ripening, bending under the weight of its own grain.",
  ),
  43: ColorPairing(
    kasaneJa: "萩",
    kasaneRomaji: "hagi",
    kasaneUk: "Хаґі (леспедеца)",
    kasaneEn: "Hagi (bush clover)",
    layers: [
      ColorLayer(
        hex: "A8497A",
        nameJa: "牡丹",
        nameRomaji: "botan",
        nameUk: "Ботан (рожево-пурпуровий)",
        nameEn: "Botan (rose-purple)",
      ),
      ColorLayer(
        hex: "768D77",
        nameJa: "老竹",
        nameRomaji: "oitake",
        nameUk: "Ойтаке (старий бамбук)",
        nameEn: "Oitake (aged bamboo)",
      ),
    ],
    noteUk: "Рожево-пурпуровий над приглушеним зеленим — гілки леспедеци клоняться під краплями білої роси.",
    noteEn: "Rose-purple over sage — bush clover bending under the weight of its first heavy white dew.",
  ),
  44: ColorPairing(
    kasaneJa: "鶺鴒",
    kasaneRomaji: "sekirei",
    kasaneUk: "Секірей (плиска)",
    kasaneEn: "Sekirei (wagtail)",
    layers: [
      ColorLayer(
        hex: "828282",
        nameJa: "灰色",
        nameRomaji: "hai-iro",
        nameUk: "Хай-іро (попелясто-сірий)",
        nameEn: "Hai-iro (ash-grey)",
      ),
      ColorLayer(
        hex: "FCD53F",
        nameJa: "玉子色",
        nameRomaji: "tamago-iro",
        nameUk: "Тамаґо-іро (яєчно-жовтий)",
        nameEn: "Tamago-iro (egg-yolk yellow)",
      ),
    ],
    noteUk: "Попіл зверху, теплий жовток знизу — плиска посмикує хвостом на каменях біля струмка, що холоне.",
    noteEn: "Ash-grey over egg-yolk — the wagtail flicking its tail on the stones of a cooling stream.",
  ),
  45: ColorPairing(
    kasaneJa: "燕去",
    kasaneRomaji: "tsubame-sari",
    kasaneUk: "Цубаме-сарі (відліт ластівок)",
    kasaneEn: "Tsubame-sari (swallows leaving)",
    layers: [
      ColorLayer(
        hex: "0F2540",
        nameJa: "縹",
        nameRomaji: "hanada",
        nameUk: "Ханада (темний індиго)",
        nameEn: "Hanada (deep indigo blue)",
      ),
      ColorLayer(
        hex: "AFAFAF",
        nameJa: "銀鼠",
        nameRomaji: "gin-nezu",
        nameUk: "Ґін-незу (срібно-сірий)",
        nameEn: "Gin-nezu (silver-grey)",
      ),
    ],
    noteUk: "Темний індиго над сріблястою сіризною — ластівки відлітають у небі, що поступово втрачає літню теплу синь.",
    noteEn: "Deep indigo over silver-grey — swallows leaving against a sky that has lost the warm blue of summer.",
  ),
  46: ColorPairing(
    kasaneJa: "彼岸",
    kasaneRomaji: "higan",
    kasaneUk: "Хіґан (рівнодення)",
    kasaneEn: "Higan (equinox)",
    layers: [
      ColorLayer(
        hex: "B7282E",
        nameJa: "茜",
        nameRomaji: "akane",
        nameUk: "Акане (мареновий червоний)",
        nameEn: "Akane (madder red)",
      ),
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
    ],
    noteUk: "Мареновий червоний над білим — паучі лілії вздовж міжі цвітуть у тиші, коли грім нарешті замовкає.",
    noteEn: "Madder red over white — spider lilies along the field-edge blooming in the silence as the thunder finally stops.",
  ),
  47: ColorPairing(
    kasaneJa: "白菊",
    kasaneRomaji: "shiragiku",
    kasaneUk: "Сіраґіку (біла хризантема)",
    kasaneEn: "Shiragiku (white chrysanthemum)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
      ColorLayer(
        hex: "E8C19D",
        nameJa: "砥粉色",
        nameRomaji: "tonoko-iro",
        nameUk: "Тоноко-іро (точильний камінь)",
        nameEn: "Tonoko-iro (whetstone tan)",
      ),
    ],
    noteUk: "Білий шовк над теплим точильним відтінком — біла хризантема стоїть у саду, як остаточна форма світла.",
    noteEn: "White over whetstone-cream — white chrysanthemum standing in the garden like the final shape of light.",
  ),
  48: ColorPairing(
    kasaneJa: "刈田",
    kasaneRomaji: "karita",
    kasaneUk: "Каріта (стерня поля)",
    kasaneEn: "Karita (harvested field)",
    layers: [
      ColorLayer(
        hex: "C7B79E",
        nameJa: "白茶",
        nameRomaji: "shiracha",
        nameUk: "Сіратя (білий чай)",
        nameEn: "Shiracha (white-tea brown)",
      ),
      ColorLayer(
        hex: "897F62",
        nameJa: "利休茶",
        nameRomaji: "rikyū-cha",
        nameUk: "Рікю-тя (чайний колір)",
        nameEn: "Rikyū-cha (Rikyū tea-brown)",
      ),
    ],
    noteUk: "Світло-чайний над темно-чайним — стерня осушеного рисового поля дрімає у м'якому жовтневому світлі.",
    noteEn: "Pale tea over deep tea — the stubble of the drained rice field dozing under soft October light.",
  ),
  49: ColorPairing(
    kasaneJa: "雁来紅",
    kasaneRomaji: "gan-rai-kō",
    kasaneUk: "Ґан-рай-ко (амарант гусячого приходу)",
    kasaneEn: "Gan-rai-kō (geese-arrival amaranth)",
    layers: [
      ColorLayer(
        hex: "C3272B",
        nameJa: "紅",
        nameRomaji: "kurenai",
        nameUk: "Куренай (багряний)",
        nameEn: "Kurenai (deep crimson)",
      ),
      ColorLayer(
        hex: "316745",
        nameJa: "千歳緑",
        nameRomaji: "chitose-midori",
        nameUk: "Чітосе-мідорі (тисячолітня зелень)",
        nameEn: "Chitose-midori (thousand-year green)",
      ),
    ],
    noteUk: "Багряний амарант над глибоким зеленим — листя амаранту червоніє саме тоді, коли в небі знов з'являються гусячі клини.",
    noteEn: "Crimson amaranth over deep green — amaranth leaves reddening just as the wedge of geese reappears overhead.",
  ),
  50: ColorPairing(
    kasaneJa: "菊",
    kasaneRomaji: "kiku",
    kasaneUk: "Кіку (хризантема)",
    kasaneEn: "Kiku (chrysanthemum)",
    layers: [
      ColorLayer(
        hex: "F6BD2C",
        nameJa: "山吹",
        nameRomaji: "yamabuki",
        nameUk: "Ямабукі (золотисто-жовтий)",
        nameEn: "Yamabuki (golden yellow)",
      ),
      ColorLayer(
        hex: "D7B45C",
        nameJa: "黄朽葉",
        nameRomaji: "ki-kuchiba",
        nameUk: "Кі-кутіба (золотисте сухе листя)",
        nameEn: "Ki-kuchiba (golden decayed-leaf)",
      ),
      ColorLayer(
        hex: "586E48",
        nameJa: "松葉色",
        nameRomaji: "matsuba-iro",
        nameUk: "Мацуба-іро (соснова хвоя)",
        nameEn: "Matsuba-iro (pine-needle green)",
      ),
    ],
    noteUk: "Золотистий жовтий, бліде золото і темна хвоя — святкова хризантема Чойо, з пелюстками, що розкриваються в саке.",
    noteEn: "Golden yellow, soft gold, and pine-needle green — Chōyō chrysanthemum, its petals opening into the cup of sake.",
  ),
  51: ColorPairing(
    kasaneJa: "蟋蟀",
    kasaneRomaji: "kōrogi",
    kasaneUk: "Короґі (цвіркун)",
    kasaneEn: "Kōrogi (cricket)",
    layers: [
      ColorLayer(
        hex: "211711",
        nameJa: "真っ黒",
        nameRomaji: "makkurō",
        nameUk: "Маккуро (чорний)",
        nameEn: "Makkurō (jet black)",
      ),
      ColorLayer(
        hex: "B96456",
        nameJa: "朽葉",
        nameRomaji: "kuchiba",
        nameUk: "Кутіба (зів'яле листя)",
        nameEn: "Kuchiba (decayed-leaf brown)",
      ),
    ],
    noteUk: "Чорний над брунатним — цвіркун співає коло порога, коли ніч стає глибшою за двір.",
    noteEn: "Black over decayed-leaf brown — the cricket singing at the threshold as the night grows deeper than the courtyard.",
  ),
  52: ColorPairing(
    kasaneJa: "霜重ね",
    kasaneRomaji: "shimo-gasane",
    kasaneUk: "Сімо-ґасане (іній)",
    kasaneEn: "Shimo-gasane (frost layering)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
      ColorLayer(
        hex: "B96456",
        nameJa: "朽葉",
        nameRomaji: "kuchiba",
        nameUk: "Кутіба (зів'яле листя)",
        nameEn: "Kuchiba (decayed-leaf brown)",
      ),
    ],
    noteUk: "Біле срібло інею над теплим брунатним — перший приморозок осідає на опалому листі, що ще не охололо.",
    noteEn: "Frost-white over decayed-leaf brown — the first frost settling onto fallen leaves still warm from the day.",
  ),
  53: ColorPairing(
    kasaneJa: "朽葉",
    kasaneRomaji: "kuchiba",
    kasaneUk: "Кутіба (зів'яле листя)",
    kasaneEn: "Kuchiba (decayed leaf)",
    layers: [
      ColorLayer(
        hex: "B96456",
        nameJa: "朽葉",
        nameRomaji: "kuchiba",
        nameUk: "Кутіба (зів'яле листя)",
        nameEn: "Kuchiba (decayed-leaf brown)",
      ),
      ColorLayer(
        hex: "D7B45C",
        nameJa: "黄朽葉",
        nameRomaji: "ki-kuchiba",
        nameUk: "Кі-кутіба (золотисте сухе листя)",
        nameEn: "Ki-kuchiba (golden decayed-leaf)",
      ),
    ],
    noteUk: "Жухле зверху, золотисто-сухе знизу — ранкова мряка пробігає по килиму листя, що шарудить під ногами.",
    noteEn: "Russet over golden ochre — a thin morning rain pattering over the carpet of leaves that crackles underfoot.",
  ),
  54: ColorPairing(
    kasaneJa: "紅葉",
    kasaneRomaji: "momiji",
    kasaneUk: "Момідзі (червоний клен)",
    kasaneEn: "Momiji (autumn maple)",
    layers: [
      ColorLayer(
        hex: "DC3023",
        nameJa: "朱",
        nameRomaji: "shu",
        nameUk: "Сю (кіноварний)",
        nameEn: "Shu (vermilion)",
      ),
      ColorLayer(
        hex: "C3272B",
        nameJa: "紅",
        nameRomaji: "kurenai",
        nameUk: "Куренай (багряний)",
        nameEn: "Kurenai (deep crimson)",
      ),
    ],
    noteUk: "Кіновар зверху, темно-багряний знизу — клен спалахує на схилі, тоді як виноград плющу жовтіє поряд.",
    noteEn: "Vermilion over deep crimson — the maple flaring on the hillside while the ivy vines yellow beside it.",
  ),

  // ─── Winter ───
  55: ColorPairing(
    kasaneJa: "椿",
    kasaneRomaji: "tsubaki",
    kasaneUk: "Цубакі (камелія)",
    kasaneEn: "Tsubaki (camellia)",
    layers: [
      ColorLayer(
        hex: "C3272B",
        nameJa: "紅",
        nameRomaji: "kurenai",
        nameUk: "Куренай (багряний)",
        nameEn: "Kurenai (deep crimson)",
      ),
      ColorLayer(
        hex: "316745",
        nameJa: "千歳緑",
        nameRomaji: "chitose-midori",
        nameUk: "Чітосе-мідорі (тисячолітня зелень)",
        nameEn: "Chitose-midori (thousand-year green)",
      ),
    ],
    noteUk: "Багряний над темно-вічнозеленим — камелія цвіте у перші холоди, тверда квітка на глянцевому листі.",
    noteEn: "Crimson over evergreen — the sazanka camellia blooming in the first cold, a firm flower on glossy leaves.",
  ),
  56: ColorPairing(
    kasaneJa: "凍重ね",
    kasaneRomaji: "itesha-gasane",
    kasaneUk: "Ітеся-ґасане (промерзання землі)",
    kasaneEn: "Itesha-gasane (earth-freezing)",
    layers: [
      ColorLayer(
        hex: "888E7E",
        nameJa: "利休鼠",
        nameRomaji: "rikyū-nezu",
        nameUk: "Рікю-незу (зеленувато-сірий)",
        nameEn: "Rikyū-nezu (Rikyū grey)",
      ),
      ColorLayer(
        hex: "211711",
        nameJa: "真っ黒",
        nameRomaji: "makkurō",
        nameUk: "Маккуро (чорний)",
        nameEn: "Makkurō (jet black)",
      ),
    ],
    noteUk: "Зеленувато-сірий над чорним — земля затвердла, її поверхня вже дзвенить, а нутро ще пам'ятає тепло.",
    noteEn: "Rikyū grey over jet black — the earth hardening at the surface while its inside still remembers warmth.",
  ),
  57: ColorPairing(
    kasaneJa: "水仙",
    kasaneRomaji: "suisen",
    kasaneUk: "Суйсен (нарцис)",
    kasaneEn: "Suisen (narcissus)",
    layers: [
      ColorLayer(
        hex: "FCD53F",
        nameJa: "玉子色",
        nameRomaji: "tamago-iro",
        nameUk: "Тамаґо-іро (яєчно-жовтий)",
        nameEn: "Tamago-iro (egg-yolk yellow)",
      ),
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
    ],
    noteUk: "Жовтий нарцисів над білим — золота чашка тримає світло у годину, коли все навколо вже поснуло.",
    noteEn: "Daffodil-yellow over white — a golden cup holding the light at the hour when everything else has gone to sleep.",
  ),
  58: ColorPairing(
    kasaneJa: "虹隠",
    kasaneRomaji: "niji-gakure",
    kasaneUk: "Нідзі-ґакуре (схована веселка)",
    kasaneEn: "Niji-gakure (rainbow hidden)",
    layers: [
      ColorLayer(
        hex: "999999",
        nameJa: "鼠",
        nameRomaji: "nezumi",
        nameUk: "Незумі (мишачо-сірий)",
        nameEn: "Nezumi (mouse-grey)",
      ),
      ColorLayer(
        hex: "2A4073",
        nameJa: "縹色",
        nameRomaji: "hanada-iro",
        nameUk: "Ханада-іро (темно-індиговий)",
        nameEn: "Hanada-iro (indigo blue)",
      ),
    ],
    noteUk: "Мишача сіризна над темним індиго — небо тримає веселку, складену й заховану до весни.",
    noteEn: "Mouse-grey over indigo — the sky keeping the rainbow folded away until spring returns.",
  ),
  59: ColorPairing(
    kasaneJa: "北風",
    kasaneRomaji: "kitakaze",
    kasaneUk: "Кітакадзе (північний вітер)",
    kasaneEn: "Kitakaze (north wind)",
    layers: [
      ColorLayer(
        hex: "1F4E79",
        nameJa: "瑠璃",
        nameRomaji: "ruri",
        nameUk: "Рурі (лазурит)",
        nameEn: "Ruri (lapis lazuli)",
      ),
      ColorLayer(
        hex: "B96456",
        nameJa: "朽葉",
        nameRomaji: "kuchiba",
        nameUk: "Кутіба (зів'яле листя)",
        nameEn: "Kuchiba (decayed-leaf brown)",
      ),
    ],
    noteUk: "Лазуритовий над брунатним — холодний північний вітер здирає останнє листя і несе його над оголеними полями.",
    noteEn: "Lapis blue over brown — the cold north wind stripping the last leaves and carrying them across the bared fields.",
  ),
  60: ColorPairing(
    kasaneJa: "橘",
    kasaneRomaji: "tachibana",
    kasaneUk: "Тачібана (мандарин)",
    kasaneEn: "Tachibana (citrus)",
    layers: [
      ColorLayer(
        hex: "DBB94C",
        nameJa: "鬱金",
        nameRomaji: "ukon",
        nameUk: "Укон (куркумовий)",
        nameEn: "Ukon (turmeric)",
      ),
      ColorLayer(
        hex: "316745",
        nameJa: "千歳緑",
        nameRomaji: "chitose-midori",
        nameUk: "Чітосе-мідорі (тисячолітня зелень)",
        nameEn: "Chitose-midori (thousand-year green)",
      ),
    ],
    noteUk: "Куркумовий жовтий над темно-вічнозеленим — мандарини дозрівають на гіллі, що пам'ятає всі минулі зими.",
    noteEn: "Turmeric over evergreen — tachibana ripening on the bough that remembers every winter before this one.",
  ),
  61: ColorPairing(
    kasaneJa: "松重ね",
    kasaneRomaji: "matsu-gasane",
    kasaneUk: "Мацу-ґасане (сосна)",
    kasaneEn: "Matsu-gasane (pine layering)",
    layers: [
      ColorLayer(
        hex: "586E48",
        nameJa: "松葉色",
        nameRomaji: "matsuba-iro",
        nameUk: "Мацуба-іро (соснова хвоя)",
        nameEn: "Matsuba-iro (pine-needle green)",
      ),
      ColorLayer(
        hex: "316745",
        nameJa: "千歳緑",
        nameRomaji: "chitose-midori",
        nameUk: "Чітосе-мідорі (тисячолітня зелень)",
        nameEn: "Chitose-midori (thousand-year green)",
      ),
    ],
    noteUk: "Соснова хвоя над глибоким зеленим — холод устоявся, але сосна тримає колір, як обіцянку весни.",
    noteEn: "Pine-needle green over deep evergreen — the cold has settled in, but the pine keeps its colour as a promise.",
  ),
  62: ColorPairing(
    kasaneJa: "枯野",
    kasaneRomaji: "kareno",
    kasaneUk: "Карено (мертве поле)",
    kasaneEn: "Kareno (winter-withered field)",
    layers: [
      ColorLayer(
        hex: "C7B79E",
        nameJa: "白茶",
        nameRomaji: "shiracha",
        nameUk: "Сіратя (білий чай)",
        nameEn: "Shiracha (white-tea brown)",
      ),
      ColorLayer(
        hex: "897F62",
        nameJa: "利休茶",
        nameRomaji: "rikyū-cha",
        nameUk: "Рікю-тя (чайно-сірий)",
        nameEn: "Rikyū-cha (Rikyū tea-brown)",
      ),
    ],
    noteUk: "Сіро-пісочний над темним чаєм — поле висохло до тиші, і ведмеді нарешті вкладаються спати.",
    noteEn: "Pale tan over dim tea — the field dried down to silence, and the bears at last lie down to sleep.",
  ),
  63: ColorPairing(
    kasaneJa: "鮭重ね",
    kasaneRomaji: "sake-gasane",
    kasaneUk: "Саке-ґасане (лосось)",
    kasaneEn: "Sake-gasane (salmon)",
    layers: [
      ColorLayer(
        hex: "973C3F",
        nameJa: "蘇芳",
        nameRomaji: "suō",
        nameUk: "Суо (червоно-брунатний)",
        nameEn: "Suō (sappanwood red-brown)",
      ),
      ColorLayer(
        hex: "AFAFAF",
        nameJa: "銀鼠",
        nameRomaji: "gin-nezu",
        nameUk: "Ґін-незу (срібно-сірий)",
        nameEn: "Gin-nezu (silver-grey)",
      ),
    ],
    noteUk: "Червоно-брунатний над срібно-сірим — лосось рветься проти течії, і його боки спалахують у темній воді.",
    noteEn: "Sappan-red over silver-grey — salmon pushing upstream, their sides flashing in the cold dark water.",
  ),
  64: ColorPairing(
    kasaneJa: "冬至",
    kasaneRomaji: "tōji",
    kasaneUk: "Тодзі (зимове сонцестояння)",
    kasaneEn: "Tōji (winter solstice)",
    layers: [
      ColorLayer(
        hex: "F6BD2C",
        nameJa: "山吹",
        nameRomaji: "yamabuki",
        nameUk: "Ямабукі (золотисто-жовтий)",
        nameEn: "Yamabuki (golden yellow)",
      ),
      ColorLayer(
        hex: "3C5AA6",
        nameJa: "紺青",
        nameRomaji: "konjō",
        nameUk: "Кондзьо (темно-синій)",
        nameEn: "Konjō (Prussian dark-blue)",
      ),
    ],
    noteUk: "Золотистий жовтий над темно-синім — у найкоротший день у казан кладуть юдзу, а під сніг знову проростає трава.",
    noteEn: "Yamabuki gold over Prussian blue — on the shortest day, yuzu floats in the bath while self-heal sprouts in the snow.",
  ),
  65: ColorPairing(
    kasaneJa: "鹿重ね",
    kasaneRomaji: "shika-gasane",
    kasaneUk: "Сіка-ґасане (олень)",
    kasaneEn: "Shika-gasane (deer)",
    layers: [
      ColorLayer(
        hex: "B96456",
        nameJa: "朽葉",
        nameRomaji: "kuchiba",
        nameUk: "Кутіба (зів'яле листя)",
        nameEn: "Kuchiba (decayed-leaf brown)",
      ),
      ColorLayer(
        hex: "C7B79E",
        nameJa: "白茶",
        nameRomaji: "shiracha",
        nameUk: "Сіратя (білий чай)",
        nameEn: "Shiracha (white-tea brown)",
      ),
    ],
    noteUk: "Брунатний над світло-чайним — олені скидають роги, які залишаються на снігу, як забуті щіпки кістки.",
    noteEn: "Brown over pale tan — deer shedding their antlers, which lie on the snow like small forgotten bones.",
  ),
  66: ColorPairing(
    kasaneJa: "御雑煮",
    kasaneRomaji: "ozōni-gasane",
    kasaneUk: "Одзоні-ґасане (новорічний шар)",
    kasaneEn: "Ozōni-gasane (New Year layering)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (сніжно-білий)",
        nameEn: "Yukijiro (snow white)",
      ),
      ColorLayer(
        hex: "DC3023",
        nameJa: "朱",
        nameRomaji: "shu",
        nameUk: "Сю (кіноварний червоний)",
        nameEn: "Shu (vermilion)",
      ),
      ColorLayer(
        hex: "316745",
        nameJa: "千歳緑",
        nameRomaji: "chitose-midori",
        nameUk: "Чітосе-мідорі (тисячолітня зелень)",
        nameEn: "Chitose-midori (thousand-year green)",
      ),
    ],
    noteUk: "Сніговий білий, святковий кіноварний і вічна зелень — церемоніальний шар першого дня, де озима пшениця спить під снігом.",
    noteEn: "Snow white, festive vermilion, and evergreen — the formal layering of New Year's day, with winter wheat asleep beneath the snow.",
  ),
  67: ColorPairing(
    kasaneJa: "雪見",
    kasaneRomaji: "yuki-mi",
    kasaneUk: "Юкі-мі (милування снігом)",
    kasaneEn: "Yuki-mi (snow-watching)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
      ColorLayer(
        hex: "80AAB3",
        nameJa: "水浅葱",
        nameRomaji: "mizu-asagi",
        nameUk: "Мідзу-асаґі (бліда водяна блакить)",
        nameEn: "Mizu-asagi (water-blue-green)",
      ),
    ],
    noteUk: "Сніжно-білий над блідою водяною блакиттю — петрушка стелиться зеленню над холодним струмком сімох трав.",
    noteEn: "Snow-white over pale water-blue — water-dropwort showing its green above the cold stream of the seven herbs.",
  ),
  68: ColorPairing(
    kasaneJa: "泉重ね",
    kasaneRomaji: "izumi-gasane",
    kasaneUk: "Ідзумі-ґасане (джерело)",
    kasaneEn: "Izumi-gasane (spring-water)",
    layers: [
      ColorLayer(
        hex: "00A3AF",
        nameJa: "浅葱",
        nameRomaji: "asagi",
        nameUk: "Асаґі (бліда блакить)",
        nameEn: "Asagi (pale spring-onion blue)",
      ),
      ColorLayer(
        hex: "AFAFAF",
        nameJa: "銀鼠",
        nameRomaji: "gin-nezu",
        nameUk: "Ґін-незу (срібно-сірий)",
        nameEn: "Gin-nezu (silver-grey)",
      ),
    ],
    noteUk: "Бліда блакить над срібно-сірим — підземні джерела ворушаться під льодом, віддаючи перше дихання назад потоку.",
    noteEn: "Pale asagi over silver-grey — the springs stirring beneath the ice, giving their first breath back to the stream.",
  ),
  69: ColorPairing(
    kasaneJa: "雉重ね",
    kasaneRomaji: "kiji-gasane",
    kasaneUk: "Кідзі-ґасане (фазан)",
    kasaneEn: "Kiji-gasane (pheasant)",
    layers: [
      ColorLayer(
        hex: "316745",
        nameJa: "千歳緑",
        nameRomaji: "chitose-midori",
        nameUk: "Чітосе-мідорі (тисячолітня зелень)",
        nameEn: "Chitose-midori (thousand-year green)",
      ),
      ColorLayer(
        hex: "B7282E",
        nameJa: "茜",
        nameRomaji: "akane",
        nameUk: "Акане (мареновий червоний)",
        nameEn: "Akane (madder red)",
      ),
    ],
    noteUk: "Темно-зелений над мареновим — самець фазана кричить на голому пагорбі, його голос розтинає тонке холодне повітря.",
    noteEn: "Deep green over madder — the cock pheasant calling from a bare hill, his cry cutting the thin cold air.",
  ),
  70: ColorPairing(
    kasaneJa: "蕗の薹",
    kasaneRomaji: "fuki-no-tō",
    kasaneUk: "Фукі-но-то (бруньки білокопитника)",
    kasaneEn: "Fuki-no-tō (butterbur bud)",
    layers: [
      ColorLayer(
        hex: "91AD70",
        nameJa: "鶸萌黄",
        nameRomaji: "hiwa-moegi",
        nameUk: "Хіва-моеґі (зелень синиці)",
        nameEn: "Hiwa-moegi (siskin-green)",
      ),
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
    ],
    noteUk: "Зеленуватий жовток над сніговим білим — бруньки фукі пробивають корку снігу, як перша зелена записка зими.",
    noteEn: "Pale siskin-green over snow-white — butterbur buds piercing the snow-crust like winter's first green note.",
  ),
  71: ColorPairing(
    kasaneJa: "氷襲",
    kasaneRomaji: "kōri-gasane",
    kasaneUk: "Корі-ґасане (крижаний шар)",
    kasaneEn: "Kōri-gasane (ice layering)",
    layers: [
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
      ColorLayer(
        hex: "76B5DE",
        nameJa: "空色",
        nameRomaji: "sora-iro",
        nameUk: "Сора-іро (бліде небо)",
        nameEn: "Sora-iro (pale sky-blue)",
      ),
    ],
    noteUk: "Білий шовк над блідою небесною блакиттю — лід на ставку загусає до самого дна, тримаючи літнє небо зверху.",
    noteEn: "White over pale sky-blue — ice thickening on the pond down to the very bottom, keeping a memory of summer sky above it.",
  ),
  72: ColorPairing(
    kasaneJa: "鶏重ね",
    kasaneRomaji: "tori-gasane",
    kasaneUk: "Торі-ґасане (курка)",
    kasaneEn: "Tori-gasane (hen)",
    layers: [
      ColorLayer(
        hex: "FCD53F",
        nameJa: "玉子色",
        nameRomaji: "tamago-iro",
        nameUk: "Тамаґо-іро (яєчно-жовтий)",
        nameEn: "Tamago-iro (egg-yolk yellow)",
      ),
      ColorLayer(
        hex: "F7F7F4",
        nameJa: "雪白",
        nameRomaji: "yukijiro",
        nameUk: "Юкідзіро (білий)",
        nameEn: "Yukijiro (white)",
      ),
    ],
    noteUk: "Жовток над білком — кури знову несуть яйця у переддень Сецубуну, коли зима готується відступити.",
    noteEn: "Yolk over white — the hens laying again on the eve of Setsubun, the winter quietly preparing to step aside.",
  ),
};

ColorPairing? colorsForKo(int koIndex) => seasonalColors[koIndex];
