/// Снимок завершённого периода; новый бюджет не меняет прошлые результаты.
class PeriodSummary {
  const PeriodSummary({
    required this.period,
    required this.plannedNeeds,
    required this.plannedWants,
    required this.plannedSavings,
    required this.actualNeeds,
    required this.actualWants,
    required this.netSaved,
    required this.needsMet,
    required this.withinPlan,
    required this.savedRegularly,
    required this.explanation,
  });
  final int period;
  final int plannedNeeds;
  final int plannedWants;
  final int plannedSavings;
  final int actualNeeds;
  final int actualWants;
  final int netSaved;
  final bool needsMet;
  final bool withinPlan;
  final bool savedRegularly;
  final String explanation;

  bool get supportsGrowth => needsMet && withinPlan && savedRegularly;
}
