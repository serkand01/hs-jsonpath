module Data.JSONPath.Eval
  ( eval
  , evalOne
  ) where

import Data.JSONPath.Types

-- | Evaluate a JSONPath expression against a QueryResult.
eval :: JSONPathExpr -> QueryResult -> [QueryResult]
eval (JSONPathExpr sels) root = go sels [root]
  where
    go [] results = results
    go (s:rest) results = go rest (concatMap (applySel s root) results)

-- | Evaluate and return the first match, if any.
evalOne :: JSONPathExpr -> QueryResult -> Maybe QueryResult
evalOne expr root = case eval expr root of
  (x:_) -> Just x
  []    -> Nothing

applySel :: Selector -> QueryResult -> QueryResult -> [QueryResult]
applySel (ChildName _name) _root (ResultArray items) =
  -- In a real implementation, this would look up named properties
  -- For now, we return all items as a simplified version
  items
applySel (ChildIndex i) _root (ResultArray items)
  | i >= 0 && i < length items = [items !! i]
  | otherwise = []
applySel Wildcard _root (ResultArray items) = items
applySel Recursive _root node = collectAll node
applySel _ _ _ = []

-- | Recursively collect all nodes.
collectAll :: QueryResult -> [QueryResult]
collectAll (ResultArray items) = items ++ concatMap collectAll items
collectAll node = [node]
