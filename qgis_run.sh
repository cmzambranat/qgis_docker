xhost +
my_homedir=${HOME}
my_files_dir="$my_homedir/qgis38-files"
my_profile_dir="$my_homedir/.qgis38-docker"

echo "Files dir:$my_files_dir"
mkdir -p "$my_files_dir"

echo "Preferences dir:$my_profile_dir"
mkdir -p "$my_profile_dir"

#Copy profiles data only if not already in place.
cp -n -r data/qgis38-docker/.local $my_profile_dir/

docker run -ti  --rm \
	-e DISPLAY=$(ipconfig getifaddr en0):0 \
	-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
	-v $my_homedir:/mnt/ext_home/ \
	-v $my_files_dir:/root/qgis38-files \
	-v $my_profile_dir:/root/ \
	cmzambranat/qgis:latest
