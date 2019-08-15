module Views.Organisms.Header exposing (view, viewLink)

import Html exposing (Html, a, li, text, ul)
import Html.Attributes exposing (href)


view : Html msg
view =
    ul []
        [ viewLink "/"
        , viewLink "/coporuns"
        ]


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]
