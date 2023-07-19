import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/prayertime.dart';

class PrayerTimeScreen extends StatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  State<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends State<PrayerTimeScreen> {
  PrayerTime time = PrayerTime();

  @override
  void initState() {
    getPrayerTime();
    super.initState();
  }

  Future<void> getPrayerTime({String city = "karachi"}) async {
    http.Response response = await http
        .get(Uri.parse("https://dailyprayer.abdulrcs.repl.co/api/${city}"));
    print(response.statusCode);
    print(response.body);

    setState(() {
      time = PrayerTime.fromJson(jsonDecode(response.body));
    });
  }

  String? cityname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/images/mosque.jpg"))),
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          TextField(
            onChanged: ((value) {
              cityname = value;
              getPrayerTime(city: cityname!);
            }),
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
                hintText: "City name",
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(3)))),
          ),
          Text(
            "${time.city ?? 'wait plz'}",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "${time.date ?? 'wait plz'}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Spacer(),
          _timeCard("Fajr", "${time.today?.fajr ?? 'wait plz'}"),
          _timeCard("Sunrise", "${time.today?.sunrise ?? 'wait plz'}"),
          _timeCard("Dhuhr", "${time.today?.dhuhr ?? 'wait plz'}"),
          _timeCard("Asr", "${time.today?.asr ?? 'wait plz'}"),
          _timeCard("Maghrib", "${time.today?.maghrib ?? 'wait plz'}"),
          _timeCard("Ishak", "${time.today?.ishaA ?? 'wait plz'}"),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  Widget _timeCard(String name, String time) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4)),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 25,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ]),
    );
  }
}
