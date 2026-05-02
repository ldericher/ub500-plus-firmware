# ub500-plus-firmware

This installs an alternative version of the firmware for "rtl8761bu" as a debian package.

Tested and intended for use with TP-Link "UB500 Plus" dongle, but might work with a variety of adapters.


## Quick Start

Simply download and install the latest package from the [Releases page](./releases).
"v1" or "v2" depends on your TP-Link Hardware Version.

Rebooting should not be necessary, but would be the first step in troubleshooting.

### Finding TP-Link Hardware Version

Follow TP-Link's [official documentation to find your hardware version](https://www.tp-link.com/us/support/faq/46).
Incidentally, the german version is [a little bit more detailed](https://www.tp-link.com/de/support/faq/46).

**tl;dr** – For the UB500 Plus, find the "FCC ID" right on the USB plug and check for a suffix like "V2".
If there's none, you have UB500 V1.

### Additional Info

TP-Link ships the same driver for "V1" and "V1.60", and another one for "V2" and "V2.60".
so you should only bother with major versions.

If you're feeling lucky, you can try and install V2 anyway.
This adds support for HCI version 13 (Bluetooth 5.4) and may or may not be stable for you.


## The Issue

My UB500 plus showed up as "Bluetooth 5.1" in `btmgmt info` command:

    $ btmgmt info
    hci0:   Primary controller
            addr XX:XX:XX:XX:XX:XX version 10 manufacturer XX class 0xXXXXXX
            supported settings: powered connectable fast-connectable discoverable bondable link-security ssp br/edr le advertising secure-conn debug-keys privacy static-addr phy-configuration wide-band-speech 
            current settings: powered bondable ssp br/edr le secure-conn 
            name XX
            short name

The key bit is the `version 10`, which corresponds to BT 5.1 according to [the Bluetooth SIG's bitbucket repository](https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/core/core_version.yaml).


## The Solution

I found a [solution on reddit](https://www.reddit.com/r/linuxhardware/comments/ynjvkx/comment/k0riwsc/?context=3) requiring some manual work, prone to being overridden by future package installs or updates.

With that solution, I got `version 12` (BT 5.3) in `btmgmt info`.

Next, I packaged this .deb to make the installation simpler and more robust.

Finally, I tried running the firmware for V2 on my V1 dongle, and that seems to be working flawlessly, reporting `version 13` (BT 5.4) despite my dongle being marked "Bluetooth®5.3".


## Disclaimer

This repository, including the released deb packages, do not contain any files licensed by TP-Link.
Instead, files are downloaded from the [official TP-Link downloads](https://www.tp-link.com/us/support/download/ub500-plus) and verified via sha256 in the packages' post-installation hook.
