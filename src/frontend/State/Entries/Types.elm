module State.Entries.Types exposing (..)

import Http exposing (Error)

import State.Control.Types exposing (Filter)


-- MODEL

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


toPersistedEntry : Entry -> PersistedEntry
toPersistedEntry { id, text, isComplete } =
    PersistedEntry id text isComplete


toModelEntry : PersistedEntry -> Entry
toModelEntry { id, text, isComplete } =
    Entry id text isComplete False ""


type alias Model =
    { list : List Entry
    , filter : Filter
    }


-- MSG

type Msg
    = MsgForModel ModelMsg
    | MsgForCmd CmdMsg


type ModelMsg
    = FetchAllResponse (Result Error (List PersistedEntry))
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
