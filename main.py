import csv
import json
from processing import computeStats, transformText

# Constantes definidas para el proyecto [cite: 46, 48]
L = 25
PAD_CHAR = '-'

def run_project():
    try:
        with open('kdrama.csv', mode='r', encoding='utf-8') as file:
            # 1. Cargar dataset y convertir a colección [cite: 22]
            reader = list(csv.DictReader(file))
            total_filas = len(reader)

            # 2. Filtrar filas inválidas usando filter y lambda [cite: 23, 80, 84]
            # Elimina filas donde NUM1/NUM2 no son números o TEXT es nulo/vacío [cite: 24, 25]
            valid_rows = list(filter(lambda r: 
                r['Rating'].replace('.','',1).isdigit() and 
                r['Number of Episodes'].isdigit() and 
                r['Name'].strip() != "", 
            reader))

            filas_descartadas = total_filas - len(valid_rows)

            # 3. Extraer columnas usando map y lambda [cite: 78, 83]
            num1_list = list(map(lambda r: float(r['Rating']), valid_rows))
            num2_list = list(map(lambda r: float(r['Number of Episodes']), valid_rows))
            
            # 4. Aplicar transformación de texto a toda la columna [cite: 71, 78]
            transformed_texts = list(map(lambda r: 
                transformText(r['Name'], L, PAD_CHAR), valid_rows))

            # 5. Calcular estadísticas (FP1) [cite: 59]
            stats_num1 = computeStats(num1_list)
            stats_num2 = computeStats(num2_list)

            # Preparar ejemplos para la salida [cite: 50, 74]
            examples = []
            for i in range(min(3, len(valid_rows))):
                examples.append({
                    "original": valid_rows[i]['Name'],
                    "transformed": transformed_texts[i]
                })

            # 6. Generar archivo results.json [cite: 90]
            results = {
                "stats_NUM1_Score": stats_num1,
                "stats_NUM2_Episodes": stats_num2,
                "config": {"L": L, "PAD_CHAR": PAD_CHAR},
                "examples": examples
            }

            with open('results.json', 'w') as f_out:
                json.dump(results, f_out, indent=4)

            # Salida mínima requerida en consola [cite: 26, 38, 49]
            print(f"--- VALIDACIÓN ---")
            print(f"Total filas: {total_filas}") 
            print(f"Filas válidas: {len(valid_rows)}") 
            print(f"Filas descartadas: {filas_descartadas}") 
            print(f"\n--- ESTADÍSTICAS ---")
            print(f"NUM1 (Rating) -> {stats_num1}") 
            print(f"NUM2 (Episodes) -> {stats_num2}") 
            print(f"\nArchivo 'results.json' generado con éxito.")

    except FileNotFoundError:
        print("Error: No se encontró el archivo 'kdrama.csv'.")

if __name__ == "__main__":
    run_project()