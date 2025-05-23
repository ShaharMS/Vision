:: Create a folder named "release", and delete its contents if already exists:
rmdir /s /q release
mkdir release

:: Copy the following stuff to that folder - extraParams.hxml, CHANGELOG.md, LICENSE, README.md, haxelib.json, hxformat.json, and src folder:

copy "extraParams.hxml" "release\extraParams.hxml"
copy "CHANGELOG.md" "release\CHANGELOG.md"
copy "LICENSE" "release\LICENSE"
copy "README.md" "release\README.md"
copy "haxelib.json" "release\haxelib.json"
copy "hxformat.json" "release\hxformat.json"
robocopy "src" "release\src" /E

:: Now move to the release folder:

cd release

:: and haxelib submit from there:

haxelib submit .
