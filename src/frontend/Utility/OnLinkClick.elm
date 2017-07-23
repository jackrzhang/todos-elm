module Utility.OnLinkClick exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


onLinkClick : msg -> Attribute msg
onLinkClick msg =
   onWithOptions "click"
    { stopPropagation = True
    , preventDefault = True
    }
    (Json.succeed msg)