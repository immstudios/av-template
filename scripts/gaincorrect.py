#!/usr/bin/env python3


import os
import sys
import time
import signal
import subprocess


def parse_buff(buff):
    buff = buff.strip()
    if buff.startswith("I:"):
        buff = buff.split(":")[1]
        buff = buff.strip()
        buff = buff.split("L")[0]
        buff = buff.strip()
        return float(buff)
    return None

def proc(fname):
    p = subprocess.Popen([
            "ffmpeg", "-i", fname,
            "-filter_complex", "ebur128",
            "-f", "null", "-"
        ], stderr=subprocess.PIPE)

    i = -23
    buff = ""
    while p.poll() == None:
        ch = p.stderr.read(1).decode()
        if ch == "\n":
            b = parse_buff(buff)
            if b:
                i = b
            buff = ""
        else:
            buff += ch

    p.wait()

    return -23 - i


if __name__ == "__main__":
    fname = sys.argv[-1]
    print(proc(fname))
