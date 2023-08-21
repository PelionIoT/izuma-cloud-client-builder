# izuma-cloud-client-builder

### Build container:

Go to project root and run:

```
./build.sh
```

### Usage:

```
docker run -e IZUMA_ACCESS_KEY=ak_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx -v ./local-creds:/auth -it izuma-cloud-client-builder
```

Pass in your [access key](https://developer.izumanetworks.com/docs/device-management/current/user-account/application-access-keys.html) in the env var `IZUMA_ACCESS_KEY`

Pass in your `mbed_cloud_dev_credentials.c` by placing them in a local folder passed to the container as `/auth`

### Running a build

In the container, from `/builder` run:

```
./use-builder.sh windriver-aarch64
```

you will have a pronpt like:

```
[windriver-aarch64]root@1aa3bd3ecb59:
```

Do

```
[windriver-aarch64]root@1aa3bd3ecb59: bash build-mbed-cloud-client.sh
```

This will attempt to build the mbed-cloud-client example

