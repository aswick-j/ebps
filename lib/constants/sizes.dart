// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

double height(context) => MediaQuery.of(context).size.height;
double width(context) => MediaQuery.of(context).size.width;
double deviceAspectRatio(context) => MediaQuery.of(context).size.aspectRatio;

//10
double TXT_SIZE_VSMALL(BuildContext context) {
  return width(context) * 0.02;
}

//12
double TXT_SIZE_SMALL(BuildContext context) {
  return width(context) * 0.025;
}

//14
double TXT_SIZE_NORMAL(BuildContext context) {
  return width(context) * 0.03;
}

//16
double TXT_SIZE_LARGE(BuildContext context) {
  return width(context) * 0.035;
}

//18
double TXT_SIZE_XL(BuildContext context) {
  return width(context) * 0.04;
}

//20
double TXT_SIZE_XXL(BuildContext context) {
  return width(context) * 0.045;
}

double TXT_SIZE_CUSTOM(BuildContext context, double val) {
  return width(context) * val;
}

//PADDING HEIGHT

double PADH_SIZE_XS(BuildContext context) {
  return height(context) * 0.045;
}

double PADH_SIZE_VSMALL(BuildContext context) {
  return height(context) * 0.045;
}

double PADH_SIZE_SMALL(BuildContext context) {
  return height(context) * 0.045;
}

double PADH_SIZE_NORMAL(BuildContext context) {
  return height(context) * 0.045;
}

double PADH_SIZE_LARGE(BuildContext context) {
  return height(context) * 0.045;
}

double PADH_SIZE_XL(BuildContext context) {
  return height(context) * 0.045;
}

double PADH_SIZE_XXL(BuildContext context) {
  return height(context) * 0.045;
}

double PADH_SIZE_CUSTOM(BuildContext context, double val) {
  return height(context) * val;
}

//PADDING-WIDTH

double PADW_SIZE_XS(BuildContext context) {
  return width(context) * 0.045;
}

double PADW_SIZE_VSMALL(BuildContext context) {
  return width(context) * 0.045;
}

double PADW_SIZE_SMALL(BuildContext context) {
  return width(context) * 0.045;
}

double PADW_SIZE_NORMAL(BuildContext context) {
  return width(context) * 0.045;
}

double PADW_SIZE_LARGE(BuildContext context) {
  return width(context) * 0.045;
}

double PADW_SIZE_XL(BuildContext context) {
  return width(context) * 0.045;
}

double PADW_SIZE_XXL(BuildContext context) {
  return width(context) * 0.045;
}

double PADW_SIZE_CUSTOM(BuildContext context, double val) {
  return width(context) * val;
}
