#### Tema "Windows 95 Gangster Edition" para Linux Mint

No MacBook Air 4.2, para que não fique com a animação bugada, é necessário adicionar o driver de vídeo aos módulos para que ele inicializa antes das animações.

```bash
echo i915 | sudo tee -a /etc/initramfs-tools/modules
sudo update-initramfs -u
```
