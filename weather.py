import requests

def get_weather(city_name, api_key):
    try:
        geo_url = 'http://api.openweathermap.org/geo/1.0/direct'
        geo_params = {
            'q': city_name,
            'appid': api_key,
            'limit': 1
        }
        geo_response = requests.get(geo_url, params=geo_params, timeout=5)
        
        if geo_response.status_code == 401:
            return {'error': 'Неверный API ключ'}
        
        if geo_response.status_code != 200 or not geo_response.json():
            return {'error': 'Город не найден'}
        
        geo_data = geo_response.json()[0]
        lat, lon = geo_data['lat'], geo_data['lon']
        
        weather_url = 'https://api.openweathermap.org/data/2.5/weather'
        weather_params = {
            'lat': lat,
            'lon': lon,
            'appid': api_key,
            'units': 'metric',
            'lang': 'ru'
        }
        weather_response = requests.get(weather_url, params=weather_params, timeout=5)
        
        if weather_response.status_code == 401:
            return {'error': 'Неверный API ключ'}
        
        if weather_response.status_code != 200:
            return {'error': 'Ошибка получения погоды'}
        
        data = weather_response.json()
        
        return {
            'город': city_name,
            'температура': data['main']['temp'],
            'описание': data['weather'][0]['description'],
            'влажность': data['main']['humidity'],
            'ветер': data['wind']['speed']
        }
        
    except requests.Timeout:
        return {'error': 'Таймаут 5 секунд'}
    except Exception:
        return {'error': 'Ошибка при запросе'}

API_KEY = 'cbcf80c6e01e6c2996e8ff4205775e14'
city = input("Введите название города: ")

result = get_weather(city, API_KEY)

if 'error' in result:
    print(result['error'])
else:
    print(f"Город: {result['город']}")
    print(f"Температура: {result['температура']}°C")
    print(f"Описание: {result['описание']}")
    print(f"Влажность: {result['влажность']}%")
    print(f"Ветер: {result['ветер']} м/с")