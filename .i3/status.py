from i3pystatus import Status

status = Status()

status.register("clock",
    format="W%V %a %-d %b %X",)

# Shows pulseaudio default sink volume
#
# Note: requires libpulseaudio from PyPI
status.register("pulseaudio",
    format="♪: {volume}",
    format_muted="♪: ---",)

# shows disk usage of / and /pi/
# Format:
# 42/128G [86G]
status.register("disk",
    path="/",
    format="/: {avail:.1f}G",)

status.register("disk",
    path="/pi/",
    format="/pi/: {avail:.1f}G",)

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
    interface="eth0",
    format_up="{interface}: {v4cidr}",
    format_down="")

# Note: requires both netifaces and basiciw (for essid and quality)
status.register("network",
    interface="wlan0",
    format_up="{interface}: {v4cidr}",
    format_down="")

status.register("mem",
    format="M: {avail_mem}/{total_mem} G",
    divisor=1024**3, interval=3)

status.register("battery",
    format= "B: {status} {percentage:.0f}% {remaining:%E%hh:%Mm}",
    alert=True,
    alert_percentage=10,
    status={
        "DIS": "D",
        "CHR": "C",
        "FULL": "=",
    })

status.register("temp",
    format="T: {temp:.0f}°C",
    interval=3)

status.register("cpu_usage",
    format="P: {usage}%",
    interval=3)


status.run()
