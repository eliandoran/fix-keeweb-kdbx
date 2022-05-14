# How the tool works

## Why .xml files instead of .xdbx

* The KeePassXC CLI cannot open or import the .kdb files due to the very errors this tool is trying to fix.
* The KDBX format can have different encryption algorithms, some of which are not directly supported by CLI tools.
* Initially the tool was to be made in Node.js and to use the [kdbxweb](https://www.npmjs.com/package/kdbxweb) library. But it did not provide out of the box support for Argon2 and it would have made the tool harder to use for people (since it would require installing the Node.js environment).

## What is being fixed?

At the moment, the tool attempts to fix the following issues:

### Invalid self-closing elements

The main reason the files cannot be opened in KeePassDX are the following error messages:

* `Invalid EnableSearching value`
* `Invalid EnableAutoType value`
* `Invalid number value`

The cause of that is that some KeeWeb versions save some elements which are self-closing, thus containing no information that is relevant for KeePassDX.

The KeeWeb parser is more error-tolerant, so that is the reason why they can be opened successfully.

One example would be:

```xml
<EnableSearching/>
```

The `EnableSearching` tag should contain a value which can be `true`, `false`, or `null`. Any other value (or no value) will faill with `Invalid EnableSearching value`.

At this time, the tool will remove the following elements which are self-closing and provide no actual value:

At "group" level:
* `EnableSearching`
* `EnableAutoType`

At "meta" level:

* `MaintenanceHistoryDays`
* `MasterKeyChanged`
* `MasterKeyChangeRec`
* `MasterKeyChangeForce`
