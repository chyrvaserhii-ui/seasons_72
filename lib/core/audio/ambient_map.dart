/// Per-kō ambient audio overrides.
///
/// Most of the 72 kō share their meta-season's loop (spring birds,
/// summer cicadas, autumn rain, winter wind). The handful below
/// describe a *specific* natural event that's iconic enough to deserve
/// its own clip — we play that instead of the meta-default when the
/// user is on these kō.
///
/// File expectations: `assets/audio/<key>.m4a`. If a file is missing,
/// `AmbientAudioService` falls back to the meta-season default.
const Map<int, String> ambientOverrides = {
  // Spring (#1–#18)
  1: 'ice_thaw',          // 東風解凍 — East wind melts ice
  2: 'warbler',           // 鶯始啼 — Bush warbler starts singing
  3: 'river_ice',         // 魚上氷 — Fish leap from ice cracks
  4: 'spring_rain',       // 土脉潤起 — Spring rain
  5: 'mist',              // 霞始靆 — First morning mists
  7: 'awakening_insects', // 蟄虫啓戸 — Insects emerge
  10: 'sparrows_nest',    // 雀始巣 — Sparrows build nests
  12: 'thunder',          // 雷乃発声 — Thunder begins
  13: 'swallows_return',  // 玄鳥至 — Swallows return
  14: 'geese_north',      // 鴻雁北 — Wild geese fly north

  // Summer (#19–#36)
  19: 'frogs',            // 蛙始鳴 — Frogs start singing
  26: 'fireflies',        // 腐草為螢 — Fireflies / evening crickets
  31: 'warm_breeze',      // 温風至 — Warm winds arrive
  33: 'hawk',             // 鷹乃学習 — Hawk practices flight
  36: 'summer_storm',     // 大雨時行 — Sudden heavy rains

  // Autumn (#37–#54)
  37: 'cool_wind',        // 涼風至 — Cool winds arrive
  38: 'cicadas',          // 寒蝉鳴 — Cicadas chirp loudly
  44: 'wagtail',          // 鶺鴒鳴 — Wagtails sing
  45: 'swallows',         // 玄鳥去 — Swallows depart
  49: 'geese_south',      // 鴻雁来 — Wild geese return south
  51: 'crickets',         // 蟋蟀在戸 — Crickets at the door
  53: 'autumn_shower',    // 霎時施 — Brief autumn showers

  // Winter (#55–#72)
  59: 'leaves_wind',      // 朔風払葉 — North wind blows leaves
  62: 'winter_silence',   // 熊蟄穴 — Bears retire to hibernate
  63: 'rapids',           // 鱖魚群 — Salmon swim upstream
  65: 'forest_winter',    // 麋角解 — Deer shed antlers
  68: 'spring_water',     // 水泉動 — Mountain springs thaw
  69: 'pheasant',         // 雉始雊 — Pheasant first crows
  72: 'henhouse',         // 鶏始乳 — Chickens begin laying
};

/// Returns a specific ambient key for [koIndex], or null if none —
/// caller should then fall back to the meta-season default.
String? ambientForKo(int koIndex) => ambientOverrides[koIndex];
