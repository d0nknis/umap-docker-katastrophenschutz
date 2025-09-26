# uMap THW-OSST

uMap-Instanz für das THW OV OSST mit MapProxy, Nginx, Redis und PostGIS/PostgreSQL als Docker-Setup.


## Enthaltene Projekte & Komponenten

- **[uMap](https://github.com/umap-project/umap)** – Webanwendung zum Erstellen und Teilen von Karten
- **[MapProxy](https://github.com/mapproxy/mapproxy)** – Tile- und Proxyserver für Karten
- **[PostGIS/PostgreSQL](https://postgis.net/)** – Geodatenbank
- **[Redis](https://redis.io/)** – In-Memory-Datenbank für Realtime-Funktionen
- **[Nginx](https://nginx.org/)** – Webserver für statische Dateien
- **[Traefik](https://traefik.io/)** – Reverse Proxy und TLS-Management
- **[Taktische Zeichen / Piktogramme](https://github.com/jonas-koeritz/Taktische-Zeichen)** – Sammlung taktischer Zeichen für Karten und Einsatzdokumentation

## Verzeichnisstruktur

- `docker-compose.yaml` – Haupt-Compose-Datei für alle Services
- `.env` – Zentrale Konfigurationsdatei für alle Umgebungsvariablen
- `config/` – Konfigurationen für MapProxy, Nginx, uMap
- `db/` – Datenbankdaten (persistente Volumes)
- `static/`, `static_custom/` – Statische Dateien für uMap
- `template_custom/` – Eigene Templates für uMap
- `kats/`, `pictograms/` – Zusatzdaten für uMap

## Voraussetzungen

- Docker (https://docs.docker.com/get-docker/)
- Docker Compose (https://docs.docker.com/compose/)

- Ein laufender [Traefik](https://traefik.io/) Dienst (Reverse Proxy) mit konfiguriertem Zertifikat-Resolver (z.B. für Let's Encrypt) muss im Netzwerk vorhanden sein. Die Compose-Datei verbindet sich mit diesem Traefik über das Netzwerk `web` und nutzt die Zertifikatsverwaltung von Traefik.

# Für die Nutzung und ggf. das Erstellen/Anpassen der taktischen Zeichen (Piktogramme) werden zusätzlich folgende Pakete benötigt:
- [j2cli](https://github.com/kolypto/j2cli) (Jinja2 Template-Engine für die SVG-Erzeugung)
- [PhantomJS](http://phantomjs.org/) (für die PNG-Erzeugung, ggf. direkt von der Webseite installieren!)
- [optipng](http://optipng.sourceforge.net/) (PNG-Optimierung)

Installiere diese Tools z.B. unter Ubuntu/Debian mit:

```sh
sudo apt-get install python3-pip optipng
sudo pip3 install j2cli
# PhantomJS ggf. von http://phantomjs.org/download.html herunterladen und entpacken
```

Für das reine Verwenden der bereits erzeugten Symbole ist keine Installation dieser Tools nötig – nur wenn du eigene Zeichen generieren oder anpassen möchtest.

## Installation & Start

1. **Repository klonen**

   ```sh
   git clone https://github.com/DEIN-USER/umap.thw-osst.de.git
   cd umap.thw-osst.de
   ```

2. **.env anpassen**

   Passe die Datei `.env` nach deinen Anforderungen an (Domains, Passwörter, API-Keys etc.).

3. **Container starten**

   ```sh
   docker compose up -d
   ```

4. **uMap aufrufen**

   Im Browser öffnen: `https://umap.thw-osst.de/` (oder deine konfigurierte Domain)

## Schnelle Installation

Führe das Skript `install.sh` im Projektverzeichnis aus, um die wichtigsten Konfigurationsdateien (.env, config/umap.conf) interaktiv zu erstellen und alle nötigen Schritte für den Erststart automatisch auszuführen:

```sh
./install.sh
```

Das Skript fragt dich nach den wichtigsten Einstellungen und übernimmt die Initialkonfiguration.

## Wichtige Hinweise zur Konfiguration

- Das Admin-Interface von uMap ist nach dem Start unter `https://example.de/admin` (bzw. deiner Domain) erreichbar.
- Damit Karten mit eigenen Hintergrundkarten (z.B. TopPlus) genutzt werden können, müssen die Tile-Server in uMap unter "Eigene Ebenen" hinzugefügt werden. Beispiel für TopPlus:

  - Name: TopPlus
  - URL: `https://example.de/tiles/topplus/EPSG3857/{z}/{y}/{x}.png`
  - TMS: deaktiviert (Standard)
  - Attribution: (nach Bedarf)

## Hinweise

- Die Datenbankdaten und Uploads werden im lokalen Dateisystem persistiert.
- Für HTTPS wird Traefik mit Let's Encrypt verwendet (Konfiguration ggf. anpassen).
- Die Konfigurationen für MapProxy, Nginx und uMap findest du im `config/`-Verzeichnis.

## Weiterführende Links

- [uMap Dokumentation](https://umap-project.readthedocs.io/)
- [MapProxy Dokumentation](https://mapproxy.org/docs/latest/)
- [PostGIS Dokumentation](https://postgis.net/documentation/)
- [Traefik Dokumentation](https://doc.traefik.io/traefik/)
- [Docker Compose Doku](https://docs.docker.com/compose/)

---

**Projekt erstellt von:** Clemens Walbrodt  
Erreichbar über THW Messenger "Hermine"  
Zugführer OV Seligenstadt

**Lizenz:** Siehe LICENSE in den jeweiligen Unterordnern und Projekten.
