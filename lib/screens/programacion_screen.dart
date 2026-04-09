import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/schedule_data.dart';
import '../providers/schedule_provider.dart';
import '../theme/app_theme.dart';

const _dayNames  = ['lunes','martes','miércoles','jueves','viernes','sábado','domingo'];
const _dayLabels = ['Lun',  'Mar',   'Mié',      'Jue',   'Vie',    'Sáb',  'Dom'];

class ProgramacionScreen extends StatefulWidget {
  const ProgramacionScreen({super.key});

  @override
  State<ProgramacionScreen> createState() => _ProgramacionScreenState();
}

class _ProgramacionScreenState extends State<ProgramacionScreen> {
  late int _selectedDay;
  late final ScrollController _scroll;
  late final ScrollController _chipScroll;

  static const _rowHeight    = 72.0; // estimated item height + padding
  static const _listPadTop   = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().weekday - 1; // 0=Mon … 6=Sun
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

    // Scroll so the current row appears near the top (one row of context above)
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
    // Scroll chip row so selected chip is visible
    final chipOffset = (i * 56.0).clamp(0.0, double.infinity);
    _chipScroll.animateTo(
      chipOffset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    // After rebuild, scroll list to now if switching to today
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToNow());
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ScheduleProvider>(); // rebuild on minute tick
    final programs   = programsForDay(_dayNames[_selectedDay]);
    final now        = DateTime.now();
    final todayIndex = now.weekday - 1;
    final nowMinutes = now.hour * 60 + now.minute;

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
        const SizedBox(height: 16),

        // ── Day chips ─────────────────────────────────────────────────────────
        SizedBox(
          height: 34,
          child: ListView.builder(
            controller: _chipScroll,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 7,
            itemBuilder: (_, i) {
              final isSelected = i == _selectedDay;
              final isToday    = i == todayIndex;
              return Padding(
                padding: EdgeInsets.only(right: i < 6 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => _onDayTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF181818),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : isToday
                                ? AppColors.primary.withValues(alpha: 0.6)
                                : const Color(0xFF2E2E2E),
                        width: isToday && !isSelected ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _dayLabels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? Colors.white
                                : Colors.white60,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // ── Program list ──────────────────────────────────────────────────────
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            itemCount: programs.length,
            itemBuilder: (_, i) {
              final p   = programs[i];
              final end = p.endMinutes == 0 ? 1440 : p.endMinutes;
              final isNow = _selectedDay == todayIndex &&
                  nowMinutes >= p.startMinutes &&
                  nowMinutes < end;
              final isPast = _selectedDay == todayIndex &&
                  nowMinutes >= end;

              return _ProgramRow(
                program: p,
                isCurrent: isNow,
                isPast: isPast,
              );
            },
          ),
        ),
      ],
    );
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: isCurrent
              ? color.withValues(alpha: 0.12)
              : const Color(0xFF111111),
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: isCurrent
                  ? color
                  : isPast
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.white.withValues(alpha: 0.07),
              width: isCurrent ? 3 : 1,
            ),
            top: BorderSide(
              color: Colors.white.withValues(alpha: isCurrent ? 0.0 : 0.05),
              width: 0.5,
            ),
            right: BorderSide(
              color: Colors.white.withValues(alpha: isCurrent ? 0.0 : 0.05),
              width: 0.5,
            ),
            bottom: BorderSide(
              color: Colors.white.withValues(alpha: isCurrent ? 0.0 : 0.05),
              width: 0.5,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Time column
              SizedBox(
                width: 68,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      program.startLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isCurrent
                            ? Colors.white
                            : isPast
                                ? Colors.white38
                                : Colors.white70,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      program.endLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isCurrent
                            ? Colors.white54
                            : isPast
                                ? Colors.white24
                                : Colors.white38,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                width: 1, height: 30,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: isCurrent
                    ? color.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.08),
              ),

              // Name + category
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      program.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: isCurrent
                            ? Colors.white
                            : isPast
                                ? Colors.white54
                                : Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    _CategoryChip(color: color, label: program.category, faded: isPast),
                  ],
                ),
              ),

              // "AHORA" badge
              if (isCurrent) ...[
                const SizedBox(width: 10),
                _NowBadge(color: color),
              ],
            ],
          ),
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
            ? Colors.white.withValues(alpha: 0.05)
            : color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: faded ? Colors.white38 : color,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ─── Now badge ────────────────────────────────────────────────────────────────

class _NowBadge extends StatefulWidget {
  final Color color;
  const _NowBadge({required this.color});

  @override
  State<_NowBadge> createState() => _NowBadgeState();
}

class _NowBadgeState extends State<_NowBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.55, end: 1.0).animate(_ctrl),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: widget.color.withValues(alpha: 0.6)),
        ),
        child: Text(
          '● AHORA',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: widget.color,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
