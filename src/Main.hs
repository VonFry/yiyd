module Main where

import Options.Applicative
import Data.Semigroup ((<>))

import Paths_yiyd
import Arguments
import ZY.Divination (divine)

arguments :: Parser Arguments
arguments = Arguments
      <$> switch
          ( long "ask"
         <> short 'a'
         <> help "ask you whether do next. This only work without quiet." )
      <*> switch
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
    strData <- readFile dataPath
    if argAsk args == True
       then case divine args strData of
              Left  str -> putStrLn str
              Right str -> putStrLn $ "error: " ++ str ++ "\n"
                                   ++ "Please contact to author about the issue."
       else return ()

opts :: ParserInfo Arguments
opts = info (arguments <**> helper)
  ( fullDesc
  <> progDesc "Print a greeting for TARGET"
  <> header "hello - a test for optparse-applicative" )
