import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sehety/core/functions/dialogs.dart';
import 'package:sehety/core/utils/colors.dart';
import 'package:sehety/core/utils/text_styles.dart';
import 'package:sehety/features/auth/data/doctor_model.dart';
import 'package:sehety/features/auth/data/specialization_list.dart';
import 'package:sehety/features/auth/peresntation/manager/auth_bloc.dart';


class DoctorRegistrationView extends StatefulWidget {
  const DoctorRegistrationView({super.key});

  @override
  _DoctorRegistrationViewState createState() => _DoctorRegistrationViewState();
}

class _DoctorRegistrationViewState extends State<DoctorRegistrationView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone1 = TextEditingController();
  final TextEditingController _phone2 = TextEditingController();
  String _specialization = specialization[0];

  late String _startTime =
      DateFormat('hh').format(DateTime(2023, 9, 7, 10, 00));
  late String _endTime = DateFormat('hh').format(DateTime(2023, 9, 7, 22, 00));

  @override
  void initState() {
    getUser();
    super.initState();
  }

  File? file;
  String? profileUrl;

  String? userID;

  getUser() {
    userID = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<String> uploadImageToStorage(File image) async {
    Reference ref =
        FirebaseStorage.instanceFor(bucket: 'gs://se7ety-119.appspot.com')
            .ref()
            .child('doctors/$userID');
    SettableMetadata metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putFile(image, metadata);
    return await ref.getDownloadURL();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        file = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is DoctorRegistrationSuccessState) {
          log('success');
        } else if (state is AuthErrorState) {
          Navigator.pop(context);
          showErrorDialog(context, state.message);
        } else if (state is DoctorRegistrationLoadingState) {
          showLoadingDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إكمال عملية التسجيل'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.white,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.white,
                              backgroundImage: (file != null)
                                  ? FileImage(file!) as ImageProvider
                                  : const AssetImage('assets/images/doc.png'),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _pickImage();
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                        child: Row(
                          children: [
                            Text(
                              'التخصص',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      // التخصص---------------
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            color: AppColors.accentColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: AppColors.color1,
                          icon: const Icon(Icons.expand_circle_down_outlined),
                          value: _specialization,
                          onChanged: (String? newValue) {
                            setState(() {
                              _specialization = newValue ?? specialization[0];
                            });
                          },
                          items: specialization.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'نبذة تعريفية',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        controller: _bio,
                        style: const TextStyle(color: AppColors.black),
                        decoration: const InputDecoration(
                            hintText:
                                'سجل المعلومات الطبية العامة مثل تعليمك الأكاديمي وخبراتك السابقة...'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل النبذة التعريفية';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Divider(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'عنوان العيادة',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _address,
                        style: const TextStyle(color: AppColors.black),
                        decoration: const InputDecoration(
                          hintText: '5 شارع مصدق - الدقي - الجيزة',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل عنوان العيادة';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'ساعات العمل من',
                                    style: getbodyStyle(color: AppColors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    'الي',
                                    style: getbodyStyle(color: AppColors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // ---------- Start Time ----------------
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      await showStartTimePicker();
                                    },
                                    icon: const Icon(
                                      Icons.watch_later_outlined,
                                      color: AppColors.color1,
                                    )),
                                hintText: _startTime,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          // ---------- End Time ----------------
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () async {
                                      await showEndTimePicker();
                                    },
                                    icon: const Icon(
                                      Icons.watch_later_outlined,
                                      color: AppColors.color1,
                                    )),
                                hintText: _endTime,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'رقم الهاتف 1',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _phone1,
                        style: const TextStyle(color: AppColors.black),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        decoration: const InputDecoration(
                          hintText: '+20xxxxxxxxxx',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'من فضلك ادخل الرقم';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'رقم الهاتف 2 (اختياري)',
                              style: getbodyStyle(color: AppColors.black),
                            )
                          ],
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _phone2,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        style: const TextStyle(color: AppColors.black),
                        decoration: const InputDecoration(
                          hintText: '+20xxxxxxxxxx',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.only(top: 25.0),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate() && file != null) {
                  profileUrl = await uploadImageToStorage(file!);
                  context.read<AuthBloc>().add(UpdateDoctorDataEvent(
                          doctorModel: DoctorModel(
                        uid: userID ?? '',
                        image: profileUrl ?? '',
                        phone1: _phone1.text,
                        phone2: _phone2.text,
                        address: _address.text,
                        specialization: _specialization,
                        openHour: _startTime,
                        closeHour: _endTime,
                        bio: _bio.text,
                      )));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('من فضلك قم بتحميل صورة الملف الشخصي'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.color1,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "التسجيل",
                style: getTitleStyle(fontSize: 16, color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showStartTimePicker() async {
    final datePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (datePicked != null) {
      setState(() {
        _startTime = datePicked.hour.toString();
      });
    }
  }

  showEndTimePicker() async {
    final timePicker = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(minutes: 15))),
    );

    if (timePicker != null) {
      setState(() {
        _endTime = timePicker.hour.toString();
      });
    }
  }
}