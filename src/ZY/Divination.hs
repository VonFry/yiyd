-- | Divine with zhouyi

module ZY.Divination where

import Arguments (Arguments)

divine ::
    Arguments -- ^ arguments in the cli
    -> String -- ^ data for string
    -> Either String String -- ^ output info. Left value is the output string. Right value is the error string.
divine args dataStr = Right "error"

divineAsk ::
    Arguments -- ^ arguments in the cli
    -> String -- ^ data for string
    -> Either String String -- ^ output info. Left value is the output string. Right value is the error string or the process that has been finished (the string will be `-`).
divineAsk args dataStr = Right "error"
