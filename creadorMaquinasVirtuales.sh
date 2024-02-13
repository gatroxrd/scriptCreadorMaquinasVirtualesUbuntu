#!/bin/bash

#23 Agosto 2023
#USTPD

# Define el origen de los archivos fuente y la ruta destino de la copia realizada
# a las 3 carpetas
# iNoINEGI

export NombreMunicipio=""
export idInegi=0

copiadoCarpetasFuente()
{
	clear
	echo -e "\033[37m Secretaría Ejecutiva del Sistema Estatal Anticorrupción Puebla - SESEAP \033[0m"
	iNoINEGI=$1
	export sNoINEGI=$(printf "%03d" ${iNoINEGI})

	set -m
	
	if [[ $iNoINEGI < 10 ]]; then
		sCeros="00"
		sNoINEGI="${sCeros}${sNoINEGI}"
	elif [[ $iNoINEGI < 100 ]]; then
		sCeros="0"
		sNoINEGI="${sCeros}${sNoINEGI}"
	fi

	echo "Valor final de sNoINEGI: ${sNoINEGI}"

    #Limpia carpetas de instalaciones previas
	# Usamos el comando test para verificar si el directorio existe
	if [ -d "SistemaDeclaraciones_backend" ]; then
	  # El directorio existe
  		echo "El directorio -SistemaDeclaraciones_backend- existe"
		sudo rm -r SistemaDeclaraciones_backend
	else
	  # El directorio no existe
  		echo "El directorio -SistemaDeclaraciones_backend- no existe"
	fi

    if [ -d "SistemaDeclaraciones_frontend" ]; then
          # El directorio existe
                echo "El directorio -SistemaDeclaraciones_frontend- existe"
                sudo rm -r SistemaDeclaraciones_frontend
        else
          # El directorio no existe
                echo "El directorio -SistemaDeclaraciones_frontend- no existe"
    fi

    if [ -d "SistemaDeclaraciones_reportes" ]; then
          # El directorio existe
                echo "El directorio -SistemaDeclaraciones_reportes- existe"
                sudo rm -r SistemaDeclaraciones_reportes
        else
          # El directorio no existe
                echo "El directorio -SistemaDeclaraciones_reportes- no existe"
    fi	
	#Carpetas previas eliminadas

	echo "Creando directorio raíz para el municipio ${sNoINEGI}"

	#Creando carpeta ORIGEN de la instalación
	sudo mkdir -p "${sNoINEGI}" -m 777
	cd "${sNoINEGI}"

	echo -e "\033[34m Número de municipio a crear es : $sNoINEGI \033[0m"
	# &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	# Ruta de origen (carpetas tal como se descargan del repositorio de la PDN)
	ruta_origen="/home/pdepuebla/SistemaDeclaraciones_backend"
	# Ruta de destino (carpetas copiadas donde se hacen las personalizaciones)
	ruta_destino=$(printf "%s" "./")


	# B A C K E N D -- - - - - - - - - - - - - - - - - - - - - - - - 
	# &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	# Verificar si la carpeta de destino existe, si no, crearla
	if [ ! -d "$ruta_destino" ]; then
	    mkdir -p "$ruta_destino" -m 755
	fi

	# Copiar la carpeta y su contenido a la ruta de destino
	cp -r "$ruta_origen" "$ruta_destino"
	echo -e "\033[33m&&&&&&&&&&&&&&&&&&&&  B A C K E N D  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \033[0m"
	echo "Carpeta Backend copiada para el municipio con número de INEGI: " $sNoINEGI
	cd SistemaDeclaraciones_backend
	configuraBackend_env ${iNoINEGI} "$2"
	cd ..
	# &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

   

	# F R O N T E N D -- - - - - - - - - - - - - - - - - - - - - - - - 
	# &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	# Ruta de origen y destino
	ruta_origen="/home/pdepuebla/SistemaDeclaraciones_frontend"
	ruta_destino=$(printf "%s" "./")

	# Verificar si la carpeta de destino existe, si no, crearla
	if [ ! -d "$ruta_destino" ]; then
	    mkdir -p "$ruta_destino" -m 755
	fi


	# Copiar la carpeta y su contenido a la ruta de destino
	cp -r "$ruta_origen" "$ruta_destino"
	echo -e "\033[33m&&&&&&&&&&&&&&&&&&&&  F R O N T E N D  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \033[0m"
	echo "Carpeta Frontend copiada para el municipio con número de INEGI: " $sNoINEGI
	cd SistemaDeclaraciones_frontend
	echo -e "\033[35m&&&&&&&&&&&&&&&&&&&&  Configurando Environmet en Frontend \033[0m"
	configuraFrontend_environment ${iNoINEGI} "$2"
	echo -e "\033[35m&&&&&&&&&&&&&&&&&&&&  Configurando Docker-compose.yml en Frontend \033[0m"
	configurarDockerCompose_FrondEnd ${iNoINEGI}
	cd ..
	# &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



	# R E P O R T E S -- - - - - - - - - - - - - - - - - - - - - - - - 
	# &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	# Ruta de origen y destino
	ruta_origen="/home/pdepuebla/SistemaDeclaraciones_reportes"
	ruta_destino=$(printf "%s" "./")

	# Verificar si la carpeta de destino existe, si no, crearla
	if [ ! -d "$ruta_destino" ]; then
	    mkdir -p "$ruta_destino" -m 755
	fi

	# Copiar la carpeta y su contenido a la ruta de destino
	cp -r "$ruta_origen" "$ruta_destino"
	echo -e "\033[33m&&&&&&&&&&&&&&&&&&&&  R E P O R T E S  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \033[0m"
	echo "Carpeta Reportes copiada para el municipio con número de INEGI: " $sNoINEGI
	cd SistemaDeclaraciones_reportes
	configuraReportes_env ${iNoINEGI}
	configurarDockerCompose_Reportes ${iNoINEGI}
	# &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	echo -e "\033[31m##########   ¡Carpetas fuente copiadas exitosamente!   ############################\033[0m"
	ls
}

######################################################################
##############  .ENV Y DOCKER-COMPOSE.YML DEL BACKEND ################
######################################################################

configuraBackend_env()
{
   #Parametros a modificar
   # Carpeta Backend
   #   Port - Puerto de operación de la APP - Port
   #   ElasticSearch - Puerto donde se monta el Elastic Search - ELASTIC_SEARCH_URL
   #   ReportsUrl - Puerto donde montara el servicio de Impresión - REPORTS_URL
   #   Base de datos de Mongo - Nombre de la base de datos - MONGO_DB
   #   Estableciendo los valores por default
   # Del '.env'
   iPort=3000
   iElasticSearch=9200
   iReportPort=3001+500
   iPortWebUrl=8000
   #Del 'docker-compose.yml'
   sumaiPort=$(echo "$iPort+ $1" | bc)
   sumaiElasticSearch=$(echo "$iElasticSearch+ $1" | bc)
   sumaiElasticSearchExtra=$(echo "$iElasticSearch+200+ $1" | bc)
   sumaiReportPort=$(echo "$iReportPort+ $1" | bc)
   sumaiPortWebUrl=$(echo "$iPortWebUrl+ $1" | bc)

   iNoBD=$1
   export sNoBD=$(printf "%03d" ${iNoBD})

   set -m
	
	if [[ $iNoBD < 10 ]]; then
		sCeros="00"
		sNoBD="${sCeros}${sNoBD}"
	elif [[ $iNoBD < 100 ]]; then
		sCeros="0"
		sNoBD="${sCeros}${sNoBD}"
	fi
	
   #nombreBD="declaraciones_"

   #nuevaBaseDatos="${nombreBD}${sNoBD}" 

   #P A R A M E T R I Z A R
   username="declarausr"
   passwd="declarapsw"
   localhost="$2"

	if [ -f .env ]; then
  		echo "El archivo .env ya existe."
	else
  		#Crea el nuevo archivo .env a partir de .env.example
   		sudo cp -p -r -f -a -v .env.example .env
	fi


   echo -e "\033[35m&&&&&&&&&&&&&&&&&&&&  Configurando .env del Backend \033[0m"
   #Cargando el archivo .env
   chmod -R 777 .env
   #Configurando el archivo .env del BACKEND
   		sudo perl -pi -e "s[PORT=3000][PORT=$sumaiPort]g" .env
		echo "Variable PORT del .env configurada con el valor: ${sumaiPort}"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		sudo perl -pi -e "s[FE_RESET_PASSWORD_URL=http://localhost:8080][FE_RESET_PASSWORD_URL=http://localhost:$sumaiPortWebUrl]g" .env
		echo "Variable puerto de recuperación de password en el .env configurada con el valor: ${sumaiPortWebUrl}"		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   		sudo perl -pi -e "s[ELASTIC_SEARCH_URL=http://localhost:9200][ELASTIC_SEARCH_URL=http://localhost:$sumaiElasticSearch]g" .env
		echo "Variable puerto del Elastic Search en el .env configurada con el valor: ${sumaiElasticSearch}"		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -		
   		sudo perl -pi -e "s[REPORTS_URL=http://localhost:3001][REPORTS_URL=http://localhost:$sumaiReportPort]g" .env
		echo "Variable ReportPort del .env configurada con el valor: ${sumaiReportPort}"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -		
   		sudo perl -pi -e "s[MONGO_USERNAME=username][MONGO_USERNAME=$username]g" .env
		echo "Variable Mongo_Username del .env configurada con el valor: ${username}"		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -		
   		sudo perl -pi -e "s[MONGO_PASSWORD=passwd][MONGO_PASSWORD=$passwd]g" .env
		echo "Variable Mongo_Password del .env configurada con el valor: ${passwd}"			
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   		sudo perl -pi -e "s[MONGO_HOSTNAME=localhost][MONGO_HOSTNAME=$localhost]g" .env
		echo "Variable Mongo_Hostname del .env configurada con el valor: ${localhost}"			
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -		
   		sudo perl -pi -e "s[MONGO_DB=newmodels][MONGO_DB=declaraciones_$sNoBD]g" .env
		echo "Variable Mongo_DB del .env configurada con el valor: ${sNoBD}"		
   #Configurando el archivo .env del BACKEND

   #Configurando el archivo docker-compose.yml del BACKEND
		#Cargando el archivo docker-compose.yml
		echo -e "\033[35m&&&&&&&&&&&&&&&&&&&&  Configurando Docker-compose.yml en Backend\033[0m"
		chmod -R 777 docker-compose.yml
		#Cargando el archivo docker-compose.yml
		#Nombre del servicio de 'Reports' a reports_sNoMunicipio
				sudo perl -pi -e "s[  reports:][  reports_$1:]g" docker-compose.yml
				echo "Nombre del servicio de Reports ha sido personalizado a reports_$1"
		#Puerto del servicio de 'Reports' pasa de  "      - 3001:3001" a "      - 3001:sumaiReportPort"
				sudo perl -pi -e "s[      - 3001:3001][      - $sumaiReportPort:3001]g" docker-compose.yml
				echo "Puerto del servicio de Reports fue personalizado de 3001 a ${sumaiReportPort}"
		#Nombre del servicio de 'ElasticSearch' pasa de  "elasticsearch" a "elasticsearch_sNoMunicipio"
				sudo perl -pi -e "s[  elasticsearch:][  elasticsearch_$1:]g" docker-compose.yml
				echo "Se personalizado el nombre del servicio de ElasticSearch a 'elasticsearch_${sumaiReportPort}'"				
		#Volumen del servicio se personaliza de 'esdata:/usr/share/elasticsearch/data' a 'esdata:/usr/share/elasticsearch_$1/data'
				sudo perl -pi -e "s[      - esdata:/usr/share/elasticsearch/data][      - esdata:/usr/share/elasticsearch_$1/data]g" docker-compose.yml
				echo "Se personalizado el nombre del volumen para este servicio'"
		#Puertos del Volumen de datos se personaliza de '      - 9200:9200' a '      - ${sumaiElasticSearch}:9200'
				sudo perl -pi -e "s[      - 9200:9200][      - ${sumaiElasticSearch}:9200]g" docker-compose.yml
				echo "Primer puerto del volumen de datos se personaliza a ${sumaiElasticSearch}"
		#Puertos del Volumen de datos se personaliza de '      - 9300:9300' a '      - ${sumaiElasticSearch}:9300'
				sudo perl -pi -e "s[      - 9300:9300][      - ${sumaiElasticSearchExtra}:9300]g" docker-compose.yml
				echo "Segundo puerto del volumen de datos se personaliza a ${sumaiElasticSearch}"
		#Nombre de la app se personaliza a 'app_$1'
				sudo perl -pi -e "s[  app:][  app_$1:]g" docker-compose.yml
				echo "Nombre de la app ha sido personalizado a app_$1"
		#Personalización del nombre de la dependencia en la sección elasticsearch en 'app_$1'
				sudo perl -pi -e "s[      - elasticsearch][      - elasticsearch_$1]g" docker-compose.yml
				echo "Personalizando el nombre de la dependencia de la sección app 'elasticsearch_$1'"
		#Personalización del nombre de la dependencia en la sección reports en 'reports_$1'
				sudo perl -pi -e "s[      - reports][      - reports_$1]g" docker-compose.yml
				echo "Personalizando el nombre de la dependencia de la sección app 'reports_$1'"											
		#Personalización del nombre de la app en la sección volumen en 'app_$1'
				sudo perl -pi -e "s[      - .:/usr/app][      - .:/usr/app_$1]g" docker-compose.yml
				echo "Personalizando el nombre de la dependencia de la sección app 'app_$1'"					


	#Configurando el archivo docker-compose.yml del BACKEND
}

configuraFrontend_environment()
{
	#Parametros a configurar
	#	La variable Server_url dentro de los archivos enviroment.ts como environment.prod.ts
	#	La variable Page_url dentro de los archivos environment.ts como environment.prod.ts
	#   serverUrl: 'http://localhost/api',
    #   pageUrl: 'http://localhost:4200/',
    #iServer_url=3000 + No. INEGI del Municipio
    #iPage_url=4200 + No. INEGI del Municipio

	cd src
	cd environments

   iServerUrl=3000
   IPComputer=$2
   iPageUrl=4200
   sumaiPageUrlPort=$(echo "$iPageUrl + $1" | bc)
   sumaiServerUrlPort=$(echo "$iServerUrl + $1" | bc)

   #Cargando el archivo environment.prod.ts -- - - - - - - - - - - - - - - - - - 
   chmod -R 777 environment.prod.ts
   #Configurando el archivo environment.prod.ts
		echo "Archivo environment.prod.ts"
   		#sudo perl -pi -e "s[serverUrl: 'http://localhost:3000,'][serverUrl: 'http://$IPComputer/api',]g" environment.prod.ts
		sudo perl -pi -e "s[serverUrl: 'http://0.0.0.0:3000',][serverUrl: 'http://$IPComputer:$sumaiServerUrlPort',]g" environment.prod.ts
		#sudo perl -pi -e "s[serverUrl: 'http://0.0.0.0:3000',][serverUrl: 'http://$IPComputer/api',]g" environment.prod.ts
		echo "Se ha preconfigurado el Server Url para el NGINX  cambiando el puerto 3000 por el valor de la IP : ${IPComputer}:${sumaiServerUrlPort}"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		#sudo perl -pi -e "s[pageUrl: 'http://localhost:4200/','][pageUrl: 'http://localhost:$sumaiPageUrlPort/,']g" environment.prod.ts
		#echo "Preconfigurado de la Page Url para utilizar el NGINX  cambiando el puerto 4200 por el valor : ${sumaiPageUrlPort}"
   

   #Cargando el archivo environment.ts - - - - - - - - - - - - - - - - - - - 
   chmod -R 777 environment.ts
   #Configurando el archivo environment.ts
   		echo "Archivo environment.ts"
   		sudo perl -pi -e "s[serverUrl: 'http://0.0.0.0:3000',][serverUrl: 'http://$IPComputer:$sumaiServerUrlPort',]g" environment.ts
		#sudo perl -pi -e "s[serverUrl: 'http://0.0.0.0:3000',][serverUrl: 'http://$IPComputer/api',]g" environment.ts
		echo "Se ha preconfigurado el Server Url para el NGINX  cambiando el puerto 3000 por el valor de la IP : ${IPComputer}:${sumaiServerUrlPort}"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		#sudo perl -pi -e "s[pageUrl: 'http://localhost:4200/','][pageUrl: 'http://localhost:$sumaiPageUrlPort/,']g" environment.ts
		#echo "Preconfigurado de la Page Url para el NGINX  cambiando el puerto 4200 por el valor : ${sumaiPageUrlPort}"
	cd ..
	cd ..
	#Saliendo de /src/environments y regresando a SistemaDeclaraciones_frontend raíz
}

configuraReportes_env()
{
	#Parametros a configurar
	#	La variable Port dentro del archivo .env
    #   Port=3000 + No. INEGI del Municipio

   iPort=3000
   sumaiPortReportes=$(echo "$iPort + $1" | bc)

   	if [ -f .env ]; then
  		echo "El archivo .env ya existe."
	else
  		#Crea el nuevo archivo .env a partir de .env.example
   		sudo cp -p -r -f -a -v .env.example .env
	fi

   #Cargando el archivo .env -- - - - - - - - - - - - - - - - - - 
   chmod -R 777 .env
   #Configurando el archivo .env
        echo -e "\033[35m&&&&&&&&&&&&&&&&&&&&  Configurando .env de Reportes \033[0m"
		echo "Configurando el archivo .env en Reportes"
   		sudo perl -pi -e "s[Port=3001][Port=$sumaiPortReportes]g" .env
		echo "Se ha configurado el puerto de impresión 3001 por el nuevo valor ${sumaiPortReportes}"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
}

######################################################################
##############  DOCKER-COMPOSE.YML DEL FRONTEND ######################
######################################################################

configurarDockerCompose_FrondEnd()
{
	#Parametros a configurar FrontEnd
	#	La variable webapp dentro del archivo docker-compose.yml
	#	Los valores de la sección ports del archivo docker-compose.yml
    #   Ports 8000 + No. INEGI del Municipio : 80

   iPort=8000
   sumaiPort=$(echo "$iPort + $1" | bc)

   #Cargando el archivo docker-compose.yml - - - - - - - - - - - - - - - - - - 
   chmod -R 777 docker-compose.yml
   #Configurando el nombre de la 'webapp' de publicación en el archivo docker-compose.yml
   		sudo perl -pi -e "s[  webapp:][  webapp_$1:]g" docker-compose.yml
		echo "Se han configurado el nombre de la Webapp de 'webapp' a 'webapp_${sumaiPort}'"
   #Configurando los puertos de publicación de la 'webapp' en el archivo docker-compose.yml
   		sudo perl -pi -e "s[      - 8080:80][      - $sumaiPort:80]g" docker-compose.yml
		echo "Se han configurado los puertos de la Webapp de '80 : 80' a '${sumaiPort}: 80'"		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   #cd ..	
}

######################################################################
##############  DOCKER-COMPOSE.YML DE REPORTES ######################
######################################################################

configurarDockerCompose_Reportes()
{
	#Parametros a configurar Reportes
	#	Los valores de la sección ports del archivo docker-compose.yml
    #   Ports 3001 + No. INEGI del Municipio : 3001

   iPort=3001+500
   sumaiPort=$(echo "$iPort + $1" | bc)

   #Cargando el archivo docker-compose.yml - - - - - - - - - - - - - - - - - - 
   chmod -R 777 docker-compose.yml
   #Configurando los puertos de publicación de la 'webapp' en el archivo docker-compose.yml
   		sudo perl -pi -e "s[      - 3001:3001][      - $sumaiPort:3001]g" docker-compose.yml
		echo "Se han configurado los puertos del servicio de '      - 3001:3001' a '      - ${sumaiPort}:3001'"		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   cd ..	
}

reconstruyeDocker()
{
	#Reconstruye el Backend y Reportes
	cd SistemaDeclaraciones_backend
        sudo docker-compose -p declaraciones-backend up -d --build --force-recreate
		cd ..
		echo "Backend y reportes reconstruidos!..."
	#Reconstruye el FrontEnd
        cd SistemaDeclaraciones_frontend
        sudo docker-compose -p declaraciones-frontend up -d --build --force-recreate
        echo "Frontend reconstruido!..."

	valor=$2

	case $valor in			
		1   )
			respuesta="acajete"  ;;
		2	)
			respuesta="acateno"  ;;
		3	)
			respuesta="acatlan"  ;;
		4	)
			respuesta="acatzingo"  ;;
		5	)
			respuesta="acteopan"  ;;
		6	)
			respuesta="ahuacatlan"  ;;
		7	)
			respuesta="ahuatlan"  ;;
		8	)
			respuesta="ahuazotepec"  ;;
		9	)
			respuesta="ahuehuetitla"  ;;
		10	)
			respuesta="ajalpan"  ;;
		11	)
			respuesta="albinozertuche"  ;;
		12	) 
			respuesta="aljojuca"  ;;
		13	)
			respuesta="altepexi"  ;;
		14	)
			respuesta="amixtlan"  ;;
		15	)
			respuesta="amozoc"  ;;
		16	)
			respuesta="aquixtla"  ;;
		17	) 
			respuesta="atempan"  ;;
		18	)
			respuesta="atexcal"  ;;
		19	)
			respuesta="atlixco"  ;;
		20	)
			respuesta="atoyatempan"  ;;
		21	) 
			respuesta="atzala"  ;;
		22	)
			respuesta="atzitzihuacan"  ;;
		23	) 
			respuesta="atzitzintla"  ;;
		24	) 
			respuesta="axutla"  ;;
		25	) 
			respuesta="ayotoxcodeguerrero"  ;;
		26	)
			respuesta="calpan"  ;;
		27	)
			respuesta="caltepec"  ;;
		28	)
			respuesta="camocuautla"  ;;
		29	)
			respuesta="caxhuacan"  ;;
		30	) 
			respuesta="coatepec"  ;;
		31	)
			respuesta="coatzingo"  ;;
		32	)
			respuesta="cohetzala"  ;;
		33	)
			respuesta="cohuecan"  ;;
		34	)
			respuesta="coronango"  ;;
		35	)
			respuesta="coxcatlan"  ;;
		36	)
			respuesta="coyomeapan"  ;;
		37	)
			respuesta="coyotepec"  ;;
		38	)
			respuesta="cuapiaxtlademadero"  ;;
		39	)
			respuesta="cuautempan"  ;;
		40	) 
			respuesta="cuautinchan"  ;;
		41	)
			respuesta="cuautlancingo"  ;;
		42	)
			respuesta="cuayucadeandrade"  ;;
		43	) 
			respuesta="cuetzalandelprogreso"  ;;
		44	)
			respuesta="cuyoaco"  ;;
		45	)
			respuesta="chalchicomuladesesma"  ;;
		46	) 
			respuesta="chapulco"  ;;
		47	)
			respuesta="chiautla"  ;;
		48	)
			respuesta="chiautzingo"  ;;
		49	) 
			respuesta="chiconcuautla"  ;;
		50	)
			respuesta="chichiquila"  ;;
		51	)
			respuesta="chietla"  ;;
		52	) 
			respuesta="chigmecatitlan"  ;;
		53	)
			respuesta="chignahuapan"  ;;
		54	) 
			respuesta="chignautla"  ;;
		55	)
			respuesta="chila"  ;;
		56	)
			respuesta="chiladelasal"  ;;
		57	)
			respuesta="honey"  ;;
		58	)
			respuesta="chilchotla"  ;;
		59	) 
			respuesta="chinantla"  ;;
		60	) 
			respuesta="domingoarenas"  ;;
		61	)
			respuesta="eloxochitlan"  ;;
		62	)
			respuesta="epatlan"  ;;
		63	)
			respuesta="esperanza"  ;;
		64	)
			respuesta="franciscozmena"  ;;
		65	)
			respuesta="generalfelipeangeles"  ;;
		66	)
			respuesta="guadalupe"  ;;
		67	)
			respuesta="guadalupevictoria"  ;;
		68	) 
			respuesta="hermenegildogaleana"  ;;
		69	)
			respuesta="huaquechula"  ;;
		70	)
			respuesta="huatlatlauca"  ;;
		71	)
			respuesta="huauchinango"  ;;
		72	)
			respuesta="huehuetla"  ;;
		73	) 
			respuesta="huehuetlanelchico"  ;;
		74	) 
			respuesta="huejotzingo	"  ;;
		75	)
			respuesta="hueyapan"  ;;
		76	)
			respuesta="hueytamalco"  ;;
		77	)
			respuesta="hueytlalpan"  ;;
		78	)
			respuesta="huitzilandeserdan"  ;;
		79	)
			respuesta="huitziltepec"  ;;
		80	)
			respuesta="atlequizayan"  ;;
		81	)
			respuesta="ixcamilpadeguerrero"  ;;
		82	) 
			respuesta="ixcaquixtla"  ;;
		83	) 
			respuesta="ixtacamaxtitlan"  ;;
		84	)
			respuesta="ixtepec"  ;;
		85	) 
			respuesta="izucardematamoros"  ;;
		86	) 
			respuesta="jalpan"  ;;
		87	) 
			respuesta="jolalpan"  ;;
		88	) 
			respuesta="jonotla"  ;;
		89	) 
			respuesta="jopala"  ;;
		90	) 
			respuesta="juancbonilla"  ;;
		91	) 
			respuesta="juangalindo"  ;;
		92	)
			respuesta="juannmendez"  ;;
		93	) 
			respuesta="lafragua"  ;;
		94	) 
			respuesta="libres"  ;;
		95	)
			respuesta="lamagdalenatlatlauquitepec"  ;;
		96	) 
			respuesta="mazapiltepecdejuarez"  ;;
		97	) 
			respuesta="mixtla"  ;;
		98	)
			respuesta="molcaxac"  ;;
		99	) 
			respuesta="cañadamorelos"  ;;
		100	)
			respuesta="naupan"  ;;
		101	)
			respuesta="nauzontla"  ;;
		102	) 
			respuesta="nealtican"  ;;
		103	)
			respuesta="nicolasbravo"  ;;
		104	)
			respuesta="nopalucan"  ;;
		105	)
			respuesta="ocotepec"  ;;
		106	)
			respuesta="ocoyucan"  ;;
		107	)
			respuesta="olintla"  ;;
		108	)
			respuesta="oriental"  ;;
		109	)
			respuesta="pahuatlan"  ;;
		110	)
			respuesta="palmardebravo"  ;;
		111	)
			respuesta="pantepec"  ;;
		112	)
			respuesta="petlalcingo"  ;;
		113	) 
			respuesta="piaxtla"  ;;
		114	) 
			respuesta="puebla"  ;;
		115	)
			respuesta="quecholac"  ;;
		116	) 
			respuesta="quimixtlan"  ;;
		117	)
			respuesta="rafaellaragrajales"  ;;
		118	)
			respuesta="losreyesdejuarez"  ;;
		119	) 
			respuesta="sanandrescholula"  ;;
		120	)
			respuesta="sanantoniocañada"  ;;
		121	)
			respuesta="sandiegolamesatochimiltzingo"  ;;
		122	)
			respuesta="sanfelipeteotlalcingo"  ;;
		123	) 
			respuesta="sanfelipetepatlan"  ;;
		124	)
			respuesta="sangabrielchilac"  ;;
		125	)
			respuesta="sangregorioatzompa"  ;;
		126	)
			respuesta="sanjeronimotecuanipan"  ;;
		127	) 
			respuesta="sanjeronimoxayacatlan"  ;;
		128	)
			respuesta="sanjosechiapa"  ;;
		129	)
			respuesta="sanjosemiahuatlan"  ;;
		130	) 
			respuesta="sanjuanatenco"  ;;
		131	)
			respuesta="sanjuanatzompa"  ;;
		132	)
			respuesta="sanmartintexmelucan"  ;;
		133	)
			respuesta="sanmartintotoltepec"  ;;
		134	)
			respuesta="sanmatiastlalancaleca"  ;;
		135	) 
			respuesta="sanmiguelixitlan"  ;;
		136	)
			respuesta="sanmiguelxoxtla"  ;;
		137	) 
			respuesta="sannicolasbuenosaires"  ;;
		138	)
			respuesta="sannicolasdelosranchos"  ;;
		139	)
			respuesta="sanpabloanicano"  ;;
		140	)
			respuesta="sanpedrocholula"  ;;
		141	)
			respuesta="sanpedroyeloixtlahuaca"  ;;
		142	)
			respuesta="sansalvadorelseco"  ;;
		143	)
			respuesta="sansalvadorelverde"  ;;
		144	)
			respuesta="sansalvadorhuixcolotla"  ;;
		145	)
			respuesta="sansebastiantlacotepec"  ;;
		146	)
			respuesta="santacatarinatlaltempan"  ;;
		147	) 
			respuesta="santainesahuatempan"  ;;
		148	)
			respuesta="santaisabelcholula"  ;;
		149	) 
			respuesta="santiagomiahuatlan"  ;;
		150	)
			respuesta="huehuetlanelgrande"  ;;
		151	)
			respuesta="santotomashueyotlipan"  ;;
		152	)
			respuesta="soltepec"  ;;
		153	)
			respuesta="tecalideherrera"  ;;
		154	)
			respuesta="tecamachalco"  ;;
		155	)
			respuesta="tecomatlan"  ;;
		156	)
			respuesta="tehuacan"  ;;
		157	)
			respuesta="tehuitzingo"  ;;
		158	) 
			respuesta="tenampulco"  ;;
		159	)
			respuesta="teopantlan"  ;;
		160	) 
			respuesta="teotlalco"  ;;
		161	)
			respuesta="tepancodelopez"  ;;
		162	)
			respuesta="tepangoderodriguez"  ;;
		163	)
			respuesta="tepatlaxcodehidalgo"  ;;
		164	)
			respuesta="tepeaca"  ;;
		165	)
			respuesta="tepemaxalco"  ;;
		166	) 
			respuesta="tepeojuma"  ;;
		167	)
			respuesta="tepetzintla"  ;;
		168	)
			respuesta="tepexco"  ;;
		169	)
			respuesta="tepexiderodriguez"  ;;
		170	)
			respuesta="tepeyahualco"  ;;
		171	)
			respuesta="tepeyahualcodecuauhtemoc"  ;;
		172	)
			respuesta="teteladeocampo"  ;;
		173	)
			respuesta="tetelesdeavilacastillo"  ;;
		174	)
			respuesta="teziutlan"  ;;
		175	)
			respuesta="tianguismanalco"  ;;
		176	) 
			respuesta="tilapa"  ;;
		177	)
			respuesta="tlacotepecdebenitojuarez"  ;;
		178	)
			respuesta="tlacuilotepec"  ;;
		179	)
			respuesta="tlachichuca"  ;;
		180	)
			respuesta="tlahuapan"  ;;
		181	)
			respuesta="tlaltenango"  ;;
		182	)
			respuesta="tlanepantla"  ;;
		183	) 
			respuesta="tlaola"  ;;
		184	)
			respuesta="tlapacoya"  ;;
		185	) 
			respuesta="tlapanala"  ;;
		186	)
			respuesta="tlatlauquitepec"  ;;
		187	) 
			respuesta="tlaxco"  ;;
		188	)
			respuesta="tochimilco"  ;;
		189	)
			respuesta="tochtepec"  ;;
		190	)
			respuesta="totoltepecdeguerrero"  ;;
		191	) 
			respuesta="tulcingo"  ;;
		192	) 
			respuesta="tuzamapandegaleana"  ;;
		193	)
			respuesta="tzicatlacoyan"  ;;
		194	)
			respuesta="venustianocarranza"  ;;
		195	)
			respuesta="vicente guerrero"  ;;
		196	)
			respuesta="xayacatlandebravo"  ;;
		197	)
			respuesta="xicotepec"  ;;
		198	)
			respuesta="xicotlan"  ;;
		199	)
			respuesta="xiutetelco"  ;;
		200	)
			respuesta="xochiapulco"  ;;
		201	)
			respuesta="xochiltepec"  ;;
		202	)
			respuesta="xochitlandevicentesuarez	"  ;;
		203	)
			respuesta="xochitlantodossantos"  ;;
		204	)
			respuesta="yaonahuac"  ;;
		205	) 
			respuesta="yehualtepec"  ;;
		206	)
			respuesta="zacapala"  ;;
		207	) 
			respuesta="zacapoaxtla"  ;;
		208	)
			respuesta="zacatlan"  ;;
		209	) 
			respuesta="zapotitlan"  ;;
		210	) 
			respuesta="zapotitlandemendez"  ;;
		211	) 
			respuesta="zaragoza"  ;;
		212	) 
			respuesta="zautla	" ;;
		213	)
			respuesta="zihuateutla"  ;;
		214	)
			respuesta="zinacatepec"  ;;
		215	) 
			respuesta="zongozotla"  ;;
		216	)
			respuesta="zoquiapan"  ;;
		217) 
			respuesta="zoquitlan"  ;;
		*)			
			respuesta="NoValido"		
		;;			
	esac

	# URL a abrir
	url="$1/$respuesta"

	# Abrir la URL en el navegador predeterminado (Firefox)
	#sudo firefox -new-window -kiosk  "$url"
}

limpiarImagenesDocker()
{
	sudo docker stop $(sudo docker ps -aq)
	docker rm $(sudo docker ps -aq)
	docker system prune -a
}

verificaDirectoriosFuente()
{

	# Desea que busquemos actualizaciones en los repositorios de la PDN
	echo "¿Desea consultar el repositorio nacional de la PDN por actualizaciones? (Si/No)"

	# Leer respuesta de limpiar del Docker 
	read respuestaConsultaPDN

	# Validar respuesta de limpieza del Docker
	if [[ "$respuestaConsultaPDN" =~ ^(Si|S|s|Yes|Y|y)$ ]]; then
		#echo "Respuesta válida: $respuestaLimpiarDocker"
		echo "Consultando repositorios de la PDN"

		if [[ -d SistemaDeclaraciones_backend ]]; then
			echo "El directorio Backend fuente existe."
		else
			echo "Obteniendo archivos fuente del Backend desde PDN"
			sudo git clone https://github.com/PDNMX/SistemaDeclaraciones_backend.git
			sudo chmod a+r SistemaDeclaraciones_backend
		fi
		
		if [[ -d SistemaDeclaraciones_frontend ]]; then
			echo "El directorio Frontend existe."
		else
			echo "Obteniendo archivos fuente del Frontend desde PDN"
			sudo git clone https://github.com/PDNMX/SistemaDeclaraciones_frontend.git
			sudo chmod a+r SistemaDeclaraciones_frontend
		fi

		if [[ -d SistemaDeclaraciones_reportes ]]; then
			echo "El directorio Reportes existe."
		else
			echo "Obteniendo archivos fuente de Reportes desde PDN"
			sudo git clone https://github.com/PDNMX/SistemaDeclaraciones_reportes.git
			sudo chmod a+r SistemaDeclaraciones_reportes
		fi

		break
	fi

}

function obtenNoMunicipio() {
  # Obtener el valor del parámetro
  numero=$1

  # Validar que sea un número entero
  if ! [[ "$numero" =~ ^[0-9]+$ ]]; then
    echo "El valor ingresado no es un número válido para un municipio del Edo. de Puebla."
    exit 1
  fi

  # Validar que esté dentro del rango
  if [[ "$numero" -lt 1 || "$numero" -gt 217 ]]; then
    echo "El valor ingresado no está dentro del rango de 1 a 217."
    exit 1
  fi

  # Usar el valor dentro de la función
  echo "El valor ingresado y validado es: $numero"
  copiadoCarpetasFuente "$numero" "$2"
  
  #----------------------- Construye NGINX ------------------------------------------------------------
   ubicacion_actual=$(pwd)

   iPort=3000
   iReportPort=3001+500
   iPortWebUrl=8000

   #Del 'docker-compose.yml'
   sumaiPort=$(echo "$iPort+ $numero" | bc)
   sumaiReportPort=$(echo "$iReportPort+ $numero" | bc)
   sumaiPortWebUrl=$(echo "$iPortWebUrl+ $numero" | bc)

	configuraNGIX "$2" "$sumaiPortWebUrl" "$sumaiPort" "$numero"
	cd "$ubicacion_actual"
  #----------------------------------------------------------------------------------------------------

}

agregaNuevoNGINX ()
{
	iIpEquipo=$1
	iURLWEB=$2
	iPORTAPI=$3
	caracteresEspeciales="$1"
	nombreMunicipio="$4"

	#Cargando el archivo Ngix con el nombre de la ip del equipo : ${iIpEquipo} 

	archivo=$1
	texto_adicional="server 
{
		listen 80;
		server_name ${iIpEquipo};
			location / {
				proxy_pass http://localhost:8080;
				proxy_http_version 1.1;
				proxy_set_header Upgrade \$http_upgrade;
				proxy_set_header Connection 'upgrade';
				proxy_set_header Host \$host;
				proxy_cache_bypass \$http_upgrade;
			}
			
			location /api {
				rewrite /api(/.*)$ \$1 break;
				proxy_pass http://localhost:3000;
				proxy_http_version 1.1;
				proxy_set_header   X-Forwarded-For \$remote_addr;
				proxy_set_header   Host \$http_host;
			}
		#-------------------------------------------------------------------
		#Municipio
				location /Municipio/ {
					rewrite /Municipio(/.*)$ \$1 break;
					proxy_pass http://localhost:URLWEB;
					proxy_http_version 1.1;
					proxy_set_header   X-Forwarded-For \$remote_addr;
					proxy_set_header   Host \$http_host;
					}
						
				location /Municipio/api {
					rewrite /Municipio/api(/.*)$ \$1 break;
					proxy_pass http://localhost:PORTAPI;
					proxy_http_version 1.1;
						proxy_set_header   X-Forwarded-For \$remote_addr;
						proxy_set_header   Host \$http_host;
				}
		#-------------------------------------------------------------------

}"

	while read linea; do
	echo "$linea" >> "$archivo"
	done < "$archivo"

	echo "$texto_adicional" >> "$archivo"

	mv "$archivo" "$archivo"
    clear
	echo "Sustituyendo la palabra Municipio por el nombre:  ${nombreMunicipio}."

	#---Sustituye Municipio por el nombre obtenido
	   chmod -R 777 "$archivo"
    #Configurando el alias del municipio por el cual se personalizará el sitio
   		sudo perl -pi -e "s[Municipio][$nombreMunicipio]g" "$archivo"
    #Configurando el puerto con el cual quedo montado el sitio del municipio
   		sudo perl -pi -e "s[URLWEB][$iURLWEB]g" "$archivo"
    #Configurando el puerto del reporteador por el cual respondera el sitio
   		sudo perl -pi -e "s[PORTAPI][$iPORTAPI]g" "$archivo"				


	#---------------------------------------------

	echo "Archivo ${1} creado."

}

ModificaNGINX()
{
	iIpEquipo=$1
	iURLWEB=$2
	iPORTAPI=$3
	nombreMunicipio="$4"

	texto_original=$(cat $1)
	clear

	echo "Modificando un NGIX preexistente"


	archivo=$1

	texto_adicional="
	    	#-------------------------------------------------------
		#NuevoMunicipio
		location /NuevoMunicipio/ {
			rewrite /NuevoMunicipio(/.*)$ \$1 break;
			proxy_pass http://localhost:URLWEB;
			proxy_http_version 1.1;
			proxy_set_header   X-Forwarded-For \$remote_addr;
			proxy_set_header   Host \$http_host;
		}

		location /NuevoMunicipio/api {
			rewrite /NuevoMunicipio/api(/.*)$ \$1 break;
			proxy_pass http://localhost:PORTAPI;
			proxy_http_version 1.1;
            	proxy_set_header   X-Forwarded-For \$remote_addr;
            	proxy_set_header   Host \$http_host;
		}
		#-------------------------------------------------------
}"

# Obtener la longitud de la variable
longitud=${#texto_original}

# Extraer la última letra
ultima_letra=${texto_original:longitud-1}

# Eliminar la última palabra
texto_original_sin_ultima_palabra=${texto_original%?"}"}
#${texto_original%$" "}

#Sumando los 2 nuevos textos:
texto_final=$(echo "$texto_original_sin_ultima_palabra $texto_adicional")

#- - - - - - - - - - - - - - - - -  -- -  -- - - - - - - - - - - - - - - 

	#while read linea; do
	#echo "$linea" >> "$archivo.temp"
	#done < "$archivo"

	#echo "$texto_adicional" >> "$archivo.temp"

	#mv "$archivo.temp" "$archivo"

	echo "$texto_final" > $1

		#---Sustituye Municipio por el nombre obtenido
	chmod -R 777 "$1"
    #Configurando el alias del municipio por el cual se personalizará el sitio
   		sudo perl -pi -e "s[NuevoMunicipio][$nombreMunicipio]g" "$1"
    #Configurando el puerto con el cual quedo montado el sitio del municipio
   		sudo perl -pi -e "s[URLWEB][$iURLWEB]g" "$1"
    #Configurando el puerto del reporteador por el cual respondera el sitio
   		sudo perl -pi -e "s[PORTAPI][$iPORTAPI]g" "$1"

	echo "Archivo ${1} ha sido modificado con un nuevo municipio."

}

configuraNGIX()
{
	# $1 Es la Ip de la máquina
    idInegi=$4

	# Texto a buscar
	textoPrimeraVez="#-------------------------------------------------------"

	# Archivo a buscar
	archivo="$1"

	# Buscar el texto Municipio en el archivo base NGINX
	grep -q "$textoPrimeraVez" "$archivo"

	alMenosUnMunicipio=0

	# Si el texto se encuentra, el script tendrá un código de salida de 0 (éxito)
	if [ $? -eq 0 ]; then
		#echo "El texto '#-------------------------------------------------------' se encuentra en el archivo base de NGINX que se traduce en que ya fue personalizado 1 vez."
		alMenosUnMunicipio=1
		echo "Ya tiene al menos una personalización"
	else
		# El texto 'Municipio' no se encuentra en el archivo base de NGINX por lo que puede ser
		# que el archivo o nunca ha sido modificado o ya fue modificado al menos 1 vez"
		# Averiguar si ya 
		alMenosUnMunicipio=0
		echo "No tiene ninguna personalización"
	fi



	#echo "Municipio a identificar : $idInegi"
    #########################################################################
	valor=$idInegi

	case $valor in			
		1   )
			respuesta="acajete"  ;;
		2	)
			respuesta="acateno"  ;;
		3	)
			respuesta="acatlan"  ;;
		4	)
			respuesta="acatzingo"  ;;
		5	)
			respuesta="acteopan"  ;;
		6	)
			respuesta="ahuacatlan"  ;;
		7	)
			respuesta="ahuatlan"  ;;
		8	)
			respuesta="ahuazotepec"  ;;
		9	)
			respuesta="ahuehuetitla"  ;;
		10	)
			respuesta="ajalpan"  ;;
		11	)
			respuesta="albinozertuche"  ;;
		12	) 
			respuesta="aljojuca"  ;;
		13	)
			respuesta="altepexi"  ;;
		14	)
			respuesta="amixtlan"  ;;
		15	)
			respuesta="amozoc"  ;;
		16	)
			respuesta="aquixtla"  ;;
		17	) 
			respuesta="atempan"  ;;
		18	)
			respuesta="atexcal"  ;;
		19	)
			respuesta="atlixco"  ;;
		20	)
			respuesta="atoyatempan"  ;;
		21	) 
			respuesta="atzala"  ;;
		22	)
			respuesta="atzitzihuacan"  ;;
		23	) 
			respuesta="atzitzintla"  ;;
		24	) 
			respuesta="axutla"  ;;
		25	) 
			respuesta="ayotoxcodeguerrero"  ;;
		26	)
			respuesta="calpan"  ;;
		27	)
			respuesta="caltepec"  ;;
		28	)
			respuesta="camocuautla"  ;;
		29	)
			respuesta="caxhuacan"  ;;
		30	) 
			respuesta="coatepec"  ;;
		31	)
			respuesta="coatzingo"  ;;
		32	)
			respuesta="cohetzala"  ;;
		33	)
			respuesta="cohuecan"  ;;
		34	)
			respuesta="coronango"  ;;
		35	)
			respuesta="coxcatlan"  ;;
		36	)
			respuesta="coyomeapan"  ;;
		37	)
			respuesta="coyotepec"  ;;
		38	)
			respuesta="cuapiaxtlademadero"  ;;
		39	)
			respuesta="cuautempan"  ;;
		40	) 
			respuesta="cuautinchan"  ;;
		41	)
			respuesta="cuautlancingo"  ;;
		42	)
			respuesta="cuayucadeandrade"  ;;
		43	) 
			respuesta="cuetzalandelprogreso"  ;;
		44	)
			respuesta="cuyoaco"  ;;
		45	)
			respuesta="chalchicomuladesesma"  ;;
		46	) 
			respuesta="chapulco"  ;;
		47	)
			respuesta="chiautla"  ;;
		48	)
			respuesta="chiautzingo"  ;;
		49	) 
			respuesta="chiconcuautla"  ;;
		50	)
			respuesta="chichiquila"  ;;
		51	)
			respuesta="chietla"  ;;
		52	) 
			respuesta="chigmecatitlan"  ;;
		53	)
			respuesta="chignahuapan"  ;;
		54	) 
			respuesta="chignautla"  ;;
		55	)
			respuesta="chila"  ;;
		56	)
			respuesta="chiladelasal"  ;;
		57	)
			respuesta="honey"  ;;
		58	)
			respuesta="chilchotla"  ;;
		59	) 
			respuesta="chinantla"  ;;
		60	) 
			respuesta="domingoarenas"  ;;
		61	)
			respuesta="eloxochitlan"  ;;
		62	)
			respuesta="epatlan"  ;;
		63	)
			respuesta="esperanza"  ;;
		64	)
			respuesta="franciscozmena"  ;;
		65	)
			respuesta="generalfelipeangeles"  ;;
		66	)
			respuesta="guadalupe"  ;;
		67	)
			respuesta="guadalupevictoria"  ;;
		68	) 
			respuesta="hermenegildogaleana"  ;;
		69	)
			respuesta="huaquechula"  ;;
		70	)
			respuesta="huatlatlauca"  ;;
		71	)
			respuesta="huauchinango"  ;;
		72	)
			respuesta="huehuetla"  ;;
		73	) 
			respuesta="huehuetlanelchico"  ;;
		74	) 
			respuesta="huejotzingo	"  ;;
		75	)
			respuesta="hueyapan"  ;;
		76	)
			respuesta="hueytamalco"  ;;
		77	)
			respuesta="hueytlalpan"  ;;
		78	)
			respuesta="huitzilandeserdan"  ;;
		79	)
			respuesta="huitziltepec"  ;;
		80	)
			respuesta="atlequizayan"  ;;
		81	)
			respuesta="ixcamilpadeguerrero"  ;;
		82	) 
			respuesta="ixcaquixtla"  ;;
		83	) 
			respuesta="ixtacamaxtitlan"  ;;
		84	)
			respuesta="ixtepec"  ;;
		85	) 
			respuesta="izucardematamoros"  ;;
		86	) 
			respuesta="jalpan"  ;;
		87	) 
			respuesta="jolalpan"  ;;
		88	) 
			respuesta="jonotla"  ;;
		89	) 
			respuesta="jopala"  ;;
		90	) 
			respuesta="juancbonilla"  ;;
		91	) 
			respuesta="juangalindo"  ;;
		92	)
			respuesta="juannmendez"  ;;
		93	) 
			respuesta="lafragua"  ;;
		94	) 
			respuesta="libres"  ;;
		95	)
			respuesta="lamagdalenatlatlauquitepec"  ;;
		96	) 
			respuesta="mazapiltepecdejuarez"  ;;
		97	) 
			respuesta="mixtla"  ;;
		98	)
			respuesta="molcaxac"  ;;
		99	) 
			respuesta="cañadamorelos"  ;;
		100	)
			respuesta="naupan"  ;;
		101	)
			respuesta="nauzontla"  ;;
		102	) 
			respuesta="nealtican"  ;;
		103	)
			respuesta="nicolasbravo"  ;;
		104	)
			respuesta="nopalucan"  ;;
		105	)
			respuesta="ocotepec"  ;;
		106	)
			respuesta="ocoyucan"  ;;
		107	)
			respuesta="olintla"  ;;
		108	)
			respuesta="oriental"  ;;
		109	)
			respuesta="pahuatlan"  ;;
		110	)
			respuesta="palmardebravo"  ;;
		111	)
			respuesta="pantepec"  ;;
		112	)
			respuesta="petlalcingo"  ;;
		113	) 
			respuesta="piaxtla"  ;;
		114	) 
			respuesta="puebla"  ;;
		115	)
			respuesta="quecholac"  ;;
		116	) 
			respuesta="quimixtlan"  ;;
		117	)
			respuesta="rafaellaragrajales"  ;;
		118	)
			respuesta="losreyesdejuarez"  ;;
		119	) 
			respuesta="sanandrescholula"  ;;
		120	)
			respuesta="sanantoniocañada"  ;;
		121	)
			respuesta="sandiegolamesatochimiltzingo"  ;;
		122	)
			respuesta="sanfelipeteotlalcingo"  ;;
		123	) 
			respuesta="sanfelipetepatlan"  ;;
		124	)
			respuesta="sangabrielchilac"  ;;
		125	)
			respuesta="sangregorioatzompa"  ;;
		126	)
			respuesta="sanjeronimotecuanipan"  ;;
		127	) 
			respuesta="sanjeronimoxayacatlan"  ;;
		128	)
			respuesta="sanjosechiapa"  ;;
		129	)
			respuesta="sanjosemiahuatlan"  ;;
		130	) 
			respuesta="sanjuanatenco"  ;;
		131	)
			respuesta="sanjuanatzompa"  ;;
		132	)
			respuesta="sanmartintexmelucan"  ;;
		133	)
			respuesta="sanmartintotoltepec"  ;;
		134	)
			respuesta="sanmatiastlalancaleca"  ;;
		135	) 
			respuesta="sanmiguelixitlan"  ;;
		136	)
			respuesta="sanmiguelxoxtla"  ;;
		137	) 
			respuesta="sannicolasbuenosaires"  ;;
		138	)
			respuesta="sannicolasdelosranchos"  ;;
		139	)
			respuesta="sanpabloanicano"  ;;
		140	)
			respuesta="sanpedrocholula"  ;;
		141	)
			respuesta="sanpedroyeloixtlahuaca"  ;;
		142	)
			respuesta="sansalvadorelseco	"  ;;
		143	)
			respuesta="sansalvadorelverde"  ;;
		144	)
			respuesta="sansalvadorhuixcolotla"  ;;
		145	)
			respuesta="sansebastiantlacotepec"  ;;
		146	)
			respuesta="santacatarinatlaltempan"  ;;
		147	) 
			respuesta="santainesahuatempan"  ;;
		148	)
			respuesta="santaisabelcholula"  ;;
		149	) 
			respuesta="santiagomiahuatlan"  ;;
		150	)
			respuesta="huehuetlanelgrande"  ;;
		151	)
			respuesta="santotomashueyotlipan"  ;;
		152	)
			respuesta="soltepec"  ;;
		153	)
			respuesta="tecalideherrera"  ;;
		154	)
			respuesta="tecamachalco"  ;;
		155	)
			respuesta="tecomatlan"  ;;
		156	)
			respuesta="tehuacan"  ;;
		157	)
			respuesta="tehuitzingo"  ;;
		158	) 
			respuesta="tenampulco"  ;;
		159	)
			respuesta="teopantlan"  ;;
		160	) 
			respuesta="teotlalco"  ;;
		161	)
			respuesta="tepancodelopez"  ;;
		162	)
			respuesta="tepangoderodriguez"  ;;
		163	)
			respuesta="tepatlaxcodehidalgo"  ;;
		164	)
			respuesta="tepeaca"  ;;
		165	)
			respuesta="tepemaxalco"  ;;
		166	) 
			respuesta="tepeojuma"  ;;
		167	)
			respuesta="tepetzintla"  ;;
		168	)
			respuesta="tepexco"  ;;
		169	)
			respuesta="tepexiderodriguez"  ;;
		170	)
			respuesta="tepeyahualco"  ;;
		171	)
			respuesta="tepeyahualcodecuauhtemoc"  ;;
		172	)
			respuesta="teteladeocampo"  ;;
		173	)
			respuesta="tetelesdeavilacastillo"  ;;
		174	)
			respuesta="teziutlan"  ;;
		175	)
			respuesta="tianguismanalco"  ;;
		176	) 
			respuesta="tilapa"  ;;
		177	)
			respuesta="tlacotepecdebenitojuarez"  ;;
		178	)
			respuesta="tlacuilotepec"  ;;
		179	)
			respuesta="tlachichuca"  ;;
		180	)
			respuesta="tlahuapan"  ;;
		181	)
			respuesta="tlaltenango"  ;;
		182	)
			respuesta="tlanepantla"  ;;
		183	) 
			respuesta="tlaola"  ;;
		184	)
			respuesta="tlapacoya"  ;;
		185	) 
			respuesta="tlapanala"  ;;
		186	)
			respuesta="tlatlauquitepec"  ;;
		187	) 
			respuesta="tlaxco"  ;;
		188	)
			respuesta="tochimilco"  ;;
		189	)
			respuesta="tochtepec"  ;;
		190	)
			respuesta="totoltepecdeguerrero"  ;;
		191	) 
			respuesta="tulcingo"  ;;
		192	) 
			respuesta="tuzamapandegaleana"  ;;
		193	)
			respuesta="tzicatlacoyan"  ;;
		194	)
			respuesta="venustianocarranza"  ;;
		195	)
			respuesta="vicenteguerrero"  ;;
		196	)
			respuesta="xayacatlandebravo"  ;;
		197	)
			respuesta="xicotepec"  ;;
		198	)
			respuesta="xicotlan"  ;;
		199	)
			respuesta="xiutetelco"  ;;
		200	)
			respuesta="xochiapulco"  ;;
		201	)
			respuesta="xochiltepec"  ;;
		202	)
			respuesta="xochitlandevicentesuarez	"  ;;
		203	)
			respuesta="xochitlantodossantos"  ;;
		204	)
			respuesta="yaonahuac"  ;;
		205	) 
			respuesta="yehualtepec"  ;;
		206	)
			respuesta="zacapala"  ;;
		207	) 
			respuesta="zacapoaxtla"  ;;
		208	)
			respuesta="zacatlan"  ;;
		209	) 
			respuesta="zapotitlan"  ;;
		210	) 
			respuesta="zapotitlandemendez"  ;;
		211	) 
			respuesta="zaragoza"  ;;
		212	) 
			respuesta="zautla" ;;
		213	)
			respuesta="zihuateutla"  ;;
		214	)
			respuesta="zinacatepec"  ;;
		215	) 
			respuesta="zongozotla"  ;;
		216	)
			respuesta="zoquiapan"  ;;
		217) 
			respuesta="zoquitlan"  ;;
		*)			
			respuesta="NoValido"		
		;;			
	esac	

    #########################################################################
	#echo "Municipio obtendido : $respuesta"

	cd -P /etc/nginx
	cd sites-enabled
	sudo rm -f $1
	cd ..
	cd sites-available
	echo "-----------  Archivo de NGINX para la IP ${1}  -------------"


	#Localiza o crea el archivo Ngix necesario
   	if [ -f "$1" ]; then
		if[ alMenosUnMunicipio == 1]
		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  		#Crea el nuevo archivo ${iIpEquipo} a partir de archivo default
		#echo "El archivo $iIpEquipo necesario ya existe."
		chmod -R 777 $1
		#Modo 1
		#clear
		ModificaNGINX $1 $2 $3 "$respuesta"
		echo "ACTUALIZACION : En la IP_$1 se agrego el portal web en el puerto $2 y url de reportes $3 del municipio $respuesta"
		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	else
			#echo "Se va a crear un nuevo archivo ${1}."
			chmod -R 777 $1
			#Modo 2
			#clear
			#echo "Nombre del municipio a crear: $NombreMunicipio"
			agregaNuevoNGINX $1 $2 $3 "$respuesta"
			echo "NUEVO : En la IP_$1 se agrego el portal web en el puerto $2 y url de reportes $3 del municipio $respuesta"
			#ls
	fi
	NombreMunicipio="$respuesta"

	#############################################################
	#RECONSTRUYE Y LANZA EL NGINX
	sudo ln -s /etc/nginx/sites-available/$1 /etc/nginx/sites-enabled/$1
	sudo nginx -t
	sudo nginx -s reload
	#############################################################
}

principal()
{
	#- - - - - - - - -  -- P R O G R A M A   P R I N C I P A L - - - - - - - - - - - - - - - - - - - - - - - - 
	#- - - - - - - - -  -- C A R P E T A S   F U E N T E S   P D N - - -  - - - - - - - - - - - - - - - - - - - - - 
	#Existen los archivos fuentes?
	verificaDirectoriosFuente
	#- - - - - - - - -  -- - - - D E S P L I E G A  P O R T A L - - - - - - - - - - - - - - - - - - - - - 
	clear
	echo "Ingrese un número entre 1 y 217:"
	#echo "Ingrese un número entre 1 y 217: "
	read numero
	#- - - - - - - - - -  - -  - - - - - - - 
    #- - - - - - - - - - - - - - - - - - - -
	echo "Escriba su número de ip local:"
	#echo "Escriba su número de ip local: "
	read numeroIp	
	obtenNoMunicipio "$numero" "$numeroIp"

	#- - - - - - - - - - - -    L I M P I A R    C O N T E N E D O R E S    D O C K E R - - - - - - - - - -
	# Mostrar pregunta para limpiar el Docker
	echo "¿Desea limpiar todo el Docker? (Si/No/s/n)"
	#echo "¿Desea limpiar todo el Docker? (Si/No)"

	# Leer respuesta de limpiar del Docker 
	read respuestaLimpiarDocker

	# Validar respuesta de limpieza del Docker
	if [[ "$respuestaLimpiarDocker" =~ ^(Si|S|s|Yes|Y|y)$ ]]; then
		#echo "Respuesta válida: $respuestaLimpiarDocker"
		echo "Se procede a limpiar las imagenes el Docker"
		limpiarImagenesDocker
		break
	fi	

	#- - - - - - - - -  - -  R E C O N S T R U Y E   L O S   C O N T E N E D O R E S    D  O  C  K  E  R   - - - - - - - - - - - - - - - - - - - 
	# Mostrar pregunta para continuar a la reconstrucción del Docker
	echo "¿Desea reconstruir el Docker? (Si/No/s/n)" 
	#echo "¿Desea reconstruir el Docker? (Si/No)"

	#Leer respuesta de reconstrucción del Docker 
	read respuestaDocker

	# Validar respuesta de reconstrucción del Docker
	if [[ "$respuestaDocker" =~ ^(Si|S|s)$ ]]; then
		#echo "Respuesta válida: $respuestaDocker"
		echo "Se procede a reconstruir el Docker"
		reconstruyeDocker "$numeroIp" "$numero"
		break
	fi
	#- - - - - - - - -  -- - - - - - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - 
	tput setaf 2 ; tput setab 0 ; echo "Portal de Declaraciones Patrimoniales del Municipio $NombreMunicipio ha sido desplegado."
}


principal
