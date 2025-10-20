# Ataque — Red de monitoreo SGC-OVSPA

**Objetivo:** Se plantea un ataque a la red de monitoreo del SGC-OVSPA, que incluye gateways, enlaces de radio, switches, routers, estaciones remotas y servidores de gestión (NMS). Se asume la existencia de debilidades básicas de gestión y configuración: credenciales por defecto o reutilizadas, interfaces administrativas accesibles desde la red, SNMPv1/v2 habilitado sin controles, puertos administrativos expuestos y falta de segmentación entre redes de gestión y de transmisión de datos. El objetivo del atacante es manipular la configuración de los equipos de comunicaciones y alterar los valores de las mediciones para generar la percepción de fallos en estaciones específicas, provocando intervenciones de mantenimiento repetidas y continuas.

---

## 1) Reconnaissance

**Objetivo:** Construir un mapa de la infraestructura, identificar inventario de dispositivos y localizar servicios y rutas administrativas que puedan proporcionar acceso o información útil para fases posteriores.

**Técnicas MITRE:** T1595 (Active Scanning) y T1592 (Gather Victim Host Information) aplicadas a la identificación de hosts, puertos y características de dispositivos.

**Acciones:** El atacante recopila información sobre hosts que actúan como gateways, enlaces de radio, servidores NMS y estaciones remotas. Se identifican puertos y servicios expuestos, versiones de software/firmware a alto nivel y la presencia de interfaces de gestión (paneles web, SSH, SNMP). También se determinan rutas de gestión (por ejemplo, accesos a través de VPN o puertos administrativos expuestos) y se registra la topología básica y la posible redundancia entre enlaces. Esta actividad puede incluir escaneos pasivos y activos para definir un listado de objetivos relevantes.

---

## 2) Weaponization 

**Objetivo:** Seleccionar y adaptar capacidades que encajen con las vulnerabilidades detectadas, priorizando vectores simples y efectivos dados los supuestos de la red.

**Técnicas MITRE:** T1587 (Develop Capabilities) para el desarrollo o adaptación de herramientas y capacidades orientadas al acceso y control.

**Acciones:** Con la información de reconocimiento, el atacante decide el vector más plausible para el acceso inicial (por ejemplo, uso de credenciales por defecto, explotación conceptual de una interfaz web administrativa vulnerable o abuso de SNMP inseguro). Se diseña un enfoque de persistencia y control acordes al entorno, definiendo un mecanismo que permita mantener comunicación y orquestación una vez se alcance un punto de ejecución dentro de la red. 

---

## 3) Delivery 

**Objetivo:** Obtener un primer acceso útil a un componente de la infraestructura (servidor con panel web, gateway, estación remota o punto de gestión).

**Técnicas MITRE:** T1078 (Valid Accounts) en caso de uso o abuso de credenciales y T1190 (Exploit Public-Facing Application) cuando la entrada se produce vía aplicaciones con interfaz pública.

**Acciones:** El atacante entrega su vector de acceso en función de lo identificado en reconnaissance y weaponization. Vectores plausibles en este contexto son el uso de credenciales por defecto o mal gestionadas para acceder a interfaces administrativas, la explotación de fallos de validación en aplicaciones web de gestión o el aprovechamiento de un puerto de administración expuesto con controles débiles. La culminación de esta fase es la obtención de una cuenta o punto de ejecución en un host dentro de la red de monitoreo.

---

## 4) Exploitation 

**Objetivo:** Elevar privilegios y consolidar el acceso de modo que sea posible modificar configuraciones, subir artefactos persistentes o cambiar datos en sistemas de gestión.

**Técnicas MITRE:** T1068 (Exploitation for Privilege Escalation) para la fase de elevación y T1078 (Valid Accounts) para moverse lateralmente o actuar con cuentas con privilegios.

**Acciones:** A partir del punto de acceso inicial, el atacante busca obtener credenciales adicionales o explotar vectores que permitan elevar privilegios locales o administrativos en servidores NMS o en dispositivos de borde. El propósito es alcanzar permisos que permitan cambiar configuraciones de radios, switches o routers, insertar o modificar entradas en bases de datos de telemetría y disponer de cuentas con capacidad de gestión consolidada. 

---

## 5) Installation 

**Objetivo:** Garantizar que el acceso y las capacidades de control sobrevivan a reinicios y a intentos básicos de remediación.

**Técnicas MITRE:** T1543 (Create or Modify System Process) y T1505 (Server Software Component) en términos relacionados con persistencia.

**Acciones:** Con privilegios adecuados, el atacante instala un mecanismo de persistencia en un host comprometido o modifica configuraciones persistentes en dispositivos de red (NVRAM, ajustes de arranque o perfiles de gestión) para mantener la capacidad de reingreso. Esto incluye asegurar que las rutas de administración o credenciales necesarias no se pierdan tras reinicios y que exista una forma de reactivar componentes de control si se detecta y limpia una instancia.

---

## 6) Command and Control 

**Objetivo:** Establecer un canal de comunicación encubierto y fiable para orquestar acciones sobre los artefactos comprometidos y recibir información útil desde ellos.

**Técnicas MITRE:** T1071 (Application Layer Protocol) y T1573 (Protocol Tunneling) aplicadas a la creación de canales de mando y control encubiertos.

**Acciones:** El atacante establece comunicaciones periódicas desde los hosts comprometidos hacia un controlador, o aprovecha canales de gestión existentes (por ejemplo SNMP o NMS) para enviar y recibir órdenes. El canal se diseña para mezclarse con tráfico legítimo de la red, pudiendo avanzar por protocolos y puertos comúnmente permitidos en la infraestructura (HTTP/HTTPS, túneles TCP, SNMP, etc). El C2 debe permitir emitir órdenes para manipular configuraciones y datos, y recoger estado o telemetría de dispositivos comprometidos.

---

## 7) Action on Objectives 

**Objetivo:** Manipular la integridad de la infraestructura de comunicaciones y de los datos de medición para producir evidencia convincente de fallas que motiven intervenciones de mantenimiento.

**Técnicas MITRE:** T1495 (Firmware Corruption) en escenarios de manipulación profunda y técnicas relacionadas con la alteración de integridad de datos y disponibilidad de servicios.

**Acciones:** El atacante modifica parámetros administrativos y estados reportados por radios, switches o routers para simular degradación de enlaces, altera o inserta registros en bases de datos de telemetría para fabricar lecturas erráticas o erróneas de sensores, y, en escenarios más agresivos, corrompe o modifica firmwares/configuraciones críticas para provocar fallas persistentes. La selección concreta de acciones depende del nivel de privilegio alcanzado y de la ausencia de mecanismos de validación cruzada entre sensores que detecten las inconsistencias.
