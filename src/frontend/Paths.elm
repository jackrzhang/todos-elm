module Paths exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (Parser, (</>), oneOf, map, s, string)

import State.Types exposing (Model)
import State.Control.Types exposing (Filter(..))


-- MODEL -> PATH

modelToPath : Model -> String
modelToPath model =
    filterToPath model.control.filter


filterToPath : Filter -> String
filterToPath filter =
    case filter of
        All -> 
            "/"

        Active ->
            "/active"

        Complete ->
            "/complete"


-- PATH -> MODEL

pathToModel : Location -> Model -> Model
pathToModel location model =
    let
        filter =
            pathToFilter location
                |> Maybe.withDefault All

        controlModel = model.control
        control =
            { controlModel | filter = filter }

    in
        { model | control = control }


pathToFilter : Location -> Maybe Filter
pathToFilter location =
    UrlParser.parsePath parseFilter location


parseFilter : Parser (Filter -> a) a
parseFilter =
    oneOf
        [ map All (s "")
        , map Active (s "active")
        , map Complete (s "complete")
        ]
