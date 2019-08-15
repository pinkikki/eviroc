module Types.Route exposing (Route(..), parse)

import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = Home
    | Coporuns



--    | Coporun Int
--    | NewCoporun
--    | UpdateCoporun


parser : Parser (Route -> a) a
parser =
    oneOf
        [ map Home top
        , map Coporuns (s "coporuns")
        ]


parse : Url -> Maybe Route
parse url =
    Url.Parser.parse parser url
