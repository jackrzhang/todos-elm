module App.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import State.Types exposing (..)
import App.Input.Connector as Input exposing (..)
import App.Entries.Connector as Entries exposing (..)
import App.Control.Connector as Control exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ title
        , Input.connector model
        , Entries.connector model
        , Control.connector model
        , infoFooter
        ]


title : Html Msg
title =
    header []
        [ h1 []
            [ a [ href "https://github.com/jackrzhang/todos-elm" ] 
                [ text "todos"] 
            ]
        ]


infoFooter : Html Msg
infoFooter =
    footer []
        [ p []
            [ text "Written by "
            , a [ href "https://github.com/jackrzhang" ] [ text "Jack Zhang" ]
            ]
        , p []
            [ text "Built with "
            , a [ href "http://elm-lang.org" ] [ text "Elm" ]
            ]
        ]
