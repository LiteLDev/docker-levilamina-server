"""Sends a RakNet unconnected ping to a Bedrock server and prints its MOTD (the pong payload).

Usage: raknet_ping.py <host> <port> [<timeout seconds>]
Exits with 0 when the server answers with an unconnected pong whose payload starts with MCPE.
"""

import os
import socket
import struct
import sys
import time

MAGIC = bytes.fromhex("00ffff00fefefefefdfdfdfd12345678")


def main() -> int:
    host, port = sys.argv[1], int(sys.argv[2])
    deadline = time.monotonic() + (float(sys.argv[3]) if len(sys.argv) > 3 else 30)
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        sock.settimeout(2)
        while time.monotonic() < deadline:
            ping = b"\x01" + struct.pack(">q", int(time.time() * 1000)) + MAGIC + os.urandom(8)
            sock.sendto(ping, (host, port))
            try:
                data, _ = sock.recvfrom(4096)
            except socket.timeout:
                continue
            # 0x1c, time (8), server GUID (8), magic (16), string length (2), string.
            if len(data) > 35 and data[0] == 0x1C and data[17:33] == MAGIC:
                (length,) = struct.unpack(">H", data[33:35])
                motd = data[35 : 35 + length].decode("utf-8", "replace")
                print(motd)
                return 0 if motd.startswith("MCPE;") else 1
    print(f"no unconnected pong from {host}:{port}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    sys.exit(main())
