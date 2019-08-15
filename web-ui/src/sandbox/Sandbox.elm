module Sandbox exposing (main)

import Browser
import Html exposing (Html, button, div, input, li, text, ul)
import Html.Attributes exposing (disabled, value)
import Html.Events exposing (onClick, onInput, onSubmit)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


type alias Model =
    { id : String
    , users : List String
    }


init : Model
init =
    { id = ""
    , users = []
    }


type Msg
    = Input String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input id ->
            { model | id = id }

        Submit ->
            { model | id = "", users = model.id :: model.users }


view : Model -> Html Msg
view model =
    div []
        [ Html.form [ onSubmit Submit ]
            [ input [ value model.id, onInput Input ] []
            , button [ disabled (String.length model.id < 1) ] [ text "idを追加するぞ" ]
            , ul [] (List.map viewUser model.users)

            -- 匿名関数だとこんな感じ
            --            , ul [] (List.map (\user -> li [] [ text user ]) model.users)
            ]
        ]


viewUser : String -> Html Msg
viewUser user =
    li [] [ text user ]
