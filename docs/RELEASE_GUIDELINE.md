## Release Guideline

In oder to make release the following steps are required

1. Update version in `VERSION` file in the following format `v{major_version}.{minor_version}.{patch version}`

2. Commit all changes to `releases` branch

3. Go to project's GitHub page

4. Navigate to "releases" menu

5. Press "Draft a new release"

6. In the "Tag version" field enter release full version in the following format:
   `v{major_version}.{minor_version}.{patch version}`.

6. In the "Describe this rlease" field enter chenglelog in the following format:<br>
   >**Dockovpn v1.1.0**
   - Feature 1
   - Feature 2
   - Feature 3

8. Press "Publish release"

9. Login to `hub.docker.com` and make sure the automated build was triggered

10. After automated build on `hub.docker.com` done, login to `cicd.dockovpn.io` and pull the newest version of repo

11. Run ./build-release.sh