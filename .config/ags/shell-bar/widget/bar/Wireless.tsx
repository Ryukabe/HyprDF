import AstalNetwork from "gi://AstalNetwork";
import { With, createBinding } from "ags";

export default function Wireless() {
    const network = AstalNetwork.get_default();
    const wifi = createBinding(network, "wifi");

    return (
        <box cssClasses={["wireless-icon"]}>
            <With value={wifi}>
                {(w) =>
                    w && <image pixelSize={14} iconName={createBinding(w, "iconName")} />
                }
            </With>
        </box>
    );
}