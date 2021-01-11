#!/usr/bin/python
from datetime import datetime
from psutil import disk_usage, sensors_battery, cpu_percent, sensors_temperatures, virtual_memory
from psutil._common import bytes2human
from socket import gethostname, gethostbyname
from subprocess import check_output
from sys import stdout
from time import sleep

def write(data):
    stdout.write('%s\n' % data)
    stdout.flush()

def refresh():
    cpu = cpu_percent()
    t = sensors_temperatures()['coretemp'][0].current
    mem = virtual_memory().percent
    ip = gethostbyname(gethostname())
    try:
        ssid = check_output("iwgetid -r", shell=True).strip().decode("utf-8")
        ssid = "(%s)" % ssid
    except Exception:
        ssid = "None"
    try:
        vol = check_output("pamixer --get-volume", shell=True).strip().decode("utf-8")
    except Exception:
        vol = "?"
    
    battery = int(sensors_battery().percent)
    status = "Charging" if sensors_battery().power_plugged else "Discharging"
    date = datetime.now().strftime('%A %m-%d %H:%M')
    format = "cpu: %s t: %s | mem: %s | Vol: %s | net: %s %s | bat: %s%% %s | date: %s"
    write(format % (cpu, t, mem, vol, ip, ssid, battery, status, date))

while True:
    refresh()
    sleep(1)
