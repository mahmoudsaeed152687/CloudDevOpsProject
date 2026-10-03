# Ansible Jenkins Configuration

## Overview

Ansible is used to automate the configuration of the Jenkins EC2 instance.

The Ansible Controller runs on a separate EC2 instance and connects to the Jenkins server over SSH.

## Architecture

```text
Ansible Controller
        |
        | SSH / Ansible
        v
Jenkins EC2
```

## What Ansible Configures

The playbook installs and configures:

* Java 21
* Docker
* Jenkins
* Trivy

It also:

* Starts and enables Docker
* Starts and enables Jenkins
* Adds the Jenkins user to the Docker group
* Configures the Jenkins repository
* Configures the Trivy repository

## Files

### `jenkins-setup.yml`

Ansible playbook responsible for configuring the Jenkins server.

### `inventory.example`

Example inventory showing how the Jenkins server is defined.

The real inventory is not committed because it contains environment-specific information such as the Jenkins public IP and SSH private-key path.

## Running the Playbook

After creating the actual inventory file:

```bash
ansible-playbook -i inventory jenkins-setup.yml
```

## Verification

The configuration was verified using Ansible commands to confirm:

```text
Java 21     -> Installed
Jenkins     -> Active
Docker      -> Active
Trivy       -> Installed
Docker      -> Accessible by Jenkins user
```

The playbook was also executed a second time to verify idempotency.

Final result:

```text
ok=12
changed=0
failed=0
unreachable=0
```

This confirms that the second execution did not make unnecessary changes.
