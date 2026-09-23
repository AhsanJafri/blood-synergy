import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:blood_synergy_app/helpers/Constants.dart';
import 'package:blood_synergy_app/themes/textTheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:blood_synergy_app/Cubits/doctors_cubit/doctors_cubit.dart';
import 'package:blood_synergy_app/Repositories/HomeRepository.dart';
import 'package:blood_synergy_app/network_helpers/network.dart';
import 'package:blood_synergy_app/Models/DoctorDetailModel.dart';
import 'package:blood_synergy_app/helpers/GeneralStates.dart';
import 'package:blood_synergy_app/helpers/app_result_state.dart';

class DoctorDetail extends StatelessWidget {
  final Map<String, dynamic>? doctor;
  final int? doctorId;

  const DoctorDetail({Key? key, this.doctor, this.doctorId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (doctor != null) {
      // Legacy path: render from provided map
      return _buildFromMap(context, doctor!);
    }

    // Fetch via cubit using doctorId
    if (doctorId == null) {
      return const Scaffold(
        body: Center(child: Text('No doctor id provided')),
      );
    }

    return BlocProvider(
      create: (_) => DoctorsCubit(
        HomeRepository(NetworkClient(Client(), dio: Dio())),
      )..getDoctorDetailById(doctorId!),
      child: BlocBuilder<DoctorsCubit, DoctorsState>(
        builder: (context, state) {
          final cubit = context.read<DoctorsCubit>();
          if (state.status.isLoading || state.status.isInitial) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state.status.isError) {
            final err = state.result;
            return Scaffold(
              appBar: AppBar(
                title: Text('Doctor Detail',
                    style: appTextTheme.gilorySemiBold16Black),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0.5,
                foregroundColor: const Color.fromRGBO(50, 50, 50, 1),
              ),
              body: Center(
                child: Text(
                  err is RespErrorState
                      ? (err.failure?.errorMessage ?? 'Error loading details')
                      : 'Error loading details',
                ),
              ),
            );
          }
          final model = cubit.docDetail;
          if (model == null) {
            // Keep showing loader while detail is being fetched
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return _buildFromModel(context, model);
        },
      ),
    );
  }

  Scaffold _buildFromMap(BuildContext context, Map<String, dynamic> doctor) {
    final model = DoctorDetailModel.fromJson(doctor);
    return _buildFromModel(context, model);
  }

  Scaffold _buildFromModel(BuildContext context, DoctorDetailModel model) {
    final name = model.name;
    final designation = model.designation ?? '';
    final email = model.email ?? '';
    final phone = model.phone ?? '';
    final personalSite = model.personalSite ?? '';
    final experience = model.experience ?? '';
    final city = model.city ?? '';
    final address = model.address ?? '';
    final description = model.description ?? '';
    final educationHtml = model.educationHtml ?? '';
    final imageRaw = model.image ?? '';
    final String assetCandidate =
        imageRaw.startsWith('/') ? imageRaw.substring(1) : imageRaw;

    return Scaffold(
      appBar: AppBar(
        title: Text(name.isEmpty ? 'Doctor Detail' : name,
            style: appTextTheme.gilorySemiBold16Black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color.fromRGBO(50, 50, 50, 1),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(243, 243, 243, 1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(200, 200, 200, 1),
                    width: 1,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: imageRaw.isEmpty
                    ? const Icon(Icons.person, size: 56, color: Colors.grey)
                    : (assetCandidate.startsWith('assets/')
                        ? Image.asset(assetCandidate, fit: BoxFit.cover)
                        : Image.network(imageRaw, fit: BoxFit.cover)),
              ),
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: appTextTheme.giloryBold22Black,
              ),
            ),
            if (designation.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    designation,
                    textAlign: TextAlign.center,
                    style: appTextTheme.giloryMedium12lightGrey.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            _SectionCard(
              title: 'About',
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    description.isNotEmpty
                        ? description
                        : 'No description available',
                    style: appTextTheme.giloryMedium12Black.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (educationHtml.isNotEmpty) ...[
              SizedBox(height: 12.h),
              _SectionCard(
                title: '',
                padding: EdgeInsets.fromLTRB(12.w, 15, 12.w, 12.w),
                children: [
                  Html(
                    data: educationHtml,
                    style: {
                      'h1': Style(
                        fontSize: FontSize(16.sp),
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(50, 50, 50, 1),
                        margin: Margins.only(bottom: 8),
                      ),
                      'li': Style(
                        fontSize: FontSize(12.sp),
                        color: const Color.fromRGBO(50, 50, 50, 1),
                        margin: Margins.only(bottom: 6),
                      ),
                      'ul': Style(
                        margin: Margins.only(top: 6),
                      ),
                      'body': Style(
                        margin: Margins.zero,
                      ),
                    },
                  ),
                ],
              ),
            ],
            if (experience.isNotEmpty) ...[
              SizedBox(height: 10.h),
              _SectionCard(
                title: '',
                padding: EdgeInsets.fromLTRB(12.w, 15, 12.w, 12.w),
                children: [
                  Html(
                    data: experience,
                    style: {
                      'h1': Style(
                        fontSize: FontSize(16.sp),
                        fontWeight: FontWeight.w600,
                        color: const Color.fromRGBO(50, 50, 50, 1),
                        margin: Margins.only(bottom: 8),
                      ),
                      'li': Style(
                        fontSize: FontSize(12.sp),
                        color: const Color.fromRGBO(50, 50, 50, 1),
                        margin: Margins.only(bottom: 6),
                      ),
                      'ul': Style(
                        margin: Margins.only(top: 6),
                      ),
                      'body': Style(
                        margin: Margins.zero,
                      ),
                    },
                  ),
                ],
              ),
            ],
            if (email.isNotEmpty ||
                phone.isNotEmpty ||
                personalSite.isNotEmpty ||
                city.isNotEmpty ||
                address.isNotEmpty) ...[
              SizedBox(height: 10.h),
              _SectionCard(
                title: '',
                children: [
                  if (email.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _InfoRow(
                        icon: Icons.email_outlined,
                        label: email,
                        onTap: () => _launchIfPossible('mailto:$email'),
                      ),
                    ),
                  if (phone.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _InfoRow(
                        icon: Icons.phone_outlined,
                        label: phone,
                        onTap: () => _launchIfPossible('tel:$phone'),
                      ),
                    ),
                  if (personalSite.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _InfoRow(
                        icon: Icons.public,
                        label: personalSite,
                        onTap: () =>
                            _launchIfPossible(_ensureUrlScheme(personalSite)),
                      ),
                    ),
                  if (city.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _InfoRow(
                        icon: Icons.location_city,
                        label: city,
                      ),
                    ),
                  if (address.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: _InfoRow(
                        icon: Icons.place_outlined,
                        label: address,
                      ),
                    ),
                ],
              ),
            ],
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  static String _ensureUrlScheme(String url) {
    final hasScheme = url.startsWith('http://') || url.startsWith('https://');
    return hasScheme ? url : 'https://$url';
  }

  static void _launchIfPossible(String url) {
    try {
      Constants.launchURL(url);
    } catch (_) {}
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const _SectionCard(
      {required this.title, required this.children, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(243, 243, 243, 1),
        borderRadius: BorderRadius.circular(14).w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(title, style: appTextTheme.giloryBold16Black),
            SizedBox(height: 8.h),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _InfoRow({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color.fromRGBO(86, 86, 86, 1)),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: appTextTheme.giloryMedium12Black.copyWith(
              decoration: onTap != null
                  ? TextDecoration.underline
                  : TextDecoration.none,
              color: onTap != null
                  ? Theme.of(context).primaryColor
                  : const Color.fromRGBO(50, 50, 50, 1),
            ),
          ),
        ),
      ],
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      child: content,
    );
  }
}
