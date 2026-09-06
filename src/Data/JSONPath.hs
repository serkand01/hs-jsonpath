-- | JSONPath query engine for Haskell.
--
-- This module re-exports the public API.
--
-- Usage:
--
-- @
-- import Data.JSONPath
--
-- result = queryPath "$..books[0].title" jsonValue
-- @
module Data.JSONPath
  ( module Data.JSONPath.Types
  , module Data.JSONPath.Parser
  , module Data.JSONPath.Eval
  ) where

import Data.JSONPath.Types
import Data.JSONPath.Parser
import Data.JSONPath.Eval
