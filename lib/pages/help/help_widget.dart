import 'package:flutter/material.dart';

class HelpWidget extends StatefulWidget {
  @override
  _HelpWidgetState createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            margin: EdgeInsets.only(right: 20, left: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 120.0,
                  width: 120.0,
                  margin: EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/sp-logo.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'DIVYA QURAN - Mobile App',
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                    'A Free App Kannada translation is taken from "Pavitra Quran"  Published by Shanthi Prakashana.',),
                Text(
                  "Established in 1988 Shanti Prakashana is a value based publishing house  contributing immensely to the Kannada literatures by enriching it with islamic books since 3 decades continuously. Facilitating Kannadiga Muslims to get islamic education and  alleviation of misconceptions about Islam among non muslim are the main objectives of this  PUBLISHING house. To realise the above objectives it has published hundreds of books on different topics like  'Pavitra Quran' a Kannada translation, 'Quran Vyakhyana' & 'Tafheemul  Quran ' tafseers,  Hadeeth ( Prophets sayings), Biography of Prophets & Sahabas, Islamic Studies, Islamic way of life , Islamic history etc. ‌Shanthi Prakashana's driving force is its belief that noble qualities like Truth, Justice, Ethics, Peace, Brother hood, Equality, Mutual Trust & Respect etc. are essential for the ultimate goal of an all round progressive society  and nation  which can only be established by the propagation of religious values.",
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          )),
    );
  }
}
