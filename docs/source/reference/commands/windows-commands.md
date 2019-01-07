# Windows Commands

*Last Update: 12/19/2018.*

## Make Junctions

```cmd
mklink /J [link] [target]
```

## Create .cmd Files

Put the following in a '.cmd' file:

```cmd
cmd.exe /C C:\Python27\python.exe "C:\path\to\some\python\script" %*"
```

## Refresh Environment Variables

I always forget this one.

But it seems that it will break something unexpectedly.

```cmd
refreshenv
```

## Open Folders

Run the following case-insensitive "names" directly in `Run` (press Win+R) 

```cmd
shell:RecycleBinFolder
shell:startup
```