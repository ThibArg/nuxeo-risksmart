(Mainly using GitHub as backup)

## Build-Install

The easiest way is to install the ready-to-use Marketplace Package you can fin in the "Releases" section of this repository. You can then either:

* Install it from the Admin Center once connected to the server (Update Center > Local Packages > Upload a local package).
* Or from the command line on your server (see the `nuxeoctl` command line parameter in the documentation. Basically: `nuxeoctl mp-install /path/to/the/package.zip`)

Reminder: If you change the plug-in and want to re-install it, you must either change (increment) the version number, or previously uninstall the previous one on your server.

You can also build the plug-in and import its source in Eclipse:

Assuming [`maven`](http://maven.apache.org) (min. 3.2.1) is installed on your computer:

```
# Clone the GitHub repository
cd /path/to/where/you/want/to/clone/this/repository
git clone https://github.com/ThibArg/nuxeo-risksmart
# Compile
cd nuxeo-risksmart
mvn clean install
```

* The Marketplace Package is in `nuxeo-risksmart/nuxeo-risksmart-mp/target/`, its name is `nuxeo-risksmart-mp-{version}.jar`.
* The WebEngine plug-in is in `nuxeo-risksmart/nuxeo-risksmart-we/target/`, its name is `nuxeo-risksmart-we-{version}.jar`.
* The specific "MyCompleteTask" operation plug-in is in `nuxeo-risksmart/nuxeo-risksmart-utils/target/`, its name is `nuxeo-risksmart-utils-{version}.jar`.

If you want to import the source code in Eclipse, then after the first build, `mvn eclipse:eclipse`. Then, in Eclipse, choose "File" > "Import...", select "Existing Projects into Workspace" and import the projects of the WebEngine and the "Utils"