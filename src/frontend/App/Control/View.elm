module App.Control.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Utility.OnLinkClick exposing (onLinkClick)

import Paths
import State.Types exposing (Msg)
import State.Control.Types as Control exposing (Filter(..))


-- INTERFACE

type alias Interface =
    { filter : Filter
    , applyFilter : Filter -> Msg
    }


-- VIEW

view : Interface -> Html Msg
view interface =
    let
        { filter, applyFilter } = interface
    in
        div [ class "control" ]
            [ viewFilters
                [ ( All, filter, applyFilter All )
                , ( Active, filter, applyFilter Active )
                , ( Complete, filter, applyFilter Complete )
                ]
            ]


viewFilters : List ( Filter, Filter, Msg ) -> Html Msg
viewFilters options =
    div [] (List.map viewFilter options)


viewFilter : ( Filter, Filter, Msg ) -> Html Msg
viewFilter ( filter, current, clickLink ) =
    let
        filterStyle =
            if filter == current then
                " current"
            else
                " "
    in
        a
            [ href (Paths.filterToPath filter)
            , class ("filter" ++ filterStyle)
            , onLinkClick clickLink
            ]
            [ text (toString filter)
            ]
