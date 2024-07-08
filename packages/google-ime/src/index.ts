import fs from "node:fs/promises";
import type {
  IMEDictionary,
  Item,
} from "@natsuneko-laboratory/dictionary-core";

class GoogleIME implements IMEDictionary {
  private readonly items: Item[] = [];
  private readonly dict: string = "google-ime";
  public readonly name = "google-ime";

  public constructor(name: string) {
    this.dict = name;
  }

  register(item: Item): void {
    this.items.push(item);
  }

  entries(): Item[] {
    return this.items;
  }

  async save(path: string): Promise<void> {
    const content = [
      ...this.items.map((w) =>
        [
          //
          w.reading,
          w.word,
          w.category,
          w.comment,
        ]
          .join("\t")
          .trim()
      ),
    ].join("\r\n");
    const filename = `${path}/${this.dict}.txt`;

    await fs.mkdir(path, { recursive: true });
    await fs.writeFile(filename, content, { encoding: "utf-8" });
  }
}

export { GoogleIME };
