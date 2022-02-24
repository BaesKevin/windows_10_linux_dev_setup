# GUI app support (x server)
 
Running Linux GUI apps on Windows requires installing an X server on Windows on pointing the WSL2 distro to this X server. These steps should not be necessary in Windows 11.

- install GWSL https://opticos.github.io/gwsl/tutorials/manual.html#installing-gwsl (see https://github.com/sirredbeard/Awesome-WSL#x-servers for alternatives)
- in case the 'auto-export display/video' feature doesn't work, add this to `~/.bashrc`
```
export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
export LIBGL_ALWAYS_INDIRECT=1
```

# Troubleshooting
 
## X window 'disappears'

Windows closes all TCP connections when a network change happens. This causes X connections to the X server on Windows to be dropped.
There is no way to 're-attach' an X client to the X server, only solution is to restart IDEA.
An actual workaround seems to use VSOCK, but seems to be more setup than I'm willing to do.
 
https://github.com/microsoft/WSL/issues/4675
https://github.com/nbdd0121/wsld and some insight in the cause of the issue https://github.com/nbdd0121/wsld/blob/master/docs/impl.md#x11-disconnection-problem
 
### Solution: gracefully kill process from the cli

Example: X disappears when IntelliJ is running

```
# list processes
ps -efH
# kill the child process of the terminal process where the application is running
# if you kill the terminal process, intellij itself doesn't actually close
kill $PID
```
 