import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart/feature/receiveMoney/remit/receiveRemit/widget/remittance_detail_fetch_widget.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';
import 'package:ismart/feature/utility_payment/resources/utility_payment_repository.dart';

class RemittanceDetailFetchPage2 extends StatelessWidget {
  final UtilityResponseData data;
  final String path;
  final String bankName;
  final String remitCode;
  final String realtion;
  final String relationshipType;
  final String remittancePurpose;
  const RemittanceDetailFetchPage2(
      {super.key,
      required this.data,
      required this.path,
      required this.bankName,
      required this.remitCode,
      required this.realtion,
      required this.relationshipType,
      required this.remittancePurpose});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UtilityPaymentCubit(
          utilityPaymentRepository:
              RepositoryProvider.of<UtilityPaymentRepository>(context)),
      child: RemittanceDetailFetchWidget(
        realtion: realtion,
        relationshipType: relationshipType,
        remittancePurpose: remittancePurpose,
        path: path,
        data: data,
        bankName: bankName,
        remitCode: remitCode,
      ),
    );
  }
}
