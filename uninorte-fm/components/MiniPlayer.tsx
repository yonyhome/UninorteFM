"use client";

import { useRadio } from "@/context/RadioContext";
import { usePathname } from "next/navigation";

export default function MiniPlayer() {
  const { playerState, play, stop } = useRadio();
  const pathname = usePathname();

  const isActive = playerState === "playing" || playerState === "loading";
  // Show only when audio is active AND user is NOT on the live page
  const isVisible = isActive && pathname !== "/";

  return (
    <div
      className="flex-shrink-0 overflow-hidden transition-all duration-300 ease-out"
      style={{ maxHeight: isVisible ? "64px" : "0px" }}
    >
      <div
        style={{
          background: "linear-gradient(90deg, #B01010 0%, #D42020 100%)",
          borderBottom: "1px solid rgba(255,255,255,0.12)",
        }}
      >
        <div className="flex items-center gap-3 px-4 h-16">
          {/* Station info */}
          <div className="flex items-center gap-2 flex-1 min-w-0">
            {/* Live pulse dot */}
            <span className="relative flex h-2.5 w-2.5 flex-shrink-0">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-white opacity-60" />
              <span className="relative inline-flex rounded-full h-2.5 w-2.5 bg-white" />
            </span>
            <div className="min-w-0">
              <p
                className="text-white text-xs font-bold truncate"
                style={{ fontFamily: "Mulish, sans-serif" }}
              >
                Uninorte 103.1 FM Estéreo
              </p>
              <p
                className="text-white/60 text-xs"
                style={{ fontFamily: "Mulish, sans-serif" }}
              >
                {playerState === "loading" ? "Conectando…" : "EN VIVO"}
              </p>
            </div>
          </div>

          {/* Play / Pause button */}
          <button
            onClick={() => (playerState === "playing" ? stop() : play())}
            className="w-9 h-9 rounded-full flex items-center justify-center flex-shrink-0 active:opacity-70 transition-opacity"
            style={{ background: "rgba(255,255,255,0.2)" }}
            aria-label={playerState === "playing" ? "Pausar" : "Reproducir"}
          >
            {playerState === "loading" ? (
              <svg
                className="w-4 h-4 animate-spin text-white"
                viewBox="0 0 24 24"
                fill="none"
              >
                <circle
                  cx="12"
                  cy="12"
                  r="10"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeOpacity="0.3"
                />
                <path
                  d="M12 2a10 10 0 0 1 10 10"
                  stroke="currentColor"
                  strokeWidth="2.5"
                  strokeLinecap="round"
                />
              </svg>
            ) : (
              <svg
                className="w-4 h-4 text-white"
                viewBox="0 0 24 24"
                fill="currentColor"
              >
                <rect x="6" y="5" width="4" height="14" rx="1" />
                <rect x="14" y="5" width="4" height="14" rx="1" />
              </svg>
            )}
          </button>

          {/* Close / stop button */}
          <button
            onClick={stop}
            className="w-8 h-8 flex items-center justify-center flex-shrink-0 active:opacity-70 transition-opacity"
            aria-label="Cerrar reproductor"
          >
            <svg
              viewBox="0 0 24 24"
              fill="none"
              strokeWidth={2}
              className="w-4 h-4"
              style={{ color: "rgba(255,255,255,0.55)" }}
            >
              <path
                d="M18 6L6 18M6 6l12 12"
                stroke="currentColor"
                strokeLinecap="round"
              />
            </svg>
          </button>
        </div>
      </div>
    </div>
  );
}
