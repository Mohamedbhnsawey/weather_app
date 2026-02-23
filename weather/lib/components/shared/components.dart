import 'package:flutter/material.dart';
import 'package:weather/controller/homeController/homeController.dart';

Row indicator(Homecontroller cubit) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      // Number of pages
      2,
      (index) => Container(
        width: 10.0,
        height: 10.0,
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cubit.currentPage == index ? Colors.blue : Colors.grey,
        ),
      ),
    ),
  );
}

Padding page2(Homecontroller cubit, BuildContext context, Size size, int day,
    String mon) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: size.height * .07,
        ),
        if (!cubit.isTxtFormVisiable)
          const Text(
            "Weather",
            style: TextStyle(
                fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        Row(
          children: [
            Expanded(
                child: txtformfield(
              onChanged: (p0) {
                if (p0.isNotEmpty) {
                  cubit.getSearch();
                }
              },
              SearchController: cubit.SearchController,
              onTap: () {
                if (cubit.isTxtFormVisiable == false) {
                  cubit.changeTxtForm();
                }
              },
            )),
            if (cubit.isTxtFormVisiable)
              const SizedBox(
                width: 10,
              ),
            if (cubit.isTxtFormVisiable)
              GestureDetector(
                onTap: () {
                  cubit.changeTxtForm2();
                  cubit.SearchController.text = '';
                  cubit.isTxtFormEmpty = true;
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                      fontSize: 16,
                      //fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //if (cubit.isTxtFormEmpty) const CityCard(),
        if (!cubit.isTxtFormEmpty)
          ...List.generate(
            cubit.searchmodel.length,
            (index) {
              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      // cubit.fetchData(index: index);

                      // Show the bottom sheet
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return FutureBuilder<List<dynamic>>(
                            future: cubit.fetchDataParallel(
                              location: "${cubit.searchmodel[index]["name"]}",
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  height: size.height * .9,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error: ${snapshot.error}'),
                                );
                              } else {
                                final data1 = snapshot.data![
                                    0]; // Assuming data1 is the first element
                                final data2 = snapshot.data![1];
                                // print(
                                //     "dddddddddd${data!['location']['name']}");
                                // print(cubit.currentmodel2!.location!
                                //     .country!);
                                return ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20)),
                                  child: All_weather2(
                                    condition: data1.current!.condition!.text!,
                                    size: size,
                                    cubit: data1,
                                    cubit2: data2,
                                    day: day,
                                    mon: mon,
                                    location:
                                        "${cubit.searchmodel[index]["name"]}",
                                    height: size.height * .9,
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                    child: cubit.searchmodel.isNotEmpty
                        ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: cubit.SearchController.text,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 14,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '${cubit.searchmodel[index]["name"]}, ${cubit.searchmodel[index]["region"]}, ${cubit.searchmodel[index]["country"]}'
                                          .toLowerCase()
                                          .replaceFirst(
                                            cubit.SearchController.text,
                                            '',
                                          ),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : null,
                  ),
                ],
              );
            },
          ),
      ],
    ),
  );
}

FutureBuilder<List<dynamic>> page1(
    Homecontroller cubit, Size size, int day, String mon) {
  return FutureBuilder<List<dynamic>>(
    future: cubit.fetchDataParallel(location: cubit.myLocation),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(
          height: double.infinity,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        final data1 = snapshot.data![0]; // Assuming data1 is the first element
        final data2 = snapshot.data![1];
        // print("dddddddddd${data1['location']['name']}");
        // print(cubit.currentmodel2!.location!
        //     .country!);
        return All_weather2(
          condition: data1.current!.condition!.text!,
          size: size,
          cubit: data1,
          cubit2: data2,
          day: day,
          mon: mon,
          location: "My Location",
          height: double.infinity,
        );
      }
    },
  );
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Color.fromARGB(70, 255, 255, 255),
      thickness: .5, // Adjust thickness as needed (default is 1.0)
      height:
          20, // Adjust height for spacing above and below the line (default is no spacing)
      indent: 5, // Add indentation from the left and right (default is 0.0)
      endIndent: 5, // Add indentation from the right only (overrides indent)
    );
  }
}

class All_weather2 extends StatelessWidget {
  const All_weather2(
      {super.key,
      required this.size,
      required this.cubit,
      required this.cubit2,
      required this.day,
      required this.mon,
      required this.location,
      required this.condition,
      required this.height});

  final Size size;
  final dynamic cubit;
  final dynamic cubit2;
  final int day;
  final String mon;
  final String location;
  final String condition;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: condition == "Sunny"
                  ? const AssetImage(
                      "assets/images/sunny.png",
                    )
                  : const AssetImage(
                      "assets/images/night.png",
                    ),
              fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .07,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,

                //space: size.height * .02,
                children: [
                  Text(
                    location,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    cubit.location!.name!,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Today",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "$day $mon",
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Image.network(
                    "https:${cubit.current!.condition!.icon!}",
                    height: size.height * .3,
                    width: size.width * .7,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    "${cubit.current!.tempC!.toInt().toString()}°",
                    style: const TextStyle(
                        fontSize: 56,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    cubit.current!.condition!.text!,
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width * .95,
                    // height: size.width * .3,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(70, 98, 95, 188),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //space: size.width * .02,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  "https:${cubit.current!.condition!.icon!}",
                                  height: size.width * .1,
                                  width: size.width * .1,
                                  fit: BoxFit.cover,
                                ),
                                const Text(
                                  "UV INDEX",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 214, 208, 208),
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Text(
                              cubit.current!.uv!.toInt().toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/wind.png",
                                  height: size.width * .1,
                                  width: size.width * .1,
                                  fit: BoxFit.cover,
                                ),
                                const Text(
                                  "WIND",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 214, 208, 208),
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Text(
                              "${cubit.current!.windKph!.toInt()}KM/H",
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/images/humidity.png",
                                  height: size.width * .1,
                                  width: size.width * .1,
                                  fit: BoxFit.contain,
                                ),
                                const Text(
                                  "Humidity",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 214, 208, 208),
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                            Text(
                              "${cubit.current!.humidity!.toInt()}%",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width * .95,
                    height: 115,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(70, 98, 95, 188),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                String txt = cubit2.forecast!.forecastday![0]
                                    .hour![index].time!;
                                return Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      txt.substring(txt.length - 5),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 214, 208, 208),
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Image.network(
                                      "https:${cubit2.forecast!.forecastday![0].hour![index].condition!.icon}",
                                      height: size.width * .1,
                                      width: size.width * .1,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(
                                      "${cubit2.forecast!.forecastday![0].hour![index].tempC!.toInt()}°",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 10,
                                  ),
                              itemCount: cubit2
                                  .forecast!.forecastday![0].hour!.length),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .02,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: size.width * .95,
                    //height: 115,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(70, 98, 95, 188),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Color.fromARGB(70, 255, 255, 255),
                            ),
                            Text(
                              "10-DAY FORCAST",
                              style: TextStyle(
                                  color: Color.fromARGB(70, 255, 255, 255),
                                  fontSize: 16),
                            )
                          ],
                        ),
                        const MyDivider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16),
                            ),
                            Image.network(
                              "https:${cubit.current!.condition!.icon!}",
                              height: size.width * .1,
                              width: size.width * .1,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              " ${cubit2.forecast!.forecastday![0].day!.mintempC!.toInt()}°",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16),
                            ),
                            Text(
                              " ${cubit2.forecast!.forecastday![0].day!.maxtempC!.toInt()}°",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        const MyDivider(),
                        ...List.generate(
                          cubit2.forecast!.forecastday!.length - 1,
                          (index) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cubit2
                                        .forecast!.forecastday![index + 1].date!
                                        .substring(cubit2
                                                .forecast!
                                                .forecastday![index + 1]
                                                .date!
                                                .length -
                                            5),
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 16),
                                  ),
                                  Image.network(
                                    "https:${cubit2.forecast!.forecastday![index + 1].day!.condition!.icon!}",
                                    height: size.width * .1,
                                    width: size.width * .1,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    " ${cubit2.forecast!.forecastday![index + 1].day!.mintempC!.toInt()}°",
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 16),
                                  ),
                                  Text(
                                    " ${cubit2.forecast!.forecastday![index + 1].day!.maxtempC!.toInt()}°",
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const MyDivider(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class CityCard extends StatelessWidget {
  const CityCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 100,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 98, 95, 188),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Location",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "Ahnasia",
                    style: TextStyle(
                        //fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
              Text(
                "38",
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w300,
                    color: Colors.white),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "sunny",
                style: TextStyle(
                    //fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "H:34 L:44",
                style: TextStyle(
                    //fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget txtformfield(
        {required void Function()? onTap,
        required void Function(String)? onChanged,
        required TextEditingController? SearchController}) =>
    TextFormField(
      onChanged: onChanged,
      controller: SearchController,
      onTap: onTap,
      style: const TextStyle(
        color: Colors.white, // Change the color here
      ),
      decoration: InputDecoration(
        filled: true, // This enables the fill color
        fillColor: const Color.fromARGB(40, 158, 158, 158),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        hintText: 'Search for a city',
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none
            // Adjust the radbordius as needed
            ),
      ),
    );
