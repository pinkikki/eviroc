module View exposing (view)

import Browser
import Types.Main exposing (Model, Msg)
import Types.Page exposing (Page(..))
import Views.Organisms.Header
import Views.Pages.Coporun.List
import Views.Pages.Error
import Views.Pages.Home
import Views.Pages.NotFound


view : Model -> Browser.Document Msg
view model =
    { title = "夏休みの工作"
    , body =
        [ Views.Organisms.Header.view
        , case model.page of
            NotFound ->
                Views.Pages.NotFound.view

            ErrorPage error ->
                Views.Pages.Error.view error

            HomePage ->
                Views.Pages.Home.view

            CoporunsPage coporuns ->
                Views.Pages.Coporun.List.view coporuns
        ]
    }
