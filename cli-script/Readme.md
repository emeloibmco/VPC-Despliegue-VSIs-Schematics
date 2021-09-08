# VPC Despliegue VSIs  ☁
*IBM® Cloud Schematics* 

La presente guía esta enfocada en crear un despliegue de un grupo de servidores virtuales en un ambiente de nube privada virtual (VPC) en una cuenta de IBM Cloud.

<br />

## Índice  📰
1. [Pre-Requisitos](#Pre-Requisitos-pencil)
2. [Crear y configurar una VPC, una subred y una ssh key en cada zona (Osaka, Tokio)](#crear-y-configurar-una-vpc-una-subred-y-una-ssh-key-en-cada-zona-dallas-washington)
3. [Generar el despliegue de las VSIs mediante un script]
4. [Eliminar las VSIs]
7. [Acceder a la ultima VSI creada](#acceder-a-la-ultima-vsi-creada)
8. [Autores](#Autores-black_nib)
<br />

## Pre Requisitos :pencil:
* Contar con una cuenta en <a href="https://cloud.ibm.com/"> IBM Cloud</a>.
* Contar con un grupo de recursos específico para la implementación de los recursos.
* Crear una ssh key en cada una de las dos zonas donde se realizara el despliegue de las VSI
* Crear una VPC en cada una de las dos zonas donde se realizara el despliegue de las VSI con su respectivo segmento de red
<br />

## Crear y configurar una VPC, una subred y una ssh key en cada zona (Dallas, Washington)

### VPC
1. Desde el menú de navegación o menú de hamburguesa seleccione la pestaña ```Infraestructura VPC```.
2. En esta pestaña, en la sección de red/network seleccione la opción de ```VPCs``` y de click en el botón de ```crear```.
3. Una vez se encuentre en la ventana de configuración de la VPC complete la información necesaria de la siguiente manera:

   * ```Nombre/Name```: asignele un nombre a la VPC, **para la VPC ubicada en Osaka utilice el nombre ```vpc-demo-osa``` y para la VPC ubicada en Tokio utilice el nombre ```vpc-demo-tok```**.
   * ```Grupo de recursos/Resource group```: Seleccione el grupo de recursos en el cual va a desplegar la VPN.
   * ```Ubicación/Region```: Seleccione la ubicación en la cual desea implementar la VPC (Osaka o Tokio).
   * ```Grupo de seguridad predeterminado```: Deje seleccionadas las opciones Permitir SSH/Allow SSH y Permitir ping/Allow ping.
  

4. Una vez haya terminado de llenar esta información de click en el botón ```Crear nube privada virtual/Create virtual private cloud```.


<p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/2b4d674a94203d40ae6ab955b9c909203e42ae9f/VPC.gif>
</p>

### Subred
El siguiente paso consiste en crear un Subred en la *VPC*. Para ello, en la sección de ```Red``` seleccione la opción ```Subredes``` y de click en el botón ```Crear```. Una vez le aparezca la ventana para la configuración y creación de la subred, complete lo siguiente:

* ```Nombre```: asignele un nombre a la subred, **para la subred ubicada en Osaka utilice el nombre ```subred-demo-osa```y para la subred ubicada en Tokio utilice el nombre ```subred-demo-tok```**.
* ```Grupo de recursos```: seleccione el grupo de recursos en el cual va a trabajar (el mismo seleccionado en la creación de la *VPC*).
* ```Ubicación```: seleccione la ubicación en la cual desea implementar la subred (la misma seleccionada en la creación de la *VPC*, Osaka#1 o Tokio#1).
* ```Nube privada virtual```: seleccione la *VPC* que creó anteriormente.
* Los demás parámetros no los modifique, deje los valores establecidos por defecto.

Cuando ya tenga todos los campos configurados de click en el botón ```Crear subred```.
<p align="center"><img width="700" src="https://github.com/emeloibmco/VPC-Despliegue-VSI-Acceso-SSH/blob/main/Imagenes/subnet.gif"></p>

6. Espere unos minutos mientras la subred aparece en estado disponible y asegúrese de tener seleccionada la región en la cual la implementó.

<br />


### SSH key
1. para crear una ssh key es necesario obtener primero una llave publica, a continuación se muestra una de las opciones en las que se puede generar el par de llaves SSH para esto tenga en cuenta los siguientes pasos:
   * Acceda al *IBM Cloud Shell* e ingrese el siguiente comando: 
   ```
   ssh-keygen -t rsa -C "user_id" 
   ```
   * Al colocar el comando anterior, en la consola se pide que especifique la ubicación, en este caso oprima la tecla Enter para que se guarde en la ubicación sugerida. Posteriormente, cuando se pida la ```Passphrase ```coloque una contraseña que pueda recordar o guárdela, ya que se utilizará más adelante.
   * Muévase con el comando 
   ```cd .ssh``` a la carpeta donde están los archivos ```id_rsa.pub``` y ```id_rsa```. Estos archivos contienen las claves públicas y privadas respectivamente.
   * Copie el valor de la clave pública, utilice el comando: 
   ```
   cat id_rsa.pub
   ```
 
2. Una vez obtenida la llave publica desde la pestaña de infraestructura VPC seleccione la opción ```SSH keys```y de click en el botón ```crear```
3. Cuando se encuentre en la ventana de configuración complete la información necesaria de la siguiente manera:
   * ```Nombre/Name```: asignele un nombre a la SSH key, **para la SSH key ubicada en Osaka utilice el nombre ```key-demo-osa```y para la SSH key ubicada en Tokio utilice el nombre ```key-demo-tok```**.
   * ```Grupo de recursos/Resource group```: Seleecione el grupo de recursos en el cual va a desplegar la VPN.
   * ```Grupo de recursos/Resource group```: Seleccione el grupo de recursos en el cual desplego la VPC y la subred creadas anteriormente.
   * ```Ubicación/Region```: Seleccione la misma ubicación en la cual desplego la VPC y la subred creadas anteriormente.
   * ```Llave publica/Public key```: Pegue el valor de la llave púbica obtenido en el numeral 1.
4. Una vez haya completado toda la información necesaria de click en el botón ```Agregar SSH key/Add SSH key```.

 <p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/2bef55b7c51b55bd02f8eec81779d5ddaa2cb5c4/SSHkey.gif>
</p>
 
> Nota: `Para acceder a las instancias creadas con la llave publica configurada anteriormente, es necesario conservar localmente la componente privada de la llave`








## Generar el despliegue de las VSIs mediante un script
Para generar el despliegue los servidores tenga en cuenta los siguientes pasos:

1. Teniendo en cuenta que el despliegue de las 100 VSIs se realizara en las regiones de Osaka y tokio, antes de comenzar es necesario verificar que la creacion de los recursos neceasrios se haya realizado adecuadamente y que cada una de estas variables tenga el nombre adecuado, estos se precentan a continuacion:
      <br />

      | **VARIABLE**| **NOMBRE** |
      | ------------- | :---: |
      | VPC Osaka        | vpc-demo-osa          |     
      | VPC Tokio        | vpc-demo-tok         |     
      | Subred Osaka        | subnet-demo-osa           |     
      | Subred Tokio        | subnet-demo-tok           |     
      | SSH key Osaka        | key-demo-osa           |     
      | SSH key Tokio         | key-demo-tok       | 

      <br />
2. Luego de esto acceda al *IBM Cloud Shell* e ingrese el siguiente comando para descargar el script necesario
```
wget https://raw.githubusercontent.com/emeloibmco/VPC-Despliegue-VSIs-Schematics/main/cli-script/script.sh
```
3. Una vez realizado esto utilice el siguiente comando el cual le otroga permisos al archivo para poder ejecutarlo
```
chmod +x script.sh
```
4. Para que este script funcione adecuadamente es necesario editar el nombre del grupo de recursos el cual va a utilizar, para esto ingrese el comando:
```
vi script.sh
```
esto abrira un espacio de edicion, una vez aqui presione la tecla i para acceder al modo de escritura y cambie el nombre de la variale *resourcegroup* por el nombre de su grupo de recursos. Para guardar los cambios realizados presione la tecla *esc* e ingrese el comando
```
:wq!
``` 
Esto lo llevara de nuevo a la ventana del *IBM Cloud shell*

5. finalemnte ejecute el script para desplegar las 100 VSIs ingresando el comando
```
./script.sh
```

<p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/861a86819927494b83200d8642051d66c6000696/Shell.png>
</p>

## Eliminar las VSIs
para poder eliminar las VSI generadas anteriormente tenga en cuenta los siguientes pasos:

1. Acceda al *IBM Cloud Shell* e ingrese el siguiente comando para descargar el script necesario
```
wget https://raw.githubusercontent.com/emeloibmco/VPC-Despliegue-VSIs-Schematics/main/cli-script/delete-script.sh
```
2. Una vez realizado esto utilice el siguiente comando el cual le otroga permisos al archivo para poder ejecutarlo
``` 
chmod +x delete-script.sh
```
3. Finalmente ejecute el script para eliminar las 100 VSIs con el sigueinte comando
```
./delete-script.sh
```

<p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/68a446690f30fe38f0891055d2a2d31866c56290/delete.png>
</p>


## Acceder a la ultima VSI creada
Para poder ver la configuración de la ultima VSI creada debe ingresar a la lista de recursos creados, para esto tenga en cuenta los siguientes pasos.
1. desde el Dashboard de *IBM CLoud* seleccione el ```Menú de hamburguesa```y de click sobre ```Lista de recursos```.
2. En esta nueva ventana podra encontrar todas las VSI desplegadas, en el caso de este tutorial solo se generaron 20 VSI por lo que la ultima sera cce-vsiwdc-10, para el caso de la prueba como se generan 100 VSI la ultima sera cce-vsiwdc-50.
3. de click sobre el nombre de esta VSI, esto lo llevara a la ventana de configuración de la VSI.


<p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/2bef55b7c51b55bd02f8eec81779d5ddaa2cb5c4/VSI.gif>
</p>

4. Si desea Acceder a la VSI mediante SSH creada para la zona a la cual pertenece la VSI tenga en cuenta los siguientes pasos:
    * Configure la IP Flotante. Para ello, haga click en la *VSI* implementada y en la sección de ```Interfaces de Red``` seleccione la opción ```editar```. 

    * En la opción ```Dirección IP flotante``` seleccione la opción ```Reservar IP flotante```. Luego, de click en ```Guardar```. Después de esto debe poder visualizar la IP flotante de la *VSI* en la sección de ```Interfaces de Red```.
    <p align="center"><img width="700" src="https://github.com/emeloibmco/VPC-Despliegue-VSI-Acceso-SSH/blob/main/Imagenes/ipflotante.gif"></p>

    * En *IBM Cloud Shell* cambie la región y el grupo de recursos mediante los comandos:
    ```
    ibmcloud target -r <REGION>
    ibmcloud target -g <GRUPO_RECURSOS>
    ```
    * Para visualizar en la linea de comandos, si la VSI ha sido creada correctamente, ingrese el siguiente comando:
    ```
    ibmcloud is instances
    ```

    * Conéctese a la *VSI* usando la clave privada y la IP flotante reservada anteriormente. Para ello utilice el comando: 
    ```
    ssh -i ./id_rsa root@<ip_flotante>
    ```

    *  Al colocar el comando anterior, en la consola se pide una confirmación para seguir con el acceso, ingrese ```yes```. Posteriormente, ingrese la ```Passphrase``` elegida anteriormente.

    * Si desea asignar una nueva contraseña utilice el comando:
    ```
    passwd 
    ```
   


## Autores :black_nib:
Equipo IBM Cloud Tech Sales Colombia.
<br />



