#!/bin/bash
# references:
# https://docs.docker.com/engine/install/debian/
# https://www.freedesktop.org/software/systemd/man/os-release.html

PORT="3306"
IP="127.0.0.1"
IMAGE_VERSION="8.0.25"
DOCKER_NAME="node-mysql-api"
MYSQL_ROOT_PASSWORD="$SUDO_USER"

success(){
	echo -e "[\e[32mÉXITO\e[0m]    $@"
}

info(){
	echo -e "[\e[36mINFO\e[0m]     $@"
}

failed(){
	echo -e "[\e[31mFALLIDO\e[0m]  $@" >&2
	exit 1
}

add_gpg_docker(){
	info "Importando clave pgp de Docker"
	wget -qO- https://download.docker.com/linux/ubuntu/gpg | \
		gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/docker-keyring.gpg

	if [ $? -eq 0  ]; then
		success "Clave importada en /etc/apt/trusted.gpg.d/docker-keyring.gpg"
	else
		failed "Clava no importada"
	fi
}

add_repo_docker(){
	local DISTRO=$(grep -oP "(?<=^ID=).*" /etc/os-release)
	local VERSION=$(grep -oP "(?<=VERSION_CODENAME=).*" /etc/os-release)

	info "Importando repositiorio de Docker"

	if [[ ! "$DISTRO" =~ ^(ubuntu|debian)$ ]]; then
		DISTRO=$(grep -oP "(?<=^ID_LIKE=).*" /etc/os-release)
		VERSION=$(grep -oP "(?<=${DISTRO^^}_CODENAME=).*" /etc/os-release)
	fi

	if [[ "$DISTRO" =~ ^(ubuntu|debian)$ ]] && [ "$VERSION" != "" ]; then
		tee /etc/apt/sources.list.d/docker.list >/dev/null <<-EOF
		#Repositorio añadido por Salvador Real (node-mysql-api)
		deb [arch=amd64] https://download.docker.com/linux/$DISTRO $VERSION stable
		EOF
		if [ $? -eq 0  ]; then
			success "Repositorio importado en /etc/apt/sources.list.d/docker.list"
		else
			failed "Repositorio no importado"
		fi
	else
		local NAME=$(grep -oP "(?<=^PRETTY_NAME=).*" /etc/os-release)
		failed "Tu distribución $NAME no es compatible con este script\nDebes de instalar docker manualmente y luego volver a ejecutar este script para importar la imagen mysql"
	fi
}

install_docker(){
	info "Instalando Docker"

	if ! command -v docker &> /dev/null; then
		add_gpg_docker
		add_repo_docker
		apt update && apt install -y docker-ce docker-ce-cli containerd.io
		if [ $? -eq 0  ]; then
			success "Docker instalado"
			closeSession=1
		else
			failed "Docker no instalado"
		fi
	else
		success "Docker ya se encuentra instalado: $(docker -v)"
	fi

	usermod -aG docker $SUDO_USER
}

import_mysql_image(){
	info "Importando imagen mysql"
	local IMAGE_ID=$(docker image list --filter=reference=mysql:$IMAGE_VERSION --quiet)
	if [ "$IMAGE_ID" == ""  ]; then
		docker pull mysql:$VERSION && success "Imagen importada" || failed "Imagen no importada"
	else
		success "Imagen ya se encuentra importada: mysql:$IMAGE_VERSION id=$IMAGE_ID"
	fi
}

start_mysql(){
	info "Iniciando servicio mysql (docker: $DOCKER_NAME)"
	local CONTAINER_ID=$(docker ps --all --filter=name="^/$DOCKER_NAME$" --quiet)
	if [ "$CONTAINER_ID" == "" ]; then
		docker run --name "$DOCKER_NAME" --restart unless-stopped \
			--env MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
			--publish "${IP}:${PORT}:3306" --detach mysql:$IMAGE_VERSION >/dev/null && \
			success "Serivicio iniciado" || \
			failed "Serivicio no iniciado"
	else
		local STATE=$(docker ps --all --filter=name="^/$DOCKER_NAME$" --format={{.State}})
		if [ "$STATE" != "running" ]; then
			docker start "$DOCKER_NAME" >/dev/null && \
				success "Serivicio iniciando" ||
				failed "Serivicio no iniciado"
		else
			success "El servicio ya se encuentra iniciado id:$CONTAINER_ID"
		fi
	fi
}

update_npm(){
	info "Actualizando npm"
	npm install --global npm
	npm completion | tee /usr/share/bash-completion/completions/npm >/dev/null
}

install_node(){
	info "Instalando Nodejs"
	if ! command -v node &> /dev/null; then
		wget -q https://install-node.vercel.app/lts -O install-node && chmod +x install-node
		./install-node -y
		if [ $? -eq 0  ]; then
			success "Nodejs instalado"
			update_npm
		else
			failed "Nodejs no instalado"
		fi
		rm -f install-node
	else
		success "Nodejs ya se encuentra instalado: node $(node -v)"
	fi
}

build_project(){
	install_node
	install_docker

	import_mysql_image
	start_mysql

	success "\e[5mBuild exitoso!"
	if [ -n "$closeSession" ]; then
		info "Se necesita cerrar sesión para recargar permisos\nGuarde todos sus achivos antes de cerra sesión"

		local timeout=60
		local resp
		local tout=1
		local start=$(date +%s%N)
		local end

		while [ "$timeout" -gt 0 ]; do

			echo -ne " <- s/n ¿Desea cerrar sesión ahora? (n=${timeout}s)\r"
			read -r -s -n 1 -t "$tout" resp

			if [ $? -gt 128 ] ; then
				start=$(date +%s%N)
				((timeout--))
				tout=1
			else
				end=$(date +%s%N)
				tout=$(bc <<< "scale=2; 1 - ($end-$start)/1000000000")
			fi

			if [[ "$resp" =~ n|N ]]; then
				info "Debe de cerrar sesión para empezar a hacer el proyecto"
				break
			fi

			if [[ "$resp" =~ s|S|y|Y ]]; then
				systemctl restart display-manager || pkill Xorg
			fi

			if [ ! "$timeout" -gt 0 ]; then
				info "Acción cancelada por tiempo agotado.\nDebe de cerrar sesión para empezar a hacer el proyecto."
			fi
		done
	fi
}

[ "$EUID" -ne 0 ] && failed "Permisos root son requeridos.\nsudo $0"

[ "$SUDO_USER" == "" ] && failed "No se detecto el usuario para instalación."

build_project
