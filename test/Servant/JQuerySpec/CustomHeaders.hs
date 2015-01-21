{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE FlexibleInstances   #-}
{-# LANGUAGE KindSignatures      #-}
{-# LANGUAGE PolyKinds           #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeFamilies        #-}
{-# LANGUAGE TypeOperators       #-}

module Servant.JQuerySpec.CustomHeaders where

import Control.Lens
import Data.Monoid
import Data.Proxy
import GHC.TypeLits
import Servant.API
import Servant.JQuery

-- | This is a hypothetical combinator that fetches an Authorization header.
-- The symbol in the header denotes what kind of authentication we are
-- using -- Basic, Digest, whatever.
data Authorization (sym :: Symbol) a

instance (KnownSymbol sym, HasJQ sublayout)
	=> HasJQ (Authorization sym a :> sublayout) where
    type JQ (Authorization sym a :> sublayout) = JQ sublayout

    jqueryFor Proxy req = jqueryFor (Proxy :: Proxy sublayout) $
        req & reqHeaders <>~ [ ReplaceHeaderArg "Authorization" $
        					   tokenType (symbolVal (Proxy :: Proxy sym)) ]
      where
      	tokenType t = t <> " {Authorization}"
