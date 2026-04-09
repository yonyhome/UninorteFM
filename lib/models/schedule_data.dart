import 'package:flutter/material.dart';

// ─── Category colors ──────────────────────────────────────────────────────────

const Map<String, Color> kCategoryColors = {
  'música clásica':         Color(0xFF8B9FD4),
  'música clásica nocturna':Color(0xFF6B7FB8),
  'jazz':                   Color(0xFF7B6FC4),
  'blues':                  Color(0xFF5B6FBC),
  'rock':                   Color(0xFFE07840),
  'música colombiana':      Color(0xFFD4A840),
  'música regional':        Color(0xFFCC8040),
  'música del mundo':       Color(0xFFE08060),
  'música brasileña':       Color(0xFF88C060),
  'música africana':        Color(0xFF70B050),
  'música retro':           Color(0xFFD460A0),
  'variedades':             Color(0xFFD060B0),
  'magazine':               Color(0xFFB05090),
  'especial':               Color(0xFF50B090),
  'noticias':               Color(0xFFD4A020),
};

Color categoryColor(String categoria) =>
    kCategoryColors[categoria.toLowerCase()] ?? const Color(0xFF888888);

// ─── Model ────────────────────────────────────────────────────────────────────

class Program {
  final String name;
  final String category;
  final List<String> days;    // 'lunes', 'martes', …
  final int startMinutes;     // minutes from midnight
  final int endMinutes;       // minutes from midnight (0 = midnight next day)

  const Program({
    required this.name,
    required this.category,
    required this.days,
    required this.startMinutes,
    required this.endMinutes,
  });

  Color get color => categoryColor(category);

  String get startLabel => _fmt(startMinutes);
  String get endLabel   => _fmt(endMinutes == 0 ? 1440 : endMinutes);

  static String _fmt(int minutes) {
    final h = (minutes ~/ 60) % 24;
    final m = minutes % 60;
    final period = h < 12 ? 'AM' : 'PM';
    final h12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    return m == 0
        ? '$h12:00 $period'
        : '$h12:${m.toString().padLeft(2, '0')} $period';
  }
}

// ─── Parser ───────────────────────────────────────────────────────────────────

int _parseTime(String t) {
  // "6:00 AM" / "12:00 PM" / "7:30 PM"
  final parts = t.trim().split(' ');
  final hm    = parts[0].split(':');
  int h       = int.parse(hm[0]);
  final m     = int.parse(hm[1]);
  final pm    = parts[1].toUpperCase() == 'PM';
  if (pm && h != 12) h += 12;
  if (!pm && h == 12) h = 0;
  return h * 60 + m;   // midnight end → 0 (treated as 1440 when displaying)
}

// ─── Schedule data ────────────────────────────────────────────────────────────

final List<Program> kSchedule = _raw.map((e) {
  return Program(
    name:         e['programa'] as String,
    category:     e['categoria'] as String,
    days:         List<String>.from(e['dias'] as List),
    startMinutes: _parseTime(e['hora_inicio'] as String),
    endMinutes:   _parseTime(e['hora_fin'] as String),
  );
}).toList();

// ── Lookup ────────────────────────────────────────────────────────────────────

const _dayNames = [
  '', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'
];

Program? currentProgram([DateTime? now]) {
  final t = now ?? DateTime.now();
  final dayName = _dayNames[t.weekday]; // weekday: 1=Mon … 7=Sun
  final minutes = t.hour * 60 + t.minute;

  for (final p in kSchedule) {
    if (!p.days.contains(dayName)) continue;
    final end = p.endMinutes == 0 ? 1440 : p.endMinutes;
    if (minutes >= p.startMinutes && minutes < end) return p;
  }
  return null;
}

List<Program> programsForDay(String dayName) =>
    kSchedule.where((p) => p.days.contains(dayName)).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));

// ─── Raw JSON ─────────────────────────────────────────────────────────────────

const _raw = [
  {"programa":"Buenos Días con los Clásicos","categoria":"música clásica","dias":["lunes","martes","miércoles","jueves","viernes"],"hora_inicio":"6:00 AM","hora_fin":"7:00 AM"},
  {"programa":"Amanecer Colombiano","categoria":"música colombiana","dias":["sábado","domingo"],"hora_inicio":"6:00 AM","hora_fin":"7:00 AM"},
  {"programa":"Concierto de la Mañana","categoria":"música clásica","dias":["lunes","miércoles","jueves","viernes"],"hora_inicio":"7:00 AM","hora_fin":"7:30 AM"},
  {"programa":"Salud","categoria":"especial","dias":["martes"],"hora_inicio":"7:00 AM","hora_fin":"7:30 AM"},
  {"programa":"Todos Cuentan","categoria":"especial","dias":["lunes"],"hora_inicio":"7:30 AM","hora_fin":"8:00 AM"},
  {"programa":"Putchimaajatü","categoria":"especial","dias":["martes"],"hora_inicio":"7:30 AM","hora_fin":"8:00 AM"},
  {"programa":"La Historia Continúa","categoria":"especial","dias":["miércoles"],"hora_inicio":"7:30 AM","hora_fin":"8:00 AM"},
  {"programa":"Apocalípticos Integrados","categoria":"variedades","dias":["jueves"],"hora_inicio":"7:30 AM","hora_fin":"8:00 AM"},
  {"programa":"Emprende+","categoria":"especial","dias":["viernes"],"hora_inicio":"7:30 AM","hora_fin":"8:00 AM"},
  {"programa":"Noticiero Voice of America","categoria":"noticias","dias":["lunes","martes","miércoles","jueves","viernes"],"hora_inicio":"8:00 AM","hora_fin":"8:30 AM"},
  {"programa":"Concierto de la Mañana","categoria":"música clásica","dias":["sábado"],"hora_inicio":"7:00 AM","hora_fin":"9:00 AM"},
  {"programa":"Onda Clásica","categoria":"música clásica","dias":["lunes","martes","miércoles","jueves","viernes"],"hora_inicio":"8:30 AM","hora_fin":"11:00 AM"},
  {"programa":"Onda Clásica","categoria":"música clásica","dias":["domingo"],"hora_inicio":"6:30 AM","hora_fin":"11:00 AM"},
  {"programa":"Así Suena Colombia","categoria":"música colombiana","dias":["sábado"],"hora_inicio":"9:00 AM","hora_fin":"10:00 AM"},
  {"programa":"Latidos de Mar y Río","categoria":"música regional","dias":["sábado"],"hora_inicio":"10:00 AM","hora_fin":"11:00 AM"},
  {"programa":"Así Suena Colombia","categoria":"música colombiana","dias":["lunes","martes","miércoles","jueves","viernes"],"hora_inicio":"11:00 AM","hora_fin":"12:00 PM"},
  {"programa":"Vaivén","categoria":"música del mundo","dias":["sábado"],"hora_inicio":"11:00 AM","hora_fin":"12:00 PM"},
  {"programa":"La Hora Vintage","categoria":"música retro","dias":["domingo"],"hora_inicio":"9:00 AM","hora_fin":"10:00 AM"},
  {"programa":"Brasileirices","categoria":"música brasileña","dias":["domingo"],"hora_inicio":"10:00 AM","hora_fin":"11:00 AM"},
  {"programa":"Africanerías","categoria":"música africana","dias":["domingo"],"hora_inicio":"11:00 AM","hora_fin":"12:00 PM"},
  {"programa":"La Pausa","categoria":"magazine","dias":["lunes","martes","miércoles","jueves","viernes"],"hora_inicio":"12:00 PM","hora_fin":"1:00 PM"},
  {"programa":"Varieté","categoria":"variedades","dias":["sábado","domingo"],"hora_inicio":"12:00 PM","hora_fin":"6:00 PM"},
  {"programa":"#Tardeando","categoria":"variedades","dias":["lunes","martes","miércoles","jueves","viernes"],"hora_inicio":"1:00 PM","hora_fin":"4:00 PM"},
  {"programa":"Trota Mundos","categoria":"música del mundo","dias":["lunes","martes","miércoles","jueves","viernes"],"hora_inicio":"4:00 PM","hora_fin":"5:00 PM"},
  {"programa":"Jazz Vespertino","categoria":"jazz","dias":["lunes","martes","miércoles","jueves","viernes"],"hora_inicio":"5:00 PM","hora_fin":"7:00 PM"},
  {"programa":"Masterclass del Rock","categoria":"rock","dias":["sábado"],"hora_inicio":"6:00 PM","hora_fin":"7:00 PM"},
  {"programa":"La Hora Vintage","categoria":"música retro","dias":["lunes"],"hora_inicio":"7:00 PM","hora_fin":"8:00 PM"},
  {"programa":"Brasileirices","categoria":"música brasileña","dias":["martes"],"hora_inicio":"7:00 PM","hora_fin":"8:00 PM"},
  {"programa":"Rock Total","categoria":"rock","dias":["miércoles"],"hora_inicio":"7:00 PM","hora_fin":"8:00 PM"},
  {"programa":"Africanerías","categoria":"música africana","dias":["jueves"],"hora_inicio":"7:00 PM","hora_fin":"8:00 PM"},
  {"programa":"Blues Bajo la Luna","categoria":"blues","dias":["lunes"],"hora_inicio":"8:00 PM","hora_fin":"9:00 PM"},
  {"programa":"Masterclass del Rock","categoria":"rock","dias":["martes"],"hora_inicio":"8:00 PM","hora_fin":"8:30 PM"},
  {"programa":"La Historia Continúa","categoria":"especial","dias":["miércoles"],"hora_inicio":"8:00 PM","hora_fin":"9:00 PM"},
  {"programa":"Vaivén","categoria":"música del mundo","dias":["jueves"],"hora_inicio":"8:00 PM","hora_fin":"9:00 PM"},
  {"programa":"Todos Cuentan","categoria":"especial","dias":["lunes"],"hora_inicio":"9:00 PM","hora_fin":"9:30 PM"},
  {"programa":"Apocalípticos Integrados","categoria":"variedades","dias":["martes"],"hora_inicio":"9:00 PM","hora_fin":"9:30 PM"},
  {"programa":"Varieté Latina","categoria":"variedades","dias":["sábado"],"hora_inicio":"7:00 PM","hora_fin":"12:00 AM"},
  {"programa":"Concierto Nocturno","categoria":"música clásica nocturna","dias":["lunes"],"hora_inicio":"9:30 PM","hora_fin":"12:00 AM"},
  {"programa":"Concierto Nocturno","categoria":"música clásica nocturna","dias":["martes"],"hora_inicio":"9:30 PM","hora_fin":"12:00 AM"},
  {"programa":"Concierto Nocturno","categoria":"música clásica nocturna","dias":["miércoles"],"hora_inicio":"9:00 PM","hora_fin":"12:00 AM"},
  {"programa":"Concierto Nocturno","categoria":"música clásica nocturna","dias":["jueves"],"hora_inicio":"9:00 PM","hora_fin":"12:00 AM"},
  {"programa":"Concierto Nocturno","categoria":"música clásica nocturna","dias":["domingo"],"hora_inicio":"8:00 PM","hora_fin":"12:00 AM"},
  {"programa":"Concierto de Madrugada","categoria":"música clásica nocturna","dias":["lunes","martes","miércoles","jueves","viernes","sábado","domingo"],"hora_inicio":"12:00 AM","hora_fin":"6:00 AM"},
];
