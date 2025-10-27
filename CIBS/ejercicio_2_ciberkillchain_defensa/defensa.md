# Defensa — Red de monitoreo SGC-OVSPA

**Objetivo:** Este plan de defensa pretende prevenir el ataque descrito previamente a la red de monitoreo remota del SGC-OVSPA, que incluye gateways, enlaces de radio, switches, routers, estaciones remotas, y servidores de gestión (NMS). Se parte de la suposición de que existen debilidades de gestión y configuración identificadas en el ataque: credenciales por defecto o reutilizadas, interfaces administrativas accesibles desde la red o mediante VPN mal configurada, SNMPv1/v2 habilitado sin controles, puertos administrativos expuestos y falta de segmentación entre redes de gestión y de transmisión de datos. El objetivo de este plan es mitigar, detectar y responder a las técnicas descritas en cada una de las siete fases del ataque, priorizando controles prácticos y accionables que puedan implementarse en un entorno operativo real.

---

## 7) Action on Objectives

Realizar backups frecuentes de las configuraciones de los dispositivos.

---

## 6) Command and Control

- No reutilizar credenciales.
- Implementar rotación automática de credenciales (cada 90 días).
- Generar alertas que indiquen intentos fallidos o uso de set.

---

## 5) Installation 

Restringir el accceso de escritura. Implementar verificación de imágenes firmadas.

---

## 4) Exploitation 

- Configurar rate-limiting de peticiones SNMP.
- Programar escaneos internos para detectar servicios expuestos.

---

## 3) Delivery 

- Configurar SNMP sólo para lectura. Se permitirá unicamente get y getnext. Sólo se permitirá usar set en excepciones justificadas.
- Implementar rotación de credenciales y contraseñas unicas por dispositivo.

---

## 2) Weaponization 

- Eliminar community strings por defecto, usar nuevas community strings largas y únicas para cada dispositivo.
- Migrar a SNMP V3, usando autenticación (SHA) y cifrado (AES).

---

## 1) Reconnaissance 

- No exponer puertos de gestión a Internet. Implementar reglas en el firewall que bloqueen puertos de gestión SNMP (161/162) , y solo permitan usarlos desde IPs específicas (NMS, jump hosts).
- Aislar la red de gestión. Implementar VLAN dedicada  y un jump host para toda la gestión. Sólo el jump hosts tendrá interfaces en esa VLAN.
- Deshabilitar SNMP en equipos donde no es necesario.
