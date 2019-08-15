module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Http
import Json.Decode as D exposing (Decoder)
import Types.Character exposing (Coporun)
import Types.Main exposing (Model, Msg(..))
import Types.Page exposing (Page(..))
import Types.Route exposing (Route(..), parse)
import Url exposing (Url)
import Url.Builder exposing (..)
import View exposing (view)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Model key HomePage
        |> goTo (parse url)



--    | CoporunPage
--    | NewCoporunPage
--    | UpdateCoporunPage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            goTo (parse url) model

        Loaded result ->
            ( { model
                | page =
                    case result of
                        Ok page ->
                            page

                        Err e ->
                            ErrorPage e
              }
            , Cmd.none
            )


coporunDecoder : Decoder Types.Character.Coporun
coporunDecoder =
    D.map2 Types.Character.Coporun
        (D.field "name" D.string)
        (D.field "lvl" D.string)


coporunsDecoder : Decoder (List Types.Character.Coporun)
coporunsDecoder =
    D.list coporunDecoder


goTo : Maybe Route -> Model -> ( Model, Cmd Msg )
goTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just Home ->
            ( { model | page = HomePage }, Cmd.none )

        Just Coporuns ->
            ( model
            , Http.get
                { url =
                    Url.Builder.crossOrigin "http://localhost:8080"
                        [ "coporuns" ]
                        []
                , expect =
                    Http.expectJson
                        (\c -> (Result.map CoporunsPage >> Loaded) c)
                        --                        (\c -> Loaded (Result.map CoporunsPage c)) ← これは●
                        --                        (Result.map CoporunsPage >> Loaded) ← これは●
                        --                        (\c -> Result.map CoporunsPage >> Loaded) ← これは×
                        coporunsDecoder
                }
            )
