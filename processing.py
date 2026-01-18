from functools import reduce
import math

# FP1 (Numérico): computeStats(numbers) -> Stats [cite: 52]
def computeStats(numbers):
    """Calcula estadísticas usando transformaciones funcionales"""
    if not numbers:
        return {}

    n = len(numbers)
    # Requisito: usar reduce/fold para agregación [cite: 81, 85]
    suma = reduce(lambda acc, x: acc + x, numbers)
    mean = suma / n
    
    # Cálculo de desviación estándar usando reduce y lambda 
    sq_diff_sum = reduce(lambda acc, x: acc + (x - mean)**2, numbers, 0)
    std = math.sqrt(sq_diff_sum / n)
    
    sorted_nums = sorted(numbers)
    median = (sorted_nums[n//2] if n % 2 != 0 
              else (sorted_nums[n//2 - 1] + sorted_nums[n//2]) / 2)
    
    # Retorna un objeto/registro Stats [cite: 57]
    return {
        "sum": round(suma, 2),
        "mean": round(mean, 2),
        "std": round(std, 2),
        "median": round(median, 2),
        "min": min(numbers),
        "max": max(numbers)
    }

# FP2 (Texto): transformText(text, L, PAD_CHAR) -> string [cite: 62]
def transformText(text, L, PAD_CHAR):
    """Aplica el pipeline de transformación de texto[cite: 42, 63]."""
    # 1. MAYÚSCULAS [cite: 43]
    # 2. Trim (espacios inicio/fin) [cite: 44]
    # 3. Colapsar múltiples espacios internos (split + join) [cite: 45]
    step123 = " ".join(text.upper().strip().split())
    
    # 4. Ajustar a longitud fija L [cite: 46]
    if len(step123) > L:
        return step123[:L] # Recortar [cite: 47]
    else:
        return step123.ljust(L, PAD_CHAR) # Rellenar con PAD_CHAR [cite: 48]