import Processing
import System.IO
import Text.Read (readMaybe)
import Data.Char (isSpace) -- <--- AGREGA ESTA LÍNEA AQUÍ

-- Constantes definidas (Requisito 3C)
lConst = 25
padChar = '-'

-- Función recursiva para dividir el CSV
splitCSV :: String -> [String]
splitCSV "" = []
splitCSV s = 
    let (before, rest) = break (== ',') s
    in before : case rest of
                    [] -> []
                    (_:after) -> splitCSV after

main :: IO ()
main = do
    putStrLn "Iniciando procesamiento de kdrama.csv..."
    
    -- Usamos readFile y forzamos la evaluación para evitar problemas de permisos
    content <- readFile "kdrama.csv"
    let allLines = lines content
    let totalFilas = length allLines - 1 
    
    -- 1. Carga y conversión a colección
    let rows = map splitCSV (tail allLines)
    
    -- 2. FILTRO CON LAMBDAS: Validación (isSpace ahora funcionará)
    let validRows = filter (\cols -> 
            length cols >= 3 && 
            not (null (head cols)) && 
            not (all isSpace (head cols)) && -- Validación de espacios
            (readMaybe (cols !! 2) :: Maybe Double) /= Nothing && 
            (readMaybe (cols !! 1) :: Maybe Double) /= Nothing    
            ) rows

    let filasValidas = length validRows
    let filasDescartadas = totalFilas - filasValidas

    -- 3. EXTRACCIÓN CON MAP Y LAMBDAS
    let num1_rating = map (\cols -> read (cols !! 2) :: Double) validRows
    let num2_episodes = map (\cols -> read (cols !! 1) :: Double) validRows
    let text_names = map (\cols -> head cols) validRows

    -- 4. PROCESAMIENTO USANDO FP1 Y FP2
    let stats1 = computeStats num1_rating
    let stats2 = computeStats num2_episodes
    let transformedTexts = map (\t -> transformText t lConst padChar) text_names

    -- 5. REPORTE
    let report = unlines [
            "=== A) VALIDACIÓN MÍNIMA ===",
            "Total de filas: " ++ show totalFilas,
            "Filas válidas: " ++ show filasValidas,
            "Filas descartadas: " ++ show filasDescartadas,
            "",
            "=== B) ESTADÍSTICA DESCRIPTIVA ===",
            "NUM1 (Rating)   -> " ++ show stats1,
            "NUM2 (Episodes) -> " ++ show stats2,
            "",
            "=== C) TRANSFORMACIÓN DE TEXTO ===",
            "L=" ++ show lConst ++ ", PAD_CHAR='" ++ [padChar] ++ "'",
            "3 Ejemplos (Original -> Transformado):",
            unlines (zipWith (\orig trans -> orig ++ " -> " ++ trans) (take 3 text_names) (take 3 transformedTexts))
            ]

    writeFile "results.txt" report
    putStrLn report
    putStrLn "======================================="
    putStrLn "¡Listo! Todo funcionó correctamente."