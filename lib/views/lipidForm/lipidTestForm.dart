import 'package:blood_synergy_app/Cubits/reports_bloc/reports_bloc.dart';
import 'package:blood_synergy_app/Models/CategoryForms.dart';
import 'package:blood_synergy_app/Models/Catergories.dart';
import 'package:blood_synergy_app/Models/FormSubmissionModel.dart';
import 'package:blood_synergy_app/helpers/RatioFormatter.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:blood_synergy_app/views/screens/widgets/MsgWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

// class LipidTestFormScreen extends StatefulWidget {
//   const LipidTestFormScreen({Key? key}) : super(key: key);

//   @override
//   State<LipidTestFormScreen> createState() => _LipidTestFormScreenState();
// }

class LipidTestFormScreen extends StatefulWidget {
  final Categories categorie;
  final ReportsBloc bloc;
  LipidTestFormScreen({Key? key, required this.categorie, required this.bloc})
      : super(key: key);

  @override
  State<LipidTestFormScreen> createState() => _LipidTestFormScreenState();
}

class _LipidTestFormScreenState extends State<LipidTestFormScreen> {
  List<FormSubmissionModel> model = [];
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ReportsBloc>(context).reportSubmissionModel = [];
  }

  void addReportModel(TestForm form, String value) {
    ReportsBloc bloc = BlocProvider.of<ReportsBloc>(context);
    FormSubmissionModel model = FormSubmissionModel(
      id: form.id,
      value: value,
      categoryId: widget.categorie.id,
    );

    int existingModelIndex = bloc.reportSubmissionModel
        .indexWhere((existingModel) => existingModel.id == model.id);

    if (existingModelIndex != -1) {
      bloc.reportSubmissionModel[existingModelIndex] = model;
    } else {
      bloc.reportSubmissionModel.add(model);
    }

    //  FocusScope.of(context).unfocus();
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pop(context);
            });
          },
          child: Container(
            margin: const EdgeInsets.only(top: 5, left: 20).r,
            height: 46.h,
            width: 46.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(255, 255, 255, 1),
              ),
              borderRadius: BorderRadius.all(const Radius.circular(30).w),
            ),
            child: Image.asset('assets/images/back.png'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14).r,
          child: Text(
            (widget.categorie.name ?? 'Test') + ' Form',
            style: appTextTheme.giloryBold22Black,
          ),
        )
      ],
    );
  }

  Widget buildListView(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.all(15),
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        // itemCount: 10,
        itemCount: (context.read<ReportsBloc>().form?.forms?.length ?? 0) + 1,
        itemBuilder: (context, index) {
          //   return buildTextFieldItem(index);
          CategoryForm form = context.read<ReportsBloc>().form!;

          if (index == form.forms?.length) {
            return continuebtn(context, form);
          } else if (index >= 0 && index < (form.forms?.length ?? 0)) {
            TestForm? form = context.read<ReportsBloc>().form?.forms?[index];
            return (form?.isRatio ?? 0) == 0
                ? getSimpleTextFieldWidget(form!)
                : getRatioFieldWidget(form!);
            return Container(
              height: 80,
              width: 100,
              child: TextField(),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildBlocConsumer(BuildContext context) {
    return BlocConsumer<ReportsBloc, ReportsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state.screen == ReportsBlocScreens.createFormScreen) {
          print("Create From Screen building");
          EasyLoading.dismiss();
          if (state.status.isInitial) {
            BlocProvider.of<ReportsBloc>(context)
                .add(FetchForm(widget.categorie.id));
          } else if (state.status.isLoading) {
            EasyLoading.show(status: "Please wait...");
          } else if (state.status.isError) {
            return MsgWidget(msg: state.errorMessage);
          } else if (state.status.isSuccess && state.form == null) {
            return MsgWidget(msg: "No forms are available!");
          } else if (state.status.shouldNavigate) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pop();
            });
          }
        }

        return (context.read<ReportsBloc>().form?.forms?.length ?? 0) < 1
            ? SizedBox.shrink()
            : buildListView(context);
      },
    );
  }

  Widget buildModalBarrier() {
    return ModalBarrier(
      color: Colors.transparent,
      dismissible: false,
    );
  }

  Widget continuebtn(BuildContext context, CategoryForm? forms) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        if (forms != null || (forms?.forms?.isNotEmpty ?? false)) {
          if (BlocProvider.of<ReportsBloc>(context)
              .reportSubmissionModel
              .isNotEmpty) {
            BlocProvider.of<ReportsBloc>(context).add(CreateForm());
          } else {
            Fluttertoast.showToast(
                msg: "Please enter at least one value.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      },
      child: Container(
        width: 345.w,
        height: 50.h,
        margin: const EdgeInsets.only(top: 40, left: 0, right: 0, bottom: 25).r,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(92, 174, 65, 1),
          borderRadius: BorderRadius.all(const Radius.circular(18).w),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Continue to Process',
            style: appTextTheme.gilorySemiBold16White,
          ),
        ),
      ),
    );
  }

  Widget getSimpleTextFieldWidget(TestForm form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 10).r,
          child: Text(
            form.label ?? '',
            style: appTextTheme.giloryBold16Black,
          ),
        ),
        Container(
          height: 50.h,
          margin: const EdgeInsets.only(top: 7).r,
          width: 345.w,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(243, 243, 243, 1),
            borderRadius: BorderRadius.all(
              const Radius.circular(12.0).w,
            ),
          ),
          child: TextField(
            textInputAction: TextInputAction.done,

            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            onChanged: (value) {
              addReportModel(form, value);
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();

              print("object");
            },
            onSubmitted: (value) {},
            controller: form.controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(6),
              DecimalTextInputFormatter()
            ],
            decoration: InputDecoration(
              hintText: 'Enter values',
              hintStyle: appTextTheme.giloryMedium14lightGrey,
              suffixText: form.unit,
              suffixStyle: appTextTheme.giloryMedium12lightGrey,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20).w,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10).w,
                borderSide: BorderSide(
                  color: const Color.fromRGBO(92, 174, 65, 1),
                  // color:Color.fromRGBO(73, 162, 237, 1),
                  width: 1.0.w,
                ),
              ),
            ),

            // onChanged: (value) => context.read<LoginBloc>().add(
            //   LoginPasswordChanged(password: value)
            // ),
          ),
        ),
      ],
    );
  }

  Column getRatioFieldWidget(TestForm form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 10).r,
          child: Text(
            form.label ?? '',
            style: appTextTheme.giloryBold16Black,
          ),
        ),
        Container(
          height: 50.h,
          margin: const EdgeInsets.only(top: 7).r,
          width: 345.w,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(243, 243, 243, 1),
            borderRadius: BorderRadius.all(
              const Radius.circular(12.0).w,
            ),
          ),
          child: TextField(
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              addReportModel(form, value);
            },
            onSubmitted: (value) {
              //  addReportModel(form, value);
            },
            inputFormatters: [
              //      RatioInputFormatter(),
              LengthLimitingTextInputFormatter(5)
            ],
            controller: form.controller,
            decoration: InputDecoration(
              // ),
              hintText: 'Enter values',

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20).w,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10).w,
                borderSide: BorderSide(
                  color: const Color.fromRGBO(92, 174, 65, 1),
                  // color:Color.fromRGBO(73, 162, 237, 1),
                  width: 1.0.w,
                ),
              ),
            ),

            // onChanged: (value) => context.read<LoginBloc>().add(
            //   LoginPasswordChanged(password: value)
            // ),
          ),
        ),
      ],
    );
  }

  void shouldClearAllTextFields() {}

  @override
  // Widget build(BuildContext context) {
  //   _isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

  //   return Scaffold(
  //     //  resizeToAvoidBottomInset: true,
  //     backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           height: 40.h,
  //         ),
  //         buildHeader(context),
  //         buildBlocConsumer(context),
  //         if (_isKeyboardOpen) buildModalBarrier(),
  //       ],
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).viewInsets.top + 30,
          ),
          buildHeader(context),
          buildBlocConsumer(context),
          if (_isKeyboardOpen) buildModalBarrier(),
        ],
      ),
    );
  }

  Widget buildTextFieldItem(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TextField ${index + 1}'),
          SizedBox(height: 8),
          Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
