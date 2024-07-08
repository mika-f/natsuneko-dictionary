import fs from "node:fs/promises";
import type {
  IMEDictionary,
  Item,
} from "@natsuneko-laboratory/dictionary-core";
import { parse } from "csv-parse/sync";

type AtokOptions = {
  default?: string;
};

class Atok implements IMEDictionary {
  private readonly items: Item[] = [];
  private readonly default: string = "";
  private readonly dict: string = "atok";
  public readonly name = "atok";

  static async fromCSV(path: string, opts?: AtokOptions): Promise<Atok> {
    const content = await fs.readFile(path, { encoding: "utf-8" });
    const records = parse(content, {});
    const dictionary = new Atok("atok", opts);

    for (const record of records) {
      const [word, reading, category, comment] = record;
      dictionary.register({ word, reading, category, comment });
    }

    return dictionary;
  }

  public constructor(name: string, opts?: AtokOptions) {
    this.dict = name;
    this.default = opts?.default ?? "";
  }
  register(item: Item): void {
    this.items.push(item);
  }

  entries(): Item[] {
    return this.items;
  }

  async save(path: string): Promise<void> {
    const header: string[] = [
      "!!ATOK_TANGO_TEXT_HEADER_1",
      "!!一覧出力",
      `!!対象辞書;${this.dict}.dic`,
      "!!単語種類;登録単語(*)",
    ];

    const chunk = Math.ceil(this.items.length / 500);
    for (let i = 0; i < chunk; i++) {
      const start = i * 500;
      const end = Math.min((i + 1) * 500, this.items.length);
      const items = this.items
        .slice(start, end)
        .map(
          (w) =>
            `${w.word || this.default}\t${w.reading}\t${w.category ?? ""}\t${
              w.comment ?? ""
            }`
        );
      const content = [...header, ...items].join("\n");
      const filename = `${path}/${this.dict}.${i}.dic`;

      await fs.mkdir(path, { recursive: true });
      await fs.writeFile(filename, content, { encoding: "utf-16le" });
    }
  }
}

export { Atok };
