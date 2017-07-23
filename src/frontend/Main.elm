module Main exposing (main)

import Navigation

import State.Types exposing (Model, Msg(Initialize))
import State.Update
import App.View


main : Program Never Model Msg
main =
    Navigation.program
        Initialize
        { init = State.Update.init
        , update = State.Update.update
        , view = App.View.view
        , subscriptions = \_ -> Sub.none
        }
