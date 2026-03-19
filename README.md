# 🏨 Sistema de gestión hotelera - MySQLWorkbench

Proyecto orientado al **diseño e implementación de una base de datos relacional para la gestión de un hotel**, desarrollado utilizando **MySQL** y **MySQL Workbench**.  
El objetivo principal es aplicar conceptos de **modelado de datos, normalización y creación de objetos de base de datos**.

---


# 📌 Objetivos

- Diseñar una base de datos relacional para mejorar la **administración y gestión de la información del Hotel Regional**.
- Aplicar principios de **modelado entidad–relación (DER)**.
- Implementar **tablas relacionadas mediante claves primarias y foráneas**, aplicando principios de **normalización**.
- Utilizar distintos **objetos de base de datos** para optimizar consultas y operaciones (**vistas, funciones, stored procedures y triggers**).

---

# 🧩 Estructura de la base de datos

El modelo está compuesto por **15 tablas interrelacionadas** que representan las principales entidades del sistema hotelero:

- procedencias  
- huespedes  
- tipos_habitacion  
- habitaciones  
- departamentos  
- cargos  
- empleados  
- promociones  
- canales_reserva  
- reservas  
- servicios  
- reserva_servicio  
- metodos_pago  
- pagos  
- quejas  

Estas tablas permiten registrar y gestionar la información necesaria para el funcionamiento básico del hotel.

Todos los **datos utilizados en el proyecto son ficticios** y fueron generados únicamente con fines **educativos y de práctica**.

---

# 🔗 Modelo de datos y relaciones principales

El modelo de datos se organiza alrededor del proceso de **reserva y estadía de huéspedes en el hotel**.

Las relaciones principales entre las tablas son:

- Un **huésped** puede realizar una o varias **reservas**.
- Cada **reserva** corresponde a una **habitación** determinada y puede estar asociada a un **canal de reserva** y una **promoción**.
- Durante su estadía, una reserva puede incluir distintos **servicios**, los cuales se registran en la tabla `reserva_servicio`.
- Al finalizar la estadía, se registran los **pagos**, indicando el **método de pago** utilizado.
- Los **empleados** del hotel se organizan en **departamentos** y poseen distintos **cargos** dentro de la estructura organizacional.
- Los huéspedes también pueden registrar **quejas**, los cuales quedan almacenados para su seguimiento.

Este diseño permite representar de forma estructurada los procesos principales de gestión del hotel, manteniendo la **integridad referencial entre las distintas entidades del sistema**.

---

# 🛠️ Tecnologías utilizadas

- MySQL  
- MySQL Workbench
- Power Bi 

---

# ▶️ Modo de ejecución

Se recomienda seguir los siguientes pasos para recrear la base de datos:

1. Ejecutar el script de **creación de la base de datos y tablas**  
   `hotel_regional.sql`

2. Ejecutar el script para la **creación de vistas, funciones, stored procedures y triggers**  
   `01_Creacion_Vistas_SP_Triggers_Funciones.sql`

3. Ejecutar el script de **inserción de datos iniciales**  
   `02_Insercion_Datos.sql`

4. Importar los archivos ubicados en la carpeta `csv_archivos` utilizando el asistente gráfico  
   **Table Data Import Wizard** de MySQL Workbench.

Para evitar conflictos con **claves foráneas**, los archivos `.csv` deben importarse en el siguiente orden:

  
1. habitaciones.csv  
2. servicios.csv  
3. huespedes.csv  
4. reservas.csv  
5. reserva_servicio.csv  
6. pagos.csv  
7. quejas.csv  

Respetar el orden de carga de los archivos para mantener la **integridad referencial de la base de datos**.

---

# 📂 Estructura del proyecto

El proyecto tiene 3 carpetas y un archivo `README.md`:

1. **sql**: Contiene los siguientes archivos SQL:  
   - `hotel_regional.sql`  
   - `01_Creacion_Vistas_SP_Triggers_Funciones.sql`  
   - `02_Insercion_Datos.sql`  

2. **csv_archivos**: Contiene los archivos `.csv` para ser insertados mediante wizard:  
   - `procedencias.csv`  
   - `habitaciones.csv`  
   - `servicios.csv`  
   - `huespedes.csv`  
   - `reservas.csv`  
   - `reserva_servicio.csv`  
   - `pagos.csv`  
   - `quejas.csv`  

3. **docs**: Contiene la documentación en PDF:  
   - `Hotelregional_JesicaLlanos.pdf`  
   - `dashboard_hotelregional.pdf`

4. **README.md**: Este archivo con la descripción y estructura del proyecto.  
# 📊 Documentación

El repositorio incluye los siguientes documentos en la carpeta `docs/`:

- Un PDF con la explicación del diseño de la base de datos y el análisis de los datos.
- Un PDF llamado `dashboard_hotelregional.pdf`que muestra únicamente gráficos del análisis, generados a partir de la conexión de la base de datos con Power BI.

📄 [Ver documentación completa del proyecto](docs/Hotelregional_JesicaLlanos.pdf)

[📊 Ver dashboard del proyecto](docs/dashboard_hotelregional.pdf)