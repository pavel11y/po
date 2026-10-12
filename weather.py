import requests
import sys

API_KEY = 'cbcf80c6e01e6c2996e8ff4205775e14'
BASE_URL = 'https://api.openweathermap.org/data/2.5/weather'

def get_weather(city):
    params = {
        'q': city,
        'appid': API_KEY,
        'units': 'metric',
        'lang': 'ru'
    }
    
    try:
        response = requests.get(BASE_URL, params=params, timeout=5)
        
        if response.status_code == 200:
            data = response.json()
            
            weather_info = {
                'город': data['name'],
                'температура': f"{data['main']['temp']:.1f}°C",
                'ощущается_как': f"{data['main']['feels_like']:.1f}°C",
                'описание': data['weather'][0]['description'].capitalize(),
                'влажность': f"{data['main']['humidity']}%",
                'ветер': f"{data['wind']['speed']} м/с"
            }
            
            if 'deg' in data['wind']:
                weather_info['направление_ветра'] = f"{data['wind']['deg']}°"
            
            return weather_info
            
        elif response.status_code == 401:
            print("Ошибка 401: Неверный API-ключ")
            return None
            
        elif response.status_code == 404:
            print(f"Ошибка 404: Город '{city}' не найден")
            return None
            
        else:
            print(f"Ошибка {response.status_code}: {response.json().get('message', 'Неизвестная ошибка')}")
            return None
            
    except requests.exceptions.Timeout:
        print("Ошибка: Превышен таймаут ожидания (5 секунд)")
        return None
        
    except requests.exceptions.ConnectionError:
        print("Ошибка: Не удалось подключиться к серверу")
        return None
        
    except requests.exceptions.RequestException as e:
        print(f"Ошибка при выполнении запроса: {e}")
        return None

if len(sys.argv) > 1:
    city = ' '.join(sys.argv[1:])
    print(f"Запрос погоды для города: {city}\n")
else:
    city = input("Введите название города: ").strip()
    if not city:
        print("Название города не может быть пустым")
        sys.exit(1)

weather = get_weather(city)

if weather:
    print(f"Погода в городе: {weather['город']}")
    print(f"Температура: {weather['температура']} (ощущается как {weather['ощущается_как']})")
    print(f"Описание: {weather['описание']}")
    print(f"Влажность: {weather['влажность']}")
    print(f"Ветер: {weather['ветер']}")
    if 'направление_ветра' in weather:
        print(f"Направление ветра: {weather['направление_ветра']}")
else:
    print("\nНе удалось получить данные о погоде")
