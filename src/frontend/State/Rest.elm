module State.Rest exposing (..)

import Http exposing (Error)
import Json.Decode as Decode
import Json.Encode as Encode

import State.Types exposing (..)


-- COMMANDS

fetchAll : Cmd Msg
fetchAll =
    Http.send fetchAllResponse getEntries


addEntry : String -> Cmd Msg
addEntry text =
    Http.send addEntryResponse (postEntry text)


removeEntry : Int -> Cmd Msg
removeEntry id =
    Http.send removeEntryResponse (deleteEntry id)


toggleComplete : PersistedEntry -> Cmd Msg
toggleComplete entry =
    Http.send toggleCompleteResponse (putEntry entry)


editText : PersistedEntry -> Cmd Msg
editText entry =
    Http.send editTextResponse (putEntry entry)


-- MSG CONTAINERS

fetchAllResponse : Result Error (List PersistedEntry) -> Msg
fetchAllResponse result =
    FetchAllResponse result
        |> MsgForModel


addEntryResponse : Result Error PersistedEntry -> Msg
addEntryResponse result =
    AddEntryResponse result
        |> MsgForModel


removeEntryResponse : Result Error Int -> Msg
removeEntryResponse result =
    RemoveEntryResponse result
        |> MsgForModel


toggleCompleteResponse : Result Error PersistedEntry -> Msg
toggleCompleteResponse result =
    ToggleCompleteResponse result
        |> MsgForModel


editTextResponse : Result Error PersistedEntry -> Msg
editTextResponse result =
    EditTextResponse result
        |> MsgForModel


-- REQUESTS

getEntries : Http.Request (List PersistedEntry)
getEntries =
    Http.get entriesUrl entriesDecoder


postEntry : String -> Http.Request PersistedEntry
postEntry text =
     Http.post entriesUrl (Http.jsonBody (entryEncoder text False)) entryDecoder


deleteEntry : Int -> Http.Request Int
deleteEntry id =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = entryUrl id
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (\_ -> Ok id)
        , timeout = Nothing
        , withCredentials = False
        }


putEntry : PersistedEntry -> Http.Request PersistedEntry
putEntry { id, text, isComplete } =
    Http.request
        { method = "PUT"
        , headers = []
        , url = entryUrl id
        , body = Http.jsonBody (entryEncoder text isComplete)
        , expect = Http.expectJson entryDecoder
        , timeout = Nothing
        , withCredentials = False
        }


-- RESOURCES

entriesUrl : String
entriesUrl =
    "/api/entries"


entryUrl : Int -> String
entryUrl id =
    String.join "/" [ entriesUrl, toString id ]


-- DECODERS

entriesDecoder : Decode.Decoder (List PersistedEntry)
entriesDecoder =
    Decode.list entryDecoder


entryDecoder : Decode.Decoder PersistedEntry
entryDecoder =
    Decode.map3 PersistedEntry
        (Decode.field "id" Decode.int)
        (Decode.field "text" Decode.string)
        (Decode.field "isComplete" Decode.bool)


-- ENCODERS

entryEncoder : String -> Bool -> Encode.Value
entryEncoder text isComplete =
    Encode.object
        [ ( "text", Encode.string text )
        , ( "isComplete", Encode.bool isComplete )
        ]

