import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/season_models.dart';

/// Loads the 72-seasons dataset from bundled JSON asset.
///
/// Holds data in memory after first load. Call [load] once at app start.
class SeasonsRepository {
  SeasonsRepository._();

  static final SeasonsRepository instance = SeasonsRepository._();

  late final Map<String, MetaSeason> _metaById;
  late final Map<String, Sekki> _sekkiById;
  late final List<MicroSeason> _microSeasons;

  bool _loaded = false;

  Future<void> load() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/data/seasons.json');
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;

    final metaRaw = json['metaSeasons'] as Map<String, dynamic>;
    _metaById = {
      for (final e in metaRaw.entries)
        e.key: MetaSeason.fromJson(e.key, e.value as Map<String, dynamic>),
    };

    final sekkiRaw = json['sekki'] as List<dynamic>;
    _sekkiById = {
      for (final s in sekkiRaw)
        (s as Map<String, dynamic>)['id'] as String: Sekki.fromJson(s),
    };

    final koRaw = json['ko'] as List<dynamic>;
    _microSeasons = koRaw
        .map((e) => MicroSeason.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    _loaded = true;
  }

  List<MicroSeason> get all {
    _assertLoaded();
    return List.unmodifiable(_microSeasons);
  }

  MicroSeason byIndex(int index) {
    _assertLoaded();
    return _microSeasons.firstWhere((k) => k.index == index);
  }

  MetaSeason meta(String id) {
    _assertLoaded();
    final m = _metaById[id];
    if (m == null) {
      throw StateError('Unknown meta season id: $id');
    }
    return m;
  }

  Sekki sekki(String id) {
    _assertLoaded();
    final s = _sekkiById[id];
    if (s == null) {
      throw StateError('Unknown sekki id: $id');
    }
    return s;
  }

  List<MetaSeason> get allMeta {
    _assertLoaded();
    return _metaById.values.toList();
  }

  void _assertLoaded() {
    if (!_loaded) {
      throw StateError(
        'SeasonsRepository is not loaded. Call await SeasonsRepository.instance.load() first.',
      );
    }
  }
}
