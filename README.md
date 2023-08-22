# izuma-cloud-client-builder

### Build container:

Go to project root and run:

```
./build.sh
```

### Usage:

```
docker run -v /tmp:/out -it izuma-cloud-client-builder 
```

Pass in a volume for `/out` to place finished binaries.

### Running a build

In the container, from `/builder` run:

```
./use-builder.sh windriver-aarch64
```

you will have a prompt like:

```
[windriver-aarch64]root@1aa3bd3ecb59:
```

Do

```
[windriver-aarch64]root@1aa3bd3ecb59: bash build-mbed-cloud-client.sh
```

This will attempt to build the mbed-cloud-client example

#### Output

Output is placed in /out in the container.

```
[windriver-aarch64]root@207e5d4217c7:/builder/windriver-aarch64# ls -al /out
total 12
drwxr-xr-x 3 root   root   4096 Aug 22 16:56 .
drwxrwxr-x 6 ubuntu ubuntu 4096 Aug 22 16:46 ..
drwxr-xr-x 3 root   root   4096 Aug 22 16:51 Release-aarch64

As long as you used a volume mount you can grab it outside the container. 

#### Options

Use `-e IZUMA_USE_CORES=n` to use `n` number of cores for cmake, which can speed up build dramatically. Default is `8`