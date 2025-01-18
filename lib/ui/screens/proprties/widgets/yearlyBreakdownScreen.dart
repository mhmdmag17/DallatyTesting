import 'package:ebroker/data/model/mortgage_calculator_model.dart';
import 'package:ebroker/exports/main_export.dart';
import 'package:flutter/material.dart';

class YearlyBreakdownScreen extends StatefulWidget {
  const YearlyBreakdownScreen({
    required this.mortgageCalculatorModel,
    super.key,
  });
  final MortgageCalculatorModel mortgageCalculatorModel;

  @override
  State<YearlyBreakdownScreen> createState() => _YearlyBreakdownScreenState();
}

class _YearlyBreakdownScreenState extends State<YearlyBreakdownScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.mortgageCalculatorModel.yearlyTotals.isEmpty
        ? const Center(
            child: NoDataFound(),
          )
        : Scaffold(
            appBar: UiUtils.buildAppBar(
              context,
              showBackButton: true,
              title: 'yearlyBreakdown'.translate(context),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      color: context.color.tertiaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSummaryRow(
                          'principalAmount'.translate(context),
                          '${Constant.currencySymbol} ${widget.mortgageCalculatorModel.mainTotal?.principalAmount}',
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                        _buildSummaryRow(
                          'monthlyEMI'.translate(context),
                          '${Constant.currencySymbol} ${widget.mortgageCalculatorModel.mainTotal?.monthlyEmi}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ...List.generate(
                    widget.mortgageCalculatorModel.yearlyTotals.length,
                    (index) {
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 8),
                        child: _buildYearContent(
                          yearData: widget
                              .mortgageCalculatorModel.yearlyTotals[index],
                          initiallyExpanded: index == 0,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildYearContent({
    required YearlyTotals yearData,
    required bool initiallyExpanded,
  }) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      childrenPadding: EdgeInsets.zero,
      expandedAlignment: Alignment.centerLeft,
      iconColor: context.color.tertiaryColor,
      collapsedIconColor: context.color.inverseSurface,
      title: Text(yearData.year ?? '').bold().size(18),
      textColor: context.color.tertiaryColor,
      collapsedTextColor: context.color.textColorDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: context.color.borderColor,
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: context.color.borderColor,
        ),
      ),
      collapsedBackgroundColor: context.color.secondaryColor,
      backgroundColor: context.color.secondaryColor,
      initiallyExpanded: initiallyExpanded,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            _buildSummaryRow(
              'principalAmount'.translate(context),
              '${Constant.currencySymbol} ${yearData.principalAmount}',
            ),
            const Spacer(),
            _buildSummaryRow(
              'outstandingAmount'.translate(context),
              '${Constant.currencySymbol} ${yearData.remainingBalance}',
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        _buildPaymentScheduleTable(monthData: yearData.monthlyTotals ?? []),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget _buildPaymentScheduleTable({required List<MonthlyTotals> monthData}) {
    const cellPadding = 12.0;
    return DataTable(
      dividerThickness: 0,
      horizontalMargin: 10,
      columnSpacing: 4,
      headingRowColor: WidgetStatePropertyAll(context.color.tertiaryColor),
      columns: [
        DataColumn(
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: cellPadding),
            child: Text('month'.translate(context))
                .bold()
                .color(context.color.primaryColor)
                .size(12),
          ),
        ),
        DataColumn(
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: cellPadding),
            child: Text('principal'.translate(context))
                .bold()
                .color(context.color.primaryColor)
                .size(12),
          ),
        ),
        DataColumn(
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: cellPadding),
            child: Text('interest'.translate(context))
                .bold()
                .color(context.color.primaryColor)
                .size(12),
          ),
        ),
        DataColumn(
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: cellPadding),
            child: Text('outstanding'.translate(context))
                .bold()
                .color(context.color.primaryColor)
                .size(12),
          ),
        ),
      ],
      rows: List.generate(
        monthData.length,
        (index) => DataRow(
          color: index.isOdd
              ? WidgetStatePropertyAll(
                  context.color.tertiaryColor.withOpacity(0.1),
                )
              : WidgetStatePropertyAll(context.color.secondaryColor),
          cells: [
            DataCell(
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: cellPadding),
                child: Text(
                  '${monthData[index].month?.substring(0, 3)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ).firstUpperCaseWidget(),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: cellPadding),
                child: Text(
                  '${Constant.currencySymbol} ${monthData[index].principalAmount}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: cellPadding),
                child: Text(
                  '${Constant.currencySymbol} ${monthData[index].payableInterest}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: cellPadding),
                child: Text(
                  '${Constant.currencySymbol} ${monthData[index].remainingBalance}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
