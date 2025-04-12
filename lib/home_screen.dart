import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int lastMeasure = 120;

  final List<FoodRecommendation> recommendedFoods = [
    FoodRecommendation(
      name: "Avocado Toast",
      imageUrl:
          "https://www.rootsandradishes.com/wp-content/uploads/2017/08/avocado-toast-with-everything-bagel-seasoning-feat.jpg",
      description: "Healthy fats and fiber-rich.",
    ),
    FoodRecommendation(
      name: "Greek Yogurt",
      imageUrl:
          "https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?auto=format&fit=crop&w=800&q=60",
      description: "High in protein and probiotics.",
    ),
    FoodRecommendation(
      name: "Oatmeal with Berries",
      imageUrl:
          "https://www.pcrm.org/sites/default/files/Oatmeal%20and%20Berries.jpg",
      description: "Great for slow-releasing energy.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Glucose Info Card
              Container(
                padding: EdgeInsets.all(14.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [Color(0xff17B5A6), Color(0xffD8EFEE)],
                  ),
                ),
                height: 150,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current Glucose',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w200)),
                        Text('$lastMeasure mg/dL',
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w600)),
                        Text('Last Measured:',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w200)),
                        Text('1 hour ago',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w200)),
                      ],
                    ),
                    Spacer(),
                    Container(
                      height: 93,
                      width: 93,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 5, color: Color(0xff22C55E)),
                        color: Colors.transparent,
                      ),
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
              ),
              SizedBox(height: 35),

              // Chart
              Container(
                height: 227,
                width: double.infinity,
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
                          getTitlesWidget: (value, meta) => Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('${value.toInt()}:00',
                                style: TextStyle(fontSize: 12)),
                          ),
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) =>
                              Text('${value.toInt()}'),
                          reservedSize: 30,
                        ),
                      ),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 20,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                      getDrawingVerticalLine: (value) => FlLine(
                        color: Colors.grey.withOpacity(0.3),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 1),
                    ),
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
                        isCurved: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.withOpacity(0.9),
                            Colors.tealAccent.withOpacity(0.7),
                          ],
                        ),
                        barWidth: 4,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 4,
                            color: Colors.white,
                            strokeColor: Colors.teal,
                            strokeWidth: 2,
                          ),
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.withOpacity(0.3),
                              Colors.teal.withOpacity(0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Food Recommendations Title
              Text(
                "Recommended Foods",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // Scrollable Horizontal List
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedFoods.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () =>
                            _showFoodDetails(context, recommendedFoods[index]),
                        child: FoodCard(food: recommendedFoods[index]),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  void _showFoodDetails(BuildContext context, FoodRecommendation food) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: food.imageUrl,
                height: 150,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(height: 150, color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                ),
              ),
              SizedBox(height: 12),
              Text(food.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(food.description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Color(0xff17B5A6),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Model
class FoodRecommendation {
  final String name;
  final String imageUrl;
  final String description;

  FoodRecommendation({
    required this.name,
    required this.imageUrl,
    required this.description,
  });
}

// Horizontal Card
class FoodCard extends StatelessWidget {
  final FoodRecommendation food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: food.imageUrl,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Container(height: 80, color: Colors.grey[200]),
              errorWidget: (context, url, error) => Container(
                height: 80,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, size: 32, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              food.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
