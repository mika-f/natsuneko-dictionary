import { Atok } from "@natsuneko-laboratory/atok";
import { Provider } from "@natsuneko-laboratory/dictionary-core";
import { GoogleIME } from "@natsuneko-laboratory/google-ime";

const DICTIONARIES = [
  "Kaomojic",
  // "GenshinImpact",
  // "HonkaiStarRail",
  // "VRChat",
];

for (const dictionary of DICTIONARIES) {
  const provider = await Provider.fromCSV(
    `../../dictionaries/${dictionary.toLowerCase()}.csv`,
    {
      defaultReading: "かお",
      defaultCategory: "顔文字",
    }
  );

  provider.add(new Atok(dictionary));
  provider.add(new GoogleIME(dictionary));

  await provider.save(`../../dist/${dictionary.toLowerCase()}`);
}
