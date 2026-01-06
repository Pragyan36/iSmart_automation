import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart/app/theme.dart';
import 'package:ismart/common/common/data_state.dart';
import 'package:ismart/common/constant/fonts.dart';
import 'package:ismart/common/navigation/navigation_service.dart';
import 'package:ismart/common/util/form_validator.dart';
import 'package:ismart/common/widget/common_container.dart';
import 'package:ismart/common/widget/common_text_field.dart';
import 'package:ismart/common/widget/page_wrapper.dart';
import 'package:ismart/feature/favorite/scheduledpayment/widget/schedulepayment_bill_widget.dart';

import 'package:ismart/feature/more/transactionLimit/transaction_progress_page.dart';
import 'package:ismart/feature/receiveMoney/remit/receiveRemit/widget/paymentrelationship.dart';
import 'package:ismart/feature/sendMoney/internalCooperative/models/internal_branch.dart';
import 'package:ismart/feature/sendMoney/internalCooperative/screen/select_co_op_branch.dart';
import 'package:ismart/feature/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart/feature/utility_payment/models/utility_response_data.dart';

class SchedulePaymentWidget extends StatefulWidget {
  final bool? pageType;
  final String? accountNumber;
  final bool? isFavAccount;
  final String? branchName;
  final String branchId;
  final String? accountName;
  final String? branchCodeQr;
  final String? remarks;
  // final List<Map<String, dynamic>>? recurrenceItems;

  const SchedulePaymentWidget(
      {Key? key,
      this.pageType,
      this.accountNumber,
      this.accountName,
      this.branchCodeQr,
      this.remarks,
      this.isFavAccount = false,
      this.branchName,
      // this.recurrenceItems,
      required this.branchId})
      : super(key: key);

  @override
  State<SchedulePaymentWidget> createState() => _SchedulePaymentWidgetState();
}

class _SchedulePaymentWidgetState extends State<SchedulePaymentWidget> {
  String? branchId;
  String? branchCode;
  bool _isRecurring = false;
  List<Map<String, dynamic>> recurrenceItems = [];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _limiteController = TextEditingController();
  final TextEditingController _recurrenceTypeController =
      TextEditingController();

  String _currentAmount = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InternalBranch? branchFromQr;
  bool _isLoading = false;
  InternalBranch? selectedIDFromQr;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _toggleBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        height: 500,
        decoration: const BoxDecoration(
          color: CustomTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const TransactionProgressPage(
          persistOpen: true,
          title: "Internal Fund Transfer ",
          profileType: 'CustomerProfile',
          isOpen: true,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _accountNumberController.text = widget.accountNumber ?? "";
    _accountNameController.text = widget.accountName ?? "";
    _branchController.text = widget.branchName ?? "";
    _remarksController.text = widget.remarks ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      scaffoldKey: _scaffoldKey,
      body: BlocListener<UtilityPaymentCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonStateSuccess<UtilityResponseData>) {
            final response = state.data;

            final recurrenceTypes =
                (response.details.first.value as List<dynamic>)
                    .map((e) => e.toString())
                    .toList();
            setState(() {
              recurrenceItems =
                  recurrenceTypes.map((e) => {"text": e}).toList();
            });
          }
        },
        child: CommonContainer(
          verificationAmount: _currentAmount,
          body: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  title: "Branch".tr(),
                  hintText: "Select Branch".tr(),
                  readOnly: true,
                  controller: _branchController,
                  validator: (val) =>
                      FormValidator.validateFieldNotEmpty(val, "Branch".tr()),
                  onTap: () {
                    NavigationService.push(
                      target: CoOperativeBranchPage(
                        onBankSelected: (val) {
                          NavigationService.pop();
                          branchCode = val.branchCode;
                          branchId = val.id.toString();
                          _branchController.text = val.name;
                        },
                      ),
                    );
                  },
                ),
                CustomTextField(
                  title: "Destination Account".tr(),
                  hintText: "Account Number".tr(),
                  controller: _accountNumberController,
                  validator: (val) => FormValidator.validateFieldNotEmpty(
                      val, "Account Number"),
                ),
                CustomTextField(
                  title: "Date",
                  readOnly: true,
                  controller: _dateController,
                  showSuffixImage: true,
                  suffixImage: "assets/icons/uit_calender.svg",
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      _dateController.text =
                          pickedDate.toString().split(" ").first;
                    }
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return "Date is required";
                    }

                    final selectedDate = DateTime.parse(val);
                    final today = DateTime.now();
                    final currentDate =
                        DateTime(today.year, today.month, today.day);

                    if (!selectedDate.isAfter(currentDate)) {
                      return "Please select a future date";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  title: "Time",
                  readOnly: false,
                  showSuffixImage: true,
                  suffixImage: "assets/icons/time.svg",
                  suffixIconSize: 23,
                  controller: _timeController,
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      final formattedTime =
                          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                      _timeController.text = formattedTime;
                    }
                  },
                  validator: (val) =>
                      FormValidator.validateFieldNotEmpty(val, "Time"),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  showTransLimit: true,
                  // transLimitFunc: _toggleBottomSheet,
                  title: "Amount".tr(),
                  textInputType: TextInputType.number,
                  hintText: "NPR".tr(),
                  onChanged: (value) {
                    setState(() {
                      _currentAmount = value;
                    });
                  },
                  controller: _amountController,
                  validator: (val) =>
                      FormValidator.validateFieldNotEmpty(val, "Amount".tr()),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recurring Payment",
                      style: TextStyle(
                        fontFamily: Fonts.poppin,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: CustomTheme.lightTextColor,
                      ),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: _isRecurring,
                        activeColor: CustomTheme.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _isRecurring = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                if (_isRecurring) ...[
                  CustomTextField(
                    title: "Limitation".tr(),
                    readOnly: true,
                    controller: _limiteController,
                    validator: (val) => FormValidator.validateFieldNotEmpty(
                        val, "Limitation".tr()),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) {
                          int selectedValue =
                              int.tryParse(_limiteController.text) ?? 1;

                          return SizedBox(
                            height: 250,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      _limiteController.text =
                                          selectedValue.toString();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Done"),
                                  ),
                                ),
                                Expanded(
                                  child: CupertinoPicker(
                                    scrollController:
                                        FixedExtentScrollController(
                                      initialItem: selectedValue - 1,
                                    ),
                                    itemExtent: 40,
                                    onSelectedItemChanged: (index) {
                                      selectedValue = index + 1;
                                    },
                                    children: List.generate(
                                      10,
                                      (index) => Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    title: "Recurrence Type".tr(),
                    readOnly: true,
                    controller: _recurrenceTypeController,
                    validator: (val) => FormValidator.validateFieldNotEmpty(
                        val, "Recurrence Type"),
                    onTap: () async {
                      if (recurrenceItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Loading recurrence types...'),
                          ),
                        );
                        return;
                      }

                      final selectedItem = await NavigationService.push(
                        target: SelectableListWidget(
                          title: "Recurrence Types",
                          items: recurrenceItems,
                          onItemSelected: (item) =>
                              Navigator.pop(context, item),
                        ),
                      );

                      if (selectedItem != null) {
                        _recurrenceTypeController.text = selectedItem['text'];
                      }
                    },
                  ),
                ],

                CustomTextField(
                  title: "Remarks".tr(),
                  hintText: "Remarks".tr(),
                  controller: _remarksController..text = widget.remarks ?? "",
                  validator: (val) =>
                      FormValidator.validateFieldNotEmpty(val, "Remarks".tr()),
                )
              ],
            ),
          ),
          topbarName: "Schedule Payment".tr(),
          showDetail: true,
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              final dateTime = Uri.decodeComponent(
                  "${_dateController.text} ${_timeController.text}:00");
              print("this is date $dateTime");

              NavigationService.push(
                  target: SchedulePaymentBillWidget(
                      schdeuleDate: dateTime,
                      isRecurring: _isRecurring,
                      recurrenceType: _recurrenceTypeController.text,
                      amount: _amountController.text,
                      limit: _limiteController.text,
                      accountNumber: _accountNumberController.text,
                      accountName: "",
                      remarks: _remarksController.text,
                      branchCode: branchCode!,
                      body: Container(),
                      message: ''));
            }
          },
          showAccountSelection: true,
          buttonName: "Proceed".tr(),
          title: "Schedule Payment".tr(),
          detail: "Send Money to account maintained at same Coop.".tr(),
        ),
      ),
    );
  }
}
