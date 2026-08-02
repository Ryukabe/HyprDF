import AstalHyprland from "gi://AstalHyprland";
import { createBinding, For } from "ags";

export default function Workspaces() {
  const hyprland = AstalHyprland.get_default();
  const workspaces = createBinding(hyprland, "workspaces");
  const focused = createBinding(hyprland, "focusedWorkspace");

  const sortedWorkspaces = workspaces.as((wss) =>
    wss.filter((ws) => ws.id > 0).sort((a, b) => a.id - b.id)
  );

  return (
    <box cssClasses={["workspaces"]}>
      <For each={sortedWorkspaces}>
        {(ws) => (
          <button
            cssClasses={focused.as((fw) => {
              const classes = ["workspace"];
              if (fw?.id === ws.id) classes.push("active");
              else if (ws.clients.length > 0) classes.push("occupied");
              return classes;
            })}
            onClicked={() => hyprland.dispatch("workspace", `${ws.id}`)}
          >
            <label label={`${ws.id}`} />
          </button>
        )}
      </For>
    </box>
  );
}