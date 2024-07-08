import fs from "node:fs/promises";
import { parse } from "csv-parse/sync";

type Item = {
  word: string;
  reading: string;
  category?: string;
  comment?: string;
};

type StringOrFunction = string | ((item: string) => string);

type ProviderOptions = {
  defaultReading?: StringOrFunction;
  defaultCategory?: StringOrFunction;
  defaultComment?: StringOrFunction;
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
  private readonly defaultReading: StringOrFunction = "";
  private readonly defaultCategory: StringOrFunction = "";
  private readonly defaultComment: StringOrFunction = "";

  private getDefault(item: string, defaultValue: StringOrFunction) {
    if (typeof defaultValue === "function") {
      return defaultValue(item ?? null);
    }

    return defaultValue ?? "";
  }

  static async fromCSV(
    path: string,
    opts?: ProviderOptions
  ): Promise<Provider> {
    const content = await fs.readFile(path, { encoding: "utf-8" });
    const records = parse(content, {});
    const dictionary = new Provider(opts);

    for (const record of records) {
      const [reading, word, category, comment] = record;
      dictionary.register({ word, reading, category, comment });
    }

    return dictionary;
  }

  public constructor(opts?: ProviderOptions) {
    this.defaultReading = opts?.defaultReading ?? "";
    this.defaultCategory = opts?.defaultCategory ?? "";
    this.defaultComment = opts?.defaultComment ?? "";
  }

  add(...provider: IMEDictionary[]): void {
    this.providers.push(...provider);
  }

  register(item: Item): void {
    this.items.push(item);
  }

  entries(): Item[] {
    return this.items;
  }

  async save(path: string): Promise<void> {
    const items = this.entries().map((w) => ({
      reading: w.reading || this.getDefault(w.word, this.defaultReading),
      word: w.word,
      category: w.category || this.getDefault(w.word, this.defaultCategory),
      comment: w.comment || this.getDefault(w.word, this.defaultComment),
    }));

    for (const provider of this.providers) {
      for (const item of items) {
        provider.register(item);
      }

      await provider.save(`${path}/${provider.name}/`);
    }
  }
}

export { Provider };
export type { Item, IMEDictionary };
