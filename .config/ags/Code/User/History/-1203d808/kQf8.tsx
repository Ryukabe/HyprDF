import { Astal, Gtk } from "ags/gtk4";

import Clock from "./bar/Clock";
import Workspaces from "./bar/Workspaces";
import Battery from "./bar/Battery";
import Media from "./bar/Media";
import Wireless from "./bar/Wireless";
import { quickSettingsOpen, setQuickSettingsOpen } from "./qs/QuickSettings";

function Separator() {
    return <label label="•" cssClasses={["separator"]} />;
}

export default function Bar() {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

    return (
        <window
            visible
            namespace="ags-top-bar"
            anchor={TOP | LEFT | RIGHT}
            layer={Astal.Layer.TOP}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
        >
            <box halign={Gtk.Align.CENTER} valign={Gtk.Align.CENTER}>
                <box cssClasses={["modules-left"]}>
                    <Clock format="%-I:%M" />
                </box>
                <box cssClasses={["modules-center"]}>
                    <Media />
                    <Separator />
                    <Workspaces />
                </box>
                <button
                    cssClasses={quickSettingsOpen((open) =>
                        open
                            ? ["modules-right", "modules-right-active"]
                            : ["modules-right"],
                    )}
                    onClicked={() => setQuickSettingsOpen((v) => !v)}
                >
                    <box>
                        <Wireless />
                        <Battery />
                    </box>
                </button>
            </box>
        </window>
    );
}