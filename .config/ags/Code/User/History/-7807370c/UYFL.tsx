import { Astal, Gtk, Gdk } from "ags/gtk4";
import { createBinding, createState } from "ags";

import AstalNetwork from "gi://AstalNetwork";
import AstalBluetooth from "gi://AstalBluetooth";

// — Shared state (imported by Bar.tsx) ————————————————
export const [quickSettingsOpen, setQuickSettingsOpen] = createState(false);

function WiFi() {
  const network = AstalNetwork.get_default();
  const wifi = network.wifi;

  const enabled = createBinding(wifi, "enabled");
  const iconName = createBinding(wifi, "iconName");

  return (
    <button
      hexpand
      onClicked={() => (wifi.enabled = !wifi.enabled)}
      cssClasses={enabled((e) =>
        e ? ["wifi-button", "wifi-button-on"] : ["wifi-button"],
      )}
    >
      <box spacing={7}>
        <image iconName={iconName} />
        <label
          halign={Gtk.Align.START}
          label={enabled((e) => (e ? "Wi-Fi: On" : "Wi-Fi: Off"))}
        />
      </box>
    </button>
  );
}

function Bluetooth() {
  const bt = AstalBluetooth.get_default();
  const adapter = bt.adapter;

  const isPowered = createBinding(bt, "isPowered");

  return (
    <button
      hexpand
      onClicked={() => (adapter.powered = !adapter.powered)}
      cssClasses={isPowered((p) =>
        p ? ["bluetooth-button", "bluetooth-button-on"] : ["bluetooth-button"],
      )}
    >
      <box cssClasses={["bluetooth-box"]} spacing={7}>
        <image iconName="bluetooth-active-symbolic" />
        <label
          halign={Gtk.Align.START}
          label={isPowered((p) => (p ? "BT: On" : "BT: Off"))}
        ></label>
      </box>
    </button>
  );
}

// — Main QuickSettings window ————————————————
export default function QuickSettings() {
  return (
    <window
      cssClasses={["quicksettings"]}
      visible={quickSettingsOpen}
      name="quicksettings"
      namespace="quicksettings"
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.RIGHT |
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
              setQuickSettingsOpen(false);

              return true;
            }

            return false;
          },
        );

        self.add_controller(controller);
      }}
    >
      <box orientation={Gtk.Orientation.VERTICAL} spacing={24} hexpand>
        <box
          spacing={16}
          orientation={Gtk.Orientation.VERTICAL}
          cssClasses={["network"]}
          hexpand
        >
          <label
            label="Network"
            cssClasses={["widget-title"]}
            halign={Gtk.Align.END}
          />
          <box hexpand spacing={8}>
            <WiFi />
            <Bluetooth />
          </box>
        </box>
        {/*
        <box
          spacing={16}
          orientation={Gtk.Orientation.VERTICAL}
          cssClasses={["volume"]}
        >
          <label
            label="Volume"
            cssClasses={["widget-title"]}
            halign={Gtk.Align.END}
          />
          <box spacing={8}>
            <label label="hello world"></label>
          </box>
        </box>
        <box
          spacing={16}
          orientation={Gtk.Orientation.VERTICAL}
          cssClasses={["volume"]}
          vexpand
        >
          <label
            label="Notifications"
            cssClasses={["widget-title"]}
            halign={Gtk.Align.END}
          />
          <box spacing={8}>
            <label label="notifications"></label>
          </box>
        </box>
        */}
      </box>
    </window>
  );
}
