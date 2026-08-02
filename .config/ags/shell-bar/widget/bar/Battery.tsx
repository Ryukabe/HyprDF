import AstalBattery from "gi://AstalBattery";
import Gtk from "gi://Gtk";
import { createBinding } from "ags";

export default function Battery() {
    const battery = AstalBattery.get_default();

    const batteryStyle = createBinding(battery, "percentage").as((p) => {
        const percent = Math.round(p * 100);

        // Change gradient based on level
        const startColor = p > 0.3 ? "@purple" : "@orange";
        const endColor = p > 0.3 ? "@blue" : "@red";

        return `background: linear-gradient(
        to right,
        ${startColor} 0%,
        ${endColor} ${percent}%,
        @grey0 ${percent}%
    );`;
    });

    const labelClass = createBinding(battery, "percentage").as((p) => {
        return p > 0.4 ? ["battery-label", "dark"] : ["battery-label", "light"];
    });

    return (
        <box
            visible={createBinding(battery, "isPresent")}
            cssClasses={["battery-pill"]}
            css={batteryStyle}
            valign={Gtk.Align.CENTER}
        >
            <label
                hexpand
                vexpand
                halign={Gtk.Align.CENTER}
                valign={Gtk.Align.CENTER}
                cssClasses={labelClass}
                label={createBinding(battery, "percentage").as(
                    (p) => `${Math.round(p * 100)}`,
                )}
            />
        </box>
    );
}