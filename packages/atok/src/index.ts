import fs from "node:fs/promises";
import type {
  IMEDictionary,
  Item,
} from "@natsuneko-laboratory/dictionary-core";

class Atok implements IMEDictionary {
  private readonly items: Item[] = [];
  private readonly dict: string = "atok";
  public readonly name = "atok";

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
    const bom = "\ufeff";
    const header: string[] = [
      "!!ATOK_TANGO_TEXT_HEADER_1",
      "!!一覧出力",
      `!!対象辞書;${this.dict}.dic`,
      "!!単語種類;登録単語(*)",
      "",
    ];

    const chunk = Math.ceil(this.items.length / 500);
    for (let i = 0; i < chunk; i++) {
      const start = i * 500;
      const end = Math.min((i + 1) * 500, this.items.length);
      const items = this.items.slice(start, end).map((w) =>
        [
          //
          w.reading,
          w.word,
          w.category,
          w.comment,
        ]
          .join("\t")
          .trim()
      );
      const content = [...header, ...items].join("\r\n");
      const filename = `${path}/${this.dict}.${i}.txt`;

      await fs.mkdir(path, { recursive: true });
      await fs.writeFile(filename, `${bom}${content}`, {
        encoding: "utf-16le",
      });
    }
  }
}

export { Atok };
