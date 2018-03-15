-- | Divine with zhouyi

module ZY.Divination where

import Data.ByteString (ByteString)
import Data.Sequence (Seq, findIndexL)
import Control.Monad (join)

import Arguments (Arguments(Arguments))

import Data.Yaml (decode, Value, Object, Parser, (.:), parseMaybe, parseJSON, FromJSON)

type Gua = Seq Int

divine
    :: Arguments -- ^ arguments in the cli
    -> ByteString -- ^ data for string
    -> Either ByteString ByteString -- ^ output info. Left value is the output string. Right value is the error string.
divine (Arguments {..}) dataStr =
    case zy of
        Just zy' -> Left "Not finish"
        Nothing -> Left "YAML Decode error, please contact with developer."
  where
    zy = decode dataStr :: Maybe Value

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

-- | read gua's index from zhouyi
readGuaNumber
    :: Gua        -- ^ converted gua
    -> Value      -- ^ data for zy
    -> Maybe Int  -- ^ number of the gua
readGuaNumber g = join . parseMaybe (\d -> do
    seq <- parseJSON d
    return $ findIndexL fGua seq
    )
  where
    fGua :: Object -> Bool
    fGua o = case parseMaybe (\v -> do
        sym <- v .: "symbol"
        return $ sym == g
        ) o of
        Just b -> b
        _ -> False
