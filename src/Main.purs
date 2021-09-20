module Main where

import Prelude
import Calculator (Result, calcNumbers)
import Data.Array (catMaybes)
import Data.Int (fromString)
import Data.Maybe (Maybe(..), isJust)
import Data.MediaType (MediaType(..))
import Data.String (joinWith)
import Effect (Effect)
import Effect.Class (liftEffect)
import Elmish (ReactElement, fork, handleMaybe)
import Elmish.Boot (defaultMain)
import Elmish.Foreign (Foreign, readForeign)
import Elmish.HTML as R
import Foreign.Object (lookup)
import UI.Util (eventTargetValue, generateDownloadLink)

type State
  = { from :: String
    , to :: String
    , result :: Maybe DisplayResult
    , csvDownloadLink :: Maybe String
    }

type DisplayResult
  = { header :: Array String
    , cells :: Array (Array String)
    }

data Message
  = CalculateSquareNumbers
  | EditFrom String
  | EditTo String
  | CsvLinkGenerated String

main :: Effect Unit
main =
  defaultMain
    { elementId: "app"
    , def:
        { init:
            do
              fork $ pure CalculateSquareNumbers
              pure { from: "1", to: "15", result: Nothing, csvDownloadLink: Nothing }
        , update
        , view
        }
    }
  where
  update s = case _ of
    EditFrom str -> pure $ s { from = str }
    EditTo str -> pure $ s { to = str }
    CalculateSquareNumbers ->
      case getAndValidateInputValues s of
        Just { from, to } -> do
          let
            result = calcNumbers from to
          fork $ liftEffect $ downloadLink result <#> CsvLinkGenerated
          pure s { result = Just (result # toDisplayResult) }
        Nothing -> pure s
    CsvLinkGenerated link -> pure $ s { csvDownloadLink = Just link }

  view s dispatch =
    R.div { className: "container my-grid" }
      $
        [ R.h1 {} "Square Numbers"
        , R.form
            { className: "row gy-3"
            , onKeyPress: handleMaybe dispatch \e -> if eventKey e == Just "Enter" then Just CalculateSquareNumbers else Nothing
            }
            $
              [ R.div { className: "col-md-2" }
                  $
                    [ R.label { className: "visually-hidden", htmlFor: "from" } $ [ R.text "from" ]
                    , R.div { className: "input-group" }
                        [ R.div { className: "input-group-text" } [ R.text "from" ]
                        , R.input { id: "from", "type": "number", placeholder: "from", className: "form-control", value: s.from, onChange: handleMaybe dispatch \e -> eventTargetValue e <#> EditFrom }
                        ]
                    ]
              , R.div { className: "col-md-2" }
                  $
                    [ R.label { className: "visually-hidden", htmlFor: "to" } $ [ R.text "to" ]
                    , R.div { className: "input-group" }
                        [ R.div { className: "input-group-text" } [ R.text "to" ]
                        , R.input { id: "to", "type": "number", placeholder: "to", className: "form-control", value: s.to, onChange: handleMaybe dispatch \e -> eventTargetValue e <#> EditTo }
                        ]
                    ]
              , R.div { className: "col-md-2" }
                  $ [ R.button { type: "button", className: "btn btn-primary", onClick: dispatch CalculateSquareNumbers, disabled: not isValid } [ R.text "calculate" ] ]
              ]
        , R.div { className: "row gy-3" } $ [ displayResult s.result s.csvDownloadLink ]
        ]
    where
    isValid = isJust $ getAndValidateInputValues s
  toRow :: Array String -> ReactElement
  toRow row =
    R.tr {} $ row <#> (\val -> R.td { className: "text-end" } [ R.text val ])

  displayResult (Just { header: header', cells: cells' }) (Just csvDownloadLink) =
    R.div { className: "col-md-8" }
      [ R.table { className: "table table-bordered table-striped  w-auto mw-100" }
          [ R.thead {} [ R.tr {} $ header' <#> (\val -> R.th { className: "text-end" } [ R.text val ]) ]
          , R.tbody {} $ cells' <#> toRow
          ]
      , R.p {} [ R.a { href: csvDownloadLink, download: "square-numbers.csv" } "download csv" ]
      , R.p {} [ R.a { href: "https://github.com/FloWi/square-numbers/", target: "_blank" } "repo on github" ]
      ]
  displayResult _ _ = R.empty

getAndValidateInputValues :: State -> Maybe { from :: Int, to :: Int }
getAndValidateInputValues s = case ([ s.from, s.to ] <#> fromString # catMaybes) of
  [ from, to ] | from <= to -> Just { from, to }
  _ -> Nothing

header :: Array String
header =
  [ "x", "y", "z", "sum squares", "squareRoot (sum squares)"
  ]

cells :: Array Result -> Array (Array String)
cells results = (results <#> \r -> resultToArray r <#> show)

resultToArray :: Result -> Array Int
resultToArray { x, y, z, squareSum, sqrtSquareSum } =
  [ x, y, z, squareSum, sqrtSquareSum ]

toCsv :: Array Result -> String
toCsv results =
  ([ header ] <> cells results) <#> (joinWith ", ") # joinWith "\n"

toDisplayResult :: Array Result -> DisplayResult
toDisplayResult results =
  { header
  , cells: cells results
  }

downloadLink :: Array Result -> Effect String
downloadLink results =
  let
    csv = toCsv results
  in
    generateDownloadLink csv (MediaType "application/csv")

eventKey :: Foreign -> Maybe String
eventKey =
  readForeign
    >=> lookup "key"
    >=> readForeign
