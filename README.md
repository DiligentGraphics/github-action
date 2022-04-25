# github-action

Custom actions used by the Diligent Engine CI

## checkout

Checks out the specified module and its required dependent modules.

Example:

```yml
steps:
- name: Checkout
    uses: DiligentGraphics/github-action/checkout@master
    with:
      module: Tools # Optional; by default, current module is checked out
```
