import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart/app/theme.dart';
import 'package:ismart/common/common/data_state.dart';
import 'package:ismart/common/navigation/navigation_service.dart';
import 'package:ismart/common/util/size_utils.dart';
import 'package:ismart/common/widget/common_button.dart';
import 'package:ismart/common/widget/common_transaction_success_screen.dart';
import 'package:ismart/common/widget/key_value_tile.dart';
import 'package:ismart/common/widget/page_wrapper.dart';
import 'package:ismart/common/widget/show_loading_dialog.dart';
import 'package:ismart/common/widget/show_pop_up_dialog.dart';
import 'package:ismart/common/widget/transactipon_pin_screen.dart';
import 'package:ismart/feature/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart/feature/favorite/scheduledpayment/screen/scheduletransfer_page.dart';
import 'package:ismart/feature/favorite/scheduledpayment/widget/scheduletransfer_widget.dart';
import 'package:ismart/feature/sendMoney/internalCooperative/cubits/internal_transfer_cubit.dart';
import 'package:ismart/feature/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';
import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

class SchedulePaymentBillWidget extends StatelessWidget {
  final String schdeuleDate;
  final bool isRecurring;
  final String recurrenceType;
  final String amount;
  final String accountNumber;
  final String accountName;
  final String remarks;
  final String limit;
  final String branchCode;
  final Widget body;
  final String message;

  const SchedulePaymentBillWidget(
      {super.key,
      required this.schdeuleDate,
      required this.isRecurring,
      required this.recurrenceType,
      required this.amount,
      required this.accountNumber,
      required this.accountName,
      required this.limit,
      required this.remarks,
      required this.branchCode,
      required this.body,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UtilityPaymentCubit(
            utilityPaymentRepository:
                RepositoryProvider.of<UtilityPaymentRepository>(context),
          ),
      child: SchedulePaymentDetailBillWidget(
        isRecurring: isRecurring,
        recurrenceType: recurrenceType,
        scheduledDatetime: schdeuleDate,
        accountName: accountName,
        accountNumber: accountNumber,
        amount: amount,
        body: body,
        branchCode: branchCode,
        message: message,
        remarks: remarks,
        limit: limit,
      ),
    );
  }
}

// ignore: must_be_immutable
class SchedulePaymentDetailBillWidget extends StatefulWidget {
  final String scheduledDatetime;
  final bool isRecurring;
  final String recurrenceType;
  final String amount;
  final String limit;
  final String accountNumber;
  final String accountName;
  final String remarks;
  final String branchCode;
  final Widget body;
  final String message;

  const SchedulePaymentDetailBillWidget(
      {super.key,
      required this.scheduledDatetime,
      required this.isRecurring,
      required this.recurrenceType,
      required this.amount,
      required this.accountNumber,
      required this.accountName,
      required this.limit,  
      required this.remarks,
      required this.branchCode,
      required this.body,
      required this.message});

  @override
  State<SchedulePaymentDetailBillWidget> createState() => _SchedulePaymentDetailBillWidgetState();
}

class _SchedulePaymentDetailBillWidgetState extends State<SchedulePaymentDetailBillWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;

    return PageWrapper(
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && _isLoading == false) {
            _isLoading = true;
            showLoadingDialogBox(context);
            return;
          } else if (state is! CommonLoading && _isLoading) {
            _isLoading = false;
            NavigationService.pop();
          }

          if (state is CommonStateSuccess<UtilityResponseData>) {
  
              NavigationService.push(target: const ScheduleTransferPage());
          }
          else if (state is CommonError) {
           showPopUpDialog(
              context: context,
              message: state.message,
              title: "Error",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }
        },
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: CustomTheme.white,
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        NavigationService.pop();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  SizedBox(height: _height * 0.02),
                  Text(widget.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall),
                  SizedBox(height: _height * 0.02),
                  const Divider(thickness: 1),
                  SizedBox(height: _height * 0.02),
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFF3F3F3),
                      // border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Paymet Details",
                            style: Theme.of(context).textTheme.titleLarge),
                        SizedBox(height: _height * 0.02),
                         KeyValueTile(
      title: "Scheduled Date & Time",
      value: widget.scheduledDatetime.toString(),
    ),
    KeyValueTile(
      title: "Recurring",
      value: widget.isRecurring ? "Yes" : "No",
    ),
    KeyValueTile(
      title: "Recurrence Type",
      value: widget.recurrenceType,
    ),
    KeyValueTile(
      title: "Amount",
      value: widget.amount.toString(),
    ),
    KeyValueTile(
      title: "Account Number",
      value: widget.accountNumber,
    ),
    KeyValueTile(
      title: "Recurrence Limit",
      value: widget.limit,
    ),
    KeyValueTile(
      title: "Remarks",
      value: widget.remarks,
    ),
    KeyValueTile(
      title: "Branch Code",
      value: widget.branchCode,
    ),
                        widget.body
                      ],
                    ),
                  ),
                  SizedBox(height: _height * 0.02),
                 CustomRoundedButtom(
  title: "ADD",
  onPressed: () {
    context.read<UtilityPaymentCubit>().fetchDetailsPost(
      serviceIdentifier: '',
      accountDetails: {
        "amount": widget.amount,
        "recurrence_limit": widget.limit,
        "remarks": widget.remarks,
        "to_account_number": widget.accountNumber,
        "bank_branch_id": widget.branchCode,
        "from_account_number": RepositoryProvider
                .of<CustomerDetailRepository>(context)
            .selectedAccount
            .value!
            .accountNumber,
        "scheduled_date_time": widget.scheduledDatetime,
        "is_recurring": widget.isRecurring,
        "recurrence_type": widget.recurrenceType,
      },
      apiEndpoint: "api/scheduled-transfer/create",
      shouldIncludeMPIN: false, // explicitly not sending mPin
    );
  },
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}