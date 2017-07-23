module App.Input.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Utility.OnEnter exposing (onEnter)

import State.Types exposing (Msg)


-- INTERFACE

type alias Interface =
    { text_ : String
    , updateInput : String -> Msg
    , enterInput : Msg
    }


-- VIEW

view : Interface -> Html Msg
view interface =
    let
        { text_ , updateInput, enterInput } = interface

    in
        div [ class "input" ]
            [ span [ class "caret" ] [ text "❯ " ]
            , input
                [ type_ "text"
                , class "new-item"
                , placeholder "write stuff, hit enter"
                , autofocus True
                , value text_
                , onInput updateInput
                , onEnter enterInput
                ] []
            ]
