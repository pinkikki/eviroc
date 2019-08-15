module Application exposing (main)

import Browser
import Browser.Navigation as Nav
import Html exposing (Html, a, b, h1, li, pre, text, ul)
import Html.Attributes exposing (href)
import Html.Events exposing (..)
import Http
import Json.Decode as D exposing (Decoder)
import Url exposing (Url)
import Url.Builder exposing (..)
import Url.Parser exposing (..)


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


type alias Model =
    { key : Nav.Key
    , page : Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    Model key HomePage
        |> goTo (parse url)


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Loaded (Result Http.Error Page)


type Route
    = Home
    | Coporuns



--    | Coporun Int
--    | NewCoporun
--    | UpdateCoporun


type Page
    = NotFound
    | ErrorPage Http.Error
    | HomePage
    | CoporunsPage (List Coporun)



--    | CoporunPage
--    | NewCoporunPage
--    | UpdateCoporunPage


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Home top
        , map Coporuns (s "coporuns")
        ]


parse : Url -> Maybe Route
parse url =
    Url.Parser.parse parser url


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


type alias Coporun =
    { name : String
    , lvl : String
    }


coporunDecoder : Decoder Coporun
coporunDecoder =
    D.map2 Coporun
        (D.field "name" D.string)
        (D.field "lvl" D.string)


coporunsDecoder : Decoder (List Coporun)
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
                        (Result.map CoporunsPage >> Loaded)
                        coporunsDecoder
                }
            )


view : Model -> Browser.Document Msg
view model =
    { title = "夏休みの工作"
    , body =
        [ viewHeader
        , case model.page of
            NotFound ->
                viewNotFound

            ErrorPage error ->
                viewError error

            HomePage ->
                viewHome

            CoporunsPage coporuns ->
                viewCoporuns coporuns
        ]
    }


viewHeader : Html msg
viewHeader =
    ul []
        [ viewLink "/"
        , viewLink "/coporuns"
        ]


viewNotFound : Html msg
viewNotFound =
    text "not found"


viewError : Http.Error -> Html msg
viewError error =
    case error of
        Http.BadBody message ->
            pre [] [ text message ]

        _ ->
            text (Debug.toString error)


viewHome : Html msg
viewHome =
    text "home"


viewCoporuns : List Coporun -> Html msg
viewCoporuns coporuns =
    ul []
        (coporuns
            |> List.map
                (\coporun ->
                    viewLink (Url.Builder.absolute [ coporun.name, coporun.lvl ] [])
                )
        )


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
