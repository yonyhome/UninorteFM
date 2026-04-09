import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/schedule_data.dart';
import '../providers/schedule_provider.dart';
import '../theme/app_theme.dart';

const _dayNames = [
  'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo',
];
const _dayLabels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

class ProgramacionScreen extends StatefulWidget {
  const ProgramacionScreen({super.key});

  @override
  State<ProgramacionScreen> createState() => _ProgramacionScreenState();
}

class _ProgramacionScreenState extends State<ProgramacionScreen> {
  late int _selectedDay; // 0 = lunes … 6 = domingo

  @override
  void initState() {
    super.initState();
    // DateTime.weekday: 1=Mon … 7=Sun → index 0–6
    _selectedDay = DateTime.now().weekday - 1;
  }

  @override
  Widget build(BuildContext context) {
    final schedule = context.watch<ScheduleProvider>();
    final programs = programsForDay(_dayNames[_selectedDay]);
    final now = DateTime.now();
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
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 7,
            itemBuilder: (_, i) {
              final isSelected = i == _selectedDay;
              final isToday = i == todayIndex;
              return Padding(
                padding: EdgeInsets.only(right: i < 6 ? 8 : 0),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDay = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF161616),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : isToday
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : const Color(0xFF2A2A2A),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _dayLabels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : Colors.white54,
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            itemCount: programs.length,
            itemBuilder: (_, i) {
              final p = programs[i];
              final end = p.endMinutes == 0 ? 1440 : p.endMinutes;
              final isNow = _selectedDay == todayIndex &&
                  nowMinutes >= p.startMinutes &&
                  nowMinutes < end;
              // Mark as current even when using ScheduleProvider
              // (they should agree, but guard against edge cases)
              final isCurrent = isNow ||
                  (schedule.current?.name == p.name &&
                      schedule.current?.startMinutes == p.startMinutes);

              return _ProgramRow(
                program: p,
                isCurrent: isCurrent,
                isPast: _selectedDay == todayIndex &&
                    nowMinutes >= end,
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
    final dimmed = isPast && !isCurrent;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: isCurrent
              ? color.withValues(alpha: 0.10)
              : const Color(0xFF0E0E0E),
          borderRadius: BorderRadius.circular(14),
          border: Border(
            left: BorderSide(
              color: isCurrent ? color : Colors.transparent,
              width: 3,
            ),
            top: BorderSide(color: const Color(0xFF1A1A1A), width: 0.5),
            right: BorderSide(color: const Color(0xFF1A1A1A), width: 0.5),
            bottom: BorderSide(color: const Color(0xFF1A1A1A), width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Time column
              SizedBox(
                width: 72,
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
                            : dimmed
                                ? Colors.white24
                                : Colors.white54,
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
                            ? Colors.white38
                            : dimmed
                                ? Colors.white12
                                : Colors.white24,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),

              // Divider
              Container(
                width: 1,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: isCurrent
                    ? color.withValues(alpha: 0.4)
                    : Colors.white.withValues(alpha: 0.07),
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
                        color: dimmed ? Colors.white30 : Colors.white,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    _CategoryChip(
                      label: program.category,
                      color: color,
                      dimmed: dimmed,
                    ),
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
  final String label;
  final Color color;
  final bool dimmed;

  const _CategoryChip({
    required this.label,
    required this.color,
    required this.dimmed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: dimmed
            ? Colors.white.withValues(alpha: 0.04)
            : color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: dimmed
              ? Colors.white24
              : color,
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
      opacity: Tween(begin: 0.6, end: 1.0).animate(_ctrl),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: widget.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: widget.color.withValues(alpha: 0.5)),
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
