module Calculator (calcNumbers, Result) where

import Prelude
import Data.Array as Array
import Data.Int (ceil, toNumber)
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

calcNumbers :: Int -> Int -> Array Result
calcNumbers from to = do
  x <- Array.range from to
  y <- Array.range x to
  z <- Array.range y to
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
