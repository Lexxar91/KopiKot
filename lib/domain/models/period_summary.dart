/// Снимок завершённого периода; новый бюджет не меняет прошлые результаты.
class PeriodSummary {
  const PeriodSummary({
    required this.period,
    required this.plannedNeeds,
    this.plannedIncome,
    required this.plannedWants,
    required this.plannedSavings,
    this.plannedGifts = 0,
    required this.actualNeeds,
    required this.actualWants,
    this.actualGifts = 0,
    required this.netSaved,
    required this.needsMet,
    required this.withinPlan,
    required this.savedRegularly,
    required this.explanation,
    this.dayKey,
    this.missedDays = 0,
  });
  final int period;
  final int plannedNeeds;

  /// null у итогов, сохранённых до появления прогноза дохода.
  final int? plannedIncome;
  final int plannedWants;
  final int plannedSavings;
  final int plannedGifts;
  final int actualNeeds;
  final int actualWants;
  final int actualGifts;
  final int netSaved;
  final bool needsMet;
  final bool withinPlan;
  final bool savedRegularly;
  final String explanation;
  final String? dayKey;
  final int missedDays;

  bool get supportsGrowth => needsMet && withinPlan && savedRegularly;
}
