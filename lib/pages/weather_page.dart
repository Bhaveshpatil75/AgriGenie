
import 'package:weather/weather.dart';

Future<String> getWeather(double lat,double lon)async{
  String cityName='pune';
  WeatherFactory wf = WeatherFactory("####################",language: Language.HINDI);
  //Weather w = await wf.currentWeatherByCityName(cityName);
  Weather w = await wf.currentWeatherByLocation(lat, lon);
  List<Weather> forecast = await wf.fiveDayForecastByLocation(lat, lon);
  return w.toString();
}
