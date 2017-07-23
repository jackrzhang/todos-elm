module State.Types exposing (..)

import Navigation exposing (Location)

import State.Input.Types as Input
import State.Entries.Types as Entries
import State.Control.Types as Control


-- MODEL

type alias Model =
    { input : Input.Model
    , entries : Entries.Model
    , control : Control.Model
    }


-- MSG

type Msg
    = NoOp
    | Initialize Location
    | SyncPath
    | ChainMsgs (List Msg)
    | MsgForInput Input.Msg
    | MsgForEntries Entries.Msg
    | MsgForControl Control.Msg
