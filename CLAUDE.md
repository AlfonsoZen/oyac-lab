# CLAUDE.md — Reportes de Laboratorio OAC (UNAM FI)

Repositorio para generar en LaTeX los reportes del **Laboratorio de Organización de
Arquitectura de Computadoras**, Ingeniería en Computación, Facultad de Ingeniería, UNAM.

Cada práctica vive en su propia carpeta. Tu trabajo es leer el manual y las evidencias
de esa carpeta y producir `out/reporte.pdf` con el formato que la profesora definió.

---

## 1. Estructura del repositorio

```
.
├── CLAUDE.md
├── datos.yml                  # datos fijos del curso (alumno, profesor, grupo, semestre)
├── assets/
│   ├── logo-unam.jpg
│   └── logo-fi.png
├── plantilla/
│   ├── preambulo.tex          # preámbulo compartido (lo generas tú la primera vez)
│   └── portada.tex            # portada compartida (lo generas tú la primera vez)
├── practica1/
│   ├── manual.pdf             # manual de la práctica (entrada obligatoria)
│   ├── meta.yml               # datos de esta práctica
│   ├── evidencias/            # capturas, fotos, simulaciones
│   │   ├── 01-carta-asm.png
│   │   ├── 02-simulacion.png
│   │   └── leyendas.md        # opcional: archivo → pie de figura
│   ├── codigo/                # fuentes VHDL/Verilog (.vhd, .v)
│   ├── notas.md               # opcional: observaciones mías durante la práctica
│   ├── reporte.tex            # lo generas tú
│   └── out/                   # salida de compilación (ignorada por git)
├── practica2/
└── ...
```

Regla: **nunca escribas fuera de la carpeta de la práctica en turno**, salvo la primera
creación de `plantilla/` y `datos.yml`.

---

## 2. Archivos de configuración

### `datos.yml` (raíz, se llena una sola vez)

```yaml
universidad: "UNIVERSIDAD NACIONAL AUTÓNOMA DE MÉXICO"
facultad: "FACULTAD DE INGENIERÍA"
carrera: "INGENIERÍA EN COMPUTACIÓN"
laboratorio: "Laboratorio de Organización de Arquitectura de Computadoras"
profesor: "ING. KAREN PÉREZ"
grupo_laboratorio: "06"
semestre: "2027-1"
integrantes:
  - nombre: "Omar Alfonso Zendejas Labias"
    grupo_teoria: "04"
```

> El nombre del laboratorio va **literal como lo escribió la profesora**, aunque falte
> la "y" en "Organización y Arquitectura". No lo corrijas.

### `practicaN/meta.yml`

```yaml
numero: 2
titulo: "Diseño de máquinas de estado"   # el que aparece tras "Reporte - "
fecha_entrega: "2026-09-15"              # se imprime como "15 de septiembre de 2026"
```

Si falta `meta.yml`, dedúcelo del manual y **pregúntame** para confirmar título y fecha
antes de compilar.

---

## 3. Flujo de trabajo cuando te pido un reporte

1. Lee `manual.pdf` completo. Extrae: objetivo declarado, actividades solicitadas,
   entregables explícitos y cualquier cuestionario o pregunta que deba responderse.
2. Lista los archivos de `evidencias/` y `codigo/`. Ábrelos (las imágenes también:
   necesitas ver qué muestra cada una para escribir su pie y su análisis).
3. Lee `notas.md` si existe. Es la fuente principal para "Análisis de resultados" y
   "Conclusiones".
4. **Antes de escribir**, muéstrame en el chat un esquema corto: secciones, qué figura
   va en cada una y qué datos te faltan. Espera mi visto bueno.
5. Genera `reporte.tex`.
6. Compila y verifica (sección 7).
7. Reporta: ruta del PDF, número de páginas, figuras incluidas y lista de huecos que
   dejaste marcados para que yo los llene.

---

## 4. Estructura obligatoria del reporte

En este orden exacto (es el formato de la profesora):

1. **Portada** (sin numeración de página)
2. **Objetivo.** — 1 o 2 párrafos. Se toma del manual, reescrito en prosa propia.
3. **Introducción.** — Marco teórico breve (media a una página): conceptos que la
   práctica necesita (máquinas de estado Moore/Mealy, cartas ASM, VHDL, etc.).
   Debe citar al menos una fuente de la bibliografía.
4. **Desarrollo.** — Procedimiento seguido. Aquí van:
   - el planteamiento del problema (carta ASM, tabla de estados, ecuaciones),
   - el **código VHDL completo** en bloque `lstlisting` con pie de figura,
   - explicación de cómo se definieron estados, entradas y transiciones.
5. **Análisis de resultados.** — Capturas de simulación (Quartus/ModelSim) y/o fotos
   del hardware, cada una con su interpretación: qué se observa, por qué coincide (o no)
   con lo esperado según la carta ASM.
6. **Conclusiones individuales.** — Un subtítulo por integrante con su nombre.
7. **Bibliografía.** — Formato **IEEE**.

Si el manual pide algo extra (cuestionario, tabla de verdad, cálculo de retardos),
agrégalo como subsección dentro de *Desarrollo* o *Análisis de resultados*, nunca como
sección de primer nivel nueva.

---

## 5. Convenciones de escritura

- Español de México, registro académico, **impersonal** ("se implementó", "se observa").
  La única sección en primera persona es *Conclusiones individuales*.
- Sin listas con viñetas en Objetivo, Introducción y Conclusiones: prosa corrida.
- Todo término técnico en inglés va en *cursiva* la primera vez (*clock*, *testbench*).
- Toda figura se referencia en el texto **antes** de aparecer: "en la figura \ref{fig:asm}
  se muestra...". Nunca dejes una figura huérfana.
- Pies de figura: descriptivos y en minúscula tras el número — `Figura 3: Simulación
  funcional de la máquina de estados.`
- Numera las ecuaciones solo si las referencias.

---

## 6. Reglas de contenido (importantes)

- **No inventes resultados.** Si una captura no permite leer un valor, escribe la
  interpretación en términos de lo que sí es visible, o marca
  `\todo{Confirmar valor de X}` y avísame.
- **No inventes bibliografía.** Usa solo fuentes que yo te dé, que aparezcan en el
  manual, o libros estándar del área que puedas citar con datos reales y completos
  (autor, título, edición, editorial, año). Ante la duda, pregunta.
- **Las conclusiones son un borrador.** Escríbelas a partir de `notas.md` y de lo que
  realmente pasó en la práctica; si no hay notas, genera un esqueleto con
  `\todo{}` en lugar de rellenar con lugares comunes. Yo las reescribo.
- Si el manual y las evidencias se contradicen, dilo en el chat; no lo resuelvas solo.
- Marca con `\todo{...}` (paquete `todonotes`, opción `disable` para la entrega final)
  cualquier hueco. Al terminar, lístamelos todos.

---

## 7. Compilación y verificación

Desde la carpeta de la práctica:

```bash
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=out reporte.tex
```

Después de compilar, **verifica siempre**:

1. El comando terminó en 0 y `out/reporte.pdf` existe.
2. `grep -c "??" out/reporte.log` — no debe haber referencias sin resolver.
3. No hay `Overfull \hbox` mayor a 20pt (ajusta anchos de imagen si los hay).
4. Revisión visual: rasteriza y mira las páginas.
   ```bash
   pdftoppm -png -r 90 out/reporte.pdf out/pagina
   ```
   Abre los PNG y confirma: logos presentes, portada bien alineada, imágenes visibles y
   no cortadas, código sin desbordarse del margen.
5. Si algo falla, corrige y recompila; no me entregues un PDF que no revisaste.

Limpieza: `latexmk -c -outdir=out`.

---

## 8. Plantilla LaTeX

Genera estos dos archivos la primera vez y reutilízalos. Si necesitas cambiarlos,
avísame antes: afectan a todas las prácticas.

### `plantilla/preambulo.tex`

```latex
\documentclass[12pt,letterpaper]{article}

\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage[spanish,mexico,es-tabla,es-noshorthands]{babel}
\usepackage{newtxtext,newtxmath}          % Times New Roman
\usepackage[margin=2.5cm]{geometry}
\usepackage{graphicx}
\usepackage{float}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{booktabs}
\usepackage{enumitem}
\usepackage{amsmath,amssymb}
\usepackage{listings}
\usepackage{xcolor}
\usepackage{setspace}
\usepackage[colorlinks=true,allcolors=black]{hyperref}
\usepackage{todonotes}                    % usar [disable] para la versión final

\graphicspath{{evidencias/}{../assets/}}
\captionsetup{labelsep=colon,font=small,labelfont=bf}
\onehalfspacing
\setlength{\parskip}{6pt}

% Títulos de sección al estilo del formato de la profesora
\usepackage{titlesec}
\titleformat{\section}{\normalfont\large\bfseries}{}{0pt}{}
\titleformat{\subsection}{\normalfont\normalsize\bfseries}{}{0pt}{}

\definecolor{codekw}{RGB}{0,0,180}
\definecolor{codecm}{RGB}{0,128,0}
\definecolor{codestr}{RGB}{170,0,0}
\definecolor{codebg}{RGB}{248,248,248}

\lstdefinestyle{hdl}{
  language=VHDL,
  basicstyle=\ttfamily\footnotesize,
  keywordstyle=\color{codekw}\bfseries,
  commentstyle=\color{codecm}\itshape,
  stringstyle=\color{codestr},
  backgroundcolor=\color{codebg},
  numbers=left, numberstyle=\tiny\color{gray}, numbersep=8pt,
  frame=single, rulecolor=\color{gray!50},
  breaklines=true, breakatwhitespace=true,
  tabsize=2, showstringspaces=false, captionpos=b,
  extendedchars=true, inputencoding=utf8,
  literate={á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
           {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
           {ñ}{{\~n}}1 {Ñ}{{\~N}}1 {ü}{{\"u}}1 {¿}{{?`}}1 {¡}{{!`}}1
}
\lstset{style=hdl}
\renewcommand{\lstlistingname}{Figura}   % el código se numera junto a las figuras
```

### `plantilla/portada.tex`

Los logos van arriba, lado a lado (UNAM izquierda, FI derecha), a 3.2 cm de alto.
Después el bloque de títulos centrado y en negritas, y al final los datos alineados a
la izquierda, tal como en el ejemplo de la profesora. El comando recibe todo de
`datos.yml` + `meta.yml`; escribe los valores literales al generar cada `reporte.tex`.

```latex
\begin{titlepage}
\centering
\noindent
\begin{minipage}[c]{0.45\textwidth}\centering
  \includegraphics[height=3.2cm]{logo-unam.png}
\end{minipage}\hfill
\begin{minipage}[c]{0.45\textwidth}\centering
  \includegraphics[height=3.2cm]{logo-fi.png}
\end{minipage}

\vspace{1.2cm}
{\Large\bfseries UNIVERSIDAD NACIONAL AUTÓNOMA\\[2pt] DE MÉXICO\par}
\vspace{0.9cm}
{\large\bfseries FACULTAD DE INGENIERÍA\par}
\vspace{0.6cm}
{\large\bfseries INGENIERÍA EN COMPUTACIÓN\par}
\vspace{0.6cm}
{\bfseries Laboratorio de Organización de Arquitectura de Computadoras\par}
\vspace{0.9cm}
{\bfseries Reporte - <TÍTULO DE LA PRÁCTICA>\par}

\vspace{2.2cm}
\raggedright
{\bfseries NOMBRE DE LOS INTEGRANTES:}\\
Omar Alfonso Zendejas Labias \quad Grupo de Teoría: 04

\vspace{2.5cm}
{\bfseries NOMBRE DEL PROFESOR: ING. KAREN PÉREZ}

\vspace{0.6cm}
{\bfseries GRUPO: 06}

\vspace{0.6cm}
{\bfseries SEMESTRE:} \underline{2027-1.}

\vspace{1.2cm}
\hfill {\bfseries FECHA DE ENTREGA: <FECHA>}
\thispagestyle{empty}
\end{titlepage}
```

---

## 9. Manejo de evidencias

- Los archivos de `evidencias/` se numeran con prefijo (`01-`, `02-`, ...) y **ese es el
  orden en que aparecen** salvo que el contenido exija otra cosa.
- Si existe `evidencias/leyendas.md` con líneas `01-simulacion.png: Simulación funcional
  con reset activo.`, usa ese texto como pie de figura, tal cual.
- Si no existe, redacta el pie a partir de lo que se ve en la imagen y lístame los pies
  que inventaste para que los valide.
- Ancho por defecto: `width=0.8\textwidth` para capturas de simulación,
  `width=0.6\textwidth` para diagramas y fotos de hardware. `[H]` como posición.
- Recorta márgenes muertos con `trim`/`clip` solo si la captura trae barras de
  navegador o escritorio de por medio.

---

## 10. Bibliografía IEEE

Usa `thebibliography` manual (pocas referencias, cero dependencias):

```latex
\begin{thebibliography}{9}
\bibitem{mano} M. M. Mano y M. D. Ciletti, \emph{Diseño digital}, 5a ed.
  Naucalpan de Juárez, México: Pearson Educación, 2013.
\end{thebibliography}
```

Citas en el texto con `\cite{mano}` → `[1]`. Toda entrada de la bibliografía debe estar
citada al menos una vez; si no la citas, quítala.

---

## 11. Qué hacer si algo no está

| Falta | Acción |
|---|---|
| `manual.pdf` | Detente y pídemelo. No inventes el objetivo de la práctica. |
| `evidencias/` vacía | Genera el reporte con `\todo{Insertar figura}` y avísame. |
| `codigo/` vacía | Igual: marca el hueco, no escribas VHDL inventado como si fuera mío. |
| `notas.md` | Escribe el esqueleto de análisis y conclusiones con `\todo{}`. |
| Un dato de `datos.yml` | Pregunta en el chat, no uses un placeholder silencioso. |
