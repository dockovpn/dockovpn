## Release Guideline

In oder to make release the following steps are required

1. Switch to `master` branch
   ```shell
   git checkout master
   ```
2. Checkout lastest revision of `master` branch
   ```shell
   git pull
   ```
   or
   ```shell
   git reset --hard origin/master
   ```
3. Create `release-x.y.z` branch, where x - major release version, y - minor version and z - patch version
   ```shell
   git checkout -b release-x.y.z
   ```
4. Update `VERSION` file
5. Update `CHANGELOG.md` file
6. Make commit with message `Preparing release x.y.z`, where x - major release version, y - minor version and z - patch version
7. Push `release-x.y.z` to `origin`
8. Go to project's GitHub page
9. Navigate to "releases" menu
10. Press "Draft a new release"
11. In the "Tag version" field enter release full version in the following format:
   `v{major_version}.{minor_version}.{patch version}`.
12. In the "Describe this rlease" field enter chenglelog in the following format:<br>
   >**Dockovpn v1.1.0**
   - Feature 1
   - Feature 2
   - ...
   - Feature n
13. Press "Publish release"
14. Login to `hub.docker.com` and make sure the automated build was triggered
15. After automated build on `hub.docker.com` done, login to `cicd.dockovpn.io` and pull the newest version of repo

11. Run ./build-release.sh
