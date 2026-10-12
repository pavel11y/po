import os
import time
from PIL import Image, ImageDraw
from multiprocessing import Pool, cpu_count
from pathlib import Path
import random

def create_img(filename, size=(1920, 1080)):
    width, height = size
    center_x = width // 2
    center_y = height // 2

    colors = [
        (255, 100, 100), (100, 255, 100), (100, 100, 255),
        (255, 255, 100), (255, 100, 255), (100, 255, 255),
        (255, 150, 50), (150, 50, 255), (50, 200, 150),
    ]

    bg_color = random.choice(colors)

    img = Image.new('RGB', size, color=bg_color)
    draw = ImageDraw.Draw(img)

    arrow_len = min(width, height) // 3
    arrow_wid = arrow_len // 6
    end_x = center_x
    end_y = center_y - arrow_len

    draw.line([(center_x, center_y), (end_x, end_y)],
                fill=(0,0,0), width=arrow_wid)
    
    arrowhead_size = arrow_wid * 2
    points = [
        (end_x, end_y),
        (end_x - arrowhead_size, end_y + arrowhead_size),
        (end_x + arrowhead_size, end_y + arrowhead_size),
    ]
    draw.polygon(points, fill=(0,0,0))

    img.save(filename, quality=95)

def process_img(args):
    input_path, output_path = args

    try:
        with Image.open(input_path) as img:
            img_rotated = img.rotate(90, expand=True)
            img_resized = img_rotated.resize((800, 600), Image.LANCZOS)
            img_gray = img_resized.convert('L')
            img_gray.save(output_path, quality=95)
        return True, input_path
    except Exception as e:
        return False, f"{input_path}: {str(e)}"
    
def sequential_processing(image_files, output_dir):
    print('последовательная обработка')

    start_time = time.time()

    results = []

    for idx, img_file in enumerate(image_files, 1):
        print(f'обработка {idx}/{len(image_files)}: {img_file.name}')
        input_path = str(img_file)
        output_path = os.path.join(output_dir, f'out_{img_file.name}')
        result = process_img((input_path, output_path))
        results.append(result)

    all_time = time.time() - start_time

    success_count = sum(1 for r in results if r[0])
    print(f'результат: успешно {success_count}/{len(image_files)}')
    print(f'время выполнения: {all_time} сек')

    return all_time

def parallel_processing(image_files, output_dir, num_workers=None):
    if num_workers is None:
        num_workers = cpu_count()

    print(f'параллельная обработка (процессов: {num_workers})')

    tasks = []
    for img_file in image_files:
        input_path = str(img_file)
        output_path = os.path.join(output_dir, f'out_{img_file.name}')
        tasks.append((input_path, output_path))

    start_time = time.time()

    with Pool(processes=num_workers) as pool:
        results = pool.map(process_img, tasks)

    all_time = time.time() - start_time

    success_count = sum(1 for r in results if r[0])
    print(f'результат: успешно {success_count}/{len(image_files)}')
    print(f'время выполнения: {all_time} сек')

    return all_time

def main():
    print('обработка изображения')
    print('создание изображений')

    input_dir = Path('test_imgs')
    input_dir.mkdir(exist_ok=True)

    NUM_TEST_IMAGES = 10

    for i in range(NUM_TEST_IMAGES):
        filename = input_dir / f'img_{i}.jpg'
        create_img(str(filename))

    print(f"создано {NUM_TEST_IMAGES} тестовых изображений в папке 'test_imgs/'")

    output_dir_seq = Path("processed_seq")
    output_dir_par = Path("processed_par")
    output_dir_seq.mkdir(exist_ok=True)
    output_dir_par.mkdir(exist_ok=True)

    image_files = sorted(list(input_dir.glob("*.jpg")))

    print(f'найдено изображений: {len(image_files)}')

    time_seq = sequential_processing(image_files, output_dir_seq)
    time_par = parallel_processing(image_files, output_dir_par)

    print('сравнение производительности')
    print(f'последовательная обработка: {time_seq} сек')
    print(f'параллельная обработка:     {time_par} сек')

    if time_par < time_seq:
        speedup = time_seq / time_par
        print(f'ускорение {speedup:.2f}x')
        print(f'экономия времени: {(time_seq - time_par)} сек')
    else:
        print('параллельная обработка не дала ускорения')

if __name__ == "__main__":
    main()