module UI.Util where

import Prelude
import Data.Maybe (Maybe)
import Data.Maybe (Maybe)
import Data.MediaType (MediaType)
import Effect (Effect)
import Elmish.Foreign (Foreign, readForeign)
import Foreign.Object as Obj
import Web.File.Blob (fromString)
import Web.File.Url (createObjectURL)

eventTargetValue :: Foreign -> Maybe String
eventTargetValue =
  readForeign
    >=> Obj.lookup "target"
    >=> readForeign
    >=> Obj.lookup "value"
    >=> readForeign

generateDownloadLink :: String -> MediaType -> Effect String
generateDownloadLink str mediaType =
  let
    blob = fromString str mediaType
  in
    createObjectURL blob
