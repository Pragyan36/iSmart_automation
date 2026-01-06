import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart/app/theme.dart';
import 'package:ismart/common/common/data_state.dart';
import 'package:ismart/common/constant/env.dart';
import 'package:ismart/common/navigation/navigation_service.dart';
import 'package:ismart/common/util/size_utils.dart';
import 'package:ismart/common/widget/common_container.dart';
import 'package:ismart/common/widget/custom_cached_network_image.dart';
import 'package:ismart/common/widget/no_data_screen.dart';
import 'package:ismart/common/widget/page_wrapper.dart';
import 'package:ismart/feature/favorite/scheduledpayment/widget/new.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';
import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

class ScheduletransferWidget extends StatefulWidget {
  const ScheduletransferWidget({super.key});

  @override
  State<ScheduletransferWidget> createState() => _ScheduletransferWidgetState();
}

class _ScheduletransferWidgetState extends State<ScheduletransferWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      scaffoldKey: _scaffoldKey,
      body: BlocBuilder<UtilityPaymentCubit, CommonState>(
        builder: (context, state) {
          // 🔄 Loading
          if (state is CommonLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (state is CommonError) {
            return Center(child: Text(state.message ?? 'Something went wrong'));
          }

          // ✅ Success
          if (state is CommonStateSuccess<UtilityResponseData>) {
            final response = state.data;
            final List<Map<String, dynamic>> scheduledPayments =
                List<Map<String, dynamic>>.from(
              response.details.first.value,
            );
            print('Scheduled Payments: $scheduledPayments');

            // if (scheduledPayments.isEmpty) {
            //   return const Center(child: Text('No Scheduled Transfers'));
            // }

            return CommonContainer(
              topbarName: "Scheduled Transfers",
              showRoundBotton: false,
              body: scheduledPayments.isEmpty
                  ? const Center(
                      child: Text(
                        'No Scheduled Transfers',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : Column(
                      children: List.generate(
                        scheduledPayments.length,
                        (index) {
                          final payment = scheduledPayments[index];

                          return InkWell(
                            onTap: () {
                              NavigationService.push(
                                target: BlocProvider(
                                  create: (context) => UtilityPaymentCubit(
                                    utilityPaymentRepository: RepositoryProvider
                                        .of<UtilityPaymentRepository>(context),
                                  ),
                                  child: ScheduledTransferDetailPage(
                                    payment: payment,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      width: _width * 0.15,
                                      height: _height * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      //url
                                      child: Image.asset(
                                        RepositoryProvider.of<CoOperative>(
                                                context)
                                            .coOperativeLogo,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(width: _width * 0.05),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Scheduled Transfer",
                                            style: _textTheme.labelMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Text(
                                            payment['toAccountNumber'] ?? 'N/A',
                                            style: _textTheme.labelLarge,
                                          ),
                                          Text(
                                            'Amount: ${payment['amount']}\n'
                                            'Date: ${_formatDate(payment['scheduledDateTime'])}',
                                            style: _textTheme.labelLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "NPR ${payment['amount']}",
                                          style: const TextStyle(
                                            fontFamily: "popinsemibold",
                                            fontSize: 12,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color:payment['status'] == 'PENDING' ? Colors.orange : Colors.red,
                                          ),
                                          child: Text(
                                            payment['status'],
                                            style: const TextStyle(
                                              color: CustomTheme.white,
                                              fontFamily: "popinsemibold",
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            );
          }

          return const NoDataScreen(
            title: '',
            details: '',
          );
        },
      ),
    );
  }

String _formatDate(dynamic dateString) {
  if (dateString == null) return '-';
  final date = DateTime.parse(dateString); // parse string to DateTime
  return '${date.day}/${date.month}/${date.year}';
}
}