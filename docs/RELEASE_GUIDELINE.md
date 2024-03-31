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
8. Switch to `releases` branch
   ```shell
   git checkout releases
   ```
9. Checkout lastest revision of `releases` branch
   ```shell
   git pull
   ```
   or
   ```shell
   git reset --hard origin/releases
   ```
10. Merge `release-x.y.z` branch you created earlier into `releases` branch
11. Push `releases` to `origin`
12. Go to project's GitHub page
13. Navigate to "releases" menu
14. Press "Draft a new release"
15. Select `releases` branch to draft a new release from
16. In the "Tag version" field enter release full version in the following format:
   `v{major_version}.{minor_version}.{patch version}`.
17. In the "Describe this rlease" field enter chenglelog in the following format:<br>
   >**Dockovpn v1.1.0**
   - Feature 1
   - Feature 2
   - ...
   - Feature n
18. Press "Publish release"
19. Login to `hub.docker.com` and make sure the automated build was triggered
20. After automated build on `hub.docker.com` done, create pull request to merge `releases` branch into `master`
