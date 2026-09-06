module Main (main) where

import Data.JSONPath.Parser
import Data.JSONPath.Types
import qualified Data.Text as T

main :: IO ()
main = do
  putStrLn "Running hs-jsonpath tests..."

  -- Test: simple child selector
  testParse "$.store" [ChildName "store"]

  -- Test: nested children
  testParse "$.store.books" [ChildName "store", ChildName "books"]

  -- Test: array index
  testParse "$.items[0]" [ChildName "items", ChildIndex 0]

  -- Test: wildcard
  testParse "$.items.*" [ChildName "items", Wildcard]

  -- Test: recursive descent
  testParse "$..title" [Recursive, ChildName "title"]

  -- Test: empty input
  case parseJSONPath "" of
    Left _ -> putStrLn "✅ Empty input rejected"
    Right _ -> error "Expected error for empty input"

  -- Test: missing $
  case parseJSONPath "store" of
    Left _ -> putStrLn "✅ Missing $ rejected"
    Right _ -> error "Expected error for missing $"

  putStrLn "\n🎉 All tests passed!"

testParse :: T.Text -> [Selector] -> IO ()
testParse input expected =
  case parseJSONPath input of
    Right (JSONPathExpr sels) ->
      if sels == expected
        then putStrLn $ "✅ " <> T.unpack input
        else error $ "❌ " <> T.unpack input <> ": got " <> show sels
    Left err -> error $ "❌ Parse error for " <> T.unpack input <> ": " <> err
