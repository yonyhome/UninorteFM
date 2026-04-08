"use client";

import { RadioProvider } from "@/context/RadioContext";
import BottomNav from "@/components/BottomNav";
import MiniPlayer from "@/components/MiniPlayer";

export default function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <RadioProvider>
      <div className="flex flex-col h-screen max-w-md mx-auto relative">
        <MiniPlayer />
        <main className="flex-1 overflow-y-auto overflow-x-hidden">
          {children}
        </main>
        <BottomNav />
      </div>
    </RadioProvider>
  );
}
