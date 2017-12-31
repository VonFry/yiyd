-- | Divine with zhouyi

module ZY.Divination where

import Arguments (Arguments)

divine
    :: Arguments -- ^ arguments in the cli
    -> String -- ^ data for string
    -> Either String String -- ^ output info. Left value is the output string. Right value is the error string.
divine args dataStr = Right "error"

-- | Generate one 爻 with 三变 method
generateYao
    :: Int -- ^ return 9, 8, 7, 6.
generateYao = -1
