# CLAUDE.md - Ostrich Demo Scenarios Guidelines

## Overview

This repository (`ostrich-demo`) contains interactive demo and tutorial scenarios for the **Ostrich SDK** (source code located in `../ostrich-sdk`).

The scenarios are built in **Killercoda** format (`https://killercoda.com`), providing an interactive browser-based terminal environment where users can learn and experiment with Ostrich SDK features.

Official reference documentation: [https://killercoda.com/creators](https://killercoda.com/creators).  
Example scenarios: `../scenario-examples/`.

---

## Repository & Course Structure (`structure.json`)

Scenarios are organized into numbered subdirectories (e.g. `01-basic/`, `02-advanced/`).

To group scenarios into structured learning paths or control display order on Killercoda, a `structure.json` file can be placed at the root level:

```json
{
  "title": "Ostrich SDK Training",
  "description": "Learn to package, deploy, and manage workloads using Ostrich SDK",
  "items": [
    { "path": "01-basic" },
    { "path": "02-advanced", "title": "Advanced Osplate & Plugin Orchestration" }
  ]
}
```

> **Note:** When `structure.json` is present, Killercoda strictly includes only items listed in `items`.

---

## Scenario File Format Specification (`index.json`)

Each scenario directory contains an `index.json` manifest defining metadata, workflow steps, background/foreground scripts, assets, backend image, and UI layout:

```json
{
  "title": "Ostrich SDK - Basic Commands",
  "description": "Learn basic ost commands, registries, and osplates",
  "difficulty": "Beginner",
  "time": "10",
  "details": {
    "intro": {
      "text": "intro.md",
      "foreground": "foreground.sh",
      "background": "background.sh"
    },
    "steps": [
      {
        "title": "Simple commands",
        "text": "step1.md",
        "verify": "step1-verify.sh",
        "foreground": "step1-fg.sh"
      }
    ],
    "finish": {
      "text": "finish.md"
    },
    "assets": {
      "host01": [
        { "file": "secret/**", "target": "~/", "chmod": "+w" },
        { "file": "config/.bashrc", "target": "~/", "chmod": "+w" }
      ]
    }
  },
  "backend": {
    "imageid": "ubuntu"
  },
  "interface": {
    "layout": "terminal"
  }
}
```

### `index.json` Field Details

| Field | Type | Description |
| :--- | :--- | :--- |
| `title` | String | Scenario title shown on Killercoda |
| `description` | String | Short summary of the scenario's learning objectives |
| `difficulty` | String | (Optional) `"Beginner"`, `"Intermediate"`, or `"Advanced"` |
| `time` | String | (Optional) Estimated duration in minutes (e.g. `"10"`) |
| `details.intro` | Object | Entry screen config (`text`, optional `foreground`, optional `background`) |
| `details.steps` | Array | Ordered step list (`title`, `text`, optional `verify`, `foreground`, `background`) |
| `details.finish` | Object | (Optional) Conclusion screen (`text`, `foreground`, `background`) |
| `details.assets` | Object | Target host file mappings (`host01` array of source glob, destination target, and chmod) |
| `backend.imageid` | String | Target environment image (`ubuntu`, `ubuntu-4GB`, `kubernetes-kubeadm-1node`, `kubernetes-kubeadm-2node`) |
| `interface.layout` | String | (Optional) UI layout style (`terminal`, `ide` for Theia/VS Code, `editor-terminal`) |

---

## Provisioning & Verification Scripts

1. **Foreground Script (`foreground.sh`)**:
   - Runs visibly in the user's interactive terminal upon starting a step or intro screen.
   - Example: Preparing Python venv `/rockdemo/venv`, cloning `ostrich-sdk`, installing `requirements.txt`.

2. **Background Script (`background.sh`)**:
   - Runs asynchronously in the background during setup. Output logs are visible in the Killercoda Creator Debug Dashboard.

3. **Verification Script (`verify.sh`)**:
   - Triggered when the user clicks the "Check" or "Verify" button for a step.
   - Must return exit code `0` for success or non-zero for failure:
     ```bash
     #!/bin/bash
     # Verify that ost command or file output exists
     test -f /rockdemo/venv/bin/ost && exit 0 || exit 1
     ```

---

## Killercoda Markdown Interactive Syntax

Killercoda supports custom code block annotations for terminal interactivity:

| Syntax Annotation | Action / Behavior |
| :--- | :--- |
| `` `command` {{exec}} `` | Executes inline bash command in the terminal on click |
| ` ```bash ... ```{{exec}} ` | Executes multiline bash block in terminal on click |
| `` `command` {{exec interrupt}} `` | Sends `Ctrl+C` to terminate active process, then executes command |
| `` `snippet` {{copy}} `` | Adds explicit copy button for snippet |
| `` `snippet` {{}} `` | Disables click-to-copy on inline code block |

### Hints & Solution Accordions
Use HTML `<details>` accordions to embed executable hints and solutions:

```html
<details><summary>Tip</summary>

```bash
ost help
```{{exec}}

</details>

<details><summary>Solution</summary>

```bash
ost template list
```{{exec}}

</details>
```

---

## Asset Deployment & Security

Asset files inside scenario `assets/` subdirectories are transferred to target host locations based on `details.assets` rules.

```json
"assets": {
  "host01": [
    { "file": "secret/**", "target": "~/", "chmod": "+w" },
    { "file": "config/.bashrc", "target": "~/", "chmod": "+w" },
    { "file": "scripts/setup.sh", "target": "/usr/local/bin/", "chmod": "+x" }
  ]
}
```

> [!IMPORTANT]
> Any `secret` directory within scenario asset folders (e.g. `01-basic/assets/secret`, `*/assets/secret`, `**/secret`) is ignored by `.gitignore` to prevent committing sensitive tokens or credentials to git.

---

## Scenario Writing Best Practices for Ostrich SDK

1. **Ensure Interactivity**: Mark executable commands with `{{exec}}` or `{{exec interrupt}}`.
2. **Automated Verification**: Include `verify.sh` scripts for steps whenever validation is possible.
3. **Structured Progression**:
   - **Scenario 01 (Basic)**: Environment setup, `ost help`, `ost template list`, `ost registry list`.
   - **Scenario 02 (Osplates & Registries)**: Searching, pulling, and describing osplates from ghcr.io / Harbor.
   - **Scenario 03 (Plugins & Config)**: Defining `ostrich.yaml` plugins, overriding Jinja2 parameters (`[[` `]]`).
   - **Scenario 04 (Local Execution with `ostd`)**: Sandboxed container execution.
   - **Scenario 05 (Remote K8s Orchestration with `ostr`)**: SSH tunnel synchronization and remote task execution.
4. **Keep Manifests In Sync**: Ensure every file in a scenario folder is registered in `index.json`.
