#!/bin/bash


# TODO: add your own needed sound outputs(list of all available - "pactl list short sinks")
laptop_out="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink"
bluez_out="bluez_sink.84_0F_2A_76_32_A2.a2dp_sink"

hdmi_status=$(xrandr |grep 'connected' |grep 'HDMI')  # line with hdmi info or nothing


echo "INFO: HDMI status: "
echo ""
echo $hdmi_status
echo ""

reset_plank() {
    echo "INFO: Reset plank"
    killall plank 
    nohup plank &
}

reset_sound_source() {
    echo "INFO: Reset sound source"
    sound_sources=$(pactl list short sinks)

    echo "INFO: Sound sources: "
    echo ""
    echo $sound_sources
    echo ""

    if [[ $sound_sources == *"$bluez_out"* ]]; then
        echo "INFO: Reset to bluez"
        pactl set-default-sink $bluez_out
    else
        echo "INFO: Reset to default laptop sound source"
        pactl set-default-sink $laptop_out
    fi
}

reset_if_sound_source_incorrect() {  # TODO: logging
    current_sound_source=$(pactl list short sinks | grep 'RUNNING')
    if [[ !($current_sound_source == *"$bluez_out"* || $current_sound_source == *"$laptop_out"*) ]]; then
        reset_sound_source
    fi
}

if [[ $hdmi_status != "" ]]; then
    echo "INFO: Reset all on start service"
    reset_sound_source
    reset_plank
fi

while :; do
    hdmi_status_new=$(xrandr |grep 'connected' |grep 'HDMI')

    # Restart all if hdmi status changed or reset sound if source changed
    if [[ $hdmi_status_new != $hdmi_status ]]; then
        echo "INFO: HDMI status changed"
        reset_sound_source
        reset_plank
    else
        reset_if_sound_source_incorrect
    fi

    hdmi_status=$hdmi_status_new
    sleep 1
    echo "INFO: Next cycle"
done


