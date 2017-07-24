module App.Entries.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Utility.OnEnter exposing (onEnter)

import State.Types exposing (..)


-- INTERFACE

type alias Interface =
    { filteredList : List Entry
    , removeEntry : Int -> Msg
    , toggleComplete : Entry -> Msg
    , startEditing : Int -> Msg
    , stopEditing : Int -> Msg
    , updateEditingInput : Int -> String -> Msg
    , editText : Entry -> Msg
    }


-- VIEW

view : Interface -> Html Msg
view interface =
    let
        { filteredList } = interface

    in
        div []
            [ div [] (List.map (viewEntry interface) filteredList)
            ]


viewEntry : Interface -> Entry -> Html Msg
viewEntry interface entry =
    let
        textStyle =
            if entry.isComplete then
                " complete"
            else
                " active"

        clickX =
            interface.removeEntry entry.id

        clickCheck =
            interface.toggleComplete entry

        clickTriangle =
            interface.startEditing entry.id

        clickEditingX =
            interface.stopEditing entry.id

        inputEditing =
            interface.updateEditingInput entry.id

        enterEditing =
            interface.editText entry

        contents =
            if entry.isEditing then
                [ span
                    [ class "edit-container"]
                    [ input
                        [ type_ "text"
                        , autofocus True
                        , value entry.editingInput
                        , class "edit-item"
                        , onInput inputEditing
                        , onEnter enterEditing
                        ] []
                    , span
                        [ class "action x"
                        , onClick clickEditingX
                        ]
                        [ text "×"
                        ]
                    ]
                ]
            else
                [ span
                    [ class "action checkmark" 
                    , onClick clickCheck
                    ]
                    [ text "☑"
                    ]
                , span 
                    [ class ("text" ++ textStyle) ]
                    [ text entry.text
                    ]
                , div [ class "container" ]
                    [ span
                        [ class "action edit"
                        , onClick clickTriangle
                        ]
                        [ text "▼"
                        ]
                    , span
                        [ class "action x"
                        , onClick clickX
                        ]
                        [ text "×"
                        ]
                    ]
                ]

    in
        div [ class "entry" ] contents
            
