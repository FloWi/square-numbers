module Calculator (calcNumbers, Result) where

import Prelude
import Data.Array as Array
import Data.Int (ceil, toNumber)
import Effect (Effect)
import Effect.Console (log)
import Math (sqrt)

-- main :: Effect Unit
-- main = do
--   log $ show $ calcNumbers 10
type Result
  = { x :: Int
    , y :: Int
    , z :: Int
    , squareSum :: Int
    , sqrtSquareSum :: Int
    }

calcNumbers :: Int -> Array Result
calcNumbers max = do
  x <- Array.range 1 max
  y <- Array.range x max
  z <- Array.range y max
  calculate x y z
  where

  calculate :: Int -> Int -> Int -> Array Result
  calculate x y z =
    let
      squareSum = x * x + y * y + z * z
      sqrtSquareSum = sqrt $ toNumber $ squareSum
      isValid = toNumber (ceil sqrtSquareSum) == sqrtSquareSum
    in
      if isValid then [ { x, y, z, squareSum, sqrtSquareSum: ceil sqrtSquareSum } ] else []
