import app from "ags/gtk4/app"
import style from "./styles/style.scss"
import colors from "./colors/colors.css";
import dashboardStyle from "./styles/dashboard.scss";
import qsStyle from "./styles/quicksettings.scss";
import popupStyle from "./styles/popups.scss";
import cornerStyle from "./styles/screencorners.scss";

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
