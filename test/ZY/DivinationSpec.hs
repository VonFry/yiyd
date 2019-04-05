-- | Divination spec

module ZY.DivinationSpec (spec) where

import Test.Hspec

import Arguments
import ZY.Divination

import Data.String (fromString)
import Prelude hiding (readFile)
import Data.ByteString (readFile)
import Paths_yiyd

spec = do
    it "divine" $
        satisfy (dataStrIO >>= return . divine args) `shouldReturn` True
  where
      dataStrIO = do
          dataPath <- getDataFileName "zy.yml"
          readFile $ fromString dataPath
      satisfy e = e >>= \case
          Right _ -> return True
          _       -> return False
      args = Arguments
          { argQuiet = True
          , argYao   = False }
