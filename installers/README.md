# Install wrapper-scripts

This is a collection of wrapper scripts to automate installation of external tools. 

To add an installation-script to the collection just add a folder for your tool (e.g. "MYTOOL") and place a file named 'install.sh' inside.
Following this convention allows for this syntax to easily install external tools:

    curl -sq https://raw.githubusercontent.com/searchmetrics/public_gists/master/installers/install.sh \
         | bash -s MYTOOL

The above will download the installer wrapper script and pipe it to bash where it in turn will try to download and execute the actuall installer.

## Tools available
Each subfolder holds the installer for one tool. Just use the folder-name as argument to the installer.

