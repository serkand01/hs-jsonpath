module Data.JSONPath.Pretty
  ( prettyPrint
  , prettySelector
  ) where

import Data.JSONPath.Types
import Data.Text (Text)
import qualified Data.Text as T

-- | Pretty-print a JSONPath expression back to string form.
prettyPrint :: JSONPathExpr -> Text
prettyPrint (JSONPathExpr sels) = "$" <> T.concat (map prettySelector sels)

-- | Pretty-print a single selector.
prettySelector :: Selector -> Text
prettySelector (ChildName name) = "." <> name
prettySelector (ChildIndex i)   = "[" <> T.pack (show i) <> "]"
prettySelector (Slice s e step) =
  "[" <> maybe "" (T.pack . show) s
  <> ":" <> maybe "" (T.pack . show) e
  <> maybe "" (\st -> ":" <> T.pack (show st)) step
  <> "]"
prettySelector Wildcard    = ".*"
prettySelector Recursive   = ".."
prettySelector (FilterExpr expr) = "[?" <> expr <> "]"

-- | Pretty-print a QueryResult with indentation.
prettyResult :: QueryResult -> Text
prettyResult = go 0
  where
    go _ ResultNull       = "null"
    go _ (ResultBool b)   = if b then "true" else "false"
    go _ (ResultNumber n) = T.pack (show n)
    go _ (ResultValue t)  = "\"" <> t <> "\""
    go indent (ResultArray items) =
      let inner = T.intercalate ",\n"
                    (map (\item -> T.replicate (indent + 2) " " <> go (indent + 2) item) items)
      in "[\n" <> inner <> "\n" <> T.replicate indent " " <> "]"
