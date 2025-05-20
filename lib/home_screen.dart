import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:glucose_monitoring/api.dart';
import 'package:glucose_monitoring/controller/data_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

// === Model Classes (Inline for simplicity) ===
class Nutrition {
  final double? calories;
  final double? protein;
  final double? fat;
  final double? sugar;

  Nutrition({this.calories, this.protein, this.fat, this.sugar});

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories']?.toDouble(),
      protein: json['protein']?.toDouble(),
      fat: json['fat']?.toDouble(),
      sugar: json['sugar']?.toDouble(),
    );
  }
}

class Food {
  final String id;
  final String name;
  final int giValue;
  final String mealType;
  final String imageUrl;
  final String recipeLink;
  final Nutrition nutrition;
  final List<String> allergens;
  final List<String> tags;

  Food({
    required this.id,
    required this.name,
    required this.giValue,
    required this.mealType,
    required this.imageUrl,
    required this.recipeLink,
    required this.nutrition,
    required this.allergens,
    required this.tags,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      giValue: json['giValue'],
      mealType: json['mealType'],
      imageUrl: json['imageUrl'],
      recipeLink: json['recipeLink'],
      nutrition: Nutrition.fromJson(json['nutrition']),
      allergens: List<String>.from(json['allergens']),
      tags: List<String>.from(json['tags']),
    );
  }
}

class RecommendationResponse {
  final List<Food> recommendations;
  final String glucoseTrend;

  RecommendationResponse({
    required this.recommendations,
    required this.glucoseTrend,
  });

  factory RecommendationResponse.fromJson(Map<String, dynamic> json) {
    var list = json['recommendations'] as List;
    List<Food> foods = list.map((i) => Food.fromJson(i)).toList();

    return RecommendationResponse(
      recommendations: foods,
      glucoseTrend: json['glucoseTrend'],
    );
  }
}
// === End of Models ===

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<Map<String, dynamic>> glucoseDataFuture;
  final DataController dataController = Get.find();
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
      return const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFDA2C38)]);
    } else {
      return const LinearGradient(
          colors: [Color(0xffD8EFEE), Color(0xff22C55E)]);
    }
  }

  String getStatusText(double glucoseValue) {
    if (glucoseValue < 70) return 'Low';
    if (glucoseValue > 140) return 'High';
    return 'Good';
  }

  // Replace hardcoded food with API call
  Future<List<Food>> fetchRecommendedFoods() async {
    try {
      final response = await Api().getFoodRecommendations();
      return response.recommendations;
    } catch (e) {
      print("Error fetching recommendations: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<Map<String, dynamic>>(
          future: glucoseDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData ||
                (snapshot.data!['readings'] as List).isEmpty &&
                    (snapshot.data!['predictions'] as List).isEmpty) {
              return const Center(child: Text('No glucose data available'));
            }

            final readings =
                snapshot.data!['readings'] as List<Map<String, dynamic>>;
            final predictions =
                snapshot.data!['predictions'] as List<Map<String, dynamic>>;

            readings.sort((a, b) => DateTime.parse(b['timestamp'])
                .compareTo(DateTime.parse(a['timestamp'])));

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

            final minX = 0;
            final maxX = chartSpots.isNotEmpty ? chartSpots.last.x : 0;

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
                      gradient: getGradient(glucoseValue),
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
                            Text('${glucoseValue.toInt()} mg/dL',
                                style: const TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.w600)),
                            const Text('Last Measured:',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w200)),
                            Text(
                              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w200),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          height: 93,
                          width: 93,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: gradient,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                spreadRadius: -2,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleButtons(
                        borderRadius: BorderRadius.circular(24),
                        borderColor: Colors.blue.withOpacity(0.7),
                        borderWidth: 2,
                        selectedBorderColor: Colors.blue,
                        selectedColor: Colors.white,
                        fillColor: Colors.blue.withOpacity(0.9),
                        splashColor: Colors.blue.withOpacity(0.3),
                        hoverColor: Colors.blue.withOpacity(0.2),
                        constraints:
                            const BoxConstraints(minHeight: 44, minWidth: 100),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        isSelected: [!showPredictions, showPredictions],
                        onPressed: (index) {
                          setState(() {
                            showPredictions = index == 1;
                          });
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.show_chart, size: 20),
                                SizedBox(width: 8),
                                Text('History'),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.auto_graph, size: 20),
                                SizedBox(width: 8),
                                Text('Predictions'),
                              ],
                            ),
                          ),
                        ],
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
                        minX: minX.toDouble(),
                        maxX: maxX.toDouble(),
                        minY: 50,
                        maxY: 200,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index >= 0 &&
                                    index < chartTimestamps.length) {
                                  if (index % 12 == 0 ||
                                      index == 0 ||
                                      index == chartTimestamps.length - 1) {
                                    final time = chartTimestamps[index];
                                    return Text(
                                      "${time.hour}:${time.minute.toString().padLeft(2, '0')}",
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
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
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.5)),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartSpots,
                            isCurved: true,
                            gradient: const LinearGradient(
                              colors: [Colors.blueAccent, Colors.blue],
                            ),
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromARGB(255, 33, 243, 114)
                                      .withOpacity(0.3),
                                  const Color.fromARGB(255, 33, 243, 58)
                                      .withOpacity(0.1),
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
                  // Food Recommendations
                  const Text(
                    "Recommended Foods",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<List<Food>>(
                    future: fetchRecommendedFoods(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No recommendations available.');
                      } else {
                        return SizedBox(
                          height: 130,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final food = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: GestureDetector(
                                  onTap: () =>
                                      _showFoodDetailsFromApi(context, food),
                                  child: FoodCardFromApi(food: food),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
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

  void _showFoodDetailsFromApi(BuildContext context, Food food) {
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
              Text(
                'GI Value: ${food.giValue}\nMeal Type: ${food.mealType}\nCalories: ${food.nutrition.calories ?? 0}',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: const Color(0xff17B5A6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FoodCardFromApi extends StatelessWidget {
  final Food food;
  const FoodCardFromApi({super.key, required this.food});

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
