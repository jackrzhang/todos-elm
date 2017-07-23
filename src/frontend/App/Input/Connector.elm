module App.Input.Connector exposing (..)

import Html exposing (Html)

import State.Types exposing (..)
import State.Input.Types as Input
import State.Entries.Types as Entries
import App.Input.View exposing (..)


connector : Model -> Html Msg
connector model =
    view (connect model)


connect : Model -> Interface
connect model =
    { text_ = text_ model
    , updateInput = updateInput
    , enterInput = (enterInput model)
    }


-- MODEL -> INTERFACE

text_ : Model -> String
text_ model =
    model.input.text


-- MSG -> INTERFACE

updateInput : String -> Msg
updateInput str =
    Input.UpdateInput str
        |> MsgForInput


enterInput : Model -> Msg
enterInput model =
    if model.input.text == "" then
        NoOp
    else
        ChainMsgs
            [ (MsgForInput Input.ClearInput)
            , (addEntry model.input.text)
            ]


addEntry : String -> Msg
addEntry text =
    Entries.AddEntryRequest text
        |> Entries.MsgForCmd
        |> MsgForEntries
