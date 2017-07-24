module App.Input.Connector exposing (..)

import Html exposing (Html)

import State.Types exposing (..)
import State.Entries.Types as Entries
import App.Input.View exposing (view, Interface)


connector : Model -> Html Msg
connector model =
    view (connect model)


connect : Model -> Interface
connect model =
    { text_ = model.input
    , updateInput = updateInput
    , enterInput = (enterInput model)
    }


-- MSG -> INTERFACE

updateInput : String -> Msg
updateInput str =
    MsgForModel (UpdateInput str)


enterInput : Model -> Msg
enterInput model =
    if model.input == "" then
        NoOp
    else
        ChainMsgs
            [ (MsgForModel ClearInput)
            , (addEntry model.input)
            ]


addEntry : String -> Msg
addEntry text =
    Entries.AddEntryRequest text
        |> Entries.MsgForCmd
        |> MsgForEntries
