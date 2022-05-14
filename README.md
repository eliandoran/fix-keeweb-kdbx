# Fix .KDBX files which are can be opened in KeeWeb, but not in KeePassXC

In some circumstances, KeePass databases created with KeeWeb will not open in KeePassXC due to the errors such as:

```
Invalid EnableSearching value
```

This is a tool to "repair" the .kdbx created by KeeWeb so that it can be opened in KeePassXC.

## :warning: Disclaimer

> This tool is operating on your sensitive data such (e.g. your passwords). The author assumes no liability for any data loss that might result from using this script. Make sure to personally review the contents of the scripts you are running, to ensure that none of your data is at risk.

To view the source code of this script, go to the following URL: https://github.com/eliandoran/fix-keeweb-kdbx/blob/master/recover.sh

If you have any question or concerns regarding the implementation of the script, feel free to [open an issue](#reporting-issues).

## Prerequisites

The "KeepassXC CLI" is required for parsing the .xml file of the "bad" database and creating a fresh .kdbx file. Without it, the tool will not work. If you are using Linux, it should already be available via your KeePassXC installation.

To test if the tool is available, type the following command in your favourite terminal:

```
keepassxc-cli
````

Running this command should output some information about the KeepassXC CLI. If you get `command not found` or similar errors, it means that it is not available.

## Running the tool

First, clone the repository and make the script executable. This should only be done once.

```
git clone https://github.com/eliandoran/fix-keeweb-kdbx.git
cd fix-keeweb-kdbx
chmod +x recover.sh
```

Afterwards, the tool can simply be run via:
```
./recover.sh
```

## Using the tool

### Step 1. Start the tool

Because there are multiple versions of KeePass databases, as well as differing encryption algorithms, it is outside the scope of the tool to actually decrypt the databases. For that, we are going to use KeeWeb itself.

The downside is that the password database has to be exported as an .xml file. The .XML file is the raw contents of the database, without any encryption. So it must be stored somewhere safe because your passwords are exposed in plain-text. 

When the tool is first started, it will create a temporary directory for you to export the database from KeeWeb. Under most Linux systems, this directory is created under `/tmp`, which is not saved to disk, but is kept in RAM. This means that the decrypted passwords are safer since they will not be persisted after a reboot. The tool makes sure the temporary directory is removed after it is run, to protect your data.


Run the tool by going to the directory where you cloned the repository. Open a terminal in that directory and run the following command:

```
./recovery.sh
```

You will be greeted by the following message:

```
In KeeWeb, go to the file settings and select "Save to...", then select "XML".
Save the XML to the following temporary directory: /tmp/tmp.Ds521R
Please don't save it anywhere else to avoid security issues. The XML files are not encrypted.
After placing all your exported XML files, press Enter to continue.
```

In this case, the `/tmp/tmp.Ds521R` is the path to the temporary directory. This will differ each time you run the tool. Note this path as it will be used in all the next steps. The directory should also be opened automatically for you in the file manager, if your system allows it.

### Step 2. Export the .kdbx file to .xml files

To decrypt the .kdbx and generate the .xml files:

1. Start KeeWeb and open the .kdbx file which generates errors in KeePassXC.
2. After opening the file, look for the file button in the bottom-left of the KeeWeb window. It should display the name of the life next to a "lock" icon. Press it to reveal the file settings.
3. A screen indicating the file settings will appear. Press "Save to..." to reveal the file export settings.
4. Pressing "Save to..." will display a list of supported file formats for exporting. Press the "XML" button.
5. A popup warning that the passwords will not be encrypted is shown. Press "Yes" to proceed.
6. In the save file dialog, make sure that the directory where the .xml file is saved is the temporary directory from step 1 (e.g. `/tmp/tmp.Ds521R`).
    * Saving the .xml file somewhere else is not recommended because the passwords will be saved unencrypted to your disks.
    * Make sure the file extension is `.xml`, otherwise the tool will be unable to find it.
    * Depending on your OS, you might be able to type the full path directly in the "Name" field (e.g. `/tmp/tmp.Ds521R/myfile.xml`).

If you have multiple .kdbx files, simply repeat the steps. In the end, you should have multiple .xml files in the temporary directory.

### Step 3. Fixing the files

After making sure that the .xml files were added to the temporary directory, go back to the terminal where the tool is run and press Enter. This will proceed to the next step.

Afterwards, the tool will open each `.xml` file and try to fix its errors. After the file is patched, it will try to export it back to `.kdbx` so that it can be opened in KeePassXC. The name of the resulting .kdbx is going to be the same as the .xml file, plus the right extension (e.g. `db.xml` becomes `db.xml.kdbx`).

At this point, the tool uses the KeePassXC CLI utility to export the .kdbx file. This means that you will have instant feedback to see if the file was successfully repaired. If you have errors at this step, please check the [Reporting issues](#reporting-issues) section.

For each file a `.kdbx` file will be created, and each file can be password protected. For this, you will have to enter a password at each of these prompts:

```
Exporting db.xml to KDBX: db.xml.kdbx
Enter password to encrypt database (optional):
```

### Step 4. Finishing up

If the previous step finished completely, you should get the following message:

```
The files have been successfully fixed. Move the KDBX files to somewhere safe and press ENTER.
The temporary directory '/tmp/tmp.wYFqr7' will be removed.
```

Using your file manager, copy/move the new `.kdbx` files in a directory of your choice. The unencrypted .xml files should already be removed at this point. Afterwards, go back to the tool and press Enter to close it. This will cause the temporary directory to be removed entirely.

## Reporting issues

If you get errors such as:

```
Invalid EnableAutoType value
Invalid EnableSearching value
Invalid number value
Invalid uuid value
````

Make sure to report them to the Issues section of the repository: https://github.com/eliandoran/fix-keeweb-kdbx/issues

Check if the issue has not already been reported. If it is a new issue, press the "New issue" button, write a short summary of the error and press "Submit new issue".

**Please make sure you are not submitting any sensitive information such as your .xml file, or any of your passwords**.