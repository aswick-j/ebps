import 'package:ebps/constants/colors.dart';
import 'package:flutter/material.dart';

MyAppText(
    {@required data,
    color,
    @required size,
    weight,
    decorate,
    align,
    maxline,
    lineHeight,
    flowType,
    textAlign}) {
  return Text(
    data ?? '',
    softWrap: false,
    overflow: flowType ?? TextOverflow.ellipsis,
    textAlign: align ?? TextAlign.left,
    maxLines: maxline ?? 2,
    style: TextStyle(
      color: color ?? primaryColor,
      fontSize: size,
      height: lineHeight ?? 0,
      fontWeight: weight ?? FontWeight.normal,
      decoration: decorate ?? TextDecoration.none,
    ),
  );
}
