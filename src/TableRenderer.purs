module TableRenderer
  ( render
  ) where

import Prelude
import Calculator (Result)
import Data.MediaType (MediaType(..))
import Data.String (joinWith)
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import Elmish (ReactElement)
import Elmish.HTML as R
import Web.File.Blob (fromString)
import Web.File.Url (createObjectURL)

render :: Array Result -> ReactElement
render results =
  R.article { className: "container" }
    [ R.h1 {} "Square Numbers"
    , R.table { className: "table table-bordered table-striped" } [ head, body ]
    , R.p {} [ R.a { href: unsafePerformEffect $ generateDownloadLink results, download: "square-numbers.csv" } "download csv" ]
    , R.p {} [ R.a { href: "https://github.com/FloWi/square-numbers/", target: "_blank" } "repo on github" ]
    ]
  where
  head =
    R.thead {}
      [ R.tr {} $ header <#> (\val -> R.th { className: "text-end" } [ R.text val ])
      ]
  body = R.tbody {} $ cells results <#> toRow

  toRow :: Array String -> ReactElement
  toRow row =
    R.tr {} $ row <#> (\val -> R.td { className: "text-end" } [ R.text val ])

header :: Array String
header =
  [ "x", "y", "z", "sum squares", "squareRoot (sum squares)"
  ]

resultToArray :: Result -> Array Int
resultToArray { x, y, z, squareSum, sqrtSquareSum } =
  [ x, y, z, squareSum, sqrtSquareSum ]

cells :: Array Result -> Array (Array String)
cells results = (results <#> \r -> resultToArray r <#> show)

toCsv :: Array Result -> String
toCsv results =
  ([ header ] <> cells results) <#> (joinWith ", ") # joinWith "\n"

generateDownloadLink :: Array Result -> Effect String
generateDownloadLink results =
  let
    csv = toCsv results
    blob = fromString csv (MediaType "application/csv")
  in
    createObjectURL blob
