#!/bin/bash

readonly NAME="liho"
readonly REPO_NAME="liho-docker-image-php-fpm"
readonly REPO="https://github.com/lehungio/$NAME"
readonly LIHO_PATH="/code"
readonly PUBLIC_PATH="/code/public_html"
readonly LOCALHOST="127.0.0.1"

helps() {
	case $1 in
		all|*) allhelps ;;
	esac
}

allhelps() {
cat <<EOF
Usage: ./help.sh COMMAND
[help|usage|build|init|up|down|restart|status|logs|ssh]
[Commands]
  build        Build docker service
  up or start  Run docker-compose as daemon (or up)
  down or stop Terminate all docker containers run by docker-compose (or down)
  restart      Restart docker-compose containers
  status       View docker containers status
  logs         View docker containers logs
  ssh          ssh cli
  open         open localhost test page
EOF
}

# Usage
usage() {
	echo "Usage:"
	echo "${0} [help|usage|build|init|up|down|restart|status|logs|ssh]"
}

# Docker compose build
build() {
	printf "param: 1:$1 2:$2\n"

	case $2 in
		plain) 
			docker-compose build --progress=plain 
			;;
		*)  docker-compose build ;;
	esac
}

# Docker compose up
start() {
	docker-compose up -d
}

# Docker compose down
stop() {
	docker-compose down
}

# Docker compose restart
restart() {
	docker-compose restart
}

# Docker compose status
status() {
	docker-compose ps
}

# Docker compose logs
logs() {
	printf "param: $2"

	case $2 in
		php-build|build)
			docker-compose logs php-build
		;;
		all|*)  docker-compose logs ;;
	esac
}

# ssh cli
dockerssh() {
	case $2 in
		php-build|build)
			docker-compose exec $2 /bin/bash
		;;
		*) docker-compose exec php /bin/bash ;;
	esac
}

# open test page
run_open() {
	case $2 in
		test)
			open http://$LOCALHOST:38086/test/index.html
		;;
		*)  open http://localhost:38086 ;;
	esac
}

case $1 in
	open) run_open ${1} ${2};;
	init) init ${2:-v2};;
	build) build ${1} ${2:-plain};;
	start|up) start ;;
	stop|down) stop ;;
	restart|reboot) restart ;;
	status|ps) status ;;
	logs) logs ${1} ${2:-all} ;;
	ssh) dockerssh ${1} ${2:-php} ;;
	*) helps ;;
esac
