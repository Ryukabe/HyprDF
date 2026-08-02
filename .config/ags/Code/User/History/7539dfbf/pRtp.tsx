import AstalWp from "gi://AstalWp";
import { createBinding } from "ags";

export default function Audio() {
  const wp = AstalWp.get_default();
  const speaker = wp?.defaultSpeaker;

  if (!speaker) return <box />;

  return (
    <button cssClasses={["audio-button"]}>
      <box spacing={6}>
        <image pixelSize={14} iconName={createBinding(speaker, "volumeIcon")} />
      </box>
    </button>
  );
}