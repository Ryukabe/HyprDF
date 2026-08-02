import GLib from "gi://GLib";
import { createPoll } from "ags/time";
import { dashboardOpen, setDashboardOpen } from "../dashboard/Dashboard";

export default function Clock({ format = "%H:%M" }) {
    const time = createPoll("", 1000, () => {
        return GLib.DateTime.new_now_local().format(format) ?? "Invalid format";
    });

    return (
        <button
            cssClasses={["clock-button"]}
            onClicked={() => setDashboardOpen(!dashboardOpen())}
        >
            <label label={time} />
        </button>
    );
}