#!/bin/bash
# Examples: 
#   ./composer.sh install
#   ./composer.sh require drupal/imce

CURRENT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
COMPOSER_CACHE_DIR="/var/cache/composer"
CURRENT_USER_UID=$(id -u)
CURRENT_USER_GID=$(id -g)

. $CURRENT_DIR/.common_func

check_env_file

[ -d "$COMPOSER_CACHE_DIR" ] || sudo mkdir -p $COMPOSER_CACHE_DIR

sudo chown -R $CURRENT_USER_UID:$CURRENT_USER_GID $COMPOSER_CACHE_DIR

# Check if runing in tty
is_tty="" && [ -t 1 ] && is_tty="-t"

docker run --rm -i ${is_tty} \
    --volume "$CURRENT_DIR/../../$COMPOSER_FOLDER_PATH":/app \
    --volume "$CURRENT_DIR/composer-docker-entrypoint-hack.sh":/docker-entrypoint.sh \
    --volume "$COMPOSER_CACHE_DIR":/tmp \
    --user $CURRENT_USER_UID:$CURRENT_USER_GID \
    ciandtchina/composer-drupal:alpine "$@"
