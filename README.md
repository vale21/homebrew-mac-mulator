# MacMulator Qemu Formula
A Homebrew formula to install a Qemu version that best fits [MacMulator](https://github.com/vale21/mac-mulator)

This formula installs a fully featured Qemu, starting from the great job done by [@knazarov](https://github.com/knazarov/homebrew-qemu-virgl) and by the [UTM](https://github.com/utmapp/UTM) guys. The Qemu that it offers has

- Spice support
- VirGL support
- Improvements to Cocoa framework (thanks to [@akihikodaki](https://github.com/akihikodaki))
- Screamer audio in PPC VMs
- Many other improvements, like the `virtio-ramfb` and `virtio-ramfb-gl` device types

## Installation

`brew install vale21/mac-mulator/qemu`

## Usage

If you are using MacMulator, just point it to your Homebrew folder: `/opt/homebrew/bin` on Apple Silicon Macs, and `/usr/local/bin` on Intel Macs. It will find Qemu and use it to launch its Virtual Machines.

If you want to invoke it via command line, or using any other tool of you choice, just follow the [Qemu User Documentation](https://www.qemu.org/docs/master/system/qemu-manpage.html). This version of Qemu if fully compatible with the standard one.

## Note on 3D Acceleration and Spice

3D Acceleration does not work with Cocoa display type, as it does with the [@knazarov](https://github.com/knazarov/homebrew-qemu-virgl) formula. It works with Spice.

MacMulator does not support Spice yet (Coming soon, however), so if you want it you will need to manually add the following arguments to the Qemu command:

`
-spice unix,addr=/tmp/spice.sock,disable-ticketing \
-device virtio-serial \
-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
-chardev spicevmc,id=spicechannel0,name=vdagent
`

and use a Spice viewer, like [virt-viewer](https://github.com/jeffreywildman/homebrew-virt-manager)