{-# LANGUAGE DeriveGeneric #-}
-- | Divine with zhouyi
module ZY.Divination where

import Data.ByteString (ByteString, concat)
import Data.Sequence (Seq(..), findIndexL)
import GHC.Generics (Generic)
import System.Random (randomR, mkStdGen)
import Data.Yaml (decodeEither', FromJSON)

import Arguments (Arguments(Arguments))

type Gua = Seq Int
data ZY = ZY
    { symbol  :: Gua
    , name    :: ByteString
    , content :: ByteString
    } deriving (Generic, Show)
instance FromJSON ZY
type ZYType = Seq ZY

divine
    :: Arguments  -- ^ arguments in the cli
    -> ByteString -- ^ data for string
    -> Either ByteString ByteString -- ^ output info. Left value is the output string. Right value is the error string.
divine Arguments {..} dataStr =
  do
    zy <- decodeEither' dataStr
    idx <- readGuaNumber g'
    return $ runReader output (zy `index` idx, idx)
  where
    g  = generateGua
    g' = convertToGua g
    gName  = Reader $ \(ZY {name}, idx) -> "卦名：" `append` name
    gGen   = Reader $ \_ -> "卦："   `append` foldr (append . (flip . append $ " ") . show) g ""
    gOrig  = Reader $ \_ -> "本卦：" `append` foldr (append . (flip . append $ " ") . show) g' ""
    gZhi   = Reader $ \_ -> "之卦：" `append` foldr (append . (flip . append $ " ") . show) (convertToZhiGua g') ""
    gIdx   = Reader $ \(_ , idx) -> "卦序：" `append` show idx `append` "（0-63）"
    gText  = Reader $ \(ZY {content}, idx) -> "卦辞：" `append` content
    output =
      do
        idx  <- gIdx
        name <- gName
        gen  <- gGen
        orig <- gOrig
        zhi  <- gZhi
        text <- gText
        return $ concat [idx, name, gen, orig, zhi, text]

-- | Generate one 爻 with 三变 method
generateYao
    :: Int -- ^ seed
    -> Int -- ^ return 9, 8, 7, 6.
generateYao seed = fst r
  where
    g = mkStdGen seed
    r = randomR (6, 9) g

-- | generate 卦
generateGua :: Gua
generateGua = generateGua' Empty
  where
    generateGua' :: Gua -> Gua
    generateGua' g =
        let l = length g in
        if l <= 6
            then generateGua' $ generateYao l :<| g
            else g

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
    :: Gua                   -- ^ converted gua
    -> ZYType                -- ^ data for zy
    -> Either ByteString Int -- ^ number of the gua
readGuaNumber g = Left "Not finish"
