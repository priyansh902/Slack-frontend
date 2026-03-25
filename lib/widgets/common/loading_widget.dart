import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  
  const LoadingWidget({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}