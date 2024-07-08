# @natsuneko-laboratory/google-ime

The Node.js package for writing IME dictionary for [Google Japanese Input](https://www.google.co.jp/ime/), from CSV.

## Installation

```bash
$ npm install @natsuneko-laboratory/google-ime
```

## Usage

```typescript
import { GoogleIME } from "@natsuneko-laboratory/google-ime";

// manually add a word
const gime = new GoogleIME({ name: "MyDictionary" });
gime.add({
  word: "雷櫻の枝",
  reading: "らいおうのえだ",
  category: "固有一般",
  comment: "システム＞謎解き",
});

// save the dictionary
await gime.save("path/to/dictionary");

// extra
import { Provider } from "@natsuneko-laboratory/dictionary-core";
const provider = new Provider();
provider.add(gime);

// save the dictionary
await provider.save("path/to/dictionary");
```

## License

MIT by [@6jz](https://twitter.com/6jz)
