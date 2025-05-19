import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:glucose_monitoring/api.dart';
import 'package:glucose_monitoring/controller/data_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<Map<String, dynamic>> glucoseDataFuture;
  final DataController dataController = Get.find();

  // New: Chart toggle state
  bool showPredictions = false;

  @override
  void initState() {
    super.initState();
    glucoseDataFuture = _initializeGlucoseData();
  }

  Future<Map<String, dynamic>> _initializeGlucoseData() async {
    await dataController.loadUserData();
    final userData = dataController.userData.value;
    final userId = userData?['id'];
    if (userId == null) {
      throw Exception('User ID not found in DataController');
    }
    final readings = await Api().getGlucoseReadings(userId);
    final predictions = await Api().getPredictedGlucose(userId);
    return {'readings': readings, 'predictions': predictions};
  }

  Gradient getGradient(double glucoseValue) {
    if (glucoseValue < 70 || glucoseValue > 140) {
      return LinearGradient(
        colors: [Colors.red.shade900, Colors.red.shade300],
      );
    } else {
      return LinearGradient(
        colors: [Colors.green.shade900, Colors.green.shade300],
      );
    }
  }

  String getStatusText(double glucoseValue) {
    if (glucoseValue < 70) return 'Low ❗';
    if (glucoseValue > 140) return 'High ❗';
    return 'Normal ✅';
  }

  final List<FoodRecommendation> recommendedFoods = [
    FoodRecommendation(
      name: "Avocado Toast",
      imageUrl:
          "https://www.rootsandradishes.com/wp-content/uploads/2017/08/avocado-toast-with-everything-bagel-seasoning-feat.jpg ",
      description: "Healthy fats and fiber-rich.",
    ),
    FoodRecommendation(
      name: "Greek Yogurt",
      imageUrl:
          "https://images.unsplash.com/photo-1627308595229-7830a5c91f9f?auto=format&fit=crop&w=800&q=60 ",
      description: "High in protein and probiotics.",
    ),
    FoodRecommendation(
      name: "Oatmeal with Berries",
      imageUrl:
          "https://www.pcrm.org/sites/default/files/Oatmeal%20and%20Berries.jpg ",
      description: "Great for slow-releasing energy.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Map<String, dynamic>>(
          future: glucoseDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData ||
                snapshot.data!['readings'].isEmpty &&
                    snapshot.data!['predictions'].isEmpty) {
              return Center(child: Text('No glucose data available'));
            }

            final readings =
                snapshot.data!['readings'] as List<Map<String, dynamic>>;
            final predictions =
                snapshot.data!['predictions'] as List<Map<String, dynamic>>;

            // Sort readings by timestamp (descending)
            readings.sort((a, b) => DateTime.parse(b['timestamp'])
                .compareTo(DateTime.parse(a['timestamp'])));

            // Generate chart data based on toggle state
            final List<FlSpot> chartSpots = [];
            final List<DateTime> chartTimestamps = [];

            if (!showPredictions) {
              for (int i = 0; i < readings.length; i++) {
                final entry = readings[i];
                final value = double.tryParse(entry['value'].toString()) ?? 0.0;
                chartSpots.add(FlSpot(i.toDouble(), value));
                chartTimestamps.add(DateTime.parse(entry['timestamp']));
              }
            } else {
              for (int i = 0; i < predictions.length; i++) {
                final entry = predictions[i];
                final value = double.tryParse(entry['value'].toString()) ?? 0.0;
                chartSpots.add(FlSpot(i.toDouble(), value));
                chartTimestamps.add(DateTime.parse(entry['predictedFor']));
              }
            }

            // Determine min/max X
            final minX = -readings.length + 1;
            final maxX = predictions.isNotEmpty ? predictions.length - 1 : 0;

            // Latest reading (for status indicator)
            final latestReading = readings.first;
            final glucoseValue = latestReading['value'] as double;
            final timestamp = DateTime.parse(latestReading['timestamp']);
            final statusText = getStatusText(glucoseValue);
            final gradient = getGradient(glucoseValue);

            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Glucose Info Card
                  Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      gradient: const LinearGradient(
                        colors: [Color(0xff17B5A6), Color(0xffD8EFEE)],
                      ),
                    ),
                    height: 150,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Current Glucose',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w200)),
                            Text('$glucoseValue mg/dL',
                                style: const TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w600)),
                            const Text('Last Measured:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w200)),
                            Text(
                                '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w200)),
                          ],
                        ),
                        const Spacer(),
                        // Gradient Status Circle
                        Container(
                          height: 93,
                          width: 93,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: gradient,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: ShaderMask(
                                  shaderCallback: (Rect rect) =>
                                      gradient.createShader(rect),
                                  child: Text(
                                    statusText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  // Toggle Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            setState(() => showPredictions = false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              !showPredictions ? Colors.blue : Colors.grey,
                        ),
                        child: const Text('History'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () => setState(() => showPredictions = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              showPredictions ? Colors.blue : Colors.grey,
                        ),
                        child: const Text('Predictions'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Chart
                  SizedBox(
                    height: 227,
                    width: double.infinity,
                    child: LineChart(
                      LineChartData(
                        minX: 0,
                        maxX: chartSpots.isNotEmpty
                            ? chartSpots.length.toDouble() - 1
                            : 0,
                        minY: 50,
                        maxY: 200,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 &&
                                    index < chartTimestamps.length) {
                                  final time = chartTimestamps[index];
                                  return Text(
                                    "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
                                    style: const TextStyle(fontSize: 10),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                              reservedSize: 32,
                              interval: 1,
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
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 20,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.3),
                            strokeWidth: 1,
                          ),
                          getDrawingVerticalLine: (value) => FlLine(
                            color: Colors.grey.withOpacity(0.2),
                            strokeWidth: 1,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartSpots,
                            isCurved: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade800,
                                Colors.blue.shade200
                              ],
                            ),
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(0.3),
                                  Colors.blue.withOpacity(0.1),
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

                  const SizedBox(height: 30),
                  // Food Recommendations (unchanged)
                  const Text(
                    "Recommended Foods",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedFoods.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: GestureDetector(
                            onTap: () => _showFoodDetails(
                                context, recommendedFoods[index]),
                            child: FoodCard(food: recommendedFoods[index]),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFoodDetails(BuildContext context, FoodRecommendation food) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
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
                  child: const Icon(Icons.broken_image,
                      size: 48, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
              Text(food.name,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(food.description,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: const Color(0xff17B5A6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text("Close"),
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
        boxShadow: const [
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                child: const Icon(Icons.broken_image,
                    size: 32, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
