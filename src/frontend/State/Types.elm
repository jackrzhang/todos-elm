module State.Types exposing (..)

import Navigation exposing (Location)
import Http exposing (Error)


-- MODEL

type Filter
    = All
    | Active
    | Complete


type alias Entry =
    { id : Int
    , text : String
    , isComplete : Bool
    , isEditing: Bool
    , editingInput : String
    }


type alias PersistedEntry =
    { id : Int
    , text : String
    , isComplete : Bool
    }


type alias Model =
    { input : String
    , list : List Entry
    , filter : Filter
    }


-- MSG

type Msg
    = NoOp
    | Initialize Location
    | SyncPath
    | ChainMsgs (List Msg)
    | MsgForModel ModelMsg 
    | MsgForCmd CmdMsg


type ModelMsg
    = UpdateInput String
    | ClearInput
    | ApplyFilter Filter
    | FetchAllResponse (Result Error (List PersistedEntry))
    | AddEntryResponse (Result Error PersistedEntry)
    | RemoveEntryResponse (Result Error Int)
    | ToggleCompleteResponse (Result Error PersistedEntry)
    | StartEditing Int
    | StopEditing Int
    | UpdateEditingInput Int String
    | EditTextResponse (Result Error PersistedEntry)


type CmdMsg
    = FetchAllRequest
    | AddEntryRequest String
    | RemoveEntryRequest Int
    | ToggleCompleteRequest Entry
    | EditTextRequest Entry
