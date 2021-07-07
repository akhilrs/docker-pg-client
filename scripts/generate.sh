#!/bin/sh

set -e

display_help() {
    echo "Usage: $0 [options...]" >&2
    echo
    echo "   -p, --platforms     set target platform for build."
    echo "   -h, --help          show this help text"
    echo
    exit 1
}


for i in "$@"
do
case $i in
    -p=*|--platforms=*)
    PLATFORMS="${i#*=}"
    shift
    ;;
    -h | --help)
    display_help
    exit 0
    ;;
    *)
    display_help
    exit 0
    # unknown option
    ;;
esac
done

DOCKER_BAKE_FILE=${1:-"docker-bake.hcl"}
TAGS=${TAGS:-"latest 3.13 3.12"}
PLATFORMS=${PLATFORMS:-"linux/amd64 linux/arm64"}
IMAGE_NAME=${IMAGE_NAME:-"akhilrs/pg-client"}


cd "$(dirname "$0")"

MAIN_TAG=${TAGS%%" "*} # First tag
TAGS_EXTRA=${TAGS#*" "} # Rest of tags
P="\"$(echo $PLATFORMS | sed 's/ /", "/g')\""

T="\"latest\", \"$(echo $TAGS_EXTRA | sed 's/ /", "/g')\""

cat > "../$DOCKER_BAKE_FILE" << EOF
group "default" {
	targets = [$T]
}
target "common" {
	platforms = [$P]
}

target "latest" {
	inherits = ["common"]
	args = {"BASETAG" = "$MAIN_TAG"}
	tags = [
		"$IMAGE_NAME:$MAIN_TAG"
	]
}
EOF

for TAG in $TAGS_EXTRA; do cat >> "../$DOCKER_BAKE_FILE" << EOF
target "$TAG" {
	inherits = ["common"]
	args = {"BASETAG" = "$TAG"}
	tags = [
		"$IMAGE_NAME:$TAG"
	]
}
EOF
done