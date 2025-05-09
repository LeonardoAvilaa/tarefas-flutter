import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherScreen(),
    );
  }
}

class WeatherModel {
  final double temperature;
  final String weatherDescription;

  WeatherModel({required this.temperature, required this.weatherDescription});
}

class WeatherService {
  final String apiKey = '4a60eac1d150790159331537b82f2d84';

  Future<WeatherModel> getWeather() async {
    // consegue a localização
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // faz a requisição HTTP
    final lat = position.latitude;
    final lon = position.longitude;
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=pt_br';

    // requisição HTTP com timeout de 10 segundos
    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    // verifica se a requisição foi bem-sucedida
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherModel(
        temperature: data['main']['temp'],
        weatherDescription: data['weather'][0]['description'],
      );
    } else {
      // exibe uma mensagem de erro
      throw Exception('Erro ao buscar clima: ${response.statusCode}');
    }
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  WeatherModel? _weatherModel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getWeather();
  }

  Future<void> _getWeather() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final weatherModel = await _weatherService.getWeather();
      setState(() {
        _weatherModel = weatherModel;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao buscar clima: $e')));
    }
  }

  // exibe a temperatura e o clima na tela
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima Atual')),
      body: Center(
        child:
            _isLoading
                ? const CircularProgressIndicator()
                : _weatherModel != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_weatherModel!.temperature} °C',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _weatherModel!.weatherDescription,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                )
                : const Text('Nenhuma condição climática encontrada'),
      ),
    );
  }
}
