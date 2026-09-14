# Reportes de Laboratorio OAC (UNAM FI)

Repositorio de trabajo del Laboratorio de Organización de Arquitectura de
Computadoras, Ingeniería en Computación, Facultad de Ingeniería, UNAM.

El flujo de trabajo completo (estructura de carpetas, formato de los reportes,
convenciones de escritura, plantilla LaTeX, etc.) está documentado en
[`CLAUDE.md`](CLAUDE.md).

## Contenido de este repositorio

- `datos.yml` — datos fijos del curso (integrantes, grupo, equipo, semestre).
- `assets/` — logos institucionales usados en la portada.
- `plantilla/` — preámbulo y portada LaTeX compartidos por todas las prácticas.
- `practicaN/` — cada práctica de laboratorio, con su manual, evidencias, código
  VHDL/Verilog y `reporte.tex`. A partir de la práctica 2 el laboratorio se
  desarrolla en equipo.

Las tareas del grupo de teoría (`tareaN/`) son trabajo individual y **no** se
suben a este repositorio; existen únicamente en el equipo local de cada
integrante (ver `.gitignore`).

## Compilar un reporte

Desde la carpeta de la práctica:

```bash
latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=out reporte.tex
```

El PDF resultante queda en `practicaN/out/reporte.pdf` (carpeta ignorada por
git, ya que se regenera con el comando anterior).
