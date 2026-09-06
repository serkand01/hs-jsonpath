{-# LANGUAGE DerivingStrategies #-}

module Data.JSONPath.Types
  ( Selector(..)
  , JSONPathExpr(..)
  , QueryResult(..)
  ) where

import Data.Text (Text)

-- | A single selector in a JSONPath expression.
data Selector
  = ChildName Text        -- ^ Named child: .store
  | ChildIndex Int        -- ^ Array index: [0]
  | Slice (Maybe Int) (Maybe Int) (Maybe Int)  -- ^ Array slice: [start:end:step]
  | Wildcard              -- ^ All children: .*
  | Recursive             -- ^ Recursive descent: ..
  | FilterExpr Text       -- ^ Filter expression: [?@.price<10]
  deriving stock (Show, Eq)

-- | A parsed JSONPath expression.
newtype JSONPathExpr = JSONPathExpr
  { selectors :: [Selector]
  } deriving stock (Show, Eq)

-- | Result of a JSONPath query.
data QueryResult
  = ResultArray [QueryResult]
  | ResultValue Text
  | ResultNumber Double
  | ResultBool Bool
  | ResultNull
  deriving stock (Show, Eq)
