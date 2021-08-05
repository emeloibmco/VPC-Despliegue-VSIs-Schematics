# VPC Despliegue VSIs Schematics ☁
*IBM® Cloud Schematics* 

La presente guía esta enfocada en crear un despliegue de un grupo de servidores virtuales en un ambiente de nube privada virtual (VPC) en una cuenta de IBM Cloud.

<br />

## Índice  📰
1. [Pre-Requisitos](#Pre-Requisitos-pencil)
2. [Crear y configurar un espacio de trabajo en IBM Cloud Schematics](#Crear-y-configurar-un-espacio-de-trabajo-en-IBM-Cloud-Schematics)
3. [Configurar las variables de personalización de la plantilla de terraform](#Conexión-con-pgAdmin-electric_plug)
4. [Generar y Aplicar el plan de despliegue de los servidores VPC](#CRUD-en-la-base-de-datos-hammer)
5. [....](#Referencias-mag)
6. [Autores](#Autores-black_nib)
<br />

## Pre Requisitos :pencil:
* Contar con una cuenta en <a href="https://cloud.ibm.com/"> IBM Cloud</a>.
* Contar con un grupo de recursos específico para la implementación de los recursos.


## Crear y configurar un espacio de trabajo en IBM Cloud Schematics
Para realizar el ejercicio lo primero que debe hacer es dirigirse al servicio de <a href="https://cloud.ibm.com/schematics/workspaces">IBM Cloud Schematics</a> y dar click en crear espacio de trabajo, una vez hecho esto aparecera una ventana en la que debera diligenciar la siguiente información.

* ```URL del repositorio de Git```: https://github.com/emeloibmco/VPC-Despliegue-VSIs-Schematics
* ```Tocken de acceso```: "Este parametro solo es necesario para trabajar con repositorio privados"
* ```Version de Terraform```: terraform_v0.14
---

# Referencias 📖

* [Pagina de joomla](https://www.joomla.org/about-joomla.html).
* [Guia para la instalación de mysql](https://linuxize.com/post/how-to-install-mysql-on-ubuntu-18-04/).
* [Instalación de ansible en SO Ubuntu](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu).
* [Modulos de ansible](https://docs.ansible.com/ansible/latest/modules/).
