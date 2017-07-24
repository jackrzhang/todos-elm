module App.Entries.Connector exposing (..)

import Html exposing (Html)

import State.Types exposing (..)
import App.Entries.View exposing (view, Interface)


connector : Model -> Html Msg
connector model =
    view (connect model)


connect : Model -> Interface
connect model =
    { filteredList = filteredList model.filter model.list
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
    RemoveEntryRequest id
        |> MsgForCmd


toggleComplete : Entry -> Msg
toggleComplete entry =
    ToggleCompleteRequest entry
        |> MsgForCmd


startEditing : Int -> Msg
startEditing id =
    StartEditing id
        |> MsgForModel


stopEditing : Int -> Msg
stopEditing id =
    StopEditing id
        |> MsgForModel


updateEditingInput : Int -> String -> Msg
updateEditingInput id text =
    UpdateEditingInput id text
        |> MsgForModel


editText : Entry -> Msg
editText entry =
    EditTextRequest entry
        |> MsgForCmd

