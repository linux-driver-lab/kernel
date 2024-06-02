
Not sure which would serve us the best.

```
apt install linux-source
apt install linux-headers-$(uname -r)
apt source linux-image-$(uname -r)
```

<https://nickdesaulniers.github.io/blog/2018/10/24/booting-a-custom-linux-kernel-in-qemu-and-debugging-it-with-gdb/>
<https://interrupt.memfault.com/blog/emulating-raspberry-pi-in-qemu>

Note: The DTB from Fedora seems to be wrong, the one from rpios good.

1) Keep the triplet QEMU + kernel + DTB working. Do not use different QEMU
machine, do not use use kernel and DTB from different sources.

Note: Fedora kernel+DTB don't see the partitions on SD for some reason...

It is possible to extract the rootfs partition and then use it as
root=/dev/mmcblk0 directly.

2) Make sure your kernel has built-in modules necessary to load the SD card
and stuff. Fedora stock kernel uses a module, that's a problem.

3) 


## Running a Fedora QCOW image

The following command was tested on openSUSE Tumbleweed and runs a slow but
steady Fedora system on there. It takes ages 

```
qemu-system-aarch64 \
    -machine virt \
    -cpu cortex-a57 \
    -m 2048 \
    -drive if=none,file=Fedora-Server-KVM-40-1.14.aarch64.qcow2,format=qcow2,id=hd \
    -device virtio-blk-device,drive=hd \
    -netdev user,id=net0 \
    -device virtio-net-device,netdev=net0 \
    -nographic \
    -bios /usr/share/qemu/qemu-uefi-aarch64.bin
```

## Yocto experiment

1) Enable hashserve options
  - `BB_HASHSERVE_UPSTREAM`
  - `SSTATE_MIRRORS`
  - `BB_HASHSERVE`
  - `BB_SIGNATURE_HANDLER`

2) https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html

3) Build with modified kernel configuration:

```
bitbake -c menuconfig virtual/kernel
bitbake core-image-minimal
runqemu core-image-minimal nographic slirp
```

4) Build with additional packages:

```
mkdir -p meta-custom/recipes-core/images
echo 'IMAGE_INSTALL:append = " i2c-tools kernel-modules"' >> meta-custom/recipes-core/images/core-image-minimal.bbappend
bitbake core-image-minimal
runqemu core-image-minimal nographic slirp
```

5) Experiment with i2c-stub via quick kernel code modification

```
bitbake linux-yocto -c devshell
# make modifications
bitbake core-image-minimal
runqemu core-image-minimal nographic slirp
```

In the VM:

```
modprobe i2c-stub chip_addr=0x50
modprobe i2c-test
```

