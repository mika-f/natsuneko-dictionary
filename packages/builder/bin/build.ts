import { Atok } from "@natsuneko-laboratory/atok";
import { Provider } from "@natsuneko-laboratory/dictionary-core";

const DICTIONARIES = [
  "Kaomojic",
  // "GenshinImpact",
  // "HonkaiStarRail",
  // "VRChat",
];

for (const dictionary of DICTIONARIES) {
  const provider = await Provider.fromCSV(
    `../../dictionaries/${dictionary.toLowerCase()}.csv`
  );

  provider.add(new Atok("atok", { default: "かお" }));

  await provider.save(`../../dist/${dictionary.toLowerCase()}`);
}
