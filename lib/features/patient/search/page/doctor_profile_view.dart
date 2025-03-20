import 'package:flutter/material.dart';
import 'package:sehety/core/functions/navigation.dart' show push;
import 'package:sehety/core/utils/colors.dart';
import 'package:sehety/core/utils/text_styles.dart';
import 'package:sehety/core/widgets/custom_button.dart';
import 'package:sehety/features/auth/data/doctor_model.dart';
import 'package:sehety/features/patient/booking/presentation/booking_view.dart';
import 'package:sehety/features/patient/search/widgets/item_tile.dart';
import 'package:sehety/features/patient/search/widgets/phone_tile.dart';

import 'package:url_launcher/url_launcher.dart';

class DoctorProfile extends StatefulWidget {
  final DoctorModel? doctorModel;

  const DoctorProfile({super.key, this.doctorModel});
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  late DoctorModel doctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('بيانات الدكتور'),
        leading: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            splashRadius: 25,
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // ------------ Header ---------------
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 60,
                        backgroundImage:
                            (widget.doctorModel?.image != null)
                                ? NetworkImage(widget.doctorModel!.image!)
                                : const AssetImage('assets/images/doctor.jpg'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "د. ${widget.doctorModel?.name ?? ''}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getTitleStyle(),
                        ),
                        Text(
                          widget.doctorModel?.specialization ?? '',
                          style: getbodyStyle(),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              widget.doctorModel?.rating.toString() ?? '0.0',
                              style: getbodyStyle(),
                            ),
                            const SizedBox(width: 3),
                            const Icon(
                              Icons.star_rounded,
                              size: 20,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            IconTile(
                              onTap: () async {
                                await launchUrl(
                                  Uri.parse(
                                    'tel:${widget.doctorModel?.phone1}',
                                  ),
                                );
                              },
                              backColor: AppColors.accentColor,
                              imgAssetPath: Icons.phone,
                              num: '1',
                            ),
                            if (widget.doctorModel?.phone2 != '') ...{
                              const SizedBox(width: 15),
                              IconTile(
                                onTap: () {},
                                backColor: AppColors.accentColor,
                                imgAssetPath: Icons.phone,
                                num: '2',
                              ),
                            },
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                "نبذه تعريفية",
                style: getbodyStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Text(widget.doctorModel?.bio ?? '', style: getsmallStyle()),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.accentColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TileWidget(
                      text:
                          '${widget.doctorModel?.openHour} - ${widget.doctorModel?.closeHour}',
                      icon: Icons.watch_later_outlined,
                    ),
                    const SizedBox(height: 15),
                    TileWidget(
                      text: widget.doctorModel?.address ?? '',
                      icon: Icons.location_on_rounded,
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              Text(
                "معلومات الاتصال",
                style: getbodyStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.accentColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // await launchUrl(
                        //     Uri.parse('mailto:${widget.doctorModel?.email}'));

                        // await launchUrl(Uri.parse(
                        //     'https://wa.me/${widget.doctorModel?.phone1}'));

                        // await launchUrl(Uri.parse(
                        //     'https://t.me/${widget.doctorModel?.phone1}'));

                        await launchUrl(Uri.parse('geo:33.3,22.4'));
                      },
                      child: TileWidget(
                        text: widget.doctorModel?.email ?? '',
                        icon: Icons.email,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TileWidget(
                      text: widget.doctorModel?.phone1 ?? '',
                      icon: Icons.call,
                    ),
                    if (widget.doctorModel?.phone2 != '') ...{
                      const SizedBox(height: 15),
                      TileWidget(
                        text: widget.doctorModel?.phone2 ?? '',
                        icon: Icons.call,
                      ),
                    },
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomButton(
          text: 'احجز موعد الان',
          onPressed: () {
            push(context, BookingView(doctor: widget.doctorModel!));
          },
        ),
      ),
    );
  }
}
