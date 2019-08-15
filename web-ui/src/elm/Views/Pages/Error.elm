module Views.Pages.Error exposing (view)

import Html exposing (Html, pre, text)
import Http


view : Http.Error -> Html msg
view error =
    case error of
        Http.BadBody message ->
            pre [] [ text message ]

        _ ->
            text (Debug.toString error)
