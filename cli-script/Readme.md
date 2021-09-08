## Generar el despliegue de las VSIs
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

