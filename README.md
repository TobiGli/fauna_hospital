# Fauna Hospital

Fauna Hospital es una aplicación web para gestionar la atención médica de
fauna silvestre y animales exóticos. El proyecto centraliza la información de
especies, pacientes y fichas clínicas, manteniendo la flexibilidad necesaria
para registrar características que no son iguales para todas las especies.

## ¿Por qué se construye?

La atención de fauna silvestre necesita algo más que un registro médico
tradicional:

- Cada especie puede requerir métricas diferentes. Por ejemplo, un carpincho
  puede necesitar registrar el desgaste de sus incisivos, mientras que una
  tortuga puede requerir el largo del caparazón y el piramidismo.
- Las fichas médicas pueden incluir una radiografía o una fotografía clínica.
- La carga de pacientes puede llegar en archivos CSV desde tareas de back
  office, por lo que no debe bloquear la interfaz web.
- El acceso debe distinguir las tareas de auxiliares, veterinarios y
  administradores.

Por estos motivos, la aplicación combina un modelo relacional para los datos
principales con un campo `jsonb` para métricas específicas, Active Storage
para imágenes, Hotwire para actualizaciones sin JavaScript personalizado,
Active Job para importaciones en segundo plano y Devise/Pundit para
autenticación y autorización.

## Funcionalidades actuales

- Alta, consulta, edición y eliminación de pacientes.
- Alta y listado de especies.
- Fichas médicas anidadas dentro de cada paciente.
- Validaciones de nombres, identificadores, fechas, peso y temperatura.
- Métricas personalizadas por paciente mediante PostgreSQL `jsonb`.
- Adjuntos `xray` en fichas médicas mediante Active Storage.
- Inserción de nuevas fichas en el historial mediante Turbo Streams.
- Autenticación de usuarios con Devise.
- Roles:
  - `auxiliary`: puede consultar información.
  - `veterinarian`: puede crear y editar fichas médicas.
  - `admin`: puede crear y editar fichas médicas.
- Autorización de fichas médicas mediante Pundit.
- Importación masiva de pacientes mediante CSV.
- Procesamiento de la importación mediante `PatientImportJob`.
- Notificación por email al finalizar una importación.

## Stack técnico

- Ruby `4.0.9` (ver [.ruby-version](./.ruby-version)).
- Rails `8.1.4.1`.
- PostgreSQL.
- Tailwind CSS mediante `tailwindcss-rails`.
- Hotwire: Turbo Rails y Stimulus Rails.
- Devise para autenticación.
- Pundit para autorización.
- Active Storage para imágenes.
- Active Job para tareas en segundo plano.
- Action Mailer para notificaciones.
- Minitest para pruebas.

## Requisitos

Antes de iniciar la aplicación, instala:

- Ruby `4.0.9`.
- Bundler.
- PostgreSQL, ejecutándose localmente.
- Git.

En Windows, asegúrate de que Ruby, Bundler y PostgreSQL estén disponibles en
el `PATH`.

## Instalación

Desde la raíz del proyecto:

```powershell
bundle install
```

Configura la conexión a PostgreSQL en
[config/database.yml](./config/database.yml). Para desarrollo se espera una
base llamada `fauna_hospital_development` y para pruebas
`fauna_hospital_test`.

Después crea y migra las bases:

```powershell
bin\rails db:create
bin\rails db:migrate
```

Para cargar los datos de ejemplo:

```powershell
bin\rails db:seed
```

Los seeds eliminan los registros anteriores y crean tres especies con
pacientes y fichas médicas. Esto permite comprobar cómo `custom_metrics`
admite estructuras distintas sin cambiar el esquema cada vez que aparece una
nueva necesidad clínica.

## Ejecutar la aplicación

Para iniciar el servidor:

```powershell
bin\rails server
```

La aplicación queda disponible en
<http://localhost:3000>.

Para iniciar el servidor y el watcher de Tailwind en desarrollo:

```powershell
bin\dev
```

La ruta raíz muestra el listado de pacientes. La navegación principal también
permite acceder al listado de especies.

## Usuarios y permisos

Toda la aplicación requiere autenticación. Devise expone las rutas de acceso
mediante `devise_for :users`.

El modelo `User` utiliza estos roles:

```ruby
enum :role, { auxiliary: 0, veterinarian: 1, admin: 2 }, default: :auxiliary
```

Las políticas de Pundit permiten consultar fichas médicas a cualquier usuario
autenticado, pero restringen su creación y edición a veterinarios y
administradores.

En un entorno de desarrollo puedes crear un usuario desde la pantalla de
registro de Devise. El rol predeterminado es `auxiliary`; para probar acciones
clínicas debe asignarse el rol correspondiente desde la consola o mediante un
flujo administrativo.

## Importación masiva de pacientes

En el listado de pacientes se puede subir un archivo CSV. La importación se
guarda temporalmente en `tmp/` y se delega a `PatientImportJob`, para que la
petición web responda sin esperar a que se procese todo el archivo.

El job:

1. Lee el CSV.
2. Busca la especie por `common_name`.
3. Convierte `custom_metrics_raw` desde JSON a un hash Ruby.
4. Crea cada paciente.
5. Elimina el archivo temporal.
6. Envía un email con la cantidad de registros importados.

El CSV debe incluir estos encabezados:

```csv
identifier,name,species_name,admission_date,status,custom_metrics_raw
CAR-002,Pancho,Carpincho,2026-11-11,En observación,"{""incisivos_desgastados"":true,""dieta_basada_en_gramineas"":true}"
```

`species_name` debe coincidir con el `common_name` de una especie existente.
`custom_metrics_raw` debe contener un objeto JSON válido.

## Rutas principales

| Ruta | Uso |
| --- | --- |
| `/` | Listado de pacientes |
| `/patients` | CRUD de pacientes |
| `/patients/import` | Importación CSV mediante `POST` |
| `/patients/:patient_id/medical_records` | Fichas médicas anidadas |
| `/species` | Listado y alta de especies |
| `/users/sign_in` | Inicio de sesión |
| `/users/sign_up` | Registro de usuario |

## Pruebas y calidad

Ejecuta la suite de pruebas con:

```powershell
bin\rails test
```

Para revisar las rutas:

```powershell
bin\rails routes
```

También están disponibles las tareas del proyecto:

```powershell
bin\rubocop
bin\brakeman
bin\bundler-audit
```

## Estructura relevante

```text
app/
  controllers/       Controladores y Strong Parameters
  jobs/              Procesamiento asíncrono de importaciones
  mailers/           Notificaciones por email
  models/            Especies, pacientes, fichas y usuarios
  policies/          Reglas de autorización Pundit
  views/             Vistas ERB, formularios y Turbo Streams
config/
  routes.rb          Rutas públicas y recursos anidados
db/
  migrate/           Migraciones de PostgreSQL y Active Storage
  seeds.rb           Datos clínicos de demostración
```

## Desarrollo futuro

Algunas extensiones naturales del sistema son:

- Panel administrativo para gestionar usuarios y roles.
- Validación detallada del formato CSV con reporte de errores por fila.
- Historial de estados y evolución clínica.
- Búsqueda y filtros por especie, estado y conservación.
- Almacenamiento de imágenes en un servicio externo en producción.
- Cobertura de pruebas para controladores, políticas, jobs y mailers.
