# VPC Despliegue VSIs  ☁
*IBM® Cloud Schematics* 

La presente guía esta enfocada en crear un despliegue de un grupo de servidores virtuales en un ambiente de nube privada virtual (VPC) en una cuenta de IBM Cloud.

<br />

## Índice  📰
1. [Pre-Requisitos](#Pre-Requisitos-pencil)
2. [Crear y configurar una VPC, una subred y una ssh key en cada zona (Osaka, Tokio)](#crear-y-configurar-una-vpc-una-subred-y-una-ssh-key-en-cada-zona-dallas-washington)
3. [Generar el despliegue de las VSIs mediante un script (Primera opción)](#generar-el-despliegue-de-las-vsis-mediante-un-script-primera-opción)
    * [Eliminar las VSIs mediante un script](#eliminar-las-vsis-mediante-un-script)
4. [Crear y configurar un espacio de trabajo en IBM Cloud Schematics (segunda opción)](#crear-y-configurar-un-espacio-de-trabajo-en-ibm-cloud-schematics-segunda-opción)
    * [Configurar las variables de personalización de la plantilla de terraform](#configurar-las-variables-de-personalización-de-la-plantilla-de-terraform)
    * [Crear un caso en soporte para aumentar la cuota de vCPUs por región]
    * [Generar y Aplicar el plan de despliegue de los servidores VPC]
7. [Acceder a la ultima VSI creada](#acceder-a-la-ultima-vsi-creada)
8. [Autores](#autores-black_nib)
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

## Generar el despliegue de las VSIs mediante un script (Primera opción)
Para generar el despliegue los servidores de manera rapida tenga en cuenta los siguientes pasos:

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

### Eliminar las VSIs mediante un script
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


## Crear y configurar un espacio de trabajo en IBM Cloud Schematics (segunda opción)
Esta opcion es un poco mas lenta que la explicada anteriormente pero es igualmente valida, para realizar el ejercicio lo primero que debe hacer es dirigirse al servicio de <a href="https://cloud.ibm.com/schematics/workspaces">IBM Cloud Schematics</a> y dar click en ```CREAR ESPACIO DE TRABAJO```, una vez hecho esto aparecera una ventana en la que debera diligenciar la siguiente información.


| Variable | Descripción |
| ------------- | ------------- |
| URL del repositorio de Gi  | https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics |
| Tocken de acceso  | "(Opcional) Este parametro solo es necesario para trabajar con repositorio privados"  |
| Version de Terraform | terraform_v0.14 |


Presione ```SIGUIENTE```  > Agregue un nombre para el espacio de trabajo > Seleccione el grupo de recursos al que tiene acceso > Seleccione una ubicacion para el espacio de trabajo y como opcional puede dar una descripción. 

Una vez completos todos los campos puede presionar la opcion ``` CREAR```.

<p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/2bef55b7c51b55bd02f8eec81779d5ddaa2cb5c4/workspacecreate.gif>
</p>

### Configurar las variables de personalización de la plantilla de terraform
Una vez  creado el espacio de trabajo, podra ver el campo VARIABLES que permite personalizar el espacio de trabajo allí debe ingresar la siguiente información:

* ```ssh_keyname_dall```: Ingrese el nombre de la llave ssh creada en Dallas anteriormente.
* ```ssh_keyname_wdc```: Ingrese el nombre de la llave ssh creada en Washington anteriormente.
* ```name_vpc_dallas```: Ingrese el nombre de la VPC desplegada en Dallas anteriormente.
* ```name_vpc_wdc```: Ingrese el nombre de la VPC desplegada en Washington anteriormente.
* ```name_subnet_dallas```: Ingrese el nombre de la subred desplegada en la VPC de Dallas anteriormente.
* ```name_subnet_wdc```: Ingrese el nombre de la subred desplegada en la VPC de Washington anteriormente.
* ```count-vsi```: Esta variable le permite establecer el numero de servidores virtuales que va a crear, debe ingresar un numero par ya que se despliegua con una distribución de dos regiones de disponibilidad
* ```resource_group```: Ingrese el nombre del grupo de recursos en el cual tiene permisos y donde quedaran agrupados todos los recursos que se aprovisionaran.

<p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/2bef55b7c51b55bd02f8eec81779d5ddaa2cb5c4/variables.gif>
</p>

### Crear un caso en soporte para aumentar la cuota de vCPUs por región 
Para evitar tener problemas al momento de generar y aplicar el plan de despliegue de los 100 servidores es necesario aumentar la cuota de vCPUs en VPC por cada región (especialmente en la región de Dallas), para esto tenga en cuenta los siguientes pasos:
1. ingrese a la documentación sobre <a href="https://cloud.ibm.com/docs/vpc"> Virtual Private Cloud (VPC)</a> en *IBM Cloud* 
2. Seleccione la pestaña de ```Cuotas y límites de servicio/Quotas and service limits```.
3. Una vez se encuentre en esta pestaña de click en el botón ```Contactar a soporte/contact support```, al hacer esto se abrirá una nueva pestaña en donde podrá crear un nuevo caso en soporte.
4. En esta pestaña debe seleccionar la categoría de Virtual Private Cloud (VPC).
5. Luego de esto en la ventana de ```tema/topic``` complete la información necesaria de la siguiente manera.
    * ```tema/topic```: Virtual Private Cloud (VPC).
    * ```subtema/subtopic```: Solicitud de cuota/Quota request.
6. Una vez complete esta información de click en el botón ```siguiente```, esto lo llevara a la ventana de ```detalles/details```.
7. En esta ventana complete la información necesaria de la siguiente manera.
    * ```Asunto/Subject```: El asunto del caso en ingles Ej:'Increase Quota limit for VPC vCPUs in Dallas'.
    * ```Descripción/Description```: La descripción del caso en ingles, esta debe contener la siguiente información:
      * Account number: número de cuenta
      * Region(s) and Availability Zone(s): regiones y zonas de disponibilidad del caso de soporte
      * Environment: (Prod/Stage): Ambiente (usar Prod)
      * JUSTIFICATION FOR REQUEST (REQUIRED): Ej: 'I need help in increasing the vCPU quota dor VPC from 200 vCPUS to 300 vCPUs'
    * ```Lista de contactos para seguimiento/contacts watchlist```: Aquí puede agregar a otro miembro del grupo, si lo desea, para que sea notificado del caso de soporte.
8. Una vez complete esta información de click en el botón de ```siguiente``` esto lo llevara a la pestaña de resumen y aquí de click en el botón de ```enviar caso/Submit case``` para finalizar el caso en soporte.

<p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/2bef55b7c51b55bd02f8eec81779d5ddaa2cb5c4/Soporte.gif>
</p>

### Generar y Aplicar el plan de despliegue de los servidores VPC
Ya que estan todos los campos de personalización completos, debe ir hasta la parte superior de la ventana donde encontrara dos opciones, Generar plan y Aplicar plan. Para continuar con el despliegue de los recursos debera presionar ```Generar Plan``` y una vez termine de generarse el plan ```Aplicar Plan```.

* ```Generar plan```: Según su configuración, Terraform crea un plan de ejecución y describe las acciones que deben ejecutarse para llegar al estado que se describe en sus archivos de configuración de Terraform. Para determinar las acciones, Schematics analiza los recursos que ya están aprovisionados en su cuenta de IBM Cloud para brindarle una vista previa de si los recursos deben agregarse, modificarse o eliminarse. Puede revisar el plan de ejecución, cambiarlo o simplemente ejecutar el plan
* ```Aplicar plan```: Cuando esté listo para realizar cambios en su entorno de nube, puede aplicar sus archivos de configuración de Terraform. Para ejecutar las acciones que se especifican en sus archivos de configuración, Schematics utiliza el complemento IBM Cloud Provider para Terraform.

<p align="center">
<img width="800" alt="img8" src=https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics-IMG/blob/2bef55b7c51b55bd02f8eec81779d5ddaa2cb5c4/Despliegue.gif>
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
   


# Referencias 📖

* [Acerca de IBM Cloud Schematics](https://cloud.ibm.com/docs/schematics?topic=schematics-about-schematics).
