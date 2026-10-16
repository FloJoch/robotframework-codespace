# Robot Framework Demo: TodoMVC im GitHub Codespace

Demo- und Schulungsumgebung für Robot Framework mit der Browser Library (Playwright) gegen die öffentliche TodoMVC-Anwendung. Läuft komplett im Browser in einem GitHub Codespace, lokal muss nichts installiert werden.

## Inhalt

```
.
├── .devcontainer/
│   └── devcontainer.json   # Umgebung: Python 3.13, Node, Desktop (noVNC)
├── tests/
│   └── todomvc.robot       # Beispieltests
├── pyproject.toml          # Dependencies (uv)
├── uv.lock                 # Gelockte Versionen, mit einchecken
└── README.md
```

Verwendet werden: `robotframework`, `robotframework-browser`, `robotframework-robocop` (Linter/Formatter), die VS-Code-Extension RobotCode und `uv` als Paketmanager.

## Codespace starten

1. Repo auf GitHub öffnen.
2. **Code → Codespaces → Create codespace on main**.
3. **Warten.** Der erste Start dauert mehrere Minuten (Container bauen, Pakete installieren, Chromium herunterladen).

### Wann ist der Codespace bereit?

Nicht schließen oder neu laden, solange der Build läuft. Bereit ist er, wenn:

- unten rechts kein Hinweis auf laufende Installationen mehr steht,
- die `.robot`-Datei **farbig hervorgehoben** ist (Syntax-Highlighting). Solange sie einfarbig weiß ist, ist die RobotCode-Extension noch nicht geladen,
- im Terminal `ls .venv/bin/python` eine Datei findet.

Ist die `.robot`-Datei nach 5 Minuten immer noch nicht farbig: **Developer: Reload Window** (`Ctrl+Shift+P`). Hilft das nicht, siehe Bugfixing.

### Python-Umgebung (.venv)

Die virtuelle Umgebung liegt in `.venv` und wird beim Start automatisch per `uv sync` angelegt. Falls VS Code einen Interpreter abfragt oder die Warnung "Interpreterpfad konnte nicht aufgelöst werden" zeigt:

1. `uv sync` im Terminal ausführen.
2. `Ctrl+Shift+P` → **Python: Select Interpreter** → `.venv/bin/python` wählen.
3. Bei Bedarf **Developer: Reload Window**.

## Tests ausführen

Headless (Standard):

```bash
uv run robot --outputdir results tests/
```

Mit sichtbarem Browser und verlangsamter Ausführung:

```bash
uv run robot --outputdir results -v HEADLESS:False -v SLOWMO:0.8 tests/
```

Ergebnisse (`log.html`, `report.html`) liegen in `results/`. Datei im Explorer rechtsklicken → Download, oder Vorschau über `python -m http.server 8000` und den Ports-Tab.

### Ausführung live ansehen (noVNC)

1. Tab **Ports** → Port **6080** → **Open in Browser**.
2. Passwort: `vscode` (in der `devcontainer.json` änderbar).
3. Test mit `-v HEADLESS:False` starten. Chromium läuft im Desktop-Fenster.

## Linting und Formatierung

```bash
uv run robocop check tests/
uv run robocop format --diff tests/   # nur anzeigen
uv run robocop format tests/          # anwenden
```

## Kosten

Codespaces laufen über das Kontingent des Accounts, der den Codespace erstellt. Ungefähre Orientierung (Stand meines Wissens, **bitte in den GitHub-Billing-Einstellungen prüfen**):

- Kostenlose persönliche Accounts haben ein monatliches Kontingent an Core-Stunden und Speicher. Ein Codespace mit 4 Cores verbraucht 4 Core-Stunden pro Stunde Laufzeit, einer mit 2 Cores entsprechend 2.
- Laufzeit zählt nur, solange der Codespace **läuft**. Gestoppte Codespaces kosten nur Speicher.
- Standardmäßig stoppt ein Codespace nach 30 Minuten Inaktivität. Nicht benutzte Codespaces werden nach einer Frist automatisch gelöscht.
- **Nach der Schulung den Codespace löschen:** github.com/codespaces → Codespace → Delete.
- Der Desktop (noVNC) und Chromium brauchen Ressourcen. Für reine Headless-Läufe reichen 2 Cores. Die Vorgabe von 4 Cores in `hostRequirements` kann in der `devcontainer.json` auf 2 gesenkt werden, um Kontingent zu sparen.

## Bugfixing

| Problem | Ursache / Lösung |
| --- | --- |
| `.robot`-Datei bleibt weiß | RobotCode noch nicht geladen. Warten, dann **Developer: Reload Window**. Prüfen, ob die Extension `d-biehl.robotcode` installiert ist. |
| Interpreter-Warnung | `.venv` fehlt. `uv sync` ausführen, dann Interpreter wählen (siehe oben). |
| `uv sync` läuft nicht automatisch | `postCreateCommand` läuft nur bei **Create/Rebuild**, nicht bei normalem Neustart. Manuell `uv sync` ausführen oder Container neu bauen. |
| `requires-python`-Fehler bei `uv sync` | Python-Version in Image, `UV_PYTHON` und `pyproject.toml` muss übereinstimmen. Aktuell: Python 3.13, `UV_PYTHON` nicht gesetzt. Eine evtl. gesetzte Variable mit `unset UV_PYTHON` entfernen. |
| "Looks like you launched a headed browser without having a XServer" | Desktop läuft nicht oder `DISPLAY` fehlt. `echo $DISPLAY` muss `:1` ausgeben. Sonst **Codespaces: Rebuild Container**. Ein einfacher Neustart reicht nicht. |
| Chromium startet nicht / stürzt ab | In `New Browser` `args=["--no-sandbox"]` und ggf. `args=["--disable-dev-shm-usage"]` ergänzen. Fehlende System-Bibliotheken: `sudo env "PATH=$PATH" uv run rfbrowser install-deps`. |
| Codespace hängt beim Build | **Codespaces: View Creation Log** öffnen, letzten Schritt prüfen. Im Recovery Mode die `devcontainer.json` korrigieren und **Rebuild Container** ausführen. |
| `rfbrowser`: Browser fehlt | `uv run rfbrowser init chromium` erneut ausführen. |
| Selektoren finden nichts | TodoMVC-URL im Browser prüfen. Die Selektoren (`.new-todo`, `.toggle`, `.destroy`) passen nicht zu jeder Variante der Anwendung. |
| Änderungen an `devcontainer.json` wirken nicht | **Codespaces: Rebuild Container** ausführen. |
