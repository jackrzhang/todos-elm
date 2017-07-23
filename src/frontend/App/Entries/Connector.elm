module App.Entries.Connector exposing (..)

import Html exposing (Html)

import State.Types exposing (..)
import State.Control.Types exposing (Filter(..))
import State.Entries.Types as Entries exposing (Entry)
import App.Entries.View exposing (..)


connector : Model -> Html Msg
connector model =
    view (connect model)


connect : Model -> Interface
connect model =
    { filteredList = filteredList model.control.filter model.entries.list
    , removeEntry = removeEntry
    , toggleComplete = toggleComplete
    , startEditing = startEditing
    , stopEditing = stopEditing
    , updateEditingInput = updateEditingInput
    , editText = editText
    }


-- MODEL -> INTERFACE

filteredList : Filter -> List Entry -> List Entry
filteredList filter list =
    case filter of
        All ->
            list

        Active ->
            List.filter (\entry -> entry.isComplete == False) list

        Complete ->
            List.filter (\entry -> entry.isComplete == True) list


-- MSG -> INTERFACE

removeEntry : Int -> Msg
removeEntry id =
    Entries.RemoveEntryRequest id
        |> Entries.MsgForCmd
        |> MsgForEntries


toggleComplete : Entry -> Msg
toggleComplete entry =
    Entries.ToggleCompleteRequest entry
        |> Entries.MsgForCmd
        |> MsgForEntries 


startEditing : Int -> Msg
startEditing id =
    Entries.StartEditing id
        |> Entries.MsgForModel
        |> MsgForEntries


stopEditing : Int -> Msg
stopEditing id =
    Entries.StopEditing id
        |> Entries.MsgForModel
        |> MsgForEntries


updateEditingInput : Int -> String -> Msg
updateEditingInput id text =
    Entries.UpdateEditingInput id text
        |> Entries.MsgForModel
        |> MsgForEntries


editText : Entry -> Msg
editText entry =
    Entries.EditTextRequest entry
        |> Entries.MsgForCmd
        |> MsgForEntries

