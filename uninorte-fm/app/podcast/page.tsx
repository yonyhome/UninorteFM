"use client";

import { useState } from "react";

interface Episode {
  title: string;
  embedUrl: string;
}

interface Show {
  id: string;
  name: string;
  color: string;
  episodes: Episode[];
}

const SHOWS: Show[] = [
  {
    id: "azul-celeste",
    name: "Azul Celeste",
    color: "#0EA5E9",
    episodes: [
      { title: "Soneto 29", embedUrl: "https://open.spotify.com/embed/episode/5mnkdwqeW5BDnSykDOn4KW?utm_source=generator" },
      { title: "Yo no quiero más luz que tu cuerpo frente al mío", embedUrl: "https://open.spotify.com/embed/episode/0dOd5QLoaHuNZEbeTusP5S?utm_source=generator" },
      { title: "Yo me nazco", embedUrl: "https://open.spotify.com/embed/episode/5ASvVQnFugCrMTvptdJ0lf?utm_source=generator" },
      { title: "Invictus", embedUrl: "https://open.spotify.com/embed/episode/0dCgRbz2telMuWl4BufSaq?utm_source=generator" },
      { title: "Paren todos los relojes", embedUrl: "https://open.spotify.com/embed/episode/26LLkEL1IKDyMR8iE6ZhuM?utm_source=generator" },
      { title: "¿Qué tal si por ejemplo llega hasta mi un hombre...", embedUrl: "https://open.spotify.com/embed/episode/0abyrowqdffs3dxNQaSfhv?utm_source=generator" },
      { title: "Lo que dejé por ti", embedUrl: "https://open.spotify.com/embed/episode/0zR3q7rQ4Lmd5Nxf1sgwp9?utm_source=generator" },
      { title: "Mamá se fue", embedUrl: "https://open.spotify.com/embed/episode/1Thad2VLXIqO7aKJgfXkUK?utm_source=generator" },
      { title: "Cubrir el cielo", embedUrl: "https://open.spotify.com/embed/episode/00b5O98vtor1xx3o00Qep2?utm_source=generator" },
      { title: "Una fotografía antigua", embedUrl: "https://open.spotify.com/embed/episode/6anBqDZTgLdFrq2dF6lNJ9?utm_source=generator" },
      { title: "A mano armada", embedUrl: "https://open.spotify.com/embed/episode/10ShA3xzvgQMgOp3sXgwAP?utm_source=generator" },
      { title: "Casa de cuervos", embedUrl: "https://open.spotify.com/embed/episode/3bxLw2Hw8G551NCqLnhRUG?utm_source=generator" },
      { title: "Pienso que en este momento", embedUrl: "https://open.spotify.com/embed/episode/2wtjEFfYfPW3QGo8Lyytbk?utm_source=generator" },
      { title: "Con estrépito de música vengo", embedUrl: "https://open.spotify.com/embed/episode/1BbeS3WvG1wAXewxmGrHst?utm_source=generator" },
      { title: "La jaula", embedUrl: "https://open.spotify.com/embed/episode/6hPscIxqCBOJdArk58pE2f?utm_source=generator" },
      { title: "La patria", embedUrl: "https://open.spotify.com/embed/episode/14JOErp4uPtRzJoq9L6Txj?utm_source=generator" },
    ],
  },
  {
    id: "historia-continua",
    name: "La Historia Continúa",
    color: "#8B5CF6",
    episodes: [
      { title: "Justicia climática y medio ambiente. Parte II", embedUrl: "https://open.spotify.com/embed/episode/0Tkubgw6UTkRrU4mMfEkWb?utm_source=generator" },
      { title: "Justicia climática y medio ambiente. Parte I", embedUrl: "https://open.spotify.com/embed/episode/2aECzlGmMv77qRWmuEszDr?utm_source=generator" },
      { title: "Paz en Centroamérica. Lecciones para Colombia", embedUrl: "https://open.spotify.com/embed/episode/2tKxT9agLGs7EuUp2csKQJ?utm_source=generator" },
      { title: "Intervención de los Estados Unidos en América Latina. Parte II", embedUrl: "https://open.spotify.com/embed/episode/2mZY9IfgaNn4zdrLu8WLKw?utm_source=generator" },
      { title: "Intervención de los Estados Unidos en América Latina. Parte I", embedUrl: "https://open.spotify.com/embed/episode/0jUy4zAQSy1xnb2ultnWU7?utm_source=generator" },
      { title: "Inteligencia Artificial, un reto para la sociedad actual", embedUrl: "https://open.spotify.com/embed/episode/0qRF4wR1tMmtzcEzbPFJ0X?utm_source=generator" },
      { title: "Trabajo y Sociedad. Cartagena de Indias, 1750-1811. Parte II", embedUrl: "https://open.spotify.com/embed/episode/6l9Nz6lcdgYOzcDSuRqby4?utm_source=generator" },
      { title: "Trabajo y Sociedad. Cartagena de Indias, 1750-1811. Parte I", embedUrl: "https://open.spotify.com/embed/episode/0I56vNp3cSGQpy2WtYfKZp?utm_source=generator" },
      { title: "Las bestias del llano como protagonistas de la independencia", embedUrl: "https://open.spotify.com/embed/episode/12p8MXJ1ZZofKtNwQQSfLG?utm_source=generator" },
      { title: "¿Crisis del modelo liberal? Parte II", embedUrl: "https://open.spotify.com/embed/episode/08gXLHhQOmfYwsxNMcZ6qx?utm_source=generator" },
      { title: "¿Crisis del modelo liberal? Parte I", embedUrl: "https://open.spotify.com/embed/episode/3aoQeVxFom29ajW9o2WAAt?utm_source=generator" },
    ],
  },
  {
    id: "todos-cuentan",
    name: "Todos Cuentan",
    color: "#F59E0B",
    episodes: [
      { title: "La situación de los derechos humanos en Colombia", embedUrl: "https://open.spotify.com/embed/episode/2tnQBuLoa4pObiVjRv8eMn?utm_source=generator" },
      { title: "El derecho de la competencia. Parte II", embedUrl: "https://open.spotify.com/embed/episode/74G4FUhp4LmSr1q5E4BlGM?utm_source=generator" },
      { title: "El derecho de la competencia. Parte I", embedUrl: "https://open.spotify.com/embed/episode/6MJ2D7TVRWni8kDaEh4CbT?utm_source=generator" },
      { title: "¿Qué podemos aprender hoy del Código Hammurabi?", embedUrl: "https://open.spotify.com/embed/episode/6oa5hq0mnZrXrj1UC9kd0M?utm_source=generator" },
      { title: "Tiempos de fricción institucional. Parte II", embedUrl: "https://open.spotify.com/embed/episode/3XXmgQen2Ivc09f8bpvGz3?utm_source=generator" },
      { title: "Integración diferenciada y convergencia jurídica en Latinoamérica", embedUrl: "https://open.spotify.com/embed/episode/740hYK5mMcFoXz8GgLhrEG?utm_source=generator" },
      { title: "El contrato más antiguo del mundo", embedUrl: "https://open.spotify.com/embed/episode/0oJM1Q3VB94mWynl1u4D3n?utm_source=generator" },
      { title: "Tiempos de fricción institucional. Parte I", embedUrl: "https://open.spotify.com/embed/episode/1xzaBKNudPS6R5jcrhAeju?utm_source=generator" },
      { title: "Sistema penal contra las mujeres en el delito de estupefacientes", embedUrl: "https://open.spotify.com/embed/episode/0v8kQYbwS96SIqaJB3CWXa?utm_source=generator" },
      { title: "Linchamientos en América Latina. Parte II", embedUrl: "https://open.spotify.com/embed/episode/3MQwiedtbjlMpP8n5TXhVp?utm_source=generator" },
    ],
  },
  {
    id: "salud",
    name: "Salud Uninorte Radio",
    color: "#10B981",
    episodes: [
      { title: "EP 19", embedUrl: "https://open.spotify.com/embed/episode/1COAsJ7jc0hQS8H7uUsnJb?utm_source=generator" },
      { title: "EP 18", embedUrl: "https://open.spotify.com/embed/episode/7p5AzSYnZOZmqmfC7suQPT?utm_source=generator" },
      { title: "EP 17", embedUrl: "https://open.spotify.com/embed/episode/0rGEb7as6096zKkjlcE8tw?utm_source=generator" },
      { title: "EP 16", embedUrl: "https://open.spotify.com/embed/episode/6wiBkcXqmgawHkcxL2OEcg?utm_source=generator" },
      { title: "EP 15", embedUrl: "https://open.spotify.com/embed/episode/6SwDxx7v4nQYoKN1nk3hRt?utm_source=generator" },
      { title: "EP 14", embedUrl: "https://open.spotify.com/embed/episode/2xZD28ScgcEHDtiMtJoGVO?utm_source=generator" },
      { title: "EP 13", embedUrl: "https://open.spotify.com/embed/episode/1YEqzFNHZ1IRJUwIkXAfE6?utm_source=generator" },
      { title: "EP 12", embedUrl: "https://open.spotify.com/embed/episode/3d9Jpz8sV62SGC0evUP01u?utm_source=generator" },
      { title: "EP 11", embedUrl: "https://open.spotify.com/embed/episode/66sQPeYrjkFsrohP9vDldT?utm_source=generator" },
      { title: "EP 10", embedUrl: "https://open.spotify.com/embed/episode/0pyzbqgyhNKNNMZVEAWS5J?utm_source=generator" },
      { title: "EP 9", embedUrl: "https://open.spotify.com/embed/episode/6HJFTXdqxEQF8iz1ibsbJy?utm_source=generator" },
      { title: "EP 8", embedUrl: "https://open.spotify.com/embed/episode/2HBfNTwT80xjEbGZWbxlN8?utm_source=generator" },
      { title: "EP 7", embedUrl: "https://open.spotify.com/embed/episode/2DpWSLQJDLYq0UV60VQRcS?utm_source=generator" },
      { title: "EP 6", embedUrl: "https://open.spotify.com/embed/episode/4TnqOoBoQDyornEGfPEoGt?utm_source=generator" },
      { title: "EP 5", embedUrl: "https://open.spotify.com/embed/episode/7N1pCsmsQWjv76moMFfOeG?utm_source=generator" },
      { title: "EP 4", embedUrl: "https://open.spotify.com/embed/episode/3N0UV7NMbr06g5IegTZCYj?utm_source=generator" },
      { title: "EP 3", embedUrl: "https://open.spotify.com/embed/episode/3tCeZFK6LIXYh9jpS0Ogvj?utm_source=generator" },
      { title: "EP 2", embedUrl: "https://open.spotify.com/embed/episode/5JijBAarotsXQx2APRXbRk?utm_source=generator" },
      { title: "EP 1", embedUrl: "https://open.spotify.com/embed/episode/1ZgHS8SQEUxmQsVOjbGfAQ?utm_source=generator" },
    ],
  },
  {
    id: "asi-me-decidi",
    name: "Así Me Decidí",
    color: "#EC4899",
    episodes: [
      { title: "Ingeniería Mecánica", embedUrl: "https://open.spotify.com/embed/episode/1W4B9z7f88al2ghrzHEvYm/video?utm_source=generator" },
      { title: "Economía", embedUrl: "https://open.spotify.com/embed/episode/0Xt7D8EpOts84BBxNgV5xq/video?utm_source=generator" },
      { title: "Filosofía y Humanidades", embedUrl: "https://open.spotify.com/embed/episode/259gFgH13ePgoDYFiZdl2E/video?utm_source=generator" },
      { title: "Música", embedUrl: "https://open.spotify.com/embed/episode/5wFKezPTsf29xbjkA8QCHp/video?utm_source=generator" },
      { title: "Odontología", embedUrl: "https://open.spotify.com/embed/episode/5s5JB3yZfFG8gl2crse7YK/video?utm_source=generator" },
      { title: "Negocios Internacionales", embedUrl: "https://open.spotify.com/embed/episode/7naEgdVoHGjIDwdzm98C1n/video?utm_source=generator" },
    ],
  },
  {
    id: "dialogos-samario",
    name: "Diálogos Samario",
    color: "#D42020",
    episodes: [
      { title: "Diálogo Samario con Oriol Márquez, gerente del hotel Hilton", embedUrl: "https://open.spotify.com/embed/episode/5XlOnhe6PVrsnaXdYvCTOC/video?utm_source=generator" },
      { title: "Diálogo Samario con Patricia Apreza", embedUrl: "https://open.spotify.com/embed/episode/1zf7LziKqFIugPHsBJysHc/video?utm_source=generator" },
      { title: "Diálogo Samario con Carolina Torrado", embedUrl: "https://open.spotify.com/embed/episode/7LZo10njmXoeiuswr6JJFJ/video?utm_source=generator" },
      { title: "Diálogo Samario con Silvia Media", embedUrl: "https://open.spotify.com/embed/episode/1P4P5lj1CrKnYTYJjfOTds/video?utm_source=generator" },
      { title: "Diálogo Samario con Claudia Cuello", embedUrl: "https://open.spotify.com/embed/episode/31TuRRGeKypmcDTUNjSlAD/video?utm_source=generator" },
      { title: "Diálogo Samario con Mayorie Barón", embedUrl: "https://open.spotify.com/embed/episode/1uRSz6t1tPk32OYLOb9szU/video?utm_source=generator" },
    ],
  },
  {
    id: "emprende",
    name: "Emprende+",
    color: "#F97316",
    episodes: [
      { title: "Del prototipo al plato", embedUrl: "https://open.spotify.com/embed/episode/5594R9plZ5kZ8DIt6yRomS?utm_source=generator" },
      { title: "Comunidad y bienes como motor emprendedor", embedUrl: "https://open.spotify.com/embed/episode/001iMVTIECQnVnmBlTDKah?utm_source=generator" },
      { title: "Innovación disruptiva: Ideas que transforman mercados", embedUrl: "https://open.spotify.com/embed/episode/1vCkgzVLlUQwy7OcXzoLAt?utm_source=generator" },
      { title: "El poder del Emprendimiento social", embedUrl: "https://open.spotify.com/embed/episode/2Crf6xEA5h6xjPbzgk4Ztq?utm_source=generator" },
      { title: "Economía circular en acción", embedUrl: "https://open.spotify.com/embed/episode/4rKh3vb4yciotCllbv5ihj?utm_source=generator" },
      { title: "Del reto a la estrategia", embedUrl: "https://open.spotify.com/embed/episode/7hhyeVaDSHRjQOLttmpq5e?utm_source=generator" },
    ],
  },
  {
    id: "tardeando",
    name: "Tardeando",
    color: "#6366F1",
    episodes: [
      { title: "Encuéntate Cátedra", embedUrl: "https://open.spotify.com/embed/episode/6AjwT7PnZ1giXgC0FLxYWt?utm_source=generator" },
      { title: "HPL", embedUrl: "https://open.spotify.com/embed/episode/45J9YnSutpPdrsLR9UUdTd?utm_source=generator" },
      { title: "Miguel Uribe", embedUrl: "https://open.spotify.com/embed/episode/1vhG8c6Q9z46NtssjSzWVM?utm_source=generator" },
      { title: "Mochilón de la Sierra", embedUrl: "https://open.spotify.com/embed/episode/4iBKl6tzTjTzAuzTsr4WWm?utm_source=generator" },
      { title: "La toga no tiene género, pero sí carácter", embedUrl: "https://open.spotify.com/embed/episode/0y6jvsOLnBjEWSGqAqCxjR?utm_source=generator" },
      { title: "Ikigai Empresarial: alinear la misión empresarial", embedUrl: "https://open.spotify.com/embed/episode/42mzlrK7qJFH1DK1Mj2Z2t?utm_source=generator" },
      { title: "Del sistema al diseño", embedUrl: "https://open.spotify.com/embed/episode/6GgOZ9fAp7il3U94m1LXGt?utm_source=generator" },
      { title: "Arteria: Ecologías raciales en el río Magdalena", embedUrl: "https://open.spotify.com/embed/episode/0hK0xv2YmOjjQMNeRqHJxc?utm_source=generator" },
      { title: "Brocha: La plataforma que acerca a artistas y públicos", embedUrl: "https://open.spotify.com/embed/episode/6wzUIKq7Paa7BRfkMoavRe?utm_source=generator" },
      { title: "Libro Noche de Bala: un retrato del lado oscuro del Caribe", embedUrl: "https://open.spotify.com/embed/episode/0z8xBOw29P0QIjCysIlBgp?utm_source=generator" },
      { title: "Encuéntate: Chrétien de Troyes y el Universo Artúrico", embedUrl: "https://open.spotify.com/embed/episode/74IvN4pCiOkZr8eECm8Lna?utm_source=generator" },
      { title: "El reto de enseñar a pensar en la era de la IA", embedUrl: "https://open.spotify.com/embed/episode/1DCopXpPn7B75S4tMhMX09?utm_source=generator" },
      { title: "Brasileirices: Del manglar al mundo, el sonido del Manguebeat", embedUrl: "https://open.spotify.com/embed/episode/5PaiAtXclCm0AR1Qi3FPNf?utm_source=generator" },
    ],
  },
];

export default function PodcastPage() {
  const [activeShowId, setActiveShowId] = useState<string>(SHOWS[0].id);
  const activeShow = SHOWS.find((s) => s.id === activeShowId)!;

  return (
    <div className="flex flex-col h-full bg-black">
      {/* Header */}
      <div className="flex items-center px-4 pt-5 pb-3 flex-shrink-0">
        <div
          className="w-1 h-6 rounded-full mr-3 flex-shrink-0"
          style={{ background: "#D42020" }}
        />
        <h1
          className="text-white font-bold text-lg tracking-wide"
          style={{ fontFamily: "Mulish, sans-serif" }}
        >
          Podcast
        </h1>
      </div>

      {/* Category pills — horizontal scroll */}
      <div className="flex-shrink-0 pb-3" style={{ borderBottom: "1px solid #1a1a1a" }}>
        <div
          className="flex gap-2 px-4 overflow-x-auto no-scrollbar"
          style={{ WebkitOverflowScrolling: "touch" }}
        >
          {SHOWS.map((show) => {
            const isActive = show.id === activeShowId;
            return (
              <button
                key={show.id}
                onClick={() => setActiveShowId(show.id)}
                className="flex-shrink-0 rounded-full font-bold transition-colors duration-150"
                style={{
                  fontFamily: "Mulish, sans-serif",
                  fontSize: "13px",
                  paddingTop: "10px",
                  paddingBottom: "10px",
                  paddingLeft: "16px",
                  paddingRight: "16px",
                  background: isActive ? show.color : "#1a1a1a",
                  color: isActive ? "#fff" : "rgba(255,255,255,0.5)",
                  border: isActive ? "none" : "1px solid #2a2a2a",
                  // Ensure minimum tap target height
                  minHeight: "44px",
                }}
              >
                {show.name}
              </button>
            );
          })}
        </div>
      </div>

      {/* Show info bar */}
      <div className="px-4 pt-4 pb-3 flex items-center gap-3 flex-shrink-0">
        <div
          className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0"
          style={{ background: activeShow.color + "22" }}
        >
          <svg
            viewBox="0 0 24 24"
            fill="none"
            strokeWidth={1.8}
            className="w-5 h-5"
            style={{ color: activeShow.color }}
          >
            <path
              d="M12 2a3 3 0 0 1 3 3v6a3 3 0 0 1-6 0V5a3 3 0 0 1 3-3z"
              stroke="currentColor"
            />
            <path
              d="M19 11a7 7 0 0 1-14 0"
              stroke="currentColor"
              strokeLinecap="round"
            />
            <path
              d="M12 18v4M8 22h8"
              stroke="currentColor"
              strokeLinecap="round"
            />
          </svg>
        </div>
        <div className="flex-1 min-w-0">
          <p
            className="text-white font-bold text-sm truncate"
            style={{ fontFamily: "Mulish, sans-serif" }}
          >
            {activeShow.name}
          </p>
          <p
            className="text-xs"
            style={{
              fontFamily: "Mulish, sans-serif",
              color: activeShow.color,
              opacity: 0.8,
            }}
          >
            {activeShow.episodes.length} episodios
          </p>
        </div>
      </div>

      {/* Episodes — cards with Spotify embed always visible */}
      <div className="flex-1 overflow-y-auto no-scrollbar">
        <div className="px-4 pb-6 flex flex-col gap-4">
          {activeShow.episodes.map((ep, i) => (
            <div
              key={`${activeShowId}-${i}`}
              className="rounded-2xl overflow-hidden"
              style={{
                background: "#0e0e0e",
                border: `1px solid ${activeShow.color}28`,
              }}
            >
              {/* Episode header */}
              <div className="flex items-center gap-3 px-3 pt-3 pb-2">
                {/* Number badge */}
                <div
                  className="w-7 h-7 rounded-lg flex items-center justify-center flex-shrink-0 text-xs font-black"
                  style={{
                    background: activeShow.color + "25",
                    color: activeShow.color,
                    fontFamily: "Mulish, sans-serif",
                  }}
                >
                  {i + 1}
                </div>
                {/* Title */}
                <p
                  className="flex-1 text-xs font-semibold leading-snug"
                  style={{
                    fontFamily: "Mulish, sans-serif",
                    color: "rgba(255,255,255,0.9)",
                  }}
                >
                  {ep.title}
                </p>
              </div>
              {/* Spotify embed */}
              <iframe
                src={ep.embedUrl}
                width="100%"
                height="152"
                allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture"
                loading="lazy"
                className="block"
                style={{ border: "none" }}
              />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
