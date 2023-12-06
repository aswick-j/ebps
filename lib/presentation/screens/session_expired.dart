import 'package:ebps/presentation/widget/no_result.dart';
import 'package:flutter/material.dart';

class SessionExpired extends StatefulWidget {
  const SessionExpired({super.key});

  @override
  State<SessionExpired> createState() => _SessionExpiredState();
}

class _SessionExpiredState extends State<SessionExpired> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, height: 500, child: const noResult());
  }
}
