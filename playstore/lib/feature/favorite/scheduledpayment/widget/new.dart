import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart/app/theme.dart';
import 'package:ismart/common/common/data_state.dart';
import 'package:ismart/common/constant/assets.dart';
import 'package:ismart/common/constant/env.dart';
import 'package:ismart/common/navigation/navigation_service.dart';
import 'package:ismart/common/route/routes.dart';
import 'package:ismart/common/util/file_download_utils.dart';
import 'package:ismart/common/util/size_utils.dart';
import 'package:ismart/common/widget/custom_cached_network_image.dart';
import 'package:ismart/common/widget/page_wrapper.dart';
import 'package:ismart/common/widget/screen_appbar.dart';
import 'package:ismart/common/widget/show_pop_up_dialog.dart';
import 'package:ismart/feature/dashboard/screen/dashboard_page.dart';
import 'package:ismart/feature/favorite/scheduledpayment/screen/scheduletransfer_page.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';

class ScheduledTransferDetailPage extends StatefulWidget {
  final Map<String, dynamic> payment;

  const ScheduledTransferDetailPage({
    super.key,
    required this.payment,
  });

  @override
  State<ScheduledTransferDetailPage> createState() =>
      _ScheduledTransferDetailPageState();
}

class _ScheduledTransferDetailPageState
    extends State<ScheduledTransferDetailPage> {
  //       @override
  //       void initState() {
  //   context.read<UtilityPaymentCubit>().fetchDetails(
  //         serviceIdentifier: "",
  //         accountDetails: {
  //           "id": widget.payment['id'].toString(),

  //         },
  //         apiEndpoint: "api/scheduled-transfer//cancel",
  //       );
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    // final e = widget.recentTransactionModel;
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return PageWrapper(
      padding: EdgeInsets.zero,
      backgroundColor: CustomTheme.white,
      showAppBar: false,
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonStateSuccess<UtilityResponseData>) {
            NavigationService.pushNamedAndRemoveUntil(routeName: Routes.schedulePaymentStatement,
);
            // NavigationService.push(target: ScheduleTransferPage());// Close detail page
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              const ScreenAppBar(
                title: "Transaction Detail",
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Scheduled Transfer",
                                style: _textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                _formatDate(
                                    widget.payment['scheduledDateTime']),
                                style: _textTheme.titleSmall,
                              ),
                              Text(
                                "Recurrence Limit",
                                style: _textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                 widget.payment['recurrenceLimit']?.toString() ?? "-",
                                style: _textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              // Text(
                              //   "Transaction ID : " +
                              //       r.transactionIdentifier.toString(),
                              //   style: _textTheme.titleSmall,
                              // ),
                              Text(
                                widget.payment['status']?.toString() ?? "-",
                                style: _textTheme.titleSmall!.copyWith(
                                    color:
                                        widget.payment['status'] == "Complete"
                                            ? CustomTheme.green
                                            : CustomTheme.googleColor),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: CustomCachedNetworkImage(
                              fit: BoxFit.cover,
                              height: 50.hp,
                              //url to be fixed
                              url: RepositoryProvider.of<CoOperative>(context)
                                  .coOperativeLogo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(children: [
                        if(widget.payment['status'] == "PENDING")...[
                        InkWell(
                          onTap: () {
                            showPopUpDialog(
                              context: context,
                              title: "Delete Scheduled Transfer",
                              message:
                                  "Are you sure you want to delete this scheduled transfer?",
                              buttonText: "Delete",
                              buttonCallback: () {
                                final id = widget.payment['id'];
                                debugPrint("Scheduled Transfer ID: $id");
                                // Call API ONLY after confirmation
                                context.read<UtilityPaymentCubit>().deleteReq(
                                    serviceIdentifier: "",
                                    accountDetails: {
                                      "id": id,
                                    },
                                    apiEndpoint:
                                        "/api/scheduled-transfer//cancel/$id",
                                    mPin: "");

                                NavigationService.pop(); // close dialog
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                                color: CustomTheme.googleColor.withOpacity(.70),
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  Assets.delete,
                                  height: 25.hp,
                                ),
                                Text(
                                  "Delete",
                                  style: _textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]]),
                    ),
                   
                    const Divider(),
                    Text(
                      "Destination A/C No.",
                      style: _textTheme.titleSmall!
                          .copyWith(color: CustomTheme.darkGray, fontSize: 11),
                    ),
                    Text(
                      widget.payment['toAccountNumber']?.toString() ?? 'N/A',
                      style: _textTheme.titleSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.hp),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 1 / 0.3),
                      children: [
                        customKeyValue(
                            title: "Service", value: "Scheduled Transfer"),
                        customKeyValue(
                          title: "Branch Code",
                          value: (widget.payment['toAccountNumber']
                                          ?.toString()
                                          .length ??
                                      0) >=
                                  3
                              ? widget.payment['toAccountNumber']
                                  .toString()
                                  .substring(0, 3)
                              : widget.payment['toAccountNumber']?.toString() ??
                                  "N/A",
                        ),
                        customKeyValue(
                          title: "Account",
                          value: widget.payment['toAccountNumber']
                                  ?.toString()
                                  .substring(3) ??
                              "N/A",
                        ),
                        customKeyValue(
                          title: "IS Recurring",
                          value: widget.payment['isRecurring']?.toString() ??
                              'N/A',
                        ),
                        customKeyValue(
                          title: "Total Amt",
                          value: widget.payment['amount']?.toString() ?? 'N/A',
                        ),
                        customKeyValue(
                          title: "Recurrence Type",
                          value: widget.payment['recurrenceType']?.toString() ??
                              'N/A',
                        ),
                        customKeyValue(
                          title: "Channel",
                          value: widget.payment['channelType']
                                      ?.toString()
                                      .toLowerCase() ==
                                  "GPRS".toLowerCase()
                              ? "Online"
                              : "SMS",
                        ),
                        customKeyValue(
                          title: "Remarks",
                          value:
                              widget.payment['remarks']?.toString().isEmpty ??
                                      true
                                  ? "-"
                                  : widget.payment['remarks'].toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  customKeyValue({required String title, required String value}) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleSmall!
              .copyWith(color: CustomTheme.darkGray, fontSize: 11),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

String _formatDate(dynamic dateString) {
  if (dateString == null) return '-';
  final date = DateTime.parse(dateString); // parse string to DateTime
  return '${date.day}/${date.month}/${date.year}';
}