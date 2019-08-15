module Types.Main exposing (Model, Msg(..))

import Browser
import Browser.Navigation as Nav
import Http
import Types.Page exposing (Page)
import Url


type alias Model =
    { key : Nav.Key
    , page : Page
    }


type Msg
    = UrlRequested Browser.UrlRequest
    | UrlChanged Url.Url
    | Loaded (Result Http.Error Page)
