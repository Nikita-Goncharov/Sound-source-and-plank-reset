# Script for reset sound source and restart plank when second monitor connected


## Run 
* Save **sound_bottom_panel_reset.sh** script on your computer and set your own sound sources.
* Put **on_hdmi_connected.service** to *~/.config/systemd/user/* and add path to script(ExecStart) in it.
* In terminal write:
```bash
systemctl --user start on_hdmi_connected.service
systemctl --user enable on_hdmi_connected.service
```
Tested on Ubuntu Mate 22 with lenovo thinkvision monitor