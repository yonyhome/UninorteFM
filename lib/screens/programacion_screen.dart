import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/schedule_data.dart';
import '../providers/schedule_provider.dart';
import '../theme/app_theme.dart';

const _dayNames  = ['lunes','martes','miércoles','jueves','viernes','sábado','domingo'];
const _dayLabels = ['LUN','MAR','MIÉ','JUE','VIE','SÁB','DOM'];

class ProgramacionScreen extends StatefulWidget {
  const ProgramacionScreen({super.key});

  @override
  State<ProgramacionScreen> createState() => _ProgramacionScreenState();
}

class _ProgramacionScreenState extends State<ProgramacionScreen> {
  late int _selectedDay;
  late final ScrollController _scroll;
  late final ScrollController _chipScroll;

  static const _rowHeight  = 80.0;
  static const _listPadTop = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().weekday - 1;
    _scroll      = ScrollController();
    _chipScroll  = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
  }

  @override
  void dispose() {
    _scroll.dispose();
    _chipScroll.dispose();
    super.dispose();
  }

  void _scrollToNow() {
    if (!mounted) return;
    final now        = DateTime.now();
    final todayIndex = now.weekday - 1;
    if (_selectedDay != todayIndex) return;

    final programs   = programsForDay(_dayNames[_selectedDay]);
    final nowMinutes = now.hour * 60 + now.minute;
    final idx = programs.indexWhere((p) {
      final end = p.endMinutes == 0 ? 1440 : p.endMinutes;
      return nowMinutes >= p.startMinutes && nowMinutes < end;
    });
    if (idx < 1) return;

    final target = ((idx - 1) * _rowHeight + _listPadTop)
        .clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.animateTo(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  void _onDayTap(int i) {
    setState(() => _selectedDay = i);
    final chipOffset = (i * 58.0).clamp(0.0, double.infinity);
    _chipScroll.animateTo(
      chipOffset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ScheduleProvider>();
    final programs   = programsForDay(_dayNames[_selectedDay]);
    final now        = DateTime.now();
    final todayIndex = now.weekday - 1;
    final nowMinutes = now.hour * 60 + now.minute;
    final isToday    = _selectedDay == todayIndex;

    // Encontrar el programa actual (si existe y es hoy)
    final currentProgram = isToday
        ? programs.where((p) {
            final end = p.endMinutes == 0 ? 1440 : p.endMinutes;
            return nowMinutes >= p.startMinutes && nowMinutes < end;
          }).firstOrNull
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ────────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Container(
                width: 4, height: 24,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Programación',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // ── Day selector estilo ROVR ──────────────────────────────────────────
        SizedBox(
          height: 52,
          child: ListView.builder(
            controller: _chipScroll,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 7,
            itemBuilder: (_, i) {
              final isSelected = i == _selectedDay;
              final isT        = i == todayIndex;
              return Padding(
                padding: EdgeInsets.only(right: i < 6 ? 6 : 0),
                child: GestureDetector(
                  onTap: () => _onDayTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isT
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : isT
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.1),
                        width: isT && !isSelected ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _dayLabels[i],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? Colors.white
                            : isT
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.4),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // ── NOW PLAYING card (solo si hay programa actual hoy) ────────────────
        if (currentProgram != null) ...[
          _NowPlayingCard(program: currentProgram, nowMinutes: nowMinutes),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 2),
            child: Text(
              'A CONTINUACIÓN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.white.withValues(alpha: 0.3),
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],

        // ── Lista de programas ─────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 120),
            itemCount: programs.length,
            itemBuilder: (_, i) {
              final p   = programs[i];
              final end = p.endMinutes == 0 ? 1440 : p.endMinutes;
              final isNow  = isToday &&
                  nowMinutes >= p.startMinutes && nowMinutes < end;
              final isPast = isToday && nowMinutes >= end;

              // Ocultar el actual ya que lo mostramos en la card grande
              if (isNow && currentProgram != null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _ProgramRow(
                  program: p,
                  isCurrent: isNow,
                  isPast: isPast,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── NOW PLAYING card grande ──────────────────────────────────────────────────

class _NowPlayingCard extends StatefulWidget {
  final Program program;
  final int nowMinutes;

  const _NowPlayingCard({required this.program, required this.nowMinutes});

  @override
  State<_NowPlayingCard> createState() => _NowPlayingCardState();
}

class _NowPlayingCardState extends State<_NowPlayingCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p      = widget.program;
    final color  = p.color;
    final end    = p.endMinutes == 0 ? 1440 : p.endMinutes;
    final total  = end - p.startMinutes;
    final elapsed = widget.nowMinutes - p.startMinutes;
    final progress = total > 0
        ? (elapsed / total).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.25),
              color.withValues(alpha: 0.06),
              const Color(0xFF0A0A0A),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          border: Border.all(
            color: color.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chip AHORA + tiempo restante
              Row(
                children: [
                  // Dot pulsante
                  FadeTransition(
                    opacity: Tween<double>(begin: 0.4, end: 1.0)
                        .animate(_pulse),
                    child: Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: color, shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'AHORA EN VIVO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: color,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${p.startLabel} – ${p.endLabel}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Nombre del programa — tipografía grande estilo ROVR
              Text(
                p.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Chip de categoría
              _CategoryChip(color: color, label: p.category, faded: false),
              const SizedBox(height: 16),

              // Barra de progreso del programa
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 8),

              // Tiempo restante
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    p.startLabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _remainingLabel(end - widget.nowMinutes),
                    style: TextStyle(
                      fontSize: 10,
                      color: color.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    p.endLabel,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _remainingLabel(int remainingMinutes) {
    if (remainingMinutes <= 0) return 'Terminando';
    if (remainingMinutes < 60) return 'Faltan $remainingMinutes min';
    final h = remainingMinutes ~/ 60;
    final m = remainingMinutes % 60;
    return m == 0 ? 'Falta ${h}h' : 'Falta ${h}h ${m}min';
  }
}

// ─── Program row ──────────────────────────────────────────────────────────────

class _ProgramRow extends StatelessWidget {
  final Program program;
  final bool isCurrent;
  final bool isPast;

  const _ProgramRow({
    required this.program,
    required this.isCurrent,
    required this.isPast,
  });

  @override
  Widget build(BuildContext context) {
    final color = program.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        color: isCurrent
            ? color.withValues(alpha: 0.10)
            : const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: isCurrent
                ? color
                : isPast
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.white.withValues(alpha: 0.06),
            width: isCurrent ? 3 : 1,
          ),
          top: BorderSide(
            color: Colors.white.withValues(alpha: isCurrent ? 0.0 : 0.04),
            width: 0.5,
          ),
          right: BorderSide(
            color: Colors.white.withValues(alpha: isCurrent ? 0.0 : 0.04),
            width: 0.5,
          ),
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: isCurrent ? 0.0 : 0.04),
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bloque de tiempo — columna izquierda prominente
            Container(
              width: 76,
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    program.startLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: isCurrent
                          ? Colors.white
                          : isPast
                              ? Colors.white24
                              : Colors.white.withValues(alpha: 0.75),
                      fontFeatures: const [FontFeature.tabularFigures()],
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    program.endLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isCurrent
                          ? Colors.white38
                          : isPast
                              ? Colors.white12
                              : Colors.white24,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),

            // Separador vertical
            Container(
              width: 1, height: 36,
              color: isCurrent
                  ? color.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.07),
            ),
            const SizedBox(width: 12),

            // Nombre + categoría
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    program.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isPast
                          ? Colors.white38
                          : Colors.white,
                      height: 1.2,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  _CategoryChip(
                      color: color,
                      label: program.category,
                      faded: isPast),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category chip ────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final Color color;
  final String label;
  final bool faded;

  const _CategoryChip({
    required this.color,
    required this.label,
    required this.faded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: faded
            ? Colors.white.withValues(alpha: 0.04)
            : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: faded ? Colors.white24 : color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
