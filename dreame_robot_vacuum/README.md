# Dreame Robot Vacuum Speach

Audio packs for your Dreame robot vacuum cleaner running [Valetudo](https://valetudo.cloud).

## `create_dreame_package.sh`

```
Create an voice pack for Dreame vacuum cleaners, given appropriately named .wav audio files.


USAGE:

 ./create_dreame_package.sh [input folder] [package name]


The vorbis-tools package or comparable providing the oggenc application is required.
```

For example, if your audio files are in the `./output` directory, run:
```
./create_dreame_package.sh output my-sound-pack
```

You will need to calculate the checksum of the created archive in order to upload to Valetudo.

You can do so with the `md5sum` utility, as follows:
```
md5sum my-sound-pack-16k.tar.gz

