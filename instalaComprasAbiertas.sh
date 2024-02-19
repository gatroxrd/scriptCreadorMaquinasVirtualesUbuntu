#!/bin/bash
#USTPD
#gatrixrd@gmail.com

PostgreSQL()
{
	#Instalando PostGreSQL 
	#Fuente :https://www.cherryservers.com/blog/how-to-install-and-setup-postgresql-server-on-ubuntu-20-04
	echo "Actualiza sistema"
	sudo apt update
	echo "Instala PostGreSQL "
	sudo apt install wget ca-certificates
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
	sudo apt update
	apt install postgresql postgresql-contrib
        clear
	echo "PostGreSQL instalado!"
	service postgresql status
	#Instalando PostGreSQL 10
}

MongoDB()
{
	#Instalando MongoDB 
	#Fuente: https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-from-the-default-apt-repositories-on-ubuntu-20-04

        clear
        echo "Instalando MongoDB"
	#- - - - - - - - - - - - - - - - - - - -
	sudo apt install curl
	sudo curl -fsSL https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
	echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
	sudo apt update
	sudo apt install mongodb-org
	#- - - - - - - - - - - - - - - - - - - -
	sudo systemctl start mongod.service
	sudo systemctl enable mongod.service
	#sudo systemctl status mongod.service	
	sudo ufw allow 27017
	echo "MongoDb instalado!"
}

NodeJs()
{
	#Instalando NodeJs
	clear
        sudo curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
	sudo apt update
	sudo apt install nodejs
	sudo wget https://nodejs.org/dist/v18.12.1/node-v18.12.1-linux-x64.tar.gz
	sudo tar -xf node-v18.12.1-linux-x64.tar.gz
	sudo sudo mv node-v18.12.1-linux-x64/* /usr/local/bin
	#------------------
	sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh
	sudo ./install.sh
	#- - - - - - - - - -
	nvm install 18.12.1
	echo "NodeJs 18 instalado!"
}


Nginx()
{
	#Instalación de Ngix
	sudo apt install nginx
	sudo systemctl enable nginx
#	sudo systemctl status nginx	
	echo "Nginx instalado!"
}

Pm2()
{
	echo "Instalando PM2"
	sudo apt update
	sudo apt install nodejs
	sudo npm install pm2@latest -g
	sudo chmod +x /usr/local/bin/pm2
	echo "PM2 instalado"
}

VisualCode()
{
	echo "Instalando Visual Code"
	sudo apt update
	sudo apt install apt-transport-https
	wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
	sudo apt update
	sudo apt install code
	echo "Visual Code instalado!"
}

Git()
{
	echo "Instalando GIT"
	sudo apt update
	sudo apt install git
	sudo chmod +x /usr/bin/git
	git --version
	echo 'export PATH=$PATH:/usr/bin/git' >> ~/.bashrc
	echo "GIT instalado!"
}

CreacionBaseDatos()
{
	echo "Desea reestablecer el password de PostgreSQL [Si/S/s/No/N/n]:"
	read respuestaReestablecerPasswordPostgreSQL
	# Validar respuesta de instalación de Visual Code
	if [[ "$respuestaReestablecerPasswordPostgreSQL" =~ ^(Si|S|s)$ ]]; then
			echo "Se procede a reestablecer la contraseña de PostgreSQL"
			#Estableciendo el nuevo password para controlar PostgreSQL
			sudo passwd postgres
	fi
	#Establecido el nuevo password o no de cualquier modo nos logeamos a PostgreSQL como super usuario
	echo "A continuación capture una a una las siguientes instrucciones"
	
	echo "1) su postgres"
	echo "2) psql"
	echo "3) create database edca;"
    echo "4) create user prueba_captura with password 'p4ssw0rd';"
	echo "5) grant all privileges on database edca to prueba_captura;"
	echo "6) create user prueba_dashboard with password 'p4ssw0rd';"
	echo "7) grant all privileges on database edca to prueba_dashboard;"	
	echo "Y al finalizar..."
	echo "8) \q"
	echo "9) exit"

	#Crea Base de Datos EDCA -------------------------------------------
        #-echo "Desea crear la Base de Datos EDCA [Si/S/s/No/N/n]:"
        #-read respuestaCreacionEDCA
        # Validar respuesta de creación de la base de Datos EDCA
        #-if [[ "$respuestaCreacionEDCA" =~ ^(Si|S|s)$ ]]; then
                #-echo "Creando base de datos EDCA"
  				#Creacion de la base de datos EDCA
				#-create database edca;              
        #-fi	

	#Esquema prueba_captura --------------------------------------------
        #-echo "Desea crear al usuario propietario del esquema 'prueba_captura' en EDCA [Si/S/s/No/N/n]:"
        #-read respuestaCreacionPruebaCaptura
        # Validar respuesta de creación del esquema prueba_captura en la base de Datos EDCA
        #-if [[ "$respuestaCreacionPruebaCaptura" =~ ^(Si|S|s)$ ]]; then
                #-echo "Creando usuario propietario del esquema prueba_captura de la base de datos EDCA"
 				#Estableciendo el usuario y password de acceso a la Base de Datos
				#Como propietario del esquema "prueba_captura"
				#-create user prueba_captura with password 'p4ssw0rd';
				#-grant all privileges on database edca to prueba_captura;             
        #-fi

	#Esquema prueba_dashboard --------------------------------------------
        #-echo "Desea crear al usuario propietario del esquema 'prueba_dashboard' en EDCA [Si/S/s/No/N/n]:"
        #-read respuestaCreacionPruebaDashboard
        # Validar respuesta de creación del esquema prueba_dashboard en la base de Datos EDCA
        #-if [[ "$respuestaCreacionPruebaDashboard" =~ ^(Si|S|s)$ ]]; then
                #-echo "Creando usuario propietario del esquema prueba_dashboard de la base de datos EDCA"
				#Como propietario del esquema "prueba_dashboard"
				#-create user prueba_dashboard with password 'p4ssw0rd';
				#-grant all privileges on database edca to prueba_dashboard;             
        #-fi		

	#Terminamos y salimos de la consola de PostgreSQL
	#- \q
	#- exit
	echo "Base de datos creada y propietarios de los esquema prueba-captura y prueba_dashboard creados"
}


prerrequisitosInstalacion()
{
		paquete="curl"
		if dpkg -s $paquete >/dev/null 2>&1; then
			echo "El paquete $paquete está instalado."
		else
			echo "El paquete $paquete no está instalado se descargará"
			sudo apt install curl			
		fi

		echo "Desea instalar Todos los prerequisitos (T) o uno por uno (U) [T/t/U/u]:"
		read respuestaTodosUnoxUno
		# Validar respuesta de instalación de todo el software de una vez o parte por parte
		if [[ "$respuestaTodosUnoxUno" =~ ^(U|u)$ ]]; then
					echo -e "\033[31m#####################################################################\033[0m"
					echo -e "\033[31m########## INSTALACIÓN 1 x 1 SOFTWARE REQUERIDO INSTALADO ###########\033[0m"
					echo -e "\033[31m#####################################################################\033[0m"		
					echo "Desea instalar Visual Code [Si/S/s/No/N/n]:"
					read respuestaVisualCode
					# Validar respuesta de instalación de Visual Code
					if [[ "$respuestaVisualCode" =~ ^(Si|S|s)$ ]]; then
								echo "Se procede a instalar Visual Code"
								VisualCode
					fi
					#----------------------------------------------------------------
					echo "Desea instalar PostgreSQL [Si/S/s/No/N/n]:"
					read respuestaPostgreSQL
					# Validar respuesta de instalación del PostgreSQL
					if [[ "$respuestaPostgreSQL" =~ ^(Si|S|s)$ ]]; then
						echo "Se procede a instalar PostgreSQL"
						PostgreSQL
					fi
					#----------------------------------------------------------------
					echo "Desea instalar MongoDB [Si/S/s/No/N/n]:"
					read respuestaMongoDB
					# Validar respuesta de instalación de MongoDB
					if [[ "$respuestaMongoDB" =~ ^(Si|S|s)$ ]]; then
							echo "Se procede a instalar MongoDB"
							MongoDB
					fi
					#----------------------------------------------------------------
					echo "Desea instalar NodeJs [Si/S/s/No/N/n]:"
					read respuestaNodeJs
					# Validar respuesta de instalación de NodeJs
					if [[ "$respuestaNodeJs" =~ ^(Si|S|s)$ ]]; then
							echo "Se procede a instalar NodeJs"
							NodeJs
					fi
					#----------------------------------------------------------------
					echo "Desea instalar NGINX [Si/S/s/No/N/n]:"
					read respuestaNginx
					# Validar respuesta de instalación de Nginx
					if [[ "$respuestaNginx" =~ ^(Si|S|s)$ ]]; then
							echo "Se procede a instalar Nginx"
							Nginx
					fi
					#----------------------------------------------------------------
					echo "Desea instalar PM2 [Si/S/s/No/N/n]:"
					read respuestaPm2
					# Validar respuesta de instalación de PM2
					if [[ "$respuestaPm2" =~ ^(Si|S|s)$ ]]; then
							echo "Se procede a instalar PM2"
							Pm2
					fi
					#----------------------------------------------------------------
					echo "Desea instalar GIT [Si/S/s/No/N/n]:"
					read respuestaGit
					# Validar respuesta de instalación de GIT
					if [[ "$respuestaGit" =~ ^(Si|S|s)$ ]]; then
							echo "Se procede a instalar GIT"
							Git
					fi
		else 
					if [[ "$respuestaTodosUnoxUno" =~ ^(T|t)$ ]]; then
						echo -e "\033[31m#####################################################################\033[0m"
						echo -e "\033[31m###### INSTALACIÓN DE TODO EL SOFTWARE REQUERIDO INSTALADO ##########\033[0m"
						echo -e "\033[31m#####################################################################\033[0m"					
						echo "Se procede a instalar todo el software necesario"
						VisualCode
						PostgreSQL
						MongoDB
						NodeJs
						Nginx
						Pm2 
						Git
					else
						echo "La selección tecleada no es válida"
						exit
					fi
		fi

		clear

		echo -e "\033[31m#####################################################################\033[0m"
		echo -e "\033[31m############ SOFTWARE REQUERIDO INSTALADO ###########################\033[0m"
		echo -e "\033[31m#####################################################################\033[0m"
		#Comprobación de las versiones instaladas - - - - - - - - - -
		echo -e "\033[31mVersión de PostGreSQL:\033[0m"
		psql --version
		echo "------------------------------------------------------"
		echo -e "\033[31mVersión de NodeJs:\033[0m"
		node -v
		echo "------------------------------------------------------"
		echo -e "\033[31mVersión de MongoDB:\033[0m"
		mongo --version
		echo "------------------------------------------------------"
		echo -e "\033[31mVersion de Nginx:\033[0m"
		nginx -v
		echo "------------------------------------------------------"
		echo -e "\033[31mVersion de PM2:\033[0m"
		pm2 -v
		echo "------------------------------------------------------"
		echo -e "\033[31mVersion de GIT:\033[0m"
		git --version
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

descargaArchivosFuenteINAI()
{
	sudo mkdir /var/www/html/contratacionesabiertas
	cd /var/www/html/contratacionesabiertas
	sudo git clone https://github.com/datosabiertosmx/contrataciones-abiertas-infraestructura
	cd contrataciones-abiertas-infraestructura/contratacionesabiertas/
	sudo mv -v captura dashboard /var/www/html/contratacionesabiertas
	cd ../..
	sudo rm -rf contrataciones-abiertas-infraestructura/
}

configuracionVariablesConexionBD()
{
	cd captura
	cd config
	#chmod -R 777 appsettings.json

}

menuConfiguracion()
{
	echo "1. Arquitectura"
	echo "2. Creación de la base de datos"
	echo "3. Descargar el archivo del código"
	echo "4. Configuración de variables de conexión a la base de datos"
	echo "5. Creación de la base de datos edca y del esquema publica"
	echo "6. Configuración del usuario propietario para el esquema public	"
	echo "7. Creación del esquema dashboard"
	echo "8. Configuración del usuario propietario para el esquema dashboard"
	echo "9. Validación de conexión a base de datos"
	echo "10. Asignación de variables MAPTOKEN"
	echo "11. Instalación de Object Relational Mapping del módulo de Infraestructura"
	echo "12. Crear vistas del módulo Infraestructura Abierta"
	echo "13. Crear usuario del aplicativo"
	echo "14. Iniciar los servicios de los módulos"
	echo "S/s Salir"
}

seleccionaOpcionMenu()
{
	# Bucle para repetir el menú
	while true; do
	# Mostrar el menú
	menuConfiguracion

	# Leer la opción del usuario
	echo -n "Seleccione una opción: "
	read opcionMenu

    echo "Usuario de configuración para prueba_captura en la Plataforma de Compras Abiertas:"
    read respuestaUsuarioCaptura
    echo "Usuario de configuración para prueba_dashboard en la Plataforma de Compras Abiertas:"
    read respuestaUsuarioDashboard	
    echo "Password de configuración de la Plataforma de Compras Abiertas:"
    read respuestaPassword	


	# Validar la opción del usuario
	if [[ $opcionMenu =~ ^[1-14]$ ]]; then
		echo "Seleccionó la opción $opcionMenu."
		case $opcion in
		1)
			echo "Seleccionó la opción $opcion1."
			# Aquí puedes agregar el código para la opción 1
			;;
		2)
			echo "Seleccionó la opción $opcion2."
			# Aquí puedes agregar el código para la opción 2
			;;
		3)
			echo "Seleccionó la opción $opcion3."
			# Aquí puedes agregar el código para la opción 3
			;;
		4)
			echo "Seleccionó la opción $opcion4."
			paso4 "$respuestaUsuarioCaptura"  "$respuestaPassword"
			# Aquí puedes agregar el código para la opción 4
			;;		
		5)
			echo "Seleccionó la opción $opcion5."
			# Aquí puedes agregar el código para la opción 5
			paso5 "$respuestaUsuarioCaptura"  "$respuestaPassword"
			;;
		6)
			echo "Seleccionó la opción $opcion6."
			# Aquí puedes agregar el código para la opción 6
			paso6 "$respuestaUsuarioDashboard"
			;;
		7)
			echo "Seleccionó la opción $opcion7."
			# Aquí puedes agregar el código para la opción 7
			paso7 "$respuestaUsuarioDashboard"
			;;	
		8)
			echo "Seleccionó la opción $opcion8."
			# Aquí puedes agregar el código para la opción 8
			paso8 "$respuestaUsuarioDashboard"
			;;		
		9)
			echo "Seleccionó la opción $opcion9."
			# Aquí puedes agregar el código para la opción 9
			paso9
			;;	
		10)
			echo "Seleccionó la opción $opcion10."
			# Aquí puedes agregar el código para la opción 10
			paso10
			;;
		11)
			echo "Seleccionó la opción $opcion11."
			# Aquí puedes agregar el código para la opción 11
			paso11
			;;
		12)
			echo "Seleccionó la opción $opcion12."
			# Aquí puedes agregar el código para la opción 12
			;;	
		13)
			echo "Seleccionó la opción $opcion13."
			# Aquí puedes agregar el código para la opción 13
			;;
		14)
			echo "Seleccionó la opción $opcion14."
			# Aquí puedes agregar el código para la opción 14
			;;																										
		*)
			echo "Opción no válida."
			;;
		esac
	elif [[ $opcionMenu =~ ^[sS]$ ]]; then
		echo "Saliendo del menú."
		break
	else
		echo "Opción no válida."
	fi
	done

}

paso2()
{
	echo -e "\033[31m#####################################################################\033[0m"
	echo -e "\033[31m############ CREANDO LA BASE DE DATOS EDCA ##########################\033[0m"
	echo -e "\033[31m#####################################################################\033[0m"
    echo "Desea iniciar las tareas de creación de la Base de Datos EDCA [Si/S/s/No/N/n]:"
      	read respuestaCrearEDCA
    # Validar respuesta de creación de la base de Datos EDCA
    if [[ "$respuestaCrearEDCA" =~ ^(Si|S|s)$ ]]; then
            echo "Iniciando tareas de creación de la base de datos EDCA"
            CreacionBaseDatos
    fi
}

paso3()
{

	echo -e "\033[31m#####################################################################\033[0m"
	echo -e "\033[31m############ DESCARGA DE ARCHIVOS FUENTE ############################\033[0m"
	echo -e "\033[31m#####################################################################\033[0m"
    echo "Desea iniciar la descarga de los archivos fuente de Compras Abiertas - INAI [Si/S/s/No/N/n]:"
      	read respuestaArchivosFuenteEDCA
    # Validar respuesta de descarga de archivos fuente del EDCA
    if [[ "$respuestaArchivosFuenteEDCA" =~ ^(Si|S|s)$ ]]; then
            echo "Iniciando tareas de descarga del proyecto de Compras Abiertas del INAI"
            descargaArchivosFuenteINAI
			cd /var/www/html/contratacionesabiertas
    fi	

}

paso4()
{
	#  $1 = usuario
    #  $2 = password
	echo "4) Configuración de variables de conexión a la base de datos"
	cd /var/www/html/contratacionesabiertas/captura
	echo "Modificar las variables “username” y “password”  correspondientes al usuario y password creados en el paso 4 del apartado 2, para el esquema public, módulo Sistema de captura en config.json"
        # PASO 1
	cd config
	chmod -R 777 config.json
	#Configurando el usuario, password y base de datos
   	sudo perl -pi -e "s[prueba_captura][$1]g" config.json
	sudo perl -pi -e "s[p4ssw0rd][$2]g" config.json
        cd ..
        # PASO 2
        chmod -R 777 db_config.js
	sudo perl -pi -e "s[prueba_captura][$1]g" db_config.js
	sudo perl -pi -e "s[p4ssw0rd][$2]g" db_config.js
	cd ..
        # PASO 3
	cd dashboard
        chmod -R 777 db_config.js
        sudo perl -pi -e "s[prueba_captura][$1]g" db_config.js
        sudo perl -pi -e "s[p4ssw0rd][$2]g" db_config.js
	echo "Paso 4 terminado."
}

paso5()
{
	#Creación de la base de datos edca y del esquema public
	# $1 = Nuevo usuario que sustituye a prueba_dashboard
	# $2 = Nuevo usuario que sustituye  a prueba_captura
	# Configurando los archivos
	echo "Creación de la base de datos edca y del esquema public"
    echo "Configurando captura - edca.sql "
	# PASO 1
	cd /var/www/html/contratacionesabiertas/captura
	# PASO 2
	cd sql
        chmod -R 777 edca.sql
        sudo perl -pi -e "s[prueba_dashboard][$1]g" edca.sql
        sudo perl -pi -e "s[p4ssw0rd][$2]g" edca.sql
        # PASO 3
	psql -U postgres edca
	psql -U postgres edca < edca.sql
	psql -U "\d"
	psql -U "\q"
	exit
	echo "Archivo captura - sql - edca.sql configurado y ejecutado"
}

paso6()
{
		# Configuración del usuario propietario para el esquema public
        # $1 = Usuario nuevo para password_captura
		echo "Configuración del usuario propietario para el esquema public"
        cd /var/www/html/contratacionesabiertas/captura
        cd sql
        chmod -R 777 owner_public.sql
        sudo perl -pi -e "s[prueba_captura][$1]g" owner_public.sql
        # PASO 3
        psql -U postgres edca
        psql -U postgres edca < owner_public.sql
        psql -U "\d"
        psql -U "\q"
        exit
        echo "Archivo captura - sql - owner_public.sql configurado y ejecutado"
}

paso7()
{
        # Creación del esquema dashboard 
        # $1 = Usuario nuevo para prueba_dashboard
		echo "Creación del esquema dashboard"
        cd /var/www/html/contratacionesabiertas/captura
        cd sql
        chmod -R 777 dashboard.sql
        sudo perl -pi -e "s[prueba_dashboard][$1]g" dashboard.sql
        # PASO 3
        psql -U postgres edca
        psql -U postgres edca < dashboard.sql
		psql -U set search_path to dashboard;
        psql -U "\d"
        psql -U "\q"
        exit
        echo "Archivo captura - sql - dashboard.sql configurado y ejecutado"
}

paso8()
{
        # Configuración del usuario propietario para el esquema dashboard 
        # $1 = Usuario nuevo para prueba_dashboard
        echo "Configuración del usuario propietario para el esquema dashboard"
        cd /var/www/html/contratacionesabiertas/captura
        cd sql
        chmod -R 777 owner_dashboard.sql
        sudo perl -pi -e "s[prueba_dashboard][$1]g" owner_dashboard.sql
        # PASO 3
        psql -U postgres edca
        psql -U postgres edca < owner_dashboard.sql
	psql -U set search_path to dashboard;
        psql -U "\d"
        psql -U "\q"
        exit
        echo "Archivo captura - sql - owner_dashboard.sql configurado y ejecutado"
}

paso9()
{
        # Validación de conexión a base de datos
	echo "Validación de conexión a base de datos"
        cd /var/www/html/contratacionesabiertas/captura
        chmod -R 777 db.js
        cat db.js
        echo "Contenido del archivo db.js"
}

paso10()
{
	# Asignación de MAPTOKEN
	echo "Asignación de MAPTOKEN"
	cd /var/www/html/contratacionesabiertas
	cd captura
	cd views
	chmod -R 777 main.ejs
	#Substituir pk.eyJ1IjoiamFtZzE0IiwiYSI6ImNqdTM4cW04aDBrbnQ0NG83ZnM4cWVnOGgifQ.d6L_McpNmO9s_MsPk5loOw
	mapToken = "pk.eyJ1IjoicGRlcHVlYmxhIiwiYSI6ImNsZ3F2czgzdTEyeG4zZmxoZno1czB5cmUifQ.-013bpBzs-GQhu27xkPDAg"
	sudo perl -pi -e "s[pk.eyJ1IjoiamFtZzE0IiwiYSI6ImNqdTM4cW04aDBrbnQ0NG83ZnM4cWVnOGgifQ.d6L_McpNmO9s_MsPk5loOw][$mapToken]g" main.ejs
	cd ..
	cd dashboard
	cd views
	#Substituir pk.eyJ1IjoiamFtZzE0IiwiYSI6ImNqdTM4cW04aDBrbnQ0NG83ZnM4cWVnOGgifQ.d6L_McpNmO9s_MsPk5loOw
	chmod -R 777 contract.ejs
	sudo perl -pi -e "s[pk.eyJ1IjoiamFtZzE0IiwiYSI6ImNqdTM4cW04aDBrbnQ0NG83ZnM4cWVnOGgifQ.d6L_McpNmO9s_MsPk5loOw][$mapToken]g" contract.ejs
	echo "MAPTOKENs han sido actualizados!"
}

paso11()
{
	# Instalación de Object Relational Mapping del módulo de Infraestructura
	cd /var/www/html/contratacionesabiertas
	cd captura
	sudo npm install -g sequelize-cli
	sequelize db:migrate
	sequelize db:seed:all
}

administradorBD_PostgreSQL()
{
  echo "Sin  código"
	
}


Principal()
{
	clear
	echo -e "\033[31m#####################################################################\033[0m"
	echo -e "\033[31m########### CONFIGURANDO SOFTWARE DE LA PLATAFORMA ##################\033[0m"
	echo -e "\033[31m#####################################################################\033[0m"
	echo "Desea instalar el software necesario para trabajar las Compras Abiertas [Si/S/s/No/N/n]:"
	read respuestaPrerequisitos
	# Validar respuesta de instalación de GIT
	if [[ "$respuestaPrerequisitos" =~ ^(Si|S|s)$ ]]; then
		echo "Se procede a instalar prerequisitos"
		prerrequisitosInstalacion
	fi


	echo -e "\033[31m#####################################################################\033[0m"
	echo -e "\033[31m#### CONFIGURAR Y DESPLEGAR LA PLATAFORMA DE COMPRAS ABIERTAS INAI ##\033[0m"
	echo -e "\033[31m#####################################################################\033[0m"
    echo "Desea iniciar la configuración y despliegue de la Plataforma de Compras Abiertas [Si/S/s/No/N/n]:"
      	read respuestaConfigurarDesplegarCA
    if [[ "$respuestaConfigurarDesplegarCA" =~ ^(Si|S|s)$ ]]; then
            echo "Iniciando la configuración y despliegue de la Plataforma de Compras Abiertas"
            seleccionaOpcionMenu
    fi	

}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Principal
