# Basic ost commands

## Install Ostrich docker CLI ostd

The only requirement is to have Docker installed.

```bash
TOKEN=$(cat /root/secret/github.txt)
ASSET_URL=$(curl -sH "Authorization: token $TOKEN" https://api.github.com/repos/rockops/ostrich-sdk/releases/tags/v0.2.5 | jq -r '.assets[] | select(.name=="ostd-linux-amd64") | .url')
curl -sH "Authorization: token $TOKEN" -H "Accept: application/octet-stream" -L -o /usr/local/bin/ostd "$ASSET_URL"
chmod +x /usr/local/bin/ostd
TOKEN=$(cat /root/secret/github_read_osplates.txt)
docker login ghcr.io -u rockops -p $TOKEN
```{{exec}}

## Help command

The `ostd` CLI is the dockerized CLI Ostrich SDK.

Get general help and list main operations for the `ostd` command:

```bash
ostd help
```{{exec}}

---

## 1. Registry Management (`ost registry`)

Templates (**osplates**) are hosted in **OCI registries**. You can manage configured registries, authenticate, and search for published templates.

### List configured registries

Display all currently configured registries:

```bash
ostd registry list
```{{exec}}

The default **`ostrich`** registry (`ghcr.io/rockops/osplate`) is pre-configured and contains generic templates.

> **Supported Registries:** Ostrich SDK supports any OCI-compliant registry. Search functionality is natively optimized for:<br/>
> - **ghcr.io** (GitHub Container Registry)<br/>
> - **Harbor** (Self-hosted private registry)<br/>

You can register additional OCI registries to pull osplates from (this is in a next demo).


---

## 2. Template Management (`ost template`)

Every deployment use case in Ostrich SDK is handled by a **template** (also called an **osplate**).

### List installed templates

Display locally installed templates:

```bash
TOKEN=$(cat /root/secret/github_read_osplates.txt)
ostd registry login ostrich -u rockops -p $TOKEN
ostd template list
```{{exec}}

*(Note: Initially, no custom templates are installed locally.)*

### Search for available templates in registries

Search configured OCI registries for published osplates:

```bash
ostd template search
```{{exec}}

This command lists the templates avaibale in the configured registries.
At the moment only the official "ostrich" registry is configured, which contains generic templates.

### Install a template

To install the *hello* template from the *ostrich* registry:

```bash
ostd template install ostrich/hello
```{{exec}}

List the installed templates again

```bash
ostd template list
```{{exec}}

### Print the description of an installed osplate

The osplate is auto documented. Print the description of the installed osplate:

```bash
ostd template describe hello
```{{exec}}

### Generate a sample config file

To bootstrap a config file you can use the following command:

```bash
mkdir -p /root/hello-test
cd /root/hello-test
ostd template config hello > ostrich.yaml
chmod 777 ostrich.yaml
```{{exec}}

This will produce a sample config file for this osplate. It contains all the default values that you can modify.

Check the generated config:

```bash
cat ostrich.yaml
```{{exec}}

or open the file in a new tab:

```text
/root/hello-test/ostrich.yaml
```{{open}}

### Configuration Structure Explanation:

The `ostrich.yaml` file above represents a **plugin descriptor**. It defines the configuration for a plugin that the Ostrich SDK will execute. Here's a breakdown of its structure and how it relates to osplates:

The **plugin** section is common to all osplates. It describes what you want to build (your own stuff). 

<ul>
<li> **`plugin`**: Defines the metadata for your plugin:</li>
<ul>
  <li>`name`: Unique identifier for your plugin instance (`simple-test`).</li>
  <li>`version`: Version string of the plugin (`0.0.1`).</li>
  <li>`business_name`: Human-readable label or description of the plugin.</li>
</ul>
</ul>

The **template** section is specific to the osplate you are using. It describes how to build your stuff.

<ul>
<li>**`template`**: Defines the osplate execution settings:</li>
<ul>
  <li>`kind`: Specifies the osplate template type (`hello`): the osplate name.</li>
  <li>`params`: Custom key-value variables passed to template tasks (such as `message`).</li>
</ul>
</ul>

### Execute a task

To run a task defined in the osplate you can use the following command:

```bash
ostd run sayhello
```{{exec}}

This will execute the *sayhello* task

You can check that the message in **template.params.message** is printed.


#### Modify the config file

Open the file in another tab, then save your modification and go back to the tab demo to execute the task again:

```text
/root/hello-test/ostrich.yaml
```{{open}}

Now run the task again, and check that the message has changed:

```bash
ostd run sayhello
```{{exec}}

#### Execute in debug mode

You can also execute in DEBUG mode. In this mode, you will see more information about the execution of the task, as well as debug messages explicitly printed by the osplate itself. Run this command to see the difference (add -d or --debug flag):

```bash
ostd -d run sayhello
```{{exec}}



