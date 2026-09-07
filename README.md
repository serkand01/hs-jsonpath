# 🟣 hs-jsonpath

A JSONPath query engine for Haskell with RFC 9535 compliance and streaming evaluation.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Haskell](https://img.shields.io/badge/Haskell-GHC%209.6+-5e5086.svg)](https://haskell.org)

## Features

- 📜 **RFC 9535** — Full compliance with the JSONPath specification
- 🌊 **Streaming** — Evaluate queries on large JSON without loading into memory
- 🔧 **Type-safe** — Compile-time JSONPath expression validation
- ⚡ **Fast** — Optimized recursive descent with memoization

## Quick Start

```haskell
import Data.JSONPath

main :: IO ()
main = do
  let json = "{\"store\":{\"books\":[{\"title\":\"Dune\",\"price\":12.99}]}}"
  let result = query "$..books[?@.price<15].title" json
  print result  -- ["Dune"]
```

## License

MIT License
