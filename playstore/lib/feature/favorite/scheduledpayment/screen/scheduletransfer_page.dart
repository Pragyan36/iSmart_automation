import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart/feature/favorite/scheduledpayment/widget/scheduletransfer_widget.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

class ScheduleTransferPage extends StatefulWidget {
  const ScheduleTransferPage(
      {super.key,
     });
  @override
  State<ScheduleTransferPage> createState() => ScheduleTransferPageState();
}

class ScheduleTransferPageState extends State<ScheduleTransferPage> {
  @override
  Widget build(BuildContext context) {
  
    return MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => UtilityPaymentCubit(
        utilityPaymentRepository:
            RepositoryProvider.of<UtilityPaymentRepository>(context),
      )..fetchDetails(
          serviceIdentifier: '',
          accountDetails: {},
          apiEndpoint: 'api/scheduled-transfer/list',
        ),
    ),

  ],
  child:const  ScheduletransferWidget(
          ),
);

  }
}
