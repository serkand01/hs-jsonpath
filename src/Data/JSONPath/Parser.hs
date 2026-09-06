module Data.JSONPath.Parser
  ( parseJSONPath
  , ParseError
  ) where

import Data.JSONPath.Types
import Data.Text (Text)
import qualified Data.Text as T

type ParseError = String

-- | Parse a JSONPath string into a structured expression.
--
-- >>> parseJSONPath "$.store.books[0].title"
-- Right (JSONPathExpr [ChildName "store", ChildName "books", ChildIndex 0, ChildName "title"])
--
parseJSONPath :: Text -> Either ParseError JSONPathExpr
parseJSONPath input
  | T.null input = Left "Empty JSONPath expression"
  | T.head input /= '$' = Left "JSONPath must start with $"
  | otherwise = do
      let rest = T.tail input
      sels <- parseSelectors rest
      Right $ JSONPathExpr sels

parseSelectors :: Text -> Either ParseError [Selector]
parseSelectors t
  | T.null t = Right []
  | T.isPrefixOf ".." t = do
      rest <- parseSelectors (T.drop 2 t)
      Right $ Recursive : rest
  | T.isPrefixOf ".*" t = do
      rest <- parseSelectors (T.drop 2 t)
      Right $ Wildcard : rest
  | T.isPrefixOf "." t = do
      let remaining = T.drop 1 t
      let (name, rest) = T.break (\c -> c == '.' || c == '[') remaining
      if T.null name
        then Left "Expected property name after '.'"
        else do
          more <- parseSelectors rest
          Right $ ChildName name : more
  | T.isPrefixOf "[" t = do
      let (bracket, afterBracket) = T.breakOn "]" (T.drop 1 t)
      if T.null afterBracket
        then Left "Unclosed bracket"
        else do
          sel <- parseBracketContent bracket
          more <- parseSelectors (T.drop 1 afterBracket)
          Right $ sel : more
  | otherwise = Left $ "Unexpected character: " <> T.unpack (T.take 1 t)

parseBracketContent :: Text -> Either ParseError Selector
parseBracketContent t
  | T.isPrefixOf "?" t = Right $ FilterExpr (T.drop 1 t)
  | T.isPrefixOf "*" t = Right Wildcard
  | otherwise = case reads (T.unpack t) :: [(Int, String)] of
      [(n, "")] -> Right $ ChildIndex n
      _         -> Right $ ChildName t
