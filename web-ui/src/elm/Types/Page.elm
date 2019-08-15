module Types.Page exposing (Page(..))

import Http
import Types.Character


type Page
    = NotFound
    | ErrorPage Http.Error
    | HomePage
    | CoporunsPage (List Types.Character.Coporun)
