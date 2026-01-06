import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart/app/theme.dart';
import 'package:ismart/common/common/data_state.dart';
import 'package:ismart/common/navigation/navigation_service.dart';
import 'package:ismart/common/util/numberRounded.dart';
import 'package:ismart/common/widget/common_button.dart';
import 'package:ismart/common/widget/show_loading_dialog.dart';
import 'package:ismart/common/widget/show_pop_up_dialog.dart';
import 'package:ismart/feature/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart/feature/more/transactionLimit/circular_indicator_widget.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';

class TransactionProgressComponent extends StatefulWidget {
  final String title;
  final String profileType;
  final bool isOpen;
  final bool persistOpen;

  const TransactionProgressComponent({
    super.key,
    required this.title,
    required this.profileType,
    required this.persistOpen,
    this.isOpen = false,
  });

  @override
  State<TransactionProgressComponent> createState() =>
      _TransactionProgressComponentState();
}

class _TransactionProgressComponentState
    extends State<TransactionProgressComponent> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool showCount = true;
  bool _isDialogVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.isOpen) {
      setState(() {
        _isExpanded = true;
      });
      onButtonPressed();
    }
  }

  Widget _buildExpandedContent(UtilityResponseData response) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: showCount ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
            children: [
              if (showCount) ...[
                MyCircularBar(
                  centerText: NumberUtils.to2Decimal(response.detail["usedDailyCount"]),
                  title: "Count",
                  maxLimit: "Max limit in count",
                  maxLimitVal: NumberUtils.to2Decimal(response.detail["dailyCountLimit"]),
                  primaryText: "Count",
                  primaryDesc: NumberUtils.to2Decimal(response.detail["usedDailyCount"]),
                  remainLimit: "Remaining Limit Count",
                  remainLimitVal: NumberUtils.to2Decimal(response.detail["remainingDailyCount"]),
                  percent: NumberUtils.to2DecimalDouble(
                    convertToFraction(
                      NumberUtils.to2DecimalDouble(response.detail["dailyCountLimit"]),
                      NumberUtils.to2DecimalDouble(response.detail["usedDailyCount"]),
                    ),
                  ),
                  color: CustomTheme.primaryColor,
                ),
                MyCircularBar(
                  centerText: "${NumberUtils.to2Decimal(
                    convertToFraction(
                      NumberUtils.to2DecimalDouble(response.detail["dailyAmountLimit"]),
                      NumberUtils.to2DecimalDouble(response.detail["usedDailyAmount"]),
                    ) * 100,
                  )}%",
                  title: "Amount Transfer",
                  maxLimit: "Max Amount Transfer",
                  maxLimitVal: "${NumberUtils.to2Decimal(response.detail["dailyAmountLimit"])} per day",
                  primaryText: "Amount Transfer",
                  primaryDesc: "NPR ${NumberUtils.to2Decimal(response.detail['usedDailyAmount'])}",
                  remainLimit: "Remaining Amount Transfer",
                  remainLimitVal: "NPR ${NumberUtils.to2Decimal(response.detail["remainingDailyAmount"])}",
                  percent: NumberUtils.to2DecimalDouble(
                    convertToFraction(
                      NumberUtils.to2DecimalDouble(response.detail["dailyAmountLimit"]),
                      NumberUtils.to2DecimalDouble(response.detail["usedDailyAmount"]),
                    ),
                  ),
                  color: CustomTheme.primaryColor,
                ),
              ],
              if (!showCount)
                MyCircularBar(
                  centerText: "${NumberUtils.to2Decimal(
                    convertToFraction(
                      NumberUtils.to2DecimalDouble(response.detail["monthlyAmountLimit"]),
                      NumberUtils.to2DecimalDouble(response.detail["usedMonthlyAmount"]),
                    ) * 100,
                  )}%",
                  title: "Amount Transfer",
                  maxLimit: "Max Amount Transfer",
                  maxLimitVal: "${NumberUtils.to2Decimal(response.detail["monthlyAmountLimit"])} per month",
                  primaryText: "Amount Transfer",
                  primaryDesc: "NPR ${NumberUtils.to2Decimal(response.detail['usedMonthlyAmount'])}",
                  remainLimit: "Remaining Amount Transfer",
                  remainLimitVal: "NPR ${NumberUtils.to2Decimal(response.detail["remainingMonthlyAmount"])}",
                  percent: NumberUtils.to2DecimalDouble(
                    convertToFraction(
                      NumberUtils.to2DecimalDouble(response.detail["monthlyAmountLimit"]),
                      NumberUtils.to2DecimalDouble(response.detail["usedMonthlyAmount"]),
                    ),
                  ),
                  color: CustomTheme.primaryColor,
                ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomRoundedButtom(
                  title: "Daily",
                  onPressed: () => setState(() => showCount = true),
                  color: showCount ? CustomTheme.primaryColor : Colors.grey.shade400,
                  fontWeight: FontWeight.bold,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                ),
                CustomRoundedButtom(
                  title: "Monthly",
                  onPressed: () => setState(() => showCount = false),
                  color: showCount ? Colors.grey.shade400 : CustomTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
                ),
                
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 7),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.transparent,
                  border: Border.all(color: Colors.grey.withOpacity(.5)),
                ),
                alignment: Alignment.center,
                height: 20,
                width: 180,
                child: Text(
                  "Per Transaction : ${NumberUtils.to2Decimal(response.detail['perTransactionLimit'])}",
                  style: const TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleLoadingDialog(bool show) async {
    if (show && !_isDialogVisible) {
      _isDialogVisible = true;
      await showLoadingDialogBox(context);
    } else if (!show && _isDialogVisible) {
      _isDialogVisible = false;
      if (Navigator.canPop(context)) NavigationService.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UtilityPaymentCubit, CommonState>(
      listener: (context, state) async {
        await _handleLoadingDialog(state is CommonLoading);
        if (state is CommonError) {
          await showPopUpDialog(
            context: context,
            message: state.message,
            title: "Error",
            showCancelButton: false,
            buttonCallback: () {
              if (Navigator.canPop(context)) NavigationService.pop();
            },
          );
        }
      },
      builder: (context, state) {
        UtilityResponseData? limitData;

        if (state is CommonStateSuccess<UtilityResponseData>) {
          final response = state.data;
          if (response.code == "M0000") {
            limitData = response;
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showPopUpDialog(
                context: context,
                message: response.message,
                title: "Error",
                buttonCallback: () {
                  if (Navigator.canPop(context)) NavigationService.pop();
                },
                showCancelButton: false,
              );
            });
          }
        }

        return Card(
          elevation: 0,
          borderOnForeground: false,
          color: Colors.white,
          child: InkWell(
            onTap: () {
              if (!widget.persistOpen) {
                setState(() => _isExpanded = !_isExpanded);
                if (_isExpanded) onButtonPressed();
              }
            },
            child: AnimatedSize(
              alignment: Alignment.topCenter,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 20,
                        child: Container(
                          alignment: AlignmentDirectional.topEnd,
                          width: 20,
                          height: 20,
                          child: Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff1c1c1c),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 5),
                                Container(
                                  width: 90,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: CustomTheme.primaryColor.withOpacity(.7),
                                  ),
                                ),
                                const SizedBox(width: 3),
                                Container(
                                  width: 5,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: CustomTheme.primaryColor.withOpacity(.7),
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (limitData != null)
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -1.0,
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                              child: _isExpanded
                                  ? KeyedSubtree(
                                      key: const ValueKey<String>('expanded'),
                                      child: _buildExpandedContent(limitData),
                                    )
                                  : const SizedBox.shrink(
                                      key: ValueKey<String>('collapsed'),
                                    ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onButtonPressed() {
    context.read<UtilityPaymentCubit>().fetchDetails(
          serviceIdentifier: '',
          accountDetails: {
            "profileType": widget.profileType,
            "accountNumber":
                RepositoryProvider.of<CustomerDetailRepository>(context)
                    .selectedAccount
                    .value!
                    .accountNumber,
          },
          apiEndpoint: "api/limit",
        );
  }

  double convertToFraction(double total, double used) {
    return total > 0 ? (used / total) : 0;
  }
}
