# Intro

This repo documents a setup to move all development work with IntelliJ IDEA on Windows to WSL 2. 
This setup allows you to run the IDE in WSL 2, allong with any other Linux utilities or applications you need. 
The only development tool I still run on the Windows side is Docker (which uses the WSL 2 backend).

Notable things to set up (in order), see `docs`:
* `gui_apps.md`: install an X server
* `intellij_idea.md`: install IntelliJ 
* `networking.md`: make it so http services running on Ubuntu can be accessed with localhost from Windows


I documented the setup and scripts for in case I need to do it again, these may be useful to other people trying to achieve something similar.

## Why?

I wanted to see if using Linux would improve my dev experience as I've always worked on Windows. I'm used to Windows, and don't want the burden of maintaining a full Linux desktop install. Mac is also not an option since I can't use it for everything.
Windows 10 already has support for Linux CLI tools with WSL 2, and Windows 11 has [support for running Linux GUI apps](https://github.com/microsoft/wslg#welcome-to-wslg).
I'm not on Windows 11 yet, so I set up Linux GUI app support on Windows 10 to be able to do all my development on Linux on Windows. 
Also included some PowerShell utilities I wrote/stole from other places to teach myself some PowerShell scripting.

I'm currently using this setup full time, and it feels like an improvement, but I don't have numbers to prove it.