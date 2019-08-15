module Views.Pages.Coporun.List exposing (view)

import Html exposing (Html, a, li, text, ul)
import Html.Attributes exposing (href)
import Types.Character exposing (Coporun)
import Url.Builder


view : List Coporun -> Html msg
view coporuns =
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
