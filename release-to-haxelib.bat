:: Create a folder named "release", and delete its contents if already exists:

mkdir release
rmdir /s /q release

:: Copy the following stuff to that folder - extraParams.hxml, CHANGELOG.md, LICENSE, README.md, haxelib.json, hxformat.json, and src folder:

xcopy /s /e /q src release
xcopy /s /e /q extraParams.hxml release
xcopy /s /e /q CHANGELOG.md release
xcopy /s /e /q LICENSE release
xcopy /s /e /q README.md release
xcopy /s /e /q haxelib.json release
xcopy /s /e /q hxformat.json release

:: Now move to the release folder:

cd release

:: and haxelib submit from there:

haxelib submit .
