"use client";

import { useState } from "react";

const PROGRAMACION_URL =
  "https://www.uninorte.edu.co/web/uninorte-fm-estereo/programacion";

export default function ProgramacionPage() {
  const [loaded, setLoaded] = useState(false);

  return (
    <div className="flex flex-col h-full bg-black">
      {/* Header */}
      <div
        className="flex items-center px-4 py-4 flex-shrink-0"
        style={{ background: "#000000" }}
      >
        <div className="flex items-center gap-3">
          <div
            className="w-1 h-6 rounded-full"
            style={{ background: "#D42020" }}
          />
          <h1
            className="text-white font-bold text-lg tracking-wide"
            style={{ fontFamily: "Mulish, sans-serif" }}
          >
            Programación
          </h1>
        </div>
      </div>

      {/* Loading skeleton */}
      {!loaded && (
        <div className="flex-1 flex flex-col items-center justify-center gap-4">
          <div
            className="w-12 h-12 rounded-full border-2 border-t-transparent animate-spin"
            style={{ borderColor: "#D42020", borderTopColor: "transparent" }}
          />
          <p
            className="text-white/50 text-sm"
            style={{ fontFamily: "Mulish, sans-serif" }}
          >
            Cargando programación…
          </p>
        </div>
      )}

      {/* iFrame */}
      <iframe
        src={PROGRAMACION_URL}
        className="flex-1 w-full border-0"
        style={{ display: loaded ? "block" : "none" }}
        onLoad={() => setLoaded(true)}
        title="Programación Uninorte FM"
        allow="autoplay"
        sandbox="allow-scripts allow-same-origin allow-popups allow-forms"
      />

      {/* Fallback button if iframe is blocked */}
      {loaded && (
        <div className="flex-shrink-0 px-4 py-3" style={{ background: "#111" }}>
          <a
            href={PROGRAMACION_URL}
            target="_blank"
            rel="noopener noreferrer"
            className="flex items-center justify-center gap-2 w-full py-3 rounded-xl text-white text-sm font-semibold transition-opacity active:opacity-70"
            style={{ background: "#D42020", fontFamily: "Mulish, sans-serif" }}
          >
            <svg viewBox="0 0 24 24" fill="none" strokeWidth={2} className="w-4 h-4">
              <path d="M10 6H6a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-4" stroke="currentColor" strokeLinecap="round" />
              <path d="M14 4h6v6M20 4l-8 8" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
            Abrir en navegador
          </a>
        </div>
      )}
    </div>
  );
}
