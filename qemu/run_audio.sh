 #qemu-system-x86_64 --enable-kvm -boot order=d -drive file=void.img -m 3G -cpu host -vga virtio -display sdl,gl=on  -audiodev alsa,id=alsa,out.frequency=44100,out.channels=2,out.format=s16,out.mixing-engine=on -device ich9-intel-hda -device hda-duplex,audiodev=alsa & disowen
 #
 
 qemu-system-x86_64 -D ./log.txt --enable-kvm \
	-boot order=d \
 	-m 4G \
	-cpu host \
	-smp 3 \
	-drive file=void.img \
	-boot d \
	-vga virtio \
	-display sdl,gl=on \
	-audiodev pa,id=snd0 -device ich9-intel-hda -device hda-output,audiodev=snd0 \
	& diswon
	#-device AC97 \

