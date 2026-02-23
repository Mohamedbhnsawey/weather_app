// ignore_for_file: camel_case_types

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/components/shared/components.dart';
import 'package:weather/controller/homeController/homeController.dart';
import 'package:weather/controller/homeController/homeStates.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    var month = now.month;
    int day = now.day;
    late String mon;
    if (month == 1) {
      mon = 'Jan';
    } else if (month == 2) {
      mon = 'Feb';
    } else if (month == 3) {
      mon = 'Mar';
    } else if (month == 4) {
      mon = 'Apr';
    } else if (month == 5) {
      mon = 'May';
    } else if (month == 6) {
      mon = 'Jun';
    } else if (month == 7) {
      mon = 'Jul';
    } else if (month == 8) {
      mon = 'Aug';
    } else if (month == 9) {
      mon = 'Sep';
    } else if (month == 10) {
      mon = 'Oct';
    } else if (month == 11) {
      mon = 'Nov';
    } else if (month == 12) {
      mon = 'Dec';
    } else {
      mon = 'Invalid Month'; // Handle invalid month input (optional)
    }
    var size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => Homecontroller()..getLocation2(),
      child: BlocConsumer<Homecontroller, Homestates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = Homecontroller.get(context);

          return ConditionalBuilder(
            condition: cubit.myLocation.isNotEmpty,
            fallback: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            builder: (context) {
              return Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  //fit: StackFit.expand,
                  //fit: StackFit.expand,
                  children: [
                    PageView(
                      controller: cubit.pageController,
                      onPageChanged: (value) {
                        cubit.onPageChanged(value);
                      },
                      children: [
                        page1(cubit, size, day, mon),
                        page2(cubit, context, size, day, mon),
                      ],
                    ),
                    Positioned(
                        bottom: 10,
                        left: size.width / 2 - 2,
                        child: indicator(cubit)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
