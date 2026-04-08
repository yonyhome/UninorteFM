"use client";

import {
  createContext,
  useContext,
  useRef,
  useState,
  useCallback,
  useEffect,
} from "react";

const STREAM_URL = "https://cactus2.uninorte.edu.co/;stream.mp3";

export type PlayerState = "idle" | "loading" | "playing" | "error";

interface RadioContextValue {
  playerState: PlayerState;
  play: () => void;
  stop: () => void;
}

const RadioContext = createContext<RadioContextValue | null>(null);

export function RadioProvider({ children }: { children: React.ReactNode }) {
  const [playerState, setPlayerState] = useState<PlayerState>("idle");
  const audioRef = useRef<HTMLAudioElement | null>(null);
  // Tracks whether pause was user-initiated — prevents false error on pause
  const isUserPaused = useRef(false);

  const stop = useCallback(() => {
    isUserPaused.current = true;
    if (audioRef.current) {
      audioRef.current.pause();
      audioRef.current.src = "";
      audioRef.current.load();
    }
    setPlayerState("idle");
  }, []);

  const play = useCallback(async () => {
    isUserPaused.current = false;

    if (!audioRef.current) {
      audioRef.current = new Audio();
      audioRef.current.crossOrigin = "anonymous";
    }

    const audio = audioRef.current;

    audio.onerror = () => {
      if (isUserPaused.current) return;
      setPlayerState("error");
      setTimeout(() => {
        if (!isUserPaused.current) setPlayerState("idle");
      }, 3000);
    };

    audio.onwaiting = () => {
      if (!isUserPaused.current) setPlayerState("loading");
    };

    audio.onplaying = () => setPlayerState("playing");

    // Ignore pause events that come from user-initiated stop
    audio.onpause = () => {
      if (!isUserPaused.current) setPlayerState("idle");
    };

    try {
      setPlayerState("loading");
      audio.src = `${STREAM_URL}?t=${Date.now()}`;
      audio.load();
      await audio.play();
    } catch {
      if (!isUserPaused.current) {
        setPlayerState("error");
        setTimeout(() => {
          if (!isUserPaused.current) setPlayerState("idle");
        }, 3000);
      }
    }
  }, []);

  // Media Session API — lock screen / headphone controls
  useEffect(() => {
    if ("mediaSession" in navigator) {
      navigator.mediaSession.metadata = new MediaMetadata({
        title: "Señal en Vivo",
        artist: "Uninorte 103.1 FM Estéreo",
        album: "Mueve la Cultura",
        artwork: [
          { src: "/icons/icon-512.png", sizes: "512x512", type: "image/png" },
        ],
      });
      navigator.mediaSession.setActionHandler("play", play);
      navigator.mediaSession.setActionHandler("pause", stop);
    }
  }, [play, stop]);

  return (
    <RadioContext.Provider value={{ playerState, play, stop }}>
      {children}
    </RadioContext.Provider>
  );
}

export function useRadio(): RadioContextValue {
  const ctx = useContext(RadioContext);
  if (!ctx) throw new Error("useRadio must be used inside <RadioProvider>");
  return ctx;
}
