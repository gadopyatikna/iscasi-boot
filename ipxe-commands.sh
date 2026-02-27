sanboot # no args already baked into startup sccript
# from grub
set root=(hd0,gpt2)
set prefix=(hd0,gpt2)/boot/grub
insmod normal
normal