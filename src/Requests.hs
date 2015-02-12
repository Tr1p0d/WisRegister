module Requests
(
registerRequest,
cookieRequest
) where

-- sandbox imports
import Network.Http.Client (http, Method(GET), setAuthorizationBasic, RequestBuilder, setHeader )

-- local imports
import Types

registerRequest :: Cookie -> RequestBuilder()
registerRequest (Cookie token _ _ _)  = 
  http GET "/FIT/st/course-sl.php?xml=f3c30eb7c65a9a46d9fb2a20ad73bf15fe49084c,1423595852&id=568612&log_51900=xml">>
  setAuthorizationBasic "xkidon00" "vujurhum6o" >>
  setHeader "User-Agent" "wis register tool" >>
  setHeader "Accept" "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" >>
  setHeader "Referer" "https://wis.fit.vutbr.cz/FIT/st/course-sl.php?id=568612&item=51899" >>
  setHeader "Accept-Encoding" "gzip, deflate" >>
  setHeader "DNT" "1" >>
  setHeader "Connection" "keep-alive" >>
  setHeader "Referer" "https://wis.fit.vutbr.cz/FIT/st/course-sl.php?id=568612" >>
  setHeader "X-Requested-With" "XMLHttpRequest"

cookieRequest :: RequestBuilder ()
cookieRequest = 
  http GET "https://wis.fit.vutbr.cz/FIT/st/course-sl.php?id=568612&item=51899" >>
  setAuthorizationBasic "xkidon00" "vujurhum6o" >>
  setHeader "User-Agent" "wis register tool" >>
  setHeader "Accept" "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" >>
  setHeader "Referer" "https://wis.fit.vutbr.cz/FIT/st/" >>
  setHeader "Accept-Encoding" "gzip, deflate" >>
  setHeader "DNT" "1" >>
  setHeader "Connection" "keep-alive" >>
  setHeader "Referer" "https://wis.fit.vutbr.cz/FIT/st/course-sl.php?id=568612" >>
  setHeader "X-Requested-With" "XMLHttpRequest"
