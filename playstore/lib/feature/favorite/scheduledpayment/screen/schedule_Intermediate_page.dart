import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart/feature/favorite/scheduledpayment/widget/SchedulePayment_widget.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

class ScheduleIntermediatePage extends StatelessWidget {
    final bool? pageType;
  final bool? isFavAccount;
  final String? branchName;
  final String? accountNumber;
  final String? accountName;
  final String? branchCode;
  final String? remarks;
  final String? branchId;
  // final List<Map<String, dynamic>>? recurrenceItems;

  const ScheduleIntermediatePage({Key? key,
      this.pageType,
      this.accountNumber,
      this.accountName,
      this.branchCode,
      this.remarks,
      this.isFavAccount,
      this.branchName,
      // this.recurrenceItems,
      this.branchId});

  @override
  Widget build(BuildContext context) {
    // return  BlocProvider(
    //       create: (context) => UtilityPaymentCubit(
    //         utilityPaymentRepository:
    //             RepositoryProvider.of<UtilityPaymentRepository>(context),
    //       ),
    //       child: SchedulePaymentWidget(
    //     pageType: pageType,
    //     branchId: branchId ?? "",
    //     isFavAccount: isFavAccount,
    //     branchName: branchName,
    //     remarks: remarks,
    //     accountName: accountName,
    //     accountNumber: accountNumber,
    //     branchCodeQr: branchCode,
    //     recurrenceItems: recurrenceItems,
    //   ),);
    return SchedulePaymentWidget(
        pageType: pageType,
        branchId: branchId ?? "",
        isFavAccount: isFavAccount,
        branchName: branchName,
        remarks: remarks,
        accountName: accountName,
        accountNumber: accountNumber,
        branchCodeQr: branchCode,
        // recurrenceItems: recurrenceItems,
      );
  }
}
