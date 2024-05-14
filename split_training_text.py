import os
import random
import pathlib
import subprocess

# print(os.getenv('FONTCONFIG_PATH'))  # Check if the variable is set
# os.environ['FONTCONFIG_PATH'] = 'C:\\msys64\\mingw64\\etc\\fonts'  # Set it explicitly
# print("______________ : ", os.getenv('FONTCONFIG_PATH'))  # Check if the variable is set

training_text_file = 'langdata/eng.training_text'

lines = []

with open(training_text_file, 'r', encoding='utf-8') as input_file:  # Change made here
    for line in input_file.readlines():
        lines.append(line.strip())

output_directory = 'tesstrain/data/earthMomma-ground-truth' # "NameFont-ground-truth" obligatoir

if not os.path.exists(output_directory):
    os.mkdir(output_directory)

random.shuffle(lines)

# count = 100

# lines = lines[:count]

line_count = 0
for line in lines:
    training_text_file_name = pathlib.Path(training_text_file).stem
    line_training_text = os.path.join(output_directory, f'{training_text_file_name}_{line_count}.gt.txt')
    with open(line_training_text, 'w', encoding='utf-8') as output_file:  # Consider also setting encoding here
        output_file.writelines([line])

    file_base_name = f'eng_{line_count}'

    subprocess.run([
        'text2image',
        '--font=Earth Momma',
        '--fonts_dir', 'fonts',
        f'--text={line_training_text}',
        f'--outputbase={output_directory}/{file_base_name}',
        '--max_pages=10',
        '--strip_unrenderable_words',
        '--leading=32',
        '--xsize=3600',
        '--ysize=480',
        '--char_spacing=1.0',
        '--exposure=0',
        '--unicharset_file=langdata/eng.unicharset'
    ])

    line_count += 1


# cd tesstrain/
# Training command:
# TESSDATA_PREFIX=../tesseract/tessdata make training MODEL_NAME=earthMomma START_MODEL= eng TESSDATA=../tesseract/tessdata MAX_ITERATIONS=10000