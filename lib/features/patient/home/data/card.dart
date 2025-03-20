import 'package:flutter/material.dart';
import 'package:sehety/features/auth/data/specialization_list.dart';

const Color skyBlue = Color(0xff71b4fb);
const Color lightBlue = Color(0xff7fbcfb);

const Color orange = Color(0xfffa8c73);
const Color lightOrange = Color(0xfffa9881);

const Color purple = Color(0xff8873f4);
const Color purpleLight = Color(0xff9489f4);

const Color green = Color(0xff4cd1bc);
const Color lightGreen = Color(0xff5ed6c3);

class SpecializationModel {
  String specialization;
  Color cardBackground;
  Color cardLightColor;

  SpecializationModel(this.specialization, this.cardBackground, this.cardLightColor);
}

List<SpecializationModel> cards = [
  SpecializationModel(specialization[0], skyBlue, lightBlue), //القلب
  SpecializationModel(specialization[1], green, lightGreen), //عام
  SpecializationModel(specialization[2], orange, lightOrange), // نساء وتوليد
  SpecializationModel(specialization[3], purple, purpleLight), // باطنه
  SpecializationModel(specialization[4], green, lightGreen), // تجميل وترميم
  SpecializationModel(specialization[5], skyBlue, lightBlue), //  اسنان
  SpecializationModel(specialization[6], green, lightGreen), //  انف اذن
  SpecializationModel(specialization[7], orange, lightOrange), // عيون
  SpecializationModel(specialization[8], purple, purpleLight), //  عظام
  SpecializationModel(specialization[9], green, lightGreen), // اطفال
];