module App.Control.Connector exposing (..)

import Html exposing (Html)

import Paths
import State.Types exposing (..)
import State.Control.Types as Control
import App.Control.View exposing (..)


connector : Model -> Html Msg
connector model =
    view (connect model)


connect : Model -> Interface
connect model =
    { filter = model.control.filter
    , applyFilter = applyFilter
    }


-- MSG -> INTERFACE

applyFilter : Control.Filter -> Msg
applyFilter filter =
    ChainMsgs
        [ Control.ApplyFilter filter
            |> MsgForControl
        , SyncPath
        ]
