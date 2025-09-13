#!/usr/bin/env bash
set -euo pipefail

DIRECTORIO_RAIZ="$(dirname "$(dirname "$(realpath "$0")")")"
DIRECTORIO_SALIDA="${DIRECTORIO_RAIZ}/out/tls"
mkdir -p "${DIRECTORIO_SALIDA}"

#Mostrar informacion sobre la conexion y la cadena de certificados
openssl s_client -connect "${TARGETS}:${PORT}" -servername "${TARGETS}" -showcerts -verify_return_error < /dev/null > "${DIRECTORIO_SALIDA}/info_tls.txt"
#Contar el numero de elementos en la cadena
n=$(grep -c "^-----END CERTIFICATE-----$" "${DIRECTORIO_SALIDA}/info_tls.txt")
#Creacion de archivo reporte.txt
echo -e '\nCADENA DE CERTIFICADOS\n' > "${DIRECTORIO_SALIDA}/reporte.txt"
#Crear archivos para cada certificado en la cadena
for i in $(seq 1 "${n}"); do
    #Guarda el certificado i
    sed -n "1,/^-----END CERTIFICATE-----$/p" "${DIRECTORIO_SALIDA}/info_tls.txt" > "${DIRECTORIO_SALIDA}/cert${i}.txt"
    #Mejorar el formato
    sed -e "s/s:/sujeto: /; s/i:/emisor: /; s/a:/algoritmo: /; s/v:/vigencia: /; s/NotBefore:/Desde:/; s/NotAfter:/Hasta:/" "${DIRECTORIO_SALIDA}/cert${i}.txt" > "${DIRECTORIO_SALIDA}/aux.txt"
    mv "${DIRECTORIO_SALIDA}/aux.txt" "${DIRECTORIO_SALIDA}/cert${i}.txt"
    #Borrar el certificado i del archivo
    sed "1,/^-----END CERTIFICATE-----$/d" "${DIRECTORIO_SALIDA}/info_tls.txt" > "${DIRECTORIO_SALIDA}/aux.txt"
    mv "${DIRECTORIO_SALIDA}/aux.txt" "${DIRECTORIO_SALIDA}/info_tls.txt"
    #Presentar el certificado en el reporte
    if [ "$i" -eq 1 ];then
        #Eliminar las 3 primeras lineas del primer certificado, no contienen informacion relevante, ademas iguala el formato del resto
        sed -i "1,3d" "${DIRECTORIO_SALIDA}/cert1.txt"
        echo "Certificado del servidor" >> "${DIRECTORIO_SALIDA}/reporte.txt"
    elif [ "$i" -eq "${n}" ]; then
        echo "Certificado raiz" >> "${DIRECTORIO_SALIDA}/reporte.txt"
    else 
        echo "Certificado intermedio" >> "${DIRECTORIO_SALIDA}/reporte.txt"
    fi
    sed -n -e "1s/^/\t- /p" -e "2s/^/\t- /p" -e "4s/^/\t- /p" "${DIRECTORIO_SALIDA}/cert${i}.txt" >> "${DIRECTORIO_SALIDA}/reporte.txt"
done
#Agregar el resto de datos al reporte
#Remover el primer campo, tiene informacion repetida
sed "1,/^---$/d" "${DIRECTORIO_SALIDA}/info_tls.txt" > "${DIRECTORIO_SALIDA}/aux.txt"
mv "${DIRECTORIO_SALIDA}/aux.txt" "${DIRECTORIO_SALIDA}/info_tls.txt"
#Limpiar el archivo y dando formato
sed '0,/---/{/---/d}; $d' "${DIRECTORIO_SALIDA}/info_tls.txt" > "${DIRECTORIO_SALIDA}/aux.txt"
mv "${DIRECTORIO_SALIDA}/aux.txt" "${DIRECTORIO_SALIDA}/info_tls.txt"
sed "1i\\\nAUTENTICACION CLIENTE/SERVIDOR Y HANDSHAKE\n" "${DIRECTORIO_SALIDA}/info_tls.txt" > "${DIRECTORIO_SALIDA}/aux.txt"
mv "${DIRECTORIO_SALIDA}/aux.txt" "${DIRECTORIO_SALIDA}/info_tls.txt"
sed "s/---/\nESTADO DE LA SESION\n/" "${DIRECTORIO_SALIDA}/info_tls.txt" > "${DIRECTORIO_SALIDA}/aux.txt"
mv "${DIRECTORIO_SALIDA}/aux.txt" "${DIRECTORIO_SALIDA}/info_tls.txt" 
cat "${DIRECTORIO_SALIDA}/info_tls.txt" "${DIRECTORIO_SALIDA}/reporte.txt" > "${DIRECTORIO_SALIDA}/aux.txt"
mv "${DIRECTORIO_SALIDA}/aux.txt" "${DIRECTORIO_SALIDA}/reporte.txt"


