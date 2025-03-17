import 'metrics_card.dart';
import '../../analytics/analytics_sales_card/analytics_sales_card_view.dart';

class AIChatMetricsTwoCard extends AIChatMetricsCard {
   const AIChatMetricsTwoCard({
    super.key,
    required super.data,
    super.cardViewType = AnalyticsSalesCardViewType.two,
  });
}