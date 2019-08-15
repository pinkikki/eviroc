module Element exposing (main)

import Browser
import Html exposing (Html, button, div, p, text)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D exposing (Decoder)


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { users : List User
    , error : String
    }


type alias User =
    { id : Int
    , name : String
    }


userDecoder : Decoder User
userDecoder =
    D.map2 User
        (D.field "id" D.int)
        (D.field "name" D.string)


usersDecoder : Decoder (List User)
usersDecoder =
    D.list userDecoder


init : () -> ( Model, Cmd Msg )
init _ =
    ( { users = [], error = "" }
    , Cmd.none
    )


type Msg
    = GetUser
    | GetUsers
    | GotUser (Result Http.Error User)
    | GotUsers (Result Http.Error (List User))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetUser ->
            ( model
            , Http.get
                { url = "http://localhost:8080/users/1"
                , expect = Http.expectJson GotUser userDecoder
                }
            )

        GetUsers ->
            ( model
            , Http.get
                { url = "http://localhost:8080/users"
                , expect = Http.expectJson GotUsers usersDecoder
                }
            )

        GotUser (Ok result) ->
            ( { model | users = [ result ] }, Cmd.none )

        GotUser (Err error) ->
            ( { model | error = Debug.toString error }, Cmd.none )

        GotUsers (Ok result) ->
            ( { model | users = result }, Cmd.none )

        GotUsers (Err error) ->
            ( { model | error = Debug.toString error }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick GetUser ] [ text "get user" ]
        , button [ onClick GetUsers ] [ text "get users" ]

        -- 匿名関数だとこんな感じ
        , div [] (List.map (\user -> p [] [ text (String.fromInt user.id ++ ":" ++ user.name) ]) model.users)

        --        , div [] (List.map viewUser model.users)
        ]


viewUser : User -> Html Msg
viewUser user =
    p [] [ text (String.fromInt user.id ++ ":" ++ user.name) ]
