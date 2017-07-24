module State.Types exposing (..)

import Navigation exposing (Location)

import State.Entries.Types as Entries
import State.Control.Types as Control


-- MODEL

type alias Model =
    { input : String
    , entries : Entries.Model
    , control : Control.Model
    }


-- MSG

type Msg
    = NoOp
    | Initialize Location
    | SyncPath
    | MsgForModel ModelMsg 
    | MsgForCmd CmdMsg
    | ChainMsgs (List Msg)
    | MsgForEntries Entries.Msg
    | MsgForControl Control.Msg


type ModelMsg
    = UpdateInput String
    | ClearInput

type CmdMsg
    = Nope
