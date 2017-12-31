-- | Divine with zhouyi

module ZY.Divination where

import Arguments (Arguments)

type Gua = [Int]

divine
    :: Arguments -- ^ arguments in the cli
    -> String -- ^ data for string
    -> Either String String -- ^ output info. Left value is the output string. Right value is the error string.
divine args dataStr = Right "error"

-- | Generate one 爻 with 三变 method
generateYao
    :: Int -- ^ return 9, 8, 7, 6.
generateYao = -1

-- | convert to 本卦.
convertToGua
    :: Gua -- ^ origin six Yao number
    -> Gua -- ^ convert six Yao number
convertToGua = map (\y -> if y `mod` 2 == 1 then 9 else 6)

-- | convert to 之卦
convertToZhiGua
    :: Gua -- ^ origin six Yao number
    -> Gua -- ^ convert six Yao number
convertToZhiGua = convertToGua . map (\y ->
    case y of
         9 -> 6
         6 -> 9
         _ -> y)

-- | read gua from zhouyi
readGuaNumber
    :: Gua    -- ^ converted gua
    -> String -- ^ data for string
    -> Int    -- ^ number of the gua
readGuaNumber g d = -1
