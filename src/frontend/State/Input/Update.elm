module State.Input.Update exposing (..)

import State.Input.Types exposing (..)


-- INIT

initialModel : Model
initialModel =
    { text = ""
    }


-- UPDATE

updateModel : Msg -> Model -> Model
updateModel msg model =
    case msg of

        UpdateInput text ->
            { model | text = text }

        ClearInput ->
            { model | text = "" }