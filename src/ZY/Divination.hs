{-# LANGUAGE DeriveGeneric #-}
-- | Divine with zhouyi
module ZY.Divination where

import Control.Monad.Reader (reader, runReader)
import Data.ByteString (ByteString)
import Data.Sequence (Seq(..), findIndexL, index)
import GHC.Generics (Generic)
import System.Random (randomR, mkStdGen)
import Data.Yaml (decodeEither', FromJSON)

import Arguments (Arguments(Arguments))

type Gua = Seq Int
data ZY = ZY
    { symbol  :: Gua
    , name    :: String
    , content :: String
    } deriving (Generic, Show)
instance FromJSON ZY
type ZYType = Seq ZY

divine
    :: Arguments  -- ^ arguments in the cli
    -> ByteString -- ^ data for string
    -> Either String String -- ^ output info. Left value is the output string. Right value is the error string.
divine Arguments {..} dataStr = do
    zy <- parseDE $ decodeEither' dataStr
    idx <- readGuaNumber g' zy
    return $ runReader output (zy `index` idx, idx)
  where
    parseDE (Right z) = return z
    parseDE (Left  e) = Left $ show e
    g  = generateGua
    g' = convertToGua g
    gName  = reader $ \(ZY {name}, _) -> "卦名：" ++ name
    gGen   = reader $ \_ -> "卦："   ++ concatMap ((++" ") . show) g
    gOrig  = reader $ \_ -> "本卦：" ++ concatMap ((++" ") . show) g'
    gZhi   = reader $ \_ -> "之卦：" ++ concatMap ((++" ") . show) (convertToZhiGua g')
    gIdx   = reader $ \(_, idx) -> "卦序：" ++ show idx ++ "（0-63）"
    gText  = reader $ \(ZY {content}, _) -> "卦辞：" ++ content
    output = do
        idx  <- gIdx
        name <- gName
        gen  <- gGen
        orig <- gOrig
        zhi  <- gZhi
        text <- gText
        return $ unlines [idx, name, gen, orig, zhi, text]

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
    -> Either String Int -- ^ number of the gua
readGuaNumber g zy = maybe errorLeft return find
  where
    errorLeft = Left "Not Found Gua, please contact to developer to fix."
    find = findIndexL eq' zy
    eq' (ZY {symbol}) = g == symbol
