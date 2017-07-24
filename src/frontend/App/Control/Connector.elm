module App.Control.Connector exposing (..)

import Html exposing (Html)

import State.Types exposing (..)
import App.Control.View exposing (view, Interface)


connector : Model -> Html Msg
connector model =
    view (connect model)


connect : Model -> Interface
connect model =
    { filter = model.filter
    , applyFilter = applyFilter
    }


-- MSG -> INTERFACE

applyFilter : Filter -> Msg
applyFilter filter =
    ChainMsgs
        [ ApplyFilter filter
            |> MsgForModel
        , SyncPath
        ]
