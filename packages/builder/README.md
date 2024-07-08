# @natsuneko-laboratory/atok

The Node.js package for writing IME dictionary for [JustSystems ATOK](https://atok.com/), from CSV.

## Installation

```bash
$ npm install @natsuneko-laboratory/atok
```

## Usage

```typescript
import { Atok } from "@natsuneko-laboratory/atok";

// manually add a word
const atok = new Atok({ name: "MyDictionary" });
atok.add({
  word: "雷櫻の枝",
  reading: "らいおうのえだ",
  category: "固有一般",
  comment: "システム＞謎解き",
});

// add a word from CSV
const atok = Atok.fromCsv("path/to/csv");

// save the dictionary
await atok.save("path/to/dictionary");

// extra
import { Provider } from "@natsuneko-laboratory/dictionary-core";
const provider = new Provider();
provider.add(atok);

// save the dictionary
await provider.save("path/to/dictionary");
```

## License

MIT by [@6jz](https://twitter.com/6jz)
