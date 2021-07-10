#!/bin/bash
# references:
# https://docs.docker.com/engine/install/debian/
# https://www.freedesktop.org/software/systemd/man/os-release.html

PORT="3306"
IP="127.0.0.1"
IMAGE_VERSION="8.0.25"
DOCKER_NAME="node-mysql-api"
MYSQL_ROOT_PASSWORD="$SUDO_USER"

c0=$'\e[1;30m'
c1=$'\e[1;31m'
c2=$'\e[1;32m'
c3=$'\e[1;33m'
c4=$'\e[1;34m'
c5=$'\e[1;35m'
c6=$'\e[1;36m'
n=$'\e[0m'  # normal
b=$'\e[1m'  # bold
d=$'\e[2m'  # dim
i=$'\e[3m'  # italic
u=$'\e[4m'  # underlined
bl=$'\e[5m' # blinking
export GREP_COLORS='ms=01;31'

success() {
	echo -e "[${c2}ÉXITO${n}]    $@"
}

info() {
	echo -e "[${c6}INFO${n}]     $@"
}

failed() {
	echo -e "[${c1}FALLIDO${n}]  $@" >&2
	exit 1
}

add_gpg_docker() {
	info "Importando clave pgp de Docker"
	wget -qO- https://download.docker.com/linux/ubuntu/gpg |
		gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/docker-keyring.gpg

	if [ $? -eq 0 ]; then
		success "Clave importada en /etc/apt/trusted.gpg.d/docker-keyring.gpg"
	else
		failed "Clava no importada"
	fi
}

add_repo_docker() {
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
		if [ $? -eq 0 ]; then
			success "Repositorio importado en /etc/apt/sources.list.d/docker.list"
		else
			failed "Repositorio no importado"
		fi
	else
		local NAME=$(grep -oP "(?<=^PRETTY_NAME=).*" /etc/os-release)
		failed "Tu distribución $NAME no es compatible con este script\nDebes de instalar docker manualmente y luego volver a ejecutar este script para importar la imagen mysql"
	fi
}

install_docker() {
	info "Instalando Docker"

	if ! command -v docker &>/dev/null; then
		add_gpg_docker
		add_repo_docker
		apt update && apt install -y docker-ce docker-ce-cli containerd.io
		if [ $? -eq 0 ]; then
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

import_mysql_image() {
	info "Importando imagen mysql"
	local IMAGE_ID=$(docker image list --filter=reference=mysql:$IMAGE_VERSION --quiet)
	if [ "$IMAGE_ID" == "" ]; then
		docker pull mysql:$IMAGE_VERSION && success "Imagen importada" || failed "Imagen no importada"
	else
		success "Imagen ya se encuentra importada: mysql:$IMAGE_VERSION id=$IMAGE_ID"
	fi
}

start_mysql() {
	info "Iniciando servicio mysql (docker: $DOCKER_NAME)"
	local CONTAINER_ID=$(docker ps --all --filter=name="^/$DOCKER_NAME$" --quiet)
	if [ "$CONTAINER_ID" == "" ]; then
		if check_mysql_process; then
			docker run --name "$DOCKER_NAME" --restart unless-stopped \
				--env MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
				--publish "${IP}:${PORT}:3306" --detach mysql:$IMAGE_VERSION \
				>/dev/null

			if [ $? -eq 0 ]; then
				success "Serivicio iniciado"
			else
				docker rm -f "$DOCKER_NAME" >/dev/null
				failed "Serivicio no iniciado"
			fi

		else
			clear_current_row
		fi
	else
		local STATE=$(docker ps --all --filter=name="^/$DOCKER_NAME$" --format={{.State}})
		if [ "$STATE" != "running" ]; then
			docker start "$DOCKER_NAME" >/dev/null &&
				success "Serivicio iniciando" ||
				failed "Serivicio no iniciado"
		else
			success "El servicio ya se encuentra iniciado id:$CONTAINER_ID"
		fi
	fi
}

update_npm() {
	info "Actualizando npm"
	npm install --global npm
	npm completion | tee /usr/share/bash-completion/completions/npm >/dev/null
}

install_node() {
	info "Instalando Nodejs"
	if ! command -v node &>/dev/null; then
		wget -q https://install-node.vercel.app/lts -O install-node && chmod +x install-node
		./install-node -y
		if [ $? -eq 0 ]; then
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

get_unused_ip() {
	local i

	# 2^16 attemps
	for i in 127.0.{0..255}.{1..255}; do
		if [[ ! "$lOut" =~ "$i:$PORT " ]]; then
			echo "$i"
			break
		#else
		#	lOut=$(sed "/$i:$PORT/d" <<< "$lOut")
		#	lOut=$(grep --invert-match $i:$PORT <<< "$lOut")
		fi
	done
}

get_unsed_port() {
	local p
	for p in {3306..65535}; do

		[[ "$lOut" =~ "*:$p " ]] && continue

		if [[ ! "$lOut" =~ "$TMP_IP:$p " ]]; then
			echo "$p"
			return 0
		fi
	done
}

clear_current_row() {
	tput civis
	tput cuu1
	tput el
	tput cnorm
}

clear_following_rows() {
	tput civis
	tput cuu1
	tput ed
	tput cnorm
}

before_read() {
	tput civis
	tput hpa 0
	tput el
	tput cnorm
}

empty_read() {
	local message="$1"
	#tput cuu1
	tput civis
	tput hpa 0
	tput el
	echo -n "${i}$message${n}"
	tput cuu1
	tput cnorm
}

invalid_option() {

	local reason="$1"
	local vaule="$2"
	local message="$3"
	local formated=$(cat -v <<<"$vaule")

	tput civis
	tput hpa 0
	tput el
	echo -n "$reason: ${i}${c1}$formated${n} $message"
	tput cuu1
	tput cnorm
}

close_cup() {
	echo "${i}${c5}"
	read -s -n 1 -p "Presiona una tecla para continuar..."
	echo -n "${n}"
	tput rmcup
}

chage_ip_and_port() {
	local unsedIP unsedPORT
	local R_IP R_PORT
	while :; do
		before_read
		read -p "Ingrese la dirección IP [$TMP_IP] -> " R_IP

		if [ "$R_IP" == "" ]; then
			if [ "$TMP_IP" != "" ]; then
				clear_following_rows
				break
			else
				empty_read "Escribe una dirección IP"
				continue
			fi
		else

			local regReduce='^0*([0-9]+\.)0*([0-9]+\.)0*([0-9]+\.)0*([0-9]+)$'
			local reduce

			reduce=$(sed -r "s/$regReduce/\1\2\3\4/; t; q1" <<<"$R_IP")
			if [ $? -ne 0 ]; then
				invalid_option "Dirección inválida" "$R_IP" "formato incorrecto, se esperaba A.B.C.D"
				continue
			fi

			R_IP="$reduce"

			local regCheck='^127\.(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){2}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
			if grep -q -P "$regCheck" <<<"$R_IP"; then
				TMP_IP="$R_IP"
				TMP_PORT=$(get_unsed_port)
				clear_following_rows
				break
			else
				invalid_option "Dirección inválida" "$R_IP" "debe petencer a la red 127.0.0.0/8"
			fi
		fi

	done

	tee "$DB_FILE" <<<"IP:     ${c6}$TMP_IP${n}"

	while :; do
		before_read
		read -p "Ingrese el número de puerto [$TMP_PORT] -> " R_PORT

		if [ "$R_PORT" == "" ]; then
			if [ "$TMP_PORT" != "" ]; then
				clear_following_rows
				break
			else
				empty_read "Escribe un número de puerto"
				continue
			fi
		else
			local regReduce='^0*([0-9]+)$'
			local reduce

			reduce=$(sed -r "s/$regReduce/\1/; t; q1" <<<"$R_PORT")
			if [ $? -ne 0 ]; then
				invalid_option "Puerto inválido" "$R_PORT" "formato incorrecto, se esperaba un número"
				continue
			fi

			if [ $R_PORT -ge 1024 ] && [ $R_PORT -le 65535 ]; then
				TMP_PORT="$R_PORT"
				clear_following_rows
				break
			else
				invalid_option "Puerto inválio" $R_PORT "debe ser un número entre 1024..65535"
				continue
			fi 2>/dev/null
		fi
	done

	tee -a "$DB_FILE" <<<"PUERTO: ${c6}$TMP_PORT${n}"

	if [[ ! "$lOut" =~ "*:$TMP_PORT " ]] && [[ ! "$lOut" =~ "$TMP_IP:$TMP_PORT " ]]; then
		IP=$TMP_IP
		PORT=$TMP_PORT
		tee -a "$DB_FILE" <<-EOF
			 Utilice esa dirección IP y número puerto en esta
			 parte del tutorial:
			 ${u}${c4}https://github.com/srealmoreno/api-express/tree/master#crear-conexión-mysql-en-vscode${n}
			 ${u}${c4}https://github.com/srealmoreno/api-express/tree/master#utilizar-base-de-datos-creada${n}
			 ${u}${c4}https://github.com/srealmoreno/api-express/tree/master#módulo-de-mysql${n}
		EOF
	else
		tput cuu 2
		tput ed
		cat <<-EOF

			${i}El puerto ya esta en uso${n}:
			$~ lsof -i:$TMP_PORT -n -P -s TCP:LISTEN
			$(head -1 <<<"$lOut")
			$(grep --color=always -P "($TMP_IP|\*):$TMP_PORT " <<<"$lOut")
		EOF
		rm -f "$DB_FILE"
		tput cuu 5
		chage_ip_and_port
	fi

}

stop_mysql_process() {
	local reply COMMAND PID USER FD TYPE DEVICE SIZE NODE NAME

	read COMMAND PID USER FD TYPE DEVICE SIZE NODE NAME < <(grep -P "($IP|\*):$PORT " <<<"$lOut")

	if [ "$COMMAND" == "mysqld" ]; then
		echo "systemctl stop mysql"
		systemctl stop mysql
	else
		echo "kill $PID"
		kill $PID
		sleep 5s
	fi

	if [ ! -e /proc/$PID ]; then
		echo "Proceso detenido exitosamente"
	else
		echo "No se pudo detener el proceso de manera segura."
		while :; do
			before_read
			read -r -p "¿Desea detener el proceso forzosamente? s/n -> " reply

			if [ "$reply" == "" ]; then
				empty_read "Escribe una opción"
				continue
			fi

			if [[ "$reply" =~ n|N ]]; then
				clear_following_rows
				cat <<-EOF

					 No podrá inicializar Docker mysql. Detenga manualmente el proceso 
					 y luego vuelva a ejcutar este script.
				EOF

				return 1
			fi

			if [[ "$reply" =~ s|S|y|Y ]]; then
				clear_following_rows

				echo "kill -9 $PID"

				kill -9 $PID
				sleep 5

				if [ ! -e /proc/$PID ]; then
					echo "Proceso detenido exitosamente"
					break
				else
					cat <<-EOF

						 El proceso se rehusa a detenerse. deberá de cerrar el proceso
						 manualmente y luego vuelva a ejcutar este script.
					EOF
					return 1
				fi
			fi
			invalid_option "Opción inválida" "$reply"
		done
	fi

	while [ "$COMMAND" == "mysqld" ]; do
		before_read
		read -r -p "¿Desea deshabilitar el servicio mysql? s/n -> " reply

		if [ "$reply" == "" ]; then
			empty_read "Escribe una opción"
			continue
		fi

		if [[ "$reply" =~ n|N ]]; then
			clear_following_rows
			tee "$DB_FILE" <<-EOF

				 Probablemente obtenga un error al reiniciar su sistema
				 ya que el servicio mysql y docker mysql intentarán
				 escuchar en el mismo puerto ${c1}${IP}:${PORT}${n}
				 si desea deshabilitar mysql ejecute lo siguiente:
				   ${c3}systemctl stop mysql${n}
				   ${c3}systemctl disable mysql${n}
			EOF
			break
		fi

		if [[ "$reply" =~ s|S|y|Y ]]; then
			clear_following_rows

			echo "systemctl disable mysql"
			systemctl disable mysql

			tee "$DB_FILE" <<-EOF

				 Para volver a habilitar el servicio ejecute lo siguiente
				 en la terminal
				  ${c3}docker rm -f "$DOCKER_NAME"${n} # Eliminará docker mysql
				  ${c3}systemctl enable mysql${n}      # Habilitará el servicio mysql
				  ${c3}systemctl start  mysql${n}      # Iniciará   el servicio mysql
			EOF
			break
		fi

		invalid_option "Opción inválida" "$reply"
	done
}

fix_db_file() {
	chown $SUDO_USER:$SUDO_USER "$DB_FILE"
	sed -i -r 's/\x1b\[[0-9;]*m?//g' "$DB_FILE"
}

check_mysql_process() {

	local lOut=$(lsof -i -s TCP:LISTEN -n -P)
	local message
	local TMP_IP TMP_PORT
	local DB_FILE="db.txt"

	# mysql process listenning in 0.0.0.0 (all ip)
	if [[ "$lOut" =~ "*:$PORT " ]] || [[ "$lOut" =~ "$IP:$PORT " ]]; then
		tput smcup
		trap 'tput rmcup' EXIT

		if [[ "$lOut" =~ "*:$PORT " ]]; then
			TMP_IP="$IP"
			TMP_PORT=$(get_unsed_port)

			read -d '' message <<-EOF
				   En este caso debe de escoger otro ${c1}puerto${n} ya que el
				   puerto no esta disponible para otra dirección IP
				   e.j ${c1}$TMP_PORT${n}
			EOF
		else
			TMP_IP=$(get_unused_ip)
			TMP_PORT="$PORT"
			read -d '' message <<-EOF
				   En este caso debe de escoger otra ${c1}IP${n} que se encuentre
				   en el rango de 127.0.0.0/8 ya que el puerto esta disponible
				   para otra dirección, e.j ${c1}$TMP_IP${n}
			EOF
		fi

		cat <<-EOF
			${c3}Atención${n}: Se detectó un servidor mysql en ejecución en su sistema.
			Docker mysql no podrá iniciar con la IP ${c1}$IP${n} y el puerto ${c1}$PORT${n}
			ya que el puerto se  encuentra en uso

			$~ lsof -i:3306 -n -P -s TCP:LISTEN
			$(head -1 <<<"$lOut")
			$(grep --color=always -P "($IP:)?$PORT " <<<"$lOut")

			Para resolver este problema tiene las siguientes opciones:

			${c2}1. Utilizar mi servidor mysql${n}
			   Ya que tiene el servidor instalado, puede omitir
			   la instalación de docker y utilizar su servidor.

			${c3}2. Escoger otra dirección IP y/o puerto diferente:${n}
			   $message

			${c6}3. Detener mi servidor mysql${n}
			   Detendrá su servidor instalado y se ejecutará Docker
			   mysql. Si desea seguir el tutorial al pie de la letra
			   escoga esta opción.

		EOF

		while :; do
			before_read
			read -p "Ingrese una opción [2] -> " reply
			case $reply in
			"1")
				clear_following_rows
				tee "$DB_FILE" <<-EOF
					${c2}Utilizar mi servidor mysql${n}
					 Deberá de averiguar la contraseña del usuario ${c1}root${n} y utilizarla
					 en esta parte del tutorial:
					 ${u}${c4}https://github.com/srealmoreno/api-express/tree/master#crear-conexión-mysql-en-vscode${n}
				EOF
				unset closeSession
				fix_db_file
				close_cup
				return 1
				;;
			"2" | "")
				clear_following_rows
				echo "${c3}Escoger otra dirección IP y/o puerto diferente ${n}"
				chage_ip_and_port
				fix_db_file
				close_cup
				return 0
				;;

			"3")
				clear_following_rows
				echo "${c6}Detener mi servidor mysql${n}"
				stop_mysql_process
				fix_db_file
				close_cup
				return 0
				;;
			*)
				invalid_option "Opción inválida" "$reply"
				;;

			esac

		done

	fi
}

close_session() {
	if [ -n "$closeSession" ]; then
		info "Se necesita cerrar sesión para recargar permisos"

		local reply
		while :; do
			before_read
			read -r -p "¿Desea cerrar sesión ahora? s/n -> " reply

			if [ "$reply" == "" ]; then
				empty_read "Escribe una opción"
				continue
			fi

			if [[ "$reply" =~ n|N ]]; then
				clear_following_rows
				info "Debe de cerrar sesión para empezar a hacer el proyecto"
				break
			fi

			if [[ "$reply" =~ s|S|y|Y ]]; then
				systemctl restart display-manager || pkill Xorg
			fi

			invalid_option "Opción inválida" "$reply"
		done
	fi
}

build_project() {
	cd ${0%/*}/..

	install_node
	install_docker

	import_mysql_image
	start_mysql

	success "${bl}Build exitoso!${n}"
	close_session
}

[ "$EUID" -ne 0 ] && failed "Permisos root son requeridos.\nsudo $0"

[ "$SUDO_USER" == "" ] && failed "No se detecto el usuario para instalación."

build_project
