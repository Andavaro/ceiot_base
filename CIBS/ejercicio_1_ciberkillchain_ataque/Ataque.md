# Ataque — Red de monitoreo SGC-OVSPA

**Objetivo:** Se plantea un ataque a la red de monitoreo del SGC-OVSPA, que incluye gateways, enlaces de radio, switches, routers, estaciones remotas y servidores de gestión (NMS). Se asume la existencia de debilidades básicas de gestión y configuración: credenciales por defecto o reutilizadas, interfaces administrativas accesibles desde la red, SNMPv1/v2 habilitado sin controles, puertos administrativos expuestos y falta de segmentación entre redes de gestión y de transmisión de datos. El objetivo del atacante es manipular la configuración de los equipos de comunicaciones y alterar los valores de las mediciones para generar la percepción de fallos en estaciones específicas, provocando intervenciones de mantenimiento repetidas y continuas.

---

## 1) Reconnaissance

Mediante Network Service Discovery (T1046) se logra identificar puertos y servicios expuestos, versiones de software/firmware a alto nivel y la presencia de interfaces de gestión (paneles web, SSH, SNMP). También se determinan rutas de gestión. 

**Resultado:** uso de SNMP V1/V2

---

## 2) Weaponization 

Se propone reunir posibles community strings, preparar diccionarios, identificar hosts desde donde lanzar consultas o técnicas como Credential Brute Force (T1110) / Credential Stuffing

---

## 3) Delivery 

Usar una community válida para consultar agentes SNMP. El acceso es de lectura-escritura (RW). Mediante Valid Accounts (T1078) se puede obtener las credenciales de una cuenta local, que bien podría ser un usuario, el soporte remoto o el administrador.  La idea es lograr el acceso inicial, la persistencia, escalada de privilegios y también, la evasión de defensa. Se obtiene un punto de ejecución en un host dentro de la red de monitoreo.

---

## 4) Exploitation - 5) Installation 

Se asume una mala configuración y tenemos RW, se pueden modificar parámetros de dispositivos (configuraciones) para afectar disponibilidad. Usando Modify Authentication Process (T1556) /Network Device Authentication se  puede usar Patch System Image para codificar una contraseña en el sistema operativo, omitiendo así los mecanismos de autenticación nativos para cuentas locales en dispositivos de red, esta acción no logra mantenerse ante reinicios, por lo que se hace uso de Modify System Image que busca asegurar acceso futuro: crear cuentas, configurar traps a servidores controlados o dejar cambios persistentes. Esto puede hacerse en el almacenamiento para implementar el cambio en el siguiente arranque del dispositivo de red.

---

## 6) Command and Control 

Se reutilizan credenciales descubiertas para aprovechar canales de gestión existentes (SNMP) y enviar y recibir órdenes. El canal se diseña para mezclarse con tráfico legítimo de la red, pudiendo avanzar por protocolos y puertos comúnmente permitidos en la infraestructura. El C2 permite emitir órdenes para manipular configuraciones y datos, y recoger estado o telemetría de dispositivos comprometidos.

---

## 7) Action on Objectives 

El objetivo es manipular datos en sistemas específicos de la red, para interrumpir la disponibilidad de sistemas, servicios y recursos. Se puede alterar configuraciones, reiniciar dispositivos o provocar fallos que causen indisponibilidad.
