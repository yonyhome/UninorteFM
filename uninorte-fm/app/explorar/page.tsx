"use client";

const socialLinks = [
  {
    id: "facebook",
    label: "Facebook",
    handle: "@Emisora.Uninorte",
    url: "https://www.facebook.com/Emisora.Uninorte",
    description: "Síguenos en Facebook y entérate de todo",
    color: "#1877F2",
    icon: (
      <svg viewBox="0 0 24 24" className="w-7 h-7" fill="currentColor">
        <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
      </svg>
    ),
  },
  {
    id: "whatsapp",
    label: "WhatsApp",
    handle: "+57 323 399 4626",
    url: "https://wa.me/573233994626?text=Hola%20Uninorte%20FM!",
    description: "Escríbenos, participa en el programa",
    color: "#25D366",
    icon: (
      <svg viewBox="0 0 24 24" className="w-7 h-7" fill="currentColor">
        <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413Z" />
      </svg>
    ),
  },
  {
    id: "web",
    label: "Sitio Web",
    handle: "uninorte.edu.co",
    url: "https://www.uninorte.edu.co/web/uninorte-fm-estereo",
    description: "Portal oficial de la emisora",
    color: "#D42020",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" strokeWidth={1.8} className="w-7 h-7">
        <circle cx="12" cy="12" r="10" stroke="currentColor" />
        <path d="M2 12h20M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z" stroke="currentColor" />
      </svg>
    ),
  },
];

export default function ExplorarPage() {
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
            Explorar
          </h1>
        </div>
      </div>

      {/* Hero banner */}
      <div
        className="mx-4 rounded-2xl overflow-hidden mb-6 p-6 relative"
        style={{
          background: "linear-gradient(135deg, #D42020 0%, #8B0000 100%)",
        }}
      >
        <div className="absolute top-3 right-4 opacity-10">
          <svg viewBox="0 0 80 80" className="w-20 h-20" fill="white">
            <circle cx="40" cy="40" r="38" strokeWidth="4" stroke="white" fill="none" />
            <circle cx="40" cy="40" r="24" strokeWidth="4" stroke="white" fill="none" />
            <circle cx="40" cy="40" r="10" fill="white" />
          </svg>
        </div>
        <p
          className="text-white/80 text-xs uppercase tracking-widest mb-1"
          style={{ fontFamily: "Mulish, sans-serif" }}
        >
          Universidad del Norte
        </p>
        <h2
          className="text-white text-2xl font-black mb-1"
          style={{ fontFamily: "Mulish, sans-serif" }}
        >
          103.1 FM Estéreo
        </h2>
        <p
          className="text-white/70 text-sm"
          style={{ fontFamily: "Mulish, sans-serif" }}
        >
          Conéctate con nosotros en todas las plataformas
        </p>
      </div>

      {/* Social cards */}
      <div className="px-4 flex flex-col gap-3 pb-6">
        <p
          className="text-white/40 text-xs uppercase tracking-[0.2em] mb-1"
          style={{ fontFamily: "Mulish, sans-serif" }}
        >
          Síguenos
        </p>

        {socialLinks.map((link) => (
          <a
            key={link.id}
            href={link.url}
            target="_blank"
            rel="noopener noreferrer"
            className="flex items-center gap-4 p-4 rounded-2xl transition-all duration-150 active:scale-98 active:opacity-80"
            style={{ background: "#111111", border: "1px solid #222" }}
          >
            {/* Icon circle */}
            <div
              className="w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0"
              style={{ background: link.color + "22", color: link.color }}
            >
              {link.icon}
            </div>

            {/* Text */}
            <div className="flex-1 min-w-0">
              <p
                className="text-white font-bold text-sm"
                style={{ fontFamily: "Mulish, sans-serif" }}
              >
                {link.label}
              </p>
              <p
                className="text-white/50 text-xs mt-0.5 truncate"
                style={{ fontFamily: "Mulish, sans-serif" }}
              >
                {link.handle}
              </p>
              <p
                className="text-white/30 text-xs mt-0.5 truncate"
                style={{ fontFamily: "Mulish, sans-serif" }}
              >
                {link.description}
              </p>
            </div>

            {/* Arrow */}
            <svg
              viewBox="0 0 24 24"
              fill="none"
              strokeWidth={2}
              className="w-4 h-4 flex-shrink-0 text-white/25"
            >
              <path d="M9 18l6-6-6-6" stroke="currentColor" strokeLinecap="round" strokeLinejoin="round" />
            </svg>
          </a>
        ))}
      </div>
    </div>
  );
}
