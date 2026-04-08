# Uninorte 103.1 FM — PWA

Progressive Web App de la emisora Uninorte FM. Stack moderno, sin dependencias de tiendas, desplegable en la infraestructura propia de la universidad.

## Stack

- **Framework:** Next.js 14 (App Router)
- **Estilos:** Tailwind CSS
- **Audio:** HTML5 Audio nativo (stream MP3)
- **PWA:** @ducanh2912/next-pwa (Workbox)
- **Deploy:** Docker + Nginx

## Funcionalidades

| Pantalla | Descripción |
|---|---|
| 🔴 En Vivo | Player con stream `cactus2.uninorte.edu.co` + visualizador animado |
| 🎙️ Podcast | Embed de Spotify + botón abrir en app |
| 📅 Programación | Iframe al portal institucional |
| 🧭 Explorar | Links a Facebook, WhatsApp, sitio web |
| ··· Más | Instalar PWA, compartir, info de la app |

## Desarrollo local

```bash
npm install
npm run dev
# → http://localhost:3000
```

## Assets incluidos

Los siguientes assets ya están incluidos en el proyecto:

```
public/
├── logo-icon.png         ← Logo cuadrado rojo (ícono de la app)
├── senal-en-vivo.png     ← Banner "¡Señal En Vivo!" 
├── icons/
│   ├── icon-192.png      ← Ícono PWA 192×192
│   └── icon-512.png      ← Ícono PWA 512×512
└── manifest.json
```

**Opcional:** Agregar `public/background.jpg` (renombrar `effectBackgroundImage_original.jpg`) para el fondo del player.

## Producción con Docker

```bash
# Build y levantar
docker-compose up -d --build

# Ver logs
docker-compose logs -f app

# Rebuild solo la app
docker-compose up -d --build app
```

## Variables de entorno

No requiere variables de entorno en el estado actual. Si en el futuro se agrega un CMS o API interna, crear un archivo `.env.local`:

```env
NEXT_PUBLIC_STREAM_URL=https://cactus2.uninorte.edu.co/;stream.mp3
```

## PWA — Requisitos para instalación

- Servido por HTTPS (obligatorio)
- `manifest.json` correctamente referenciado
- Service Worker activo (generado automáticamente en `npm run build`)

## Personalización

### Cambiar colores
Editar `tailwind.config.ts` y `app/globals.css` — variable `--primary`.

### Cambiar stream URL
Editar la constante `STREAM_URL` en `app/page.tsx`.

### Agregar una pestaña
1. Agregar entrada en `components/BottomNav.tsx`
2. Crear carpeta `app/[nombre]/page.tsx`
