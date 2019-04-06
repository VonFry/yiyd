{-# LANGUAGE DeriveGeneric #-}
-- | Divine with zhouyi
module ZY.Divination where

import Control.Monad.Reader (reader, runReader)
import Data.ByteString (ByteString)
import Data.Sequence (Seq(..), findIndexL, index)
import GHC.Generics (Generic)
import System.Random (randomR, mkStdGen, StdGen)
import Data.Yaml (decodeEither', FromJSON)

import Arguments (Arguments(..))

type Gua = Seq Int
data ZY = ZY
    { symbol  :: Gua
    , name    :: String
    , content :: Seq String
    } deriving (Generic, Show)
instance FromJSON ZY
type ZYType = Seq ZY

divine
    :: Arguments  -- ^ arguments in the cli
    -> ByteString -- ^ data for string
    -> Either String String -- ^ output info. Left value is the output string. Right value is the error string.
divine args dataStr = do
    zy <- parseDE $ decodeEither' dataStr
    idx <- readGuaNumber g' zy
    return $ runReader output (args, zy `index` idx, idx)
  where
    parseDE (Right z) = return z
    parseDE (Left  e) = Left $ show e
    checkArgQY (Arguments {..}) str
        | (argQuiet && argYao) || not argQuiet = str
        | otherwise = ""
    g  = generateGua
    g' = convertToGua g
    gName  = reader $ \(_, ZY {name}, _) -> "卦名：\t" ++ name
    gGen   = reader $ \(args, _, _) -> checkArgQY args $ "爻：\t" ++ concatMap ((++" ") . show) g
    gOrig  = reader $ \(args, _, _) -> checkArgQY args $ "本卦：\t" ++ concatMap ((++" ") . show) g'
    gZhi   = reader $ \(args, _, _) -> checkArgQY args $ "之卦：\t" ++ concatMap ((++" ") . show) (convertToZhiGua g')
    gIdx   = reader $ \(_, _, idx) -> "卦序：\t" ++ show (succ idx) ++ "（1-64）"
    gText  = reader $ \((Arguments {argQuiet}), ZY {content}, _) ->
        if not argQuiet then "卦辞：" ++ concatMap (++"\n\t") content
                    else ""
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
    :: StdGen        -- ^ seed
    -> (Int, StdGen) -- ^ return 9, 8, 7, 6.
generateYao seed = randomR (6, 9) seed

-- | generate 卦
generateGua :: Gua
generateGua = generateGua' Empty (mkStdGen 64)
  where
    generateGua' g s =
        let (g', s') = generateYao s
        in if length g < 6 then generateGua' (g' :<| g) s'
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
    errorLeft = Left $ "Not Found Gua: " ++ show g
    find = findIndexL eq' zy
    eq' (ZY {symbol}) = g == symbol
