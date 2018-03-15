module Main where

import Options.Applicative
import Data.Semigroup ((<>))

import Data.String (fromString)
import Prelude hiding (readFile, putStrLn)
import Data.ByteString (append, readFile)
import Data.ByteString.Char8 (putStrLn)
import Paths_yiyd
import Arguments
import ZY.Divination (divine)

arguments :: Parser Arguments
arguments = Arguments
      <$> switch
          ( long "quiet"
         <> short 'q'
         <> help "Whether to be quiet. This will rewrite verbose options." )
      <*> switch
          ( long "yao"
         <> short 'y'
         <> help "Whether to print yao after the result. This is only used under quiet." )

main :: IO ()
main = do
    args <- execParser opts
    dataPath <- getDataFileName "zy.yml"
    strData <- readFile $ fromString dataPath
    case divine args strData of
        Right msg -> putStrLn msg
        Left  msg -> putStrLn $ "error: " `append` msg `append` "\n"
                       `append` "Please contact to author about the issue."

opts :: ParserInfo Arguments
opts = info (arguments <**> helper)
  ( fullDesc
  <> progDesc "Print a greeting for TARGET"
  <> header "hello - a test for optparse-applicative" )
