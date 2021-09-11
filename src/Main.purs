module Main where

import Prelude
import Calculator (calcNumbers)
import Effect (Effect)
import Elmish.Boot (defaultMain)
import TableRenderer (render)

main :: Effect Unit
main =
  defaultMain
    { elementId: "app"
    , def:
        { init: pure unit
        , update: \_ _ -> pure unit
        , view: \_ _ -> render $ calcNumbers 20
        }
    }
