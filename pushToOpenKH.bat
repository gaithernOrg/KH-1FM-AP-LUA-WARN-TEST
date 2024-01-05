rem pushes each file to the openKH directory, so you can work in the repo
rem but still can test it right away

cd %~dp0
set openKH= "E:\Games\Epic\Kingdom Hearts Mods\KH2\KH2_Randomizer\OpenKH.Mod.Manager\mod\kh1\scripts\"

for %%f in (*.lua) do (
    copy "%%f" %openKH%%%f
)
