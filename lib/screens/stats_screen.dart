import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../provider/character_provider.dart';

/// Pantalla que muestra estadísticas sobre los personajes,
/// incluyendo conteos por estado y gráficos de distribución y top episodios.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<CharacterProvider>();
    final characters = prov.allCharacters;

    // Conteo de personajes vivos, muertos y desconocidos
    final alive = characters
        .where((c) => c.status?.toLowerCase() == 'alive')
        .length;
    final dead = characters
        .where((c) => c.status?.toLowerCase() == 'dead')
        .length;
    final unknown = characters
        .where((c) => c.status?.toLowerCase() == 'unknown')
        .length;

    // Lista ordenada por cantidad de episodios (descendente)
    final top = [...characters];
    top.sort((a, b) => b.episode!.length.compareTo(a.episode!.length));
    final topFive = top.take(5).toList();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Estadísticas'),
        backgroundColor: Colors.greenAccent[400],
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estados de los personajes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Tarjetas con conteos
            StatCard('Total', characters.length, Colors.amber),
            StatCard('Vivos', alive, Colors.green),
            StatCard('Muertos', dead, Colors.red),
            StatCard('Desconocidos', unknown, Colors.grey),
            const SizedBox(height: 50),

            // Gráfico circular con la distribución de estados
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: alive.toDouble(),
                      color: Colors.green,
                      title: 'Vivos: $alive',
                      radius: 120,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: dead.toDouble(),
                      color: Colors.red,
                      title: 'Muertos: $dead',
                      radius: 120,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: unknown.toDouble(),
                      color: Colors.grey,
                      title: 'Desconocidos: $unknown',
                      radius: 120,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  centerSpaceRadius: 20,
                  sectionsSpace: 0,
                ),
              ),
            ),
            const SizedBox(height: 50),

            const Text(
              'Top 5 Personajes con más episodios',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Gráfico de barras para los 5 personajes con más episodios
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: topFive.isNotEmpty
                      ? topFive.first.episode!.length.toDouble() + 2
                      : 10,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          final idx = v.toInt();
                          if (idx < 0 || idx >= topFive.length) {
                            return const SizedBox.shrink();
                          }
                          // Mostrar solo el primer nombre para evitar saturación
                          return Text(
                            topFive[idx].name!.split(' ')[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: topFive.asMap().entries.map((e) {
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: e.value.episode!.length.toDouble(),
                          color: Colors.greenAccent,
                          width: 18,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget que muestra una tarjeta con una etiqueta, un conteo y color personalizado.
class StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  /// Crea una tarjeta estadística con [label], [count] y [color].
  const StatCard(this.label, this.count, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.2),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          count.toString(),
          style: TextStyle(color: color, fontSize: 20),
        ),
      ),
    );
  }
}
