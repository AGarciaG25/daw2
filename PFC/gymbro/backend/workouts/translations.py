import re


EXERCISE_NAME_MAP = {
    '3/4 Sit Up': 'Abdominal parcial 3/4',
    '90/90 Hamstring': 'Estiramiento de isquios 90/90',
    'Ab Crunch Machine': 'Crunch en maquina abdominal',
    'Ab Roller': 'Rueda abdominal',
    'Adductor': 'Aductor',
    'Adductor/Groin': 'Aductor e ingle',
    'Advanced Kettlebell Windmill': 'Molino avanzado con kettlebell',
    'Air Bike': 'Bicicleta abdominal',
    'All Fours Quad Stretch': 'Estiramiento de cuadriceps a cuatro apoyos',
    'Alternate Hammer Curl': 'Curl martillo alterno',
    'Alternate Heel Touchers': 'Toques alternos de talon',
    'Alternate Incline Dumbbell Curl': 'Curl inclinado alterno con mancuernas',
    'Alternate Leg Diagonal Bound': 'Salto diagonal alterno de pierna',
    'Alternating Cable Shoulder Press': 'Press alterno de hombro en polea',
    'Alternating Deltoid Raise': 'Elevacion alterna de deltoides',
    'Alternating Floor Press': 'Press alterno en el suelo',
    'Alternating Hang Clean': 'Cargada colgante alterna',
    'Alternating Kettlebell Press': 'Press alterno con kettlebell',
    'Alternating Kettlebell Row': 'Remo alterno con kettlebell',
    'Alternating Renegade Row': 'Remo renegado alterno',
    'Ankle Circles': 'Circulos de tobillo',
    'Ankle On The Knee': 'Tobillo sobre rodilla',
    'Anterior Tibialis Smr': 'Liberacion miofascial del tibial anterior',
    'Anti Gravity Press': 'Press antigravedad',
    'Arm Circles': 'Circulos de brazos',
    'Arnold Dumbbell Press': 'Press Arnold con mancuernas',
    'Around The Worlds': 'Alrededor del mundo',
    'Atlas Stone Trainer': 'Entrenador de piedra Atlas',
    'Atlas Stones': 'Piedras Atlas',
    'Axle Deadlift': 'Peso muerto con barra gruesa',
    'Back Flyes With Bands': 'Aperturas posteriores con bandas',
    'Backward Drag': 'Arrastre hacia atras',
    'Backward Medicine Ball Throw': 'Lanzamiento hacia atras con balon medicinal',
    'Balance Board': 'Tabla de equilibrio',
    'Ball Leg Curl': 'Curl femoral con fitball',
    'Band Assisted Pull Up': 'Dominada asistida con banda',
    'Band Good Morning': 'Buenos dias con banda',
    'Band Good Morning (Pull Through)': 'Buenos dias con banda tipo pull through',
    'Band Hip Adductions': 'Aducciones de cadera con banda',
    'Band Pull Apart': 'Separacion de banda',
    'Band Skull Crusher': 'Extension de triceps con banda',
    'Barbell Ab Rollout': 'Rueda abdominal con barra',
    'Barbell Incline Press': 'Press inclinado con barra',
    'Barbell Incline Bench Press - Medium Grip': 'Press inclinado con barra agarre medio',
    'Barbell Lunge': 'Zancada con barra',
    'Barbell Shrug': 'Encogimiento con barra',
    'Barbell Squat': 'Sentadilla con barra',
    'Barbell Step Ups': 'Subida al cajon con barra',
    'Bench Dips': 'Fondos en banco',
    'Bench Press - With Bands': 'Press banca con bandas',
    'Bent Over Barbell Row': 'Remo inclinado con barra',
    'Bent Over Two-Dumbbell Row': 'Remo inclinado con dos mancuernas',
    'Butt Lift Bridge': 'Puente de gluteos',
    'Cable Hammer Curls - Rope Attachment': 'Curl martillo en polea con cuerda',
    'Cable Incline Triceps Extension': 'Extension inclinada de triceps en polea',
    'Cable Lying Triceps Extension': 'Extension tumbada de triceps en polea',
    'Calf Press On The Leg Press Machine': 'Elevacion de gemelos en prensa',
    'Chin-Up': 'Dominada supina',
    'Close-Grip Front Lat Pulldown': 'Jalon frontal cerrado',
    'Glute Kickback': 'Patada de gluteo',
    'Monster Walk': 'Caminata monster walk',
    'Thigh Adductor': 'Aductor en maquina',
}

DISPLAY_NAME_MAP = {
    'abdominals': 'Abdominales',
    'abductors': 'Abductores',
    'adductors': 'Aductores',
    'bands': 'Bandas',
    'barbell': 'Barra',
    'biceps': 'Biceps',
    'body only': 'Peso corporal',
    'body weight': 'Peso corporal',
    'cable': 'Polea',
    'calves': 'Gemelos',
    'cardio': 'Cardio',
    'cardiovascular system': 'Sistema cardiovascular',
    'chest': 'Pecho',
    'delts': 'Deltoides',
    'dumbbell': 'Mancuernas',
    'exercise ball': 'Fitball',
    'foam roll': 'Rodillo de espuma',
    'forearms': 'Antebrazos',
    'glutes': 'Gluteos',
    'hamstrings': 'Isquiotibiales',
    'hip flexors': 'Flexores de cadera',
    'kettlebell': 'Pesa rusa',
    'kettlebells': 'Pesas rusas',
    'lats': 'Dorsales',
    'lower arms': 'Antebrazos',
    'lower back': 'Lumbar',
    'machine': 'Maquina',
    'medicine ball': 'Balon medicinal',
    'middle back': 'Espalda media',
    'none': 'Sin material',
    'other': 'Accesorio',
    'pectorals': 'Pectorales',
    'quadriceps': 'Cuadriceps',
    'shoulders': 'Hombros',
    'traps': 'Trapecios',
    'triceps': 'Triceps',
    'upper arms': 'Brazos',
    'upper back': 'Espalda alta',
    'waist': 'Core',
}

BODY_REGION_VALUE_MAP = {
    'upper_body': 'tren_superior',
    'lower_body': 'tren_inferior',
    'full_body': 'cuerpo_completo',
}

DIFFICULTY_VALUE_MAP = {
    'beginner': 'principiante',
    'intermediate': 'intermedio',
    'advanced': 'avanzado',
}

EMPHASIS_VALUE_MAP = {
    'primary': 'principal',
    'secondary': 'secundario',
    'stabilizer': 'estabilizador',
}


def prettify_spanish(value):
    normalized = ' '.join(str(value or '').replace('_', ' ').replace('-', ' ').split()).strip()
    if not normalized:
        return ''
    return DISPLAY_NAME_MAP.get(normalized.lower(), normalized.title())


def translate_exercise_name(value):
    cleaned = re.sub(r'\s+', ' ', str(value or '').replace('_', ' ')).strip()
    if not cleaned:
        return ''
    return EXERCISE_NAME_MAP.get(cleaned, EXERCISE_NAME_MAP.get(cleaned.title(), cleaned))


def build_spanish_description(name, equipment='', target=''):
    target_fragment = f' enfocado en {target.lower()}' if target else ''
    if str(equipment).strip().lower() == 'sin material':
        equipment_fragment = ' sin material'
    else:
        equipment_fragment = f' con {equipment.lower()}' if equipment else ''
    return f'Ejercicio{target_fragment}{equipment_fragment} para incluir en una rutina de fuerza o acondicionamiento.'


def build_spanish_instructions(name):
    return (
        f'Realiza {name.lower()} con una postura estable y movimiento controlado.\n'
        'Ajusta la carga a tu nivel, respira de forma constante y detente si aparece dolor.'
    )
