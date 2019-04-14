# Windows Commands

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

## File inside Picture

Will put a file inside an image.

* Put the files inside an archive (rar or zip)

```cmd
copy /b input.jpg+input.rar=output.jpg
copy /b input.jpg+input.zip=output.jpg
```

Rename `output.jpg` to either `output.rar` or `output.zip`
and unpack to get original file.

Note even if the original input archive is `rar`, try `zip`
to see if it works.