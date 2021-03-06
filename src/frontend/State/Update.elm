module State.Update exposing (..)

import Navigation exposing (Location)
import Paths exposing (..)

import State.Types exposing (..)
import State.Rest as Rest


-- INIT

init : Location -> ( Model, Cmd Msg )
init location =
    ( (pathToModel location initialModel), initialCmd )


initialModel : Model
initialModel =
    { input = ""
    , list = []
    , filter = All
    }


initialCmd : Cmd Msg
initialCmd =
    Cmd.batch
        [ Rest.fetchAll
        ]


-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp -> 
            model ! []

        Initialize location ->
            (pathToModel location model) ! []

        SyncPath ->
            model ! [ Navigation.newUrl (modelToPath model) ]

        ChainMsgs msgs ->
            (List.foldl chain (model ! []) msgs)

        MsgForModel modelMsg ->
            ( updateModel modelMsg model, Cmd.none )

        MsgForCmd cmdMsg ->
            ( model, updateCmd cmdMsg model )


updateModel : ModelMsg -> Model -> Model
updateModel msg model =
    case msg of
        UpdateInput text ->
            { model | input = text }

        ClearInput ->
            { model | input = "" }

        ApplyFilter filter ->
            { model | filter = filter }

        FetchAllResponse (Ok persistedList) ->
            let
                list = List.map toModelEntry persistedList
            in
                { model
                    | list = list
                }

        FetchAllResponse (Err _) ->
            model

        AddEntryResponse (Ok persistedEntry) ->
            let
                entry = toModelEntry persistedEntry
            in
                { model
                    | list = List.append model.list [ entry ]
                }

        AddEntryResponse (Err _) ->
            model

        RemoveEntryResponse (Ok id) ->
            { model
                | list = List.filter (\entry -> not <| entry.id == id) model.list
            }

        RemoveEntryResponse (Err _) ->
            model

        ToggleCompleteResponse (Ok persistedEntry) ->
            { model
                | list = toggleComplete persistedEntry.id model.list
            }

        ToggleCompleteResponse (Err _) ->
            model

        StartEditing id ->
            { model 
                | list = startEditing id model.list
            }

        StopEditing id ->
            { model
                | list = stopEditing id model.list
            }

        UpdateEditingInput id text ->
            { model
                | list = updateEditingInput id text model.list
            }            

        EditTextResponse (Ok persistedEntry) ->
            let
                entry = toModelEntry persistedEntry
            in
                { model
                    | list = editText entry model.list
                }

        EditTextResponse (Err _) ->
            model


updateCmd : CmdMsg -> Model -> Cmd Msg
updateCmd msg model =
    case msg of
        FetchAllRequest ->
            Rest.fetchAll

        AddEntryRequest text ->
            Rest.addEntry text

        RemoveEntryRequest id ->
            Rest.removeEntry id

        ToggleCompleteRequest entry ->
            let
                persistedEntry = toPersistedEntry entry
                updatedEntry =
                    { persistedEntry
                        | isComplete = not entry.isComplete
                    }
            in
                Rest.toggleComplete updatedEntry

        EditTextRequest entry ->
            let
                persistedEntry = toPersistedEntry entry
                updatedEntry =
                    { persistedEntry
                        | text = entry.editingInput
                    }
            in
                Rest.editText updatedEntry


-- HELPERS

chain : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
chain msg ( model, cmd ) =
    let ( nextModel, nextCmd ) =
        update msg model
    in
        nextModel ! [ cmd, nextCmd ]


toPersistedEntry : Entry -> PersistedEntry
toPersistedEntry { id, text, isComplete } =
    PersistedEntry id text isComplete


toModelEntry : PersistedEntry -> Entry
toModelEntry { id, text, isComplete } =
    Entry id text isComplete False ""


toggleComplete : Int -> List Entry -> List Entry
toggleComplete id entries =
    let
        updateEntry entry =
            if entry.id == id then
                { entry | isComplete = not entry.isComplete }
            else
                entry
    in
        List.map updateEntry entries


startEditing : Int -> List Entry -> List Entry
startEditing id entries =
    let
        updateEntry entry =
            if entry.id == id then
                { entry
                    | isEditing = True
                    , editingInput = entry.text
                }
            else
                entry
    in
        List.map updateEntry entries


stopEditing : Int -> List Entry -> List Entry
stopEditing id entries =
    let
        updateEntry entry =
            if entry.id == id then
                { entry
                    | isEditing = False
                    , editingInput = ""
                }
            else
                entry
    in
        List.map updateEntry entries


updateEditingInput : Int -> String -> List Entry -> List Entry
updateEditingInput id text entries =
    let
        updateEntry entry =
            if entry.id == id then
                { entry
                    | editingInput = text
                }
            else
                entry
    in
        List.map updateEntry entries


editText : Entry -> List Entry -> List Entry
editText newEntry entries =
    let
        updateEntry entry =
            if entry.id == newEntry.id then
                { entry
                    | isEditing = False
                    , text = newEntry.text
                }
            else
                entry
    in
        List.map updateEntry entries
