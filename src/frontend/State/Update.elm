module State.Update exposing (..)

import Navigation exposing (Location)
import Paths exposing (..)

import State.Types exposing (..)
import State.Control.Types exposing (Filter(..))
import State.Input.Update as Input exposing (..)
import State.Entries.Update as Entries exposing (..)
import State.Control.Update as Control exposing (..)


-- INIT

init : Location -> ( Model, Cmd Msg )
init location =
    ( (pathToModel location initialModel), initialCmd )


initialModel : Model
initialModel =
    { input = Input.initialModel
    , entries = Entries.initialModel
    , control = Control.initialModel
    }


initialCmd : Cmd Msg
initialCmd =
    Cmd.batch
        [ Entries.initialCmd
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

        MsgForInput inputMsg ->
            let input =
                Input.updateModel inputMsg model.input
            in
                { model | input = input } ! []

        MsgForEntries entriesMsg ->
            let ( entries, cmd ) =
                Entries.update entriesMsg model.entries
            in
                { model | entries = entries } ! [ cmd ]

        MsgForControl controlMsg ->
            let control =
                Control.updateModel controlMsg model.control
            in
                { model | control = control } ! []



-- HELPERS

chain : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
chain msg ( model, cmd ) =
    let ( nextModel, nextCmd ) =
        update msg model
    in
        nextModel ! [ cmd, nextCmd ]
