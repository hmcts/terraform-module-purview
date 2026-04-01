# Legacy Terraform state (pre–module layout)

Before this repository was a **pure Terraform module**, it contained a root configuration that was applied from this repo. Remote state for that layout is keyed like other HMCTS stacks:

`UK South/hub/terraform-module-purview/prod/infrastructure/terraform.tfstate`

(Exact key matches `steps/terraform.yaml` in `cnp-azuredevops-libraries`: `location/product/buildRepoSuffix/environment/component/terraform.tfstate`.)

## Reference commit (from git history)

This SHA exists on `origin` for `hmcts/terraform-module-purview` (parent of `89cf064` / `feat: purview module init`). The pipeline YAML requests a full checkout (`fetchDepth: 0`), but Azure DevOps may still shallow-clone the triggering branch; the **Materialize legacy Terraform** step therefore runs `git fetch origin <legacyCommit>` before `git archive` so the tree is always present.

- **`712d2e2a07957845655d7858b85692f775f41b20`** — last tree **before** the module layout, suitable for `git archive` into `legacy/infrastructure/`.

If you use a shallow local clone, run `git fetch origin 712d2e2a07957845655d7858b85692f775f41b20` once. If history was rewritten on the remote, recover the commit from a backup mirror (for example a full clone under `../acompare/.git`).

## Local materialization (optional)

```bash
mkdir -p legacy/infrastructure
git archive 712d2e2a07957845655d7858b85692f775f41b20 | tar -xC legacy/infrastructure
```

## When not to use this

If live resources are now managed only from **`purview-azure-infrastructure`** with state under `.../purview-azure-infrastructure/...`, run **`terraform destroy`** from that repo’s pipeline (`overrideAction: destroy`) instead of this legacy pipeline.
