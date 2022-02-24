# Setup intellij IDEA

## Install IDEA
IntelliJ doesn't seem to publish to a repository, so need to download, extract and symlink.

```
wget https://download.jetbrains.com/idea/ideaIU-2021.3.2.tar.gz
tar -xf ideaIU-2021.3.2.tar.gz
# mv to /opt 
sudo ln -s /opt/idea-IU-213.6777.52/bin/idea.sh /usr/local/bin/idea
```

running `idea` should now start intellij
 
NOTE: IntelliJ will complain about shared license usage if you run IDEA on Windows and Ubuntu at the same time, and force shut one instance

 ## Install a browser

 To see test reports etc, you need to install a browser as well, i.e. `sudo apt install firefox`

## Missing dependencies error on startup
 
popup that states you miss dependencies makes it so you can't open READMEs
https://intellij-support.jetbrains.com/hc/en-us/articles/360016421559
 
`ldd /opt/idea-IU-213.6777.52/jbr/lib/libcef.so | grep "not found"`
 
For each missing dep, search it via `apt search` (or install synaptic), if you get a hit, `sudo apt install` it. For me it was the following 2: `libnss3` and `libgbm1`.
 