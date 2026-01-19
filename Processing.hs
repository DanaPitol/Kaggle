module Processing where

import Data.Char (toUpper, isSpace)
import Data.List (sort, foldl')

-- FP1: Definición del registro Stats (Requisito 4)
data Stats = Stats { 
    suma :: Double, 
    promedio :: Double, 
    std :: Double,
    mediana :: Double,
    minimo :: Double, 
    maximo :: Double 
} deriving (Show)

-- FP1: Función pura para estadísticas (Requisito 4 y 5)
computeStats :: [Double] -> Stats
computeStats [] = Stats 0 0 0 0 0 0
computeStats xs = 
    let n = fromIntegral $ length xs
        -- REQUISITO: Uso de fold (reduce) para la suma
        s = foldl' (+) 0 xs
        m = s / n
        -- REQUISITO: Uso de fold (reduce) para desviación estándar
        sumSqDiff = foldl' (\acc x -> acc + (x - m)**2) 0 xs
        dev = sqrt (sumSqDiff / n)
        -- Cálculo de mediana
        sortedXs = sort xs
        med = if odd (length xs) 
              then sortedXs !! (length xs `div` 2)
              else (sortedXs !! (length xs `div` 2 - 1) + sortedXs !! (length xs `div` 2)) / 2
    in Stats s m dev med (minimum xs) (maximum xs)

-- FP2: Función pura para transformación de texto (Requisito 4 y 5)
transformText :: String -> Int -> Char -> String
transformText txt l pad = 
    let -- Pipeline: Mayúsculas -> Trim -> Colapsar espacios (unwords . words)
        clean = unwords . words . map toUpper $ txt
        len = length clean
    in if len > l 
       then take l clean -- Recortar si excede L
       else clean ++ replicate (l - len) pad -- Rellenar con PAD_CHAR