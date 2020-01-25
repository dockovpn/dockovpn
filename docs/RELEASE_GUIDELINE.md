## Release Guideline

In oder to make release the following steps are required

1. Update APP_VERSION in Dockerfile

2. Update MAJOR_VERSION and MINOR_VERSION in build_release.sh

3. Commit all changes to `releases` branch

4. Go to project's GitHub page

5. Navigate to "releases" menu

6. Press "Draft a new release"

7. In the "Tag version" field enter release full version in the following format:
   `v{major_version}.{minor_version}.{patch version}`.

8. In the "Describe this rlease" field enter chenglelog in the following format:<br>
   >**Dockovpn v1.1.0**
   - Feature 1
   - Feature 2
   - Feature 3

9. Press "Publish release"

10. Login to `hub.docker.com` and make sure the automated build was triggered

11. After automated build on `hub.docker.com` done, login to `cicd.dockovpn.io` and pull the newest version of
