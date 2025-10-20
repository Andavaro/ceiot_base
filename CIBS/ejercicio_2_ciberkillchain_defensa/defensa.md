# Defensa — Red de monitoreo SGC-OVSPA

**Objetivo:** Este plan de defensa pretende prevenir el ataque descrito previamente a la red de monitoreo remota del SGC-OVSPA, que incluye gateways, enlaces de radio, switches, routers, estaciones remotas, y servidores de gestión (NMS). Se parte de la suposición de que existen debilidades de gestión y configuración identificadas en el ataque: credenciales por defecto o reutilizadas, interfaces administrativas accesibles desde la red o mediante VPN mal configurada, SNMPv1/v2 habilitado sin controles, puertos administrativos expuestos y falta de segmentación entre redes de gestión y de transmisión de datos. El objetivo de este plan es mitigar, detectar y responder a las técnicas descritas en cada una de las siete fases del ataque, priorizando controles prácticos y accionables que puedan implementarse en un entorno operativo real.

---

## 7) Action on Objectives

**Objetivo:** Evitar o detectar manipulaciones de configuraciones, lecturas de sensores o firmwares que puedan provocar falsos fallos o daños persistentes.

**Acciones:** Implementar validación cruzada de lecturas: cuando existan sensores redundantes o estaciones cercanas, automatizar comparaciones para detectar discrepancias significativas entre mediciones que indiquen manipulación de datos. Mantener control de versiones y firmas criptográficas para imágenes de firmware y para paquetes de configuración, cualquier intento de aplicar una imagen no firmada debe bloquearse y generar alerta crítica. Auditar y registrar todos los cambios de configuración en dispositivos de borde y en NMS, con alertas por cambios fuera de ventanas de mantenimiento autorizadas. Establecer umbrales y reglas de integridad para telemetría (por ejemplo, límites físicos plausibles, rate-limits de variación) y activar listas de verificación manuales/automáticas cuando se detecten valores fuera de rango. Estas acciones previenen y detectan la técnica T1609 (Modify Firmware) y otras relacionadas con la alteración de integridad de datos.

---

## 6) Command and Control

**Objetivo:** Detectar y bloquear canales de mando y control encubiertos y prevenir la exfiltración o control remoto mediante protocolos legítimos.

**Acciones:** Implementar política de egress-deny por defecto en el perímetro: permitir salidas sólo a destinos y puertos explícitamente autorizados por función de negocio. Forzar el uso de proxies corporativos para HTTP/HTTPS con inspección TLS, y aplicar listas blancas de dominios para equipos de gestión. Monitorizar y alertar sobre patrones de beaconing y comunicaciones periódicas desde hosts internos hacia endpoints externos no aprobados. Usar análisis de comportamiento en el SIEM para identificar periodicidad y anomalías en tráfico saliente. Restringir y controlar SNMP: migrar a SNMPv3 con autenticación y cifrado, aplicar ACLs que limiten qué hosts pueden hacer GET/SET y auditar todos los SET. Segmentar la red de gestión en una VLAN aislada con egress controlado y sin salida directa a Internet. Estas acciones están orientadas a mitigar T1071 (Application Layer Protocol) y T1573/T1095 (Protocol Tunneling/Encapsulation).

---

## 5) Installation 

**Objetivo:** Evitar la implantación persistente de mecanismos maliciosos y asegurar detección temprana si se intentan instalar.

**Acciones:** Restringir la capacidad de crear o modificar servicios en hosts mediante políticas de control de cambios y hardening (systemd, políticas de ejecución en routers/switches, cuentas separadas para gestión de arranque). Habilitar mecanismos de verificación de integridad de archivos en hosts críticos y en almacenamiento de configuración de dispositivos (FIM, AIDE, Tripwire), con alertas automáticas ante cualquier modificación de binarios, scripts de arranque o configuraciones de NVRAM. En dispositivos de red, forzar que solo firmware firmado y versiones aprobadas sean instalables (firmware signing). Mantener copias de configuración y firmware offline (versionadas y firmadas) para restauración rápida. Estas contramedidas contrarrestan técnicas T1543 (Create or Modify System Process) y T1505 (Modify System Image/Persistent Storage).
---

## 4) Exploitation 

**Objetivo:** Evitar que un acceso inicial se convierta en control administrativo completo.

**Acciones:** Aplicar el principio de menor privilegio en cuentas y procesos: las cuentas de servicio y procesos del NMS que gestionan equipos no deben ejecutar con privilegios innecesarios. Habilitar controles de separación de funciones en la gestión (role-based access control) para que ninguna cuenta por sí sola permita reconfigurar dispositivos críticos o modificar firmware. Implementar hardening del sistema operativo y mitigaciones contra exploits de elevación (ASLR, DEP/No Execute, control de ejecución de código). Desplegar EDR/HIPS en servidores de gestión y en jump hosts para detectar comportamientos de escalada (creación de procesos inusuales, accesos a áreas protegidas, harvesting de credenciales). Registrar y auditar cambios en usuarios y permisos, correlando eventos en SIEM para detectar movimientos laterales. Estas medidas mitigan las técnicas T1068 (Exploitation for Privilege Escalation) y reducen el uso malicioso de T1078 (Valid Accounts).

---

## 3) Delivery 

**Objetivo:** Reducir la probabilidad de acceso inicial por credenciales débiles, aplicaciones web vulnerables o puntos de gestión expuestos.

**Acciones:** Eliminar credenciales por defecto y aplicar políticas de gestión de contraseñas centralizadas (rotación periódica, longitud y complejidad, evitar reutilización). Habilitar y exigir autenticación fuerte para todas las interfaces administrativas: SSH con llaves, gestión de certificados, y MFA para accesos a NMS o paneles críticos. Asegurar que el acceso administrativo remoto solo sea posible desde jump hosts o bastion hosts con logging detallado y controles de bastionado. Implementar un WAF frente a paneles web públicos y revisar las aplicaciones web en un programa de pruebas y hardening continuo (pentesting). Estas acciones mitigan las técnicas T1078 (Valid Accounts) y T1190 (Exploit Public-Facing Application).


---

## 2) Weaponization 

**Objetivo:** Incrementar la dificultad y coste para que un atacante desarrolle o adapte capacidades efectivas contra la infraestructura.

**Acciones:** Establecer un programa de gestión de vulnerabilidades que incluya inventario de CVEs por dispositivo y priorización de parches críticos para dispositivos embebidos (radios, switches, routers) y servidores NMS. Mantener una línea base de configuración y firmas de firmware aprobadas, bloquear instalaciones de firmware no autorizadas mediante políticas de gestión de proveedores. Implementar controles de hardening en servicios expuestos (deshabilitar funciones innecesarias, restringir APIs administrativas, aplicar políticas de Content Security Policy/headers en interfaces web). Usar servicios de sandboxing y pruebas en laboratorio para validar actualizaciones antes de su despliegue. Estas medidas elevan la barrera para la técnica T1587 (Develop Capabilities), dificultando que herramientas a medida operen sin ser detectadas.

---

## 1) Reconnaissance 

**Objetivo:** Reducir la visibilidad de la infraestructura para atacantes y aumentar la detección temprana de actividades de reconocimiento.

**Acciones:** Implementar inventario de activos y gestión de configuración que detalle modelos, versiones y rutas de gestión de todos los dispositivos. Aplicar gestión de exposición: cerrar puertos innecesarios en los bordes y en los dispositivos de gestión, deshabilitar servicios no usados, y publicar el mínimo posible en interfaces públicas. Separar redes de gestión y datos mediante VLANs y firewalls internos para que las interfaces administrativas no queden accesibles desde segmentos de la red con exposición a Internet. Implementar un programa de escaneo interno y autorizado que busque credenciales por defecto y servicios inseguros (SNMPv1, Telnet, paneles web sin protección), y automatizar alertas cuando aparezcan hosts o servicios nuevos. En el SIEM, crear reglas para detectar patrones de reconocimiento como escaneos de puertos y solicitudes inusuales hacia puertos administrativos. Estas acciones mitigan y permiten detectar técnicas T1595 (Active Scanning) y T1592 (Gather Victim Host Information).
