"use client";

import Image from "next/image";
import { useRadio } from "@/context/RadioContext";

export default function LivePage() {
  const { playerState, play, stop } = useRadio();

  const toggle = () => {
    if (playerState === "playing" || playerState === "loading") {
      stop();
    } else {
      play();
    }
  };

  const isPlaying = playerState === "playing";
  const isLoading = playerState === "loading";
  const isError = playerState === "error";

  return (
    <div
      className="relative min-h-full flex flex-col overflow-hidden select-none"
      style={{
        background:
          "linear-gradient(160deg, #C01818 0%, #D42020 40%, #B01010 100%)",
      }}
    >
      {/* Background image overlay */}
      <div
        className="absolute inset-0 opacity-30 bg-cover bg-center"
        style={{ backgroundImage: "url('/background.jpg')" }}
      />

      {/* Decorative circles */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="float-1 absolute top-[8%] left-[8%] w-16 h-16 rounded-full border border-white/20" />
        <div className="float-2 absolute top-[6%] right-[20%] w-3 h-3 rounded-full bg-white/20" />
        <div className="float-1 absolute top-[20%] right-[8%] w-10 h-10 rounded-full bg-red-900/40 border border-white/10" />
        <div className="float-2 absolute top-[32%] left-[14%] w-4 h-4 rounded-full border border-white/15" />
        <div className="float-1 absolute bottom-[32%] left-[6%] w-14 h-14 rounded-full border-2 border-white/10 flex items-center justify-center">
          <div className="w-8 h-8 rounded-full bg-red-800/50" />
        </div>
        <div className="float-2 absolute bottom-[28%] right-[10%] w-2 h-2 rounded-full bg-white/25" />
        <div className="float-1 absolute bottom-[18%] left-[30%] w-6 h-6 rounded-full border border-white/15" />
        <div
          className="float-2 absolute bottom-[12%] right-[6%] w-20 h-20 rounded-full border border-white/10"
          style={{
            background:
              "repeating-linear-gradient(45deg, transparent, transparent 3px, rgba(255,255,255,0.05) 3px, rgba(255,255,255,0.05) 6px), radial-gradient(circle, rgba(180,0,0,0.3), transparent)",
          }}
        />
        <div className="float-1 absolute top-[48%] right-[4%] w-2 h-2 rounded-full bg-white/20" />
      </div>

      {/* Content */}
      <div className="relative z-10 flex flex-col items-center flex-1 px-6 pt-safe">
        {/* Live badge */}
        <div className="w-full pt-8 pb-2 flex justify-center">
          <div className="relative h-8 w-64">
            <Image
              src="/senal-en-vivo.png"
              alt="¡Señal En Vivo!"
              fill
              style={{ objectFit: "contain" }}
              priority
            />
          </div>
        </div>

        {/* Logo */}
        <div className="my-16">
          <div className="relative w-44 h-20">
            <Image
              src="/logo-icon.png"
              alt="Uninorte 103.1 FM Estéreo"
              fill
              style={{ objectFit: "contain" }}
              priority
            />
          </div>
        </div>

        {/* Spacer */}
        <div className="flex-1" />

        {/* Play button with ripple */}
        <div className="relative flex items-center justify-center mb-8">
          {isPlaying && (
            <>
              <div className="absolute w-44 h-44 rounded-full bg-white/10 ripple" />
              <div className="absolute w-44 h-44 rounded-full bg-white/10 ripple-delay" />
            </>
          )}

          {/* Outer ring */}
          <div
            className="w-40 h-40 rounded-full flex items-center justify-center transition-all duration-300"
            style={{
              background: isPlaying
                ? "radial-gradient(circle, rgba(255,255,255,0.25) 0%, rgba(255,255,255,0.08) 100%)"
                : "radial-gradient(circle, rgba(255,255,255,0.18) 0%, rgba(255,255,255,0.05) 100%)",
              border: "2px solid rgba(255,255,255,0.2)",
            }}
          >
            {/* Inner button */}
            <button
              onClick={toggle}
              className="w-24 h-24 rounded-full flex items-center justify-center active:scale-95 transition-all duration-150"
              style={{
                background: "rgba(255,255,255,0.25)",
                border: "2px solid rgba(255,255,255,0.4)",
                backdropFilter: "blur(8px)",
              }}
              aria-label={isPlaying ? "Detener" : "Reproducir señal en vivo"}
            >
              {isLoading ? (
                <svg
                  className="w-10 h-10 animate-spin text-white"
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
              ) : isPlaying ? (
                <svg
                  className="w-10 h-10 text-white"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <rect x="6" y="5" width="4" height="14" rx="1" />
                  <rect x="14" y="5" width="4" height="14" rx="1" />
                </svg>
              ) : isError ? (
                <svg
                  className="w-10 h-10 text-white"
                  viewBox="0 0 24 24"
                  fill="none"
                  strokeWidth="2"
                >
                  <circle cx="12" cy="12" r="10" stroke="currentColor" />
                  <path
                    d="M12 8v4M12 16h.01"
                    stroke="currentColor"
                    strokeLinecap="round"
                  />
                </svg>
              ) : (
                <svg
                  className="w-10 h-10 text-white"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                >
                  <path d="M8 5.5v13l11-6.5L8 5.5z" />
                </svg>
              )}
            </button>
          </div>
        </div>

        {/* Status text */}
        <div className="h-6 flex items-center mb-6">
          {isLoading && (
            <p
              className="text-white/70 text-sm tracking-widest uppercase animate-pulse"
              style={{ fontFamily: "Mulish, sans-serif" }}
            >
              Conectando…
            </p>
          )}
          {isPlaying && (
            <p
              className="text-white/80 text-sm tracking-widest uppercase"
              style={{ fontFamily: "Mulish, sans-serif" }}
            >
              ● EN VIVO
            </p>
          )}
          {isError && (
            <p
              className="text-white/80 text-sm tracking-wide text-center"
              style={{ fontFamily: "Mulish, sans-serif" }}
            >
              Error de conexión. Intenta de nuevo.
            </p>
          )}
        </div>

        {/* Spacer */}
        <div className="flex-1" />

        {/* Slogan */}
        <div className="mb-4 text-center">
          <p
            className="text-5xl font-black text-white/25 tracking-tight leading-tight uppercase"
            style={{ fontFamily: "Mulish, sans-serif" }}
          >
            MUEVE
          </p>
          <p
            className="text-4xl font-black text-white/25 tracking-tight uppercase italic"
            style={{ fontFamily: "Carrois Gothic SC, sans-serif" }}
          >
            LA CULTURA
          </p>
        </div>

        {/* Audio visualizer bars */}
        <div className="w-full pb-2">
          <div className="flex items-end justify-center gap-[2px] h-12 overflow-hidden opacity-40">
            {Array.from({ length: 48 }).map((_, i) => {
              const barClass = ["bar-1", "bar-2", "bar-3", "bar-4", "bar-5"][
                i % 5
              ];
              const delay = `${(i * 0.04).toFixed(2)}s`;
              const baseH = [8, 14, 22, 18, 30, 16, 24, 12, 28, 20][i % 10];
              return (
                <div
                  key={i}
                  className={`rounded-t-sm flex-1 ${isPlaying ? barClass : ""}`}
                  style={{
                    background: "rgba(255,255,255,0.7)",
                    height: isPlaying ? undefined : `${baseH}px`,
                    animationDelay: delay,
                    minWidth: "2px",
                    maxWidth: "8px",
                    transition: "height 0.3s ease",
                  }}
                />
              );
            })}
          </div>
        </div>
      </div>
    </div>
  );
}
