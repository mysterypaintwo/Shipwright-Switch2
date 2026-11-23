#!/usr/bin/env python3
"""Receives the debug stream from a console build and saves it.

  python3 switch2/debug_listener.py session.log
  python3 switch2/debug_listener.py session.log --peek CONSOLE_IP 0x1234 64

Put this computer's IP in debug-host.txt next to the NRO to turn the stream on.
--peek reads memory at an offset in the build's .elf.
"""
import socket
import sys
import time


def main():
    log_path = sys.argv[1]
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(("0.0.0.0", 4243))
    if len(sys.argv) >= 6 and sys.argv[2] == "--peek":
        sock.sendto(f"R {int(sys.argv[4], 0):x} {int(sys.argv[5])}".encode(), (sys.argv[3], 4242))
        sock.settimeout(2)
    last_heartbeat = None
    with open(log_path, "a", buffering=1) as log:
        while True:
            try:
                data, _ = sock.recvfrom(4096)
            except socket.timeout:
                return
            text = data.decode(errors="replace")
            stamp = time.strftime("%H:%M:%S") + f".{int(time.time() * 1000) % 1000:03d}"
            if text.startswith("H "):
                last_heartbeat = text
            log.write(f"{stamp} {text}\n")
            if text.startswith(("M ", "E ")) and len(sys.argv) >= 6:
                print(text)
                return


if __name__ == "__main__":
    main()
