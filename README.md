# Extreme Programming Skills for AI Agents

Colección minimalista de **Agent Skills** para trabajar con agentes de programación de IA aplicando **Extreme Programming (XP)**, **ATDD** y **TDD** — la antítesis del *vibe coding*.

La IA actúa como **driver** (propone y escribe código en incrementos pequeños) y tú mantienes el rol de **navigator** (decides el alcance, apruebas la especificación y controlas los commits).

```text
Idea ──▶ /backlog ──▶ /story ──▶ /pair ──▶ /review
          (qué)     (criterios)  (TDD)   (auditoría)
```

---

## Las 4 skills

| Skill | Propósito | Reglas clave |
| :--- | :--- | :--- |
| **`backlog`** | Convierte una idea en 10–15 historias de usuario verticales de una sola línea. | Sin arquitectura ni historias técnicas. Identifica *expensive decisions*. La historia #1 es siempre el *walking skeleton*. |
| **`story`** | Refina **una** historia antes de implementarla (criterios *Given/When/Then*, mini plan, *Out of scope*). | Revisa si toca alguna *expensive decision*. Si necesita >3 criterios, propone dividirla. Solución más simple posible. |
| **`pair`** | Programación en pareja con TDD estricto paso a paso (1 test → rojo → código mínimo → verde). | Se detiene tras cada paso (o lotes de `N`). Frenos de seguridad (>50 líneas, >3 archivos, decisiones no planeadas). **Nunca hace `git commit`**. Permite bugs directo sin `/story` y salida controlada para UI/scaffolding. |
| **`review`** | Revisión de código en un contexto limpio sobre el `git diff` y la historia refinada. | Solo lectura. Audita criterios/alcance, calidad de tests, seguridad/bordes y simplicidad citando `archivo:línea`. |

Todas las skills incluyen `disable-model-invocation: true`, por lo que **solo se activan cuando las invocas explícitamente** (`/backlog`, `/story`, `/pair`, `/review`).

---

## Estructura del repositorio

```text
extreme-programming/
├── README.md
├── install.sh
└── skills/
    ├── backlog/SKILL.md
    ├── story/SKILL.md
    ├── pair/SKILL.md
    └── review/SKILL.md
```

---

## Instalación

Clona este repositorio en tu equipo:

```bash
git clone https://github.com/<tu-usuario>/extreme-programming.git ~/dev/extreme-programming
cd ~/dev/extreme-programming
```

### Opción 1: Script incluido (recomendado para sincronizar varios equipos)

Por defecto crea **symlinks**, así cualquier `git pull` actualiza automáticamente las skills en todos tus agentes:

```bash
# Instalar para un agente específico
./install.sh antigravity
./install.sh claude
./install.sh codex

# O varios a la vez
./install.sh antigravity claude codex cursor

# Instalar en todos los agentes soportados
./install.sh all

# Instalar solo en un proyecto específico (.agents/skills/)
./install.sh project --dir /ruta/a/tu/proyecto
```

Opciones útiles:
* `--copy`: copia los archivos en lugar de crear symlinks.
* `--force`: reemplaza skills existentes con el mismo nombre.

---

### Opción 2: Con `npx skills` (Agent Skills CLI)

Una vez publicado el repositorio en GitHub, puedes instalarlo en cualquier agente compatible con el estándar [Agent Skills](https://agentskills.io):

```bash
npx skills add <tu-usuario>/extreme-programming
```

---

### Opción 3: Instalación manual por agente

#### Rutas de skills por agente

| Agente | Global (toda la máquina) | Por proyecto (en el repo) |
| :--- | :--- | :--- |
| **Antigravity (AGY)** | `~/.gemini/config/skills/` | `.agents/skills/` |
| **Claude Code** | `~/.claude/skills/` | `.claude/skills/` |
| **Codex CLI (OpenAI)** | `~/.agents/skills/` | `.agents/skills/` |
| **Gemini CLI** | `~/.gemini/skills/` | `.gemini/skills/` o `.agents/skills/` |
| **Cursor** | `~/.cursor/skills/` | `.cursor/skills/` o `.agents/skills/` |
| **GitHub Copilot / VS Code** | `~/.copilot/skills/` | `.github/skills/` o `.agents/skills/` |
| **OpenCode** | `~/.config/opencode/skills/` | `.opencode/skills/` o `.agents/skills/` |

#### Comandos manuales (symlinks)

Sustituye `<RUTA_DESTINO>` por la ruta global o de proyecto de tu agente:

```bash
mkdir -p <RUTA_DESTINO>
for s in backlog story pair review; do
  ln -s ~/dev/extreme-programming/skills/$s <RUTA_DESTINO>/$s
done
```

Ejemplos directos:

* **Antigravity:**
  ```bash
  mkdir -p ~/.gemini/config/skills
  for s in backlog story pair review; do ln -s ~/dev/extreme-programming/skills/$s ~/.gemini/config/skills/$s; done
  ```
* **Claude Code:**
  ```bash
  mkdir -p ~/.claude/skills
  for s in backlog story pair review; do ln -s ~/dev/extreme-programming/skills/$s ~/.claude/skills/$s; done
  ```
* **Codex CLI:**
  ```bash
  mkdir -p ~/.agents/skills
  for s in backlog story pair review; do ln -s ~/dev/extreme-programming/skills/$s ~/.agents/skills/$s; done
  ```
* **Gemini CLI:**
  ```bash
  mkdir -p ~/.gemini/skills
  for s in backlog story pair review; do ln -s ~/dev/extreme-programming/skills/$s ~/.gemini/skills/$s; done
  ```
* **Cursor:**
  ```bash
  mkdir -p ~/.cursor/skills
  for s in backlog story pair review; do ln -s ~/dev/extreme-programming/skills/$s ~/.cursor/skills/$s; done
  ```
* **OpenCode:**
  ```bash
  mkdir -p ~/.config/opencode/skills
  for s in backlog story pair review; do ln -s ~/dev/extreme-programming/skills/$s ~/.config/opencode/skills/$s; done
  ```

> **Tip:** Si quieres compartir estas skills con un equipo dentro de un proyecto concreto, instala en `.agents/skills/` (reconocido por Antigravity, Codex, Cursor, Gemini CLI, Copilot y OpenCode) usando `./install.sh --copy project --dir /ruta/al/proyecto` y súbelo al repositorio del proyecto.

---

## Mantener tus equipos sincronizados

Si instalaste mediante symlinks (Opción 1 u Opción 3), actualizar las skills en otro equipo es simplemente:

```bash
cd ~/dev/extreme-programming && git pull
```

---

## Flujo de uso típico

1. **Explorar una idea nueva:** inicia una sesión con `/backlog` y describe el producto o funcionalidad. Al terminar, guarda el contexto y las *expensive decisions* en el archivo de instrucciones del proyecto (`AGENTS.md` / `GEMINI.md` / `CLAUDE.md`).
2. **Preparar una historia:** toma una historia del backlog y ejecuta `/story`. Ajusta los criterios y el mini plan hasta aprobarlo.
3. **Implementar en pareja:** abre una sesión con `/pair`, pega el bloque generado por `/story`, aprueba la lista de tests y avanza paso a paso (o pide `"do 3"` para lotes pequeños). Haz tus propios `git commit` cuando el estado esté en verde.
4. **Auditar antes de integrar:** abre una sesión nueva (contexto limpio) y ejecuta `/review` pasando la historia refinada para revisar el `git diff`.
5. **Para bugs:** puedes entrar directo a `/pair` describiendo cómo reproducir el error (test en rojo que reproduce el bug → fix mínimo → verde) y cerrar con `/review`.
