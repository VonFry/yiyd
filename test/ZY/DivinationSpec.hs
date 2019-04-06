-- | Divination spec

module ZY.DivinationSpec (spec) where

import Test.Hspec

import Arguments
import ZY.Divination

import Data.String (fromString)
import System.IO hiding (readFile)
import Prelude hiding (readFile)
import Data.ByteString (readFile)
import Paths_yiyd

spec = do
    it "divine" $
        satisfy (divine args <$> dataStrIO) `shouldReturn` True
  where
      dataPathIO = getDataFileName "zy.yml"
      dataStrIO = do
          dataPath <- dataPathIO
          readFile $ fromString dataPath
      satisfy = (=<<) $ \case
          Right _ -> return True
          _       -> return False
      args = Arguments
          { argQuiet = True
          , argYao   = False }
