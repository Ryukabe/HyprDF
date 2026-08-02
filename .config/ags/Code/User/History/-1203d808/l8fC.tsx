import Gtk from "gi://Gtk";
import { Astal } from "ags/gtk4";

import Clock from "./bar/Clock";
import Workspaces from "./bar/Workspaces";
import Battery from "./bar/Battery";
import Media from "./bar/Media";
import Wireless from "./bar/Wireless";

function Separator() {
    return <label label="•" cssClasses={["separator"]} />;
}

export default function Bar() {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

    return (
        <window
            visible
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
                <box cssClasses={["modules-right"]}>
                    <Wireless />
                    <Battery />
                </box>
            </box>
        </window>
    );
}