# Basic ost commands

## Help command

The ost script has been installed in /rockdemo/ostrich-sdk/ost-core.


Get help for the ost command:

```bash
ost help
```

## List available templates

The Ostrich SDK is a versatile tool. It allows do execute almose any task, for any technilogy.  

Every use case be handled by a **template**, aka. a **ostplate**.  

You can display the available osplate:

```bash
ost template list
```

As you can see, no template is installed at this time.

## Check the available registries

The templates can be installed from an **ostrich registry**. List the avaibale registries:

```bash
ost registry list
```

The **ostrich** registry is available by default. It contains some generic templates, suitable for testing.  

**Note:** A Ostrich registry is a OCI registry. Any OCI registry can be used to handle osplates. However, to be able to search a osplate in a registry, the following platforms are fully supported:
- ghcr.io (GitHub registry) for public or repositories (authentication is supported)
- harbor for private, self hosted repositories

You can use any other docker registry (like docker.io), but the search functionnality will be less accurate and is not guaranteed to work.

### List the osplates in a registry

To list the os



