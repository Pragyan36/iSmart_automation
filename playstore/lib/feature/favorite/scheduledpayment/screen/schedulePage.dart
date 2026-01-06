import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart/feature/favorite/scheduledpayment/screen/schedule_Intermediate_page.dart';
import 'package:ismart/feature/sendMoney/internalCooperative/cubits/coop_list_cubit.dart';
import 'package:ismart/feature/sendMoney/internalCooperative/resources/internal_transfer_repository.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage(
      {super.key,
     });
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider(
    //         create: (context) => UtilityPaymentCubit(
    //               utilityPaymentRepository:
    //                   RepositoryProvider.of<UtilityPaymentRepository>(context),
    //             )..fetchDetails(
    //                 serviceIdentifier: '',
    //                 accountDetails: {},
    //                 apiEndpoint: 'api/scheduled-transfer/recurrence-types',
    //               )),
        // BlocProvider(
        //   create: (context) => CoopListCubit(
        //     internalTransferRepository:
        //         RepositoryProvider.of<InternalTransferRepository>(context)
        //           ..getBranchList(),
        //   ),
        // ),
    //   ],
    //   // child: SchedulePaymentWidget(
    //   //   pageType: pageType,
    //   //   branchId: branchId ?? "",
    //   //   isFavAccount: isFavAccount,
    //   //   branchName: branchName,
    //   //   remarks: remarks,
    //   //   accountName: accountName,
    //   //   accountNumber: accountNumber,
    //   //   branchCodeQr: branchCode,
    //   // ),
    //   child: BlocBuilder<UtilityPaymentCubit, CommonState>(
    //     builder: (context, state) {
    //       if(state is CommonStateSuccess<UtilityResponseData>){
    //              final UtilityResponseData _response = state.data;
    //           final List<String> recurrenceTypes =
    //               (_response.details.first.value as List<dynamic>)
    //                   .map((e) => e.toString())
    //                   .toList();
    //                   NavigationService.push(target: ScheduleIntermediatePage(recurrenceItems: recurrenceTypes.map((e) => {"text": e}).toList(),));
    //       }
    //               if (state is CommonLoading) {
    //                 return const CommonLoadingWidget();
    //               } else {
    //                 return Container();
    //               }
    //     },
    //     // listener: (context, state) {
    //     //    if (state is CommonLoading && _isLoading == false) {
    //     //     _isLoading = true;
    //     //     showLoadingDialogBox(context);
    //     //   } else if (state is! CommonLoading && _isLoading) {
    //     //     _isLoading = false;
    //     //     NavigationService.pop();
    //     //   }

    //     //   if (state is CommonStateSuccess<UtilityResponseData>) {
    //     //     final UtilityResponseData _response = state.data;
    //     //       final List<String> recurrenceTypes =
    //     //           (_response.details.first.value as List<dynamic>)
    //     //               .map((e) => e.toString())
    //     //               .toList();
    //     //               NavigationService.push(target: ScheduleIntermediatePage(recurrenceItems: recurrenceTypes.map((e) => {"text": e}).toList(),));

    //     //     }
    //     // },
    //     // child: ScheduleIntermediatePage(),
    //   ),
    // );
    return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => UtilityPaymentCubit(
        utilityPaymentRepository:
            RepositoryProvider.of<UtilityPaymentRepository>(context),
      )..fetchDetails(
          serviceIdentifier: '',
          accountDetails: {},
          apiEndpoint: 'api/scheduled-transfer/recurrence-types',
        ),
    ),
    BlocProvider(
          create: (context) => CoopListCubit(
            internalTransferRepository:
                RepositoryProvider.of<InternalTransferRepository>(context)
                  ..getBranchList(),
          ),
        ),
  ],
  child:const  ScheduleIntermediatePage(
          ),
);

  }
}
