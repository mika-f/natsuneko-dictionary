import fs from "node:fs/promises";
import { parse } from "csv-parse/sync";

type Item = {
  word: string;
  reading: string;
  category?: string;
  comment?: string;
};

interface IMEDictionary {
  register(item: Item): void;
  entries(): Item[];
  save(path: string): Promise<void>;

  get name(): string;
}

class Provider implements IMEDictionary {
  get name(): string {
    throw new Error("Method not implemented.");
  }

  private readonly providers: IMEDictionary[] = [];
  private readonly items: Item[] = [];

  static async fromCSV(path: string): Promise<Provider> {
    const content = await fs.readFile(path, { encoding: "utf-8" });
    const records = parse(content, {});
    const dictionary = new Provider();

    for (const record of records) {
      const [word, reading, category, comment] = record;
      dictionary.register({ word, reading, category, comment });
    }

    return dictionary;
  }

  add(provider: IMEDictionary): void {
    this.providers.push(provider);
  }

  register(item: Item): void {
    this.items.push(item);
  }

  entries(): Item[] {
    return this.items;
  }

  async save(path: string): Promise<void> {
    for (const provider of this.providers) {
      for (const item of this.entries()) {
        provider.register(item);
      }

      await provider.save(`${path}/${provider.name}/`);
    }
  }
}

export { Provider };
export type { Item, IMEDictionary };
