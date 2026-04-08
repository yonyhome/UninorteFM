"use client";

import { useState, useEffect } from "react";

interface BeforeInstallPromptEvent extends Event {
  prompt: () => Promise<void>;
  userChoice: Promise<{ outcome: "accepted" | "dismissed" }>;
}

export default function MasPage() {
  const [deferredPrompt, setDeferredPrompt] = useState<BeforeInstallPromptEvent | null>(null);
  const [isInstalled, setIsInstalled] = useState(false);
  const [showCopied, setShowCopied] = useState(false);

  useEffect(() => {
    // Check if already installed as PWA
    if (window.matchMedia("(display-mode: standalone)").matches) {
      setIsInstalled(true);
    }

    const handler = (e: Event) => {
      e.preventDefault();
      setDeferredPrompt(e as BeforeInstallPromptEvent);
    };

    window.addEventListener("beforeinstallprompt", handler);
    return () => window.removeEventListener("beforeinstallprompt", handler);
  }, []);

  const handleInstall = async () => {
    if (!deferredPrompt) return;
    await deferredPrompt.prompt();
    const { outcome } = await deferredPrompt.userChoice;
    if (outcome === "accepted") setIsInstalled(true);
    setDeferredPrompt(null);
  };

  const handleShare = async () => {
    if (navigator.share) {
      await navigator.share({
        title: "Uninorte 103.1 FM Estéreo",
        text: "Escucha Uninorte FM en vivo — Mueve la Cultura",
        url: window.location.origin,
      });
    } else {
      await navigator.clipboard.writeText(window.location.origin);
      setShowCopied(true);
      setTimeout(() => setShowCopied(false), 2000);
    }
  };

  const menuItems = [
    {
      icon: (
        <svg viewBox="0 0 24 24" fill="none" strokeWidth={1.8} className="w-5 h-5">
          <path d="M3 12h18M3 6h18M3 18h18" stroke="currentColor" strokeLinecap="round" />
        </svg>
      ),
      label: "Acerca de la emisora",
      desc: "Uninorte 103.1 MHz F.M. Estéreo",
      action: () => window.open("https://www.uninorte.edu.co/web/uninorte-fm-estereo", "_blank"),
    },
    {
      icon: (
        <svg viewBox="0 0 24 24" fill="none" strokeWidth={1.8} className="w-5 h-5">
          <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12a19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 3.6 1.18h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L7.91 8.27a16 16 0 0 0 6 6l.57-.57a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 21 16z" stroke="currentColor" />
        </svg>
      ),
      label: "Contáctanos",
      desc: "WhatsApp · +57 323 399 4626",
      action: () => window.open("https://wa.me/573233994626", "_blank"),
    },
    {
      icon: (
        <svg viewBox="0 0 24 24" fill="none" strokeWidth={1.8} className="w-5 h-5">
          <circle cx="18" cy="5" r="3" stroke="currentColor" />
          <circle cx="6" cy="12" r="3" stroke="currentColor" />
          <circle cx="18" cy="19" r="3" stroke="currentColor" />
          <path d="m8.59 13.51 6.83 3.98M15.41 6.51l-6.82 3.98" stroke="currentColor" />
        </svg>
      ),
      label: "Compartir app",
      desc: showCopied ? "¡Enlace copiado!" : "Recomiénda la app",
      action: handleShare,
    },
  ];

  return (
    <div className="flex flex-col min-h-full bg-black">
      {/* Header */}
      <div className="flex items-center px-4 py-4 bg-black">
        <div className="flex items-center gap-3">
          <div className="w-1 h-6 rounded-full" style={{ background: "#D42020" }} />
          <h1
            className="text-white font-bold text-lg tracking-wide"
            style={{ fontFamily: "Mulish, sans-serif" }}
          >
            Más
          </h1>
        </div>
      </div>

      {/* App identity card */}
      <div
        className="mx-4 rounded-2xl p-5 mb-6 flex items-center gap-4"
        style={{ background: "#111", border: "1px solid #222" }}
      >
        <div
          className="w-16 h-16 rounded-2xl flex items-center justify-center flex-shrink-0"
          style={{ background: "#D42020" }}
        >
          <svg viewBox="0 0 24 24" fill="none" strokeWidth={1.5} className="w-8 h-8 text-white">
            <rect x="2" y="8" width="5" height="8" rx="1" stroke="currentColor" />
            <path d="M7 11h4M7 13h3" stroke="currentColor" strokeLinecap="round" />
            <rect x="11" y="5" width="9" height="14" rx="1.5" stroke="currentColor" />
            <circle cx="15.5" cy="15" r="1.5" stroke="currentColor" />
            <path d="M15.5 13.5V9" stroke="currentColor" strokeLinecap="round" />
          </svg>
        </div>
        <div>
          <p
            className="text-white font-black text-base"
            style={{ fontFamily: "Mulish, sans-serif" }}
          >
            Uninorte FM
          </p>
          <p
            className="text-white/50 text-xs mt-0.5"
            style={{ fontFamily: "Mulish, sans-serif" }}
          >
            103.1 MHz · F.M. Estéreo
          </p>
          <p
            className="text-xs mt-1 font-semibold"
            style={{ color: "#D42020", fontFamily: "Mulish, sans-serif" }}
          >
            Mueve la Cultura
          </p>
        </div>
      </div>

      {/* Install PWA button */}
      {!isInstalled && deferredPrompt && (
        <div className="px-4 mb-4">
          <button
            onClick={handleInstall}
            className="w-full py-3.5 rounded-2xl text-white font-bold text-sm flex items-center justify-center gap-2 transition-opacity active:opacity-80"
            style={{ background: "#D42020", fontFamily: "Mulish, sans-serif" }}
          >
            <svg viewBox="0 0 24 24" fill="none" strokeWidth={2} className="w-5 h-5">
              <path d="M12 3v13M8 12l4 4 4-4" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" />
              <path d="M3 19h18" stroke="currentColor" strokeLinecap="round" />
            </svg>
            Instalar en este dispositivo
          </button>
        </div>
      )}

      {isInstalled && (
        <div className="px-4 mb-4">
          <div
            className="w-full py-3 rounded-2xl text-center text-sm font-semibold"
            style={{
              background: "#1a2a1a",
              color: "#4ade80",
              fontFamily: "Mulish, sans-serif",
              border: "1px solid #4ade8033",
            }}
          >
            ✓ App instalada
          </div>
        </div>
      )}

      {/* Menu items */}
      <div className="px-4 flex flex-col gap-2 pb-6">
        <p
          className="text-white/40 text-xs uppercase tracking-[0.2em] mb-1"
          style={{ fontFamily: "Mulish, sans-serif" }}
        >
          Opciones
        </p>

        {menuItems.map((item, i) => (
          <button
            key={i}
            onClick={item.action}
            className="flex items-center gap-4 p-4 rounded-2xl text-left transition-all active:scale-98 active:opacity-80 w-full"
            style={{ background: "#111111", border: "1px solid #222" }}
          >
            <div className="w-10 h-10 rounded-xl flex items-center justify-center flex-shrink-0 text-white/60"
              style={{ background: "#1a1a1a" }}>
              {item.icon}
            </div>
            <div className="flex-1">
              <p
                className="text-white font-semibold text-sm"
                style={{ fontFamily: "Mulish, sans-serif" }}
              >
                {item.label}
              </p>
              <p
                className="text-white/40 text-xs mt-0.5"
                style={{ fontFamily: "Mulish, sans-serif" }}
              >
                {item.desc}
              </p>
            </div>
            <svg viewBox="0 0 24 24" fill="none" strokeWidth={2} className="w-4 h-4 text-white/20 flex-shrink-0">
              <path d="M9 18l6-6-6-6" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
          </button>
        ))}
      </div>

      {/* Version footer */}
      <div className="px-4 pb-6 mt-auto text-center">
        <p
          className="text-white/20 text-xs"
          style={{ fontFamily: "Mulish, sans-serif" }}
        >
          Uninorte FM · v1.0.0 · Universidad del Norte
        </p>
      </div>
    </div>
  );
}
