# CLAUDE.md - Ostrich Demo Scenarios Guidelines

## Overview

This repository (`ostrich-demo`) contains interactive demo and tutorial scenarios for the **Ostrich SDK** (source code located in `../ostrich-sdk`).

The scenarios are built in **Killercoda** format (`https://killercoda.com`), providing an interactive browser-based terminal environment where users can learn and experiment with Ostrich SDK features.

Reference examples for all Killercoda features are available in `../scenario-examples/`.

---

## Scenario File Structure (Killercoda Format)

Each scenario is located in its own subfolder (e.g. `01-basic/`, `02-.../`). A complete Killercoda scenario consists of the following components within its folder:

- **`index.json`**: Scenario manifest defining structure and runtime setup:
  - `title` & `description`: Metadata displayed in the scenario hub.
  - `details.intro`: Entry screen object (`text`: `intro.md`, `foreground`: `foreground.sh`, `background`: `background.sh`).
  - `details.steps`: Ordered list of steps, each with `title`, `text` (markdown file), optional `verify` (shell script), `foreground`, and `background`.
  - `details.finish`: Optional finish step screen (`text`, `foreground`, `background`).
  - `details.assets`: Host file deployment mappings (e.g. `host01`).
  - `backend`: Target environment specification (e.g. `"imageid": "ubuntu"` or `"kubernetes-1node"`).

- **`intro.md`**: Welcome screen and ascii banner displayed when starting the environment.

- **`step1.md`, `step2.md`, ...**: Markdown step guides containing instructions, tips, and interactive command blocks.

- **`foreground.sh` / `background.sh`**: Provisioning scripts. `foreground.sh` runs visibly in the terminal on environment setup (e.g. cloning `ostrich-sdk`, preparing python venv `/rockdemo/venv`, installing `requirements.txt`). `background.sh` executes silently in the background.

- **`verify.sh`**: Verification script for a step. Must exit with return code `0` when conditions are satisfied, or non-zero when unfulfilled.

- **`assets/`**: Supplementary file assets deployed to target hosts during environment creation.

---

## Killercoda Markdown Extensions & Interactive Syntax

Killercoda supports special annotations attached to code blocks for interactive terminal execution:

| Syntax Annotation | Description |
| :--- | :--- |
| `` `command` {{exec}} `` | Runs inline bash command in the terminal on click |
| ` ```bash ... ```{{exec}} ` | Runs multiline bash code block in the terminal on click |
| `` `command` {{exec interrupt}} `` | Sends `Ctrl+C` to terminate any running process, then executes command |
| `` `text` {{copy}} `` | Displays explicit copy button for snippet |
| `` `text` {{}} `` | Disables automatic click-to-copy on inline code |

### Solutions & Hints (Details Accordion)
Use standard `<details>` blocks for tips and solutions:

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

## Asset Deployment (`index.json` `details.assets`)

Host asset files inside `assets/` are mapped in `index.json`:

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
> Any `secret` directory within scenario asset folders (e.g. `01-basic/assets/secret`, `*/assets/secret`, `**/secret`) is ignored by `.gitignore` to prevent committing sensitive tokens or passwords to git.


---

## Scenario Writing Guidelines & Standards

1. **Interactive Execution**: Always use `{{exec}}` or `{{exec interrupt}}` on code blocks intended for user execution.
2. **Step Verification**: Provide verification scripts (`verify.sh`) for steps wherever automated validation is feasible.
3. **Clear Progression**:
   - **Step 1**: Environment setup, Ostrich CLI overview (`ost help`, `ost template list`, `ost registry list`).
   - **Step 2**: Searching & pulling osplates from OCI registries (ghcr.io, harbor).
   - **Step 3**: Creating plugins (`ostrich.yaml`) and parameterizing configurations.
   - **Step 4**: Executing local deployments using `ostd`.
   - **Step 5**: Remote Kubernetes orchestration using `ostr`.
4. **Maintain `index.json`**: Ensure all steps, scripts, and asset mappings are registered in `index.json`.
