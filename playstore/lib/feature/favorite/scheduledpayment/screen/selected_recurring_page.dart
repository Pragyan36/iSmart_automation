// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/feature/receiveMoney/remit/receiveRemit/widget/paymentrelationship.dart';
// import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
// import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

// class SelectedRecurringPage extends StatefulWidget {
//   const SelectedRecurringPage({super.key});

//   @override
//   State<SelectedRecurringPage> createState() => _SelectedRecurringPage();
// }

// class _SelectedRecurringPage extends State<SelectedRecurringPage> {
//   @override
//   Widget build(BuildContext context) {
//     return  BlocProvider(
//           create: (context) => UtilityPaymentCubit(
//             utilityPaymentRepository:
//                 RepositoryProvider.of<UtilityPaymentRepository>(context),
                
//           ),
          
//           // child:SelectableListWidget(
//           //               title: "Recurrence Types",
//           //               items: recurrenceItems,
//           //               onItemSelected: (item) {
//           //                 Navigator.pop(context, item);
//           //               },
//           //             ), 
//         );
//   }
// }
