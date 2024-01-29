#!/bin/bash

#23 Agosto 2023
#USTPD

# Define el origen de los archivos fuente y la ruta destino de la copia realizada
# a las 3 carpetas
# iNoINEGI

copiadoCarpetasFuente()
{
	clear
	echo -e "\033[37m Secretaría Ejecutiva del Sistema Estatal Anticorrupción Puebla - SESEAP \033[0m"
	iNoINEGI=9
	sNoINEGI=$(printf "%d" ${iNoINEGI})
	#echo ${sNoINEGI}
	#echo "Inicia verificación del valor asignado"
	set -m
	if [[ $iNoINEGI < 10 ]];
	  then
	    echo "Si fue menor a 10"
		sCeros="0"
        sNoINEGI+="00"+$sNoINEGI
		echo ${sNoINEGI}
	  else
		if [[ $iNoINEGI < 100 ]];
			then
				echo "Fue menor a 100"
				sCeros="00"
        		sNoINEGI+="0"+$sNoINEGI
				echo ${sNoINEGI}
		fi
	fi


    #Limpia instalaciones previas
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
	

	echo "Creando directorio raíz para el municipio ${sNoINEGI}"

	#echo ${sNoINEGI}

	sudo mkdir -p "${sNoINEGI}" -m 777
	cd "${sNoINEGI}"

	# B A C K E N D -- - - - - - - - - - - - - - - - - - - - - - - - 
	echo "Número de municipio a crear : $sNoINEGI"
	# &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	# Ruta de origen y destino
	ruta_origen="/home/pdepuebla/SistemaDeclaraciones_backend"
	#ruta_destino="/".$sNoINEGI."/SistemaDeclaraciones_backend"
	ruta_destino=$(printf "%s" "./")

	# Verificar si la carpeta de destino existe, si no, crearla
	if [ ! -d "$ruta_destino" ]; then
	    mkdir -p "$ruta_destino" -m 755
	fi

	# Copiar la carpeta y su contenido a la ruta de destino
	cp -r "$ruta_origen" "$ruta_destino"
	echo -e "\033[33m&&&&&&&&&&&&&&&&&&&&  B A C K E N D  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& \033[0m"
	echo "Carpeta Backend copiada para el municipio con número de INEGI: " $sNoINEGI
	cd SistemaDeclaraciones_backend
	configuraBackend_env ${iNoINEGI}
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
	configuraFrontend_environment ${iNoINEGI} "192.168.0.200"
	#cd SistemaDeclaraciones_frontend
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
   iReportPort=3001

   #Del 'docker-compose.yml'
   sumaiPort=$(echo "$iPort+ $1" | bc)
   sumaiElasticSearch=$(echo "$iElasticSearch+ $1" | bc)
   sumaiElasticSearchExtra=$(echo "$iElasticSearch+100+ $1" | bc)
   sumaiReportPort=$(echo "$iReportPort+ $1" | bc)
   nuevaBaseDatos=$(echo "declaraciones_+ $1" | bc)

   #Cargando el archivo .env
   chmod -R 777 .env
   #Configurando el archivo .env del BACKEND
   		sudo perl -pi -e "s[PORT=3000][PORT=$sumaiPort]g" .env
		echo "Variable PORT del .env configurada con el valor: ${sumaiPort}"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   		sudo perl -pi -e "s[ELASTIC_SEARCH_URL=http://localhost:9200][ELASTIC_SEARCH_URL=http://localhost:$sumaiElasticSearch]g" .env
		echo "Variable puerto del Elastic Search en el .env configurada con el valor: ${sumaiElasticSearch}"		
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -		
   		sudo perl -pi -e "s[REPORTS_URL=http://localhost:3001][REPORTS_URL=http://localhost:$sumaiReportPort]g" .env
		echo "Variable ReportPort del .env configurada con el valor: ${sumaiReportPort}"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -		
   		sudo perl -pi -e "s[MONGO_DB=declaraciones][MONGO_DB=declaraciones_$nuevaBaseDatos]g" .env
		echo "Variable Mongo_DB del .env configurada con el valor: ${nuevaBaseDatos}"		
   #Configurando el archivo .env del BACKEND

   #Configurando el archivo docker-compose.yml del BACKEND
		#Cargando el archivo docker-compose.yml
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

   IPComputer=$2
   iPageUrl=4200
   sumaiPageUrlPort=$(echo "$iPageUrl + $1" | bc)

   #Cargando el archivo environment.prod.ts -- - - - - - - - - - - - - - - - - - 
   chmod -R 777 environment.prod.ts
   #Configurando el archivo environment.prod.ts
   		sudo perl -pi -e "s[serverUrl: 'http://localhost:3000,'][serverUrl: 'http://$IPComputer/api',]g" environment.prod.ts
		echo "Se ha preconfigurado el Server Url para el NGINX  cambiando el puerto 3000 por el valor de la IP : ${IPComputer}/api"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		sudo perl -pi -e "s[pageUrl: 'http://localhost:4200/','][pageUrl: 'http://localhost:$sumaiPageUrlPort/,']g" environment.prod.ts
		echo "Preconfigurado de la Page Url para utilizar el NGINX  cambiando el puerto 4200 por el valor : ${sumaiPageUrlPort}"
   

   #Cargando el archivo environment.ts - - - - - - - - - - - - - - - - - - - 
   chmod -R 777 environment.ts
   #Configurando el archivo environment.ts
   		sudo perl -pi -e "s[serverUrl: 'http://localhost:3000,'][serverUrl: 'http://$IPComputer/api',]g" environment.ts
		echo "Se ha preconfigurado el Server Url para el NGINX  cambiando el puerto 3000 por el valor de la IP : ${IPComputer}/api"
		#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
		sudo perl -pi -e "s[pageUrl: 'http://localhost:4200/','][pageUrl: 'http://localhost:$sumaiPageUrlPort/,']g" environment.ts
		echo "Preconfigurado de la Page Url para el NGINX  cambiando el puerto 4200 por el valor : ${sumaiPageUrlPort}"
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
   sumaiPort=$(echo "$iPort + $1" | bc)

   #Cargando el archivo .env -- - - - - - - - - - - - - - - - - - 
   chmod -R 777 .env
   #Configurando el archivo .env
   		sudo perl -pi -e "s[Port=3000][Port=$sumaiPort]g" .env
		echo "Se ha configurado el puerto de impresión 3000 por el nuevo valor ${sumaiPort}"
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
   		sudo perl -pi -e "s[  webapp:][  webapp_$sumaiPort:]g" docker-compose.yml
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

   iPort=3001
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
	#Reconstruye el Backend
	cd SistemaDeclaraciones_backend
        sudo git pull
        sudo docker-compose -p declaraciones-backend up -d --build --force-recreate
	echo "Backend y reportes reconstruidos..."
        cd SistemaDeclaraciones_frontend
        sudo git pull
        sudo docker-compose -p declaraciones-frontend up -d --build --force-recreate
        echo "Frontend reconstruido..."

}

limpiarImagenesDocker()
{
	sudo docker stop $(sudo docker ps -aq)
	docker rm $(sudo docker ps -aq)
	docker system prune -a
}

#- - - - - - - - -  -- - - - - - - - - - - - - - - - - - - - - - - - - 
# Mostrar pregunta para limpiar el Docker
  echo "¿Desea limpiar todo el Docker? (Si/No)"

# Leer respuesta de limpiar del Docker 
  read respuestaLimpiarDocker

# Validar respuesta de limpieza del Docker
  if [[ "$respuestaLimpiarDocker" =~ ^(Si|S|s)$ ]]; then
    #echo "Respuesta válida: $respuestaLimpiarDocker"
	echo "Se procede a limpiar las imagenes el Docker"
	limpiarImagenesDocker
    break
  fi
#- - - - - - - - -  -- - - - - - - - - - - - - - - - - - - - - - - - - 

clear
echo "Inicia el proceso"
copiadoCarpetasFuente

#- - - - - - - - -  -- - - - - - - - - - - - - - - - - - - - - - - - - 
# Mostrar pregunta para continuar a la reconstrucción del Docker
  echo "¿Desea reconstruir el Docker? (Si/No)"

# Leer respuesta de reconstrucción del Docker 
  read respuestaDocker

# Validar respuesta de reconstrucción del Docker
  if [[ "$respuestaDocker" =~ ^(Si|S|s)$ ]]; then
    #echo "Respuesta válida: $respuestaDocker"
	echo "Se procede a reconstruir el Docker"
	reconstruyeDocker
    break
  else
    echo "Portal de Declaraciones Patrimoniales del Municipio  ha sido desplegado."
  fi
#- - - - - - - - -  -- - - - - - - - - - - - - - - - - - - - - - - - - 

