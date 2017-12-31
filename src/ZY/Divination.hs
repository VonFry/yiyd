-- | Divine with zhouyi

module ZY.Divination where

import Data.ByteString (ByteString)
import Data.Sequence (Seq)

import Arguments (Arguments)
import qualified Data.Yaml as Y

type Gua = Seq Int

divine
    :: Arguments -- ^ arguments in the cli
    -> ByteString -- ^ data for string
    -> Either ByteString ByteString -- ^ output info. Left value is the output string. Right value is the error string.
divine args dataStr = Right "error"
  where
    zy = Y.decode dataStr :: Maybe Y.Array

-- | Generate one 爻 with 三变 method
generateYao
    :: Int -- ^ return 9, 8, 7, 6.
generateYao = -1

-- | convert to 本卦.
convertToGua
    :: Gua -- ^ origin six Yao number
    -> Gua -- ^ convert six Yao number
convertToGua = fmap (\y -> if y `mod` 2 == 1 then 9 else 6)

-- | convert to 之卦
convertToZhiGua
    :: Gua -- ^ origin six Yao number
    -> Gua -- ^ convert six Yao number
convertToZhiGua = convertToGua . fmap (\y ->
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
