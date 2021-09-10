module HTMLHelloWorld
  ( helloWorld
  ) where

import Prelude
import Calculator (Result)
import Data.Array (concat)
import Data.Int (ceil)
import Elmish (ReactElement)
import Elmish.HTML as R

helloWorld :: Array Result -> ReactElement
helloWorld results =
  R.article { className: "container" }
    [ R.h1 {} "Square Numbers"
    , R.table { className: "table table-bordered table-striped" } [ head, body ]
    ]
  where
  head =
    R.thead {}
      [ R.tr {}
          [ R.th {} [ R.text "x" ]
          , R.th {} [ R.text "y" ]
          , R.th {} [ R.text "z" ]
          , R.th {} [ R.text "sum squares" ]
          , R.th {} [ R.text "squareRoot (sum squares)" ]
          ]
      ]
  body = R.tbody {} $ results <#> toRow

  toRow :: Result -> ReactElement
  toRow { x, y, z, squareSum, sqrtSquareSum } =
    R.tr {}
      [ R.td { className: "text-end" } [ R.text $ show x ]
      , R.td { className: "text-end" } [ R.text $ show y ]
      , R.td { className: "text-end" } [ R.text $ show z ]
      , R.td { className: "text-end" } [ R.text $ show squareSum ]
      , R.td { className: "text-end" } [ R.text $ show $ ceil sqrtSquareSum ]
      ]
