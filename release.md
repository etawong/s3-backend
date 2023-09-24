Releases with semantic-versioning
1. Install the semantic-release on your local environment:

 $ npm install --save-dev semantic-release
 $ npm install semantic-release @semantic-release/git @semantic-release/github -D
2. Create a config file (release.config.js) in the project with the contents below:

release.config.js
====================

module.exports = {
branches: "main",
repositoryUrl: "https://github.com/etawong/s3-backend.git",
plugins: [
  '@semantic-release/commit-analyzer',
  '@semantic-release/release-notes-generator',
  '@semantic-release/git',
  '@semantic-release/github']
 }
3. Add your project to the repo:

 git add .
4. Commit your project to the repo using conventional commits. Your commit messages should start with:

   fix:                  ......for a patch version
   feat:                 ......for a minor version
   BREAKING CHANGE:      .......for a major version
5. Add step in the CI workflow:

name: release workflow

on: [workflow_dispatch]

jobs:
  run-shell-command:
    permissions:
      contents: write
      issues: write
      pull-requests: write
   runs-on: ubuntu-latest
    steps:
     - name: checkout
       uses: actions/checkout@v3 # clone a repository
     - name: release
       run: npx semantic-release
       env:
         GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
Or use conditions like:
     name: release workflow
     on:
        [workflow_dispatch]

     - name: Create a release
       if: github.event_name == 'workflow_dispatch' && github.ref == 'refs/heads/main'
       run: npx semantic-release
       env:
         GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN}}
6. After the code is pushed to the repo, trigger this workflow manually to publish and create a release version.

- name: Create a release
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  run: npx semantic-release
  env:
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN}}
- name: Terraform apply
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
  run: terraform apply -auto-approve