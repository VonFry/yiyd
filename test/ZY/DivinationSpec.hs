-- | Divination spec

module ZY.DivinationSpec (spec) where

import Test.Hspec
import ZY.Divination

spec = do
  it "generate yao" $
    generateYao `shouldSatisfy` (flip . elem $ [9, 8, 7, 6])
  it "convert to Gua" $
    pending
  it "convert to zhi gua" $
    pending
  it "read gua number" $
    pending
