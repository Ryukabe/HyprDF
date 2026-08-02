import app from "ags/gtk4/app"
import style from "./styles/style.scss"
import Bar from "./widget/Bar"

app.start({
   css: `${colors}\n${style}`, /*\n${dashboardStyle}\n${qsStyle}\n${popupStyle}(when add theme)*/
    gtkTheme: "Adwaita-dark",

    main() {
        Bar();
        Dashboard();
        /*QuickSettings();
        NotificationPopups();
        ScreenCorners();*/
    },
})
