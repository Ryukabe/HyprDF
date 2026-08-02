import { Astal, Gtk, Gdk } from "ags/gtk4";
import { createState } from "ags";

import Calendar from "./Calendar";
import Pomodoro from "./Pomodoro";
import Todo from "./Todo";

export const [dashboardOpen, setDashboardOpen] = createState(false);

export default function Dashboard() {
    return (
        <window
            visible={dashboardOpen}
            name="dashboard"
            namespace="dashboard"
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.BOTTOM
            }
            layer={Astal.Layer.OVERLAY}
            exclusivity={Astal.Exclusivity.NORMAL}
            keymode={Astal.Keymode.ON_DEMAND}
            $={(self: Astal.Window) => {
                const controller = new Gtk.EventControllerKey();
                controller.connect(
                    "key-pressed",
                    (_ctrl: Gtk.EventControllerKey, keyval: number) => {
                        if (keyval === Gdk.KEY_Escape) {
                            setDashboardOpen(false);
                            return true;
                        }
                        return false;
                    },
                );
                self.add_controller(controller);
            }}
        >
            <box
                cssClasses={["dashboard"]}
                orientation={Gtk.Orientation.VERTICAL}
                spacing={24}
            >
                <Calendar />
                <Pomodoro />
                <Gtk.Separator orientation={Gtk.Orientation.HORIZONTAL} />
                <Todo />
            </box>
        </window>
    );
}
