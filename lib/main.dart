import 'package:demo_application/consts/colors.dart';
import 'package:demo_application/consts/images.dart';
import 'package:demo_application/consts/strings.dart';
import 'package:demo_application/controllers/main_controller.dart';
import 'package:demo_application/models/current_weather_model.dart';
import 'package:demo_application/models/hourly_weather_model.dart';
import 'package:demo_application/services/api_services.dart';
import 'package:demo_application/utils/our_themes.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const weatherapp(),
      title: "Weather App",
    );
  }
}

class weatherapp extends StatefulWidget {
  const weatherapp({super.key});

  @override
  State<weatherapp> createState() => _weatherappState();
}

class _weatherappState extends State<weatherapp> {
  @override
  Widget build(BuildContext context) {
    var date = DateFormat("yMMMMd").format(DateTime.now());
    var theme = Theme.of(context);
    var controller = Get.put(MainController());
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
          title: "$date".text.color(theme.primaryColor).make(),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            Obx(
              () => IconButton(
                onPressed: () {
                  controller.changeTheme();
                },
                icon: Icon(
                  controller.isDark.value ? Icons.light_mode : Icons.dark_mode,
                  color: theme.iconTheme.color,
                ),
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_vert,
                  color: Vx.gray600,
                ))
          ]),
      body: Obx(
        () => controller.isloaded.value == true
            ? Container(
                padding: EdgeInsets.all(12),
                child: FutureBuilder(
                  future: controller.currentWeatherData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      Currentweatherdata data = snapshot.data;

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data.name}"
                                  .text
                                  .uppercase
                                  .fontFamily("poppins_bold")
                                  .size(36)
                                  .letterSpacing(3)
                                  .color(theme.primaryColor)
                                  .make(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/weather/${data.weather![0].icon}.png",
                                    width: 80,
                                    height: 80,
                                  ),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: "${data.main!.temp}",
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 64,
                                          fontFamily: "poppins",
                                        )),
                                    TextSpan(
                                        text: "  ${data.weather![0].main}",
                                        style: TextStyle(
                                          color: theme.primaryColor,
                                          fontSize: 14,
                                          fontFamily: "poppins_light",
                                        )),
                                  ]))
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.expand_less_rounded,
                                      color: theme.iconTheme.color,
                                    ),
                                    label: "41$degree"
                                        .text
                                        .color(theme.iconTheme.color)
                                        .make(),
                                  ),
                                  TextButton.icon(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.expand_more_rounded,
                                      color: theme.iconTheme.color,
                                    ),
                                    label: "${data.main!.tempMin}$degree"
                                        .text
                                        .color(theme.iconTheme.color)
                                        .make(),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: List.generate(3, (index) {
                                  var iconsList = [clouds, humidity, windspeed];
                                  var values = [
                                    "${data.clouds!.all}",
                                    "",
                                    "3.5 KM/h"
                                  ];
                                  return Column(
                                    children: [
                                      Image.asset(
                                        iconsList[index],
                                        width: 60,
                                        height: 60,
                                      )
                                          .box
                                          .gray100
                                          .padding(const EdgeInsets.all(8))
                                          .roundedSM
                                          .make(),
                                      10.heightBox,
                                      values[index].text.gray400.make(),
                                    ],
                                  );
                                }),
                              ),
                              10.heightBox,
                              const Divider(),
                              10.heightBox,
                              FutureBuilder(
                                future: controller.hourlyWeatherData,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    HourlyWeatherData hourlydata =
                                        snapshot.data;
                                    return SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: hourlydata.list!.length > 6
                                              ? 6
                                              : hourlydata.list!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var time = DateFormat.jm().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        hourlydata.list![index]
                                                                .dt!
                                                                .toInt() *
                                                            1000));
                                            return Expanded(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                margin: const EdgeInsets.only(
                                                    right: 4),
                                                decoration: BoxDecoration(
                                                  color: cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Column(
                                                  children: [
                                                    time.text.gray200.make(),
                                                    Image.asset(
                                                      "assets/weather/${hourlydata.list![index].weather![0].icon}.png",
                                                      width: 80,
                                                    ),
                                                    // 10.heightBox,
                                                    "${hourlydata.list![index].main!.temp}$degree"
                                                        .text
                                                        .make(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                              10.heightBox,
                              const Divider(),
                              10.heightBox,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  "Next  7 days"
                                      .text
                                      .semiBold
                                      .size(16)
                                      .color(theme.primaryColor)
                                      .make(),
                                  TextButton(
                                    onPressed: () {},
                                    child: "view all".text.make(),
                                  ),
                                ],
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: 7,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var day = DateFormat("EEEE").format(
                                        DateTime.now()
                                            .add(Duration(days: index + 1)));
                                    return Card(
                                      color: theme.cardColor,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          //color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(1),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: day.text.semiBold
                                                      .color(theme.primaryColor)
                                                      .make()),
                                              Expanded(
                                                child: TextButton.icon(
                                                  onPressed: null,
                                                  icon: Image.asset(
                                                    "assets/weather/50n.png",
                                                    width: 40,
                                                  ),
                                                  label: "26$degree"
                                                      .text
                                                      .color(theme.primaryColor)
                                                      .make(),
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "38$degree/",
                                                      style: TextStyle(
                                                        color:
                                                            theme.primaryColor,
                                                        fontFamily: "poppins",
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: "25$degree",
                                                      style: TextStyle(
                                                        color:
                                                            theme.primaryColor,
                                                        fontFamily: "poppins",
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      ),
                                    );
                                  })
                            ]),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
