module Types 
(  
  Cookie(..),
  Token,
  Path,
  Domain
) where

--system imports
import qualified Data.Text as T (Text)

data Cookie = Cookie Token Expires Path Domain deriving (Show) 
type Token = T.Text
type Expires = T.Text
type Path = T.Text
type Domain = T.Text
