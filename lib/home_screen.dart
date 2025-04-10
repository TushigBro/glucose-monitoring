import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int lastMeasure = 90;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.green,
                gradient: LinearGradient(
                    colors: [Color(0xff17B5A6), Color(0xffD8EFEE)])),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Glucose',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                    ),
                    Text(
                      '$lastMeasure mg/dL',
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Last Measured: ',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                    ),
                    Text(
                      '1 hour ago',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  height: 93,
                  width: 93,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 5, color: Color(0xff22C55E)),
                      color: Colors.transparent),
                  child: Center(
                    child: Text(
                      'Good',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff22C55E)),
                    ),
                  ),
                ),
              ],
            ),
            height: 150,
          ),
          SizedBox(height: 35),
          Container(
            height: 227,
            width: 390,
            child: LineChart(
              LineChartData(
                minX: 1,
                maxX: 6,
                minY: 0,
                maxY: 120,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}:00');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(1, 60),
                      FlSpot(2, 70),
                      FlSpot(3, 80),
                      FlSpot(4, 90),
                      FlSpot(5, 100),
                      FlSpot(6, 110),
                    ],
                    isCurved: false,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    color: Colors.teal[700],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}

class FoodContainer extends StatelessWidget {
  const FoodContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CachedNetworkImage(
              imageUrl:
                  "https://lh5.googleusercontent.com/proxy/BM9hVGgcrE7tem5IcXX_-fafxT9238Wn0ZQ02eex5OEAb4yMsOQeUpM98q1SzxqB67BnIpE_cF-l6Q2AjPIzX37srwMCQZ56jJSs2b6qDfS-MsjvFiouOgzW0MJ0tjEL",
              height: 100,
              width: 120),
        ],
      ),
    );
  }
}
