import 'package:ebps/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dynamic getComplaintStatusValue(String statusID) {
  switch (statusID) {
    case "ASSIGNED":
      {
        return "Assigned";
      }
    case "ESCALATED":
      {
        return "Escalated";
      }
    case "RE_ASSIGNED":
      {
        return "Re Assigned";
      }
    case "ASSIGNED_TO_COU":
      {
        return "Assigned to COU";
      }
    case "ASSIGNED_TO_BOU":
      {
        return "Assigned to BOU";
      }
    case "ASSIGNED_TO_OU":
      {
        return "Assigned to OU";
      }
    case "RESOLVED":
      {
        return "Resolved";
      }
    case "UNRESOLVED":
      {
        return "Unresolved";
      }
    case "PENDING_WITH_BBPOU":
      {
        return "Pending With BBPOU";
      }
    default:
      {
        return statusID.toString();
      }
  }
}

Color getComplaintStatusColors(String statusID) {
  switch (statusID) {
    case "ASSIGNED":
      {
        return AppColors.CLR_PRIMARY_LITE;
      }
    case "ESCALATED":
      {
        return AppColors.CLR_ERROR;
      }
    case "RE_ASSIGNED":
      {
        return Colors.purple;
      }
    case "ASSIGNED_TO_COU":
      {
        return Colors.teal;
      }
    case "ASSIGNED_TO_BOU":
      {
        return Colors.teal;
      }
    case "ASSIGNED_TO_OU":
      {
        return Colors.teal;
      }
    case "RESOLVED":
      {
        return AppColors.CLR_GREEN;
      }
    case "UNRESOLVED":
      {
        return Colors.red;
      }
    case "PENDING_WITH_BBPOU":
      {
        return Colors.orange;
      }
    default:
      {
        return Colors.blue;
      }
  }
}
