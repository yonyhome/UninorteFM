"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const tabs = [
  {
    href: "/",
    label: "En Vivo",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" strokeWidth={1.5}>
        <rect x="2" y="8" width="5" height="8" rx="1" stroke="currentColor" />
        <path d="M7 11h4" stroke="currentColor" strokeLinecap="round" />
        <path d="M7 13h3" stroke="currentColor" strokeLinecap="round" />
        <rect x="11" y="5" width="9" height="14" rx="1.5" stroke="currentColor" />
        <circle cx="15.5" cy="15" r="1.5" stroke="currentColor" />
        <path d="M15.5 13.5V9" stroke="currentColor" strokeLinecap="round" />
      </svg>
    ),
  },
  {
    href: "/podcast",
    label: "Podcast",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" strokeWidth={1.5}>
        <path d="M12 2a3 3 0 0 1 3 3v6a3 3 0 0 1-6 0V5a3 3 0 0 1 3-3z" stroke="currentColor" />
        <path d="M19 11a7 7 0 0 1-14 0" stroke="currentColor" strokeLinecap="round" />
        <path d="M12 18v4" stroke="currentColor" strokeLinecap="round" />
        <path d="M8 22h8" stroke="currentColor" strokeLinecap="round" />
      </svg>
    ),
  },
  {
    href: "/programacion",
    label: "Programación",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" strokeWidth={1.5}>
        <rect x="3" y="4" width="18" height="18" rx="2" stroke="currentColor" />
        <path d="M3 10h18" stroke="currentColor" />
        <path d="M8 2v4M16 2v4" stroke="currentColor" strokeLinecap="round" />
        <path d="M7 14h2M11 14h2M15 14h2M7 18h2M11 18h2" stroke="currentColor" strokeLinecap="round" />
      </svg>
    ),
  },
  {
    href: "/explorar",
    label: "Explorar",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6" strokeWidth={1.5}>
        <circle cx="12" cy="12" r="9" stroke="currentColor" />
        <path d="M16.5 7.5l-3 6-6 3 3-6 6-3z" stroke="currentColor" strokeLinejoin="round" />
        <circle cx="12" cy="12" r="1" fill="currentColor" />
      </svg>
    ),
  },
  {
    href: "/mas",
    label: "Más",
    icon: (
      <svg viewBox="0 0 24 24" fill="none" className="w-6 h-6">
        <circle cx="5" cy="12" r="1.5" fill="currentColor" />
        <circle cx="12" cy="12" r="1.5" fill="currentColor" />
        <circle cx="19" cy="12" r="1.5" fill="currentColor" />
      </svg>
    ),
  },
];

export default function BottomNav() {
  const pathname = usePathname();

  return (
    <nav
      className="safe-bottom flex-shrink-0"
      style={{ background: "#000000" }}
    >
      <div className="flex items-stretch h-[64px]">
        {tabs.map((tab) => {
          const isActive = tab.href === "/"
            ? pathname === "/"
            : pathname.startsWith(tab.href);

          return (
            <Link
              key={tab.href}
              href={tab.href}
              className="flex-1 flex flex-col items-center justify-center gap-1 transition-all duration-200"
              style={{
                background: isActive ? "#D42020" : "transparent",
                color: isActive ? "#FFFFFF" : "rgba(255,255,255,0.5)",
              }}
            >
              {tab.icon}
              <span
                className="text-[9px] font-mulish font-600 tracking-wide uppercase"
                style={{ fontFamily: "Mulish, sans-serif" }}
              >
                {tab.label}
              </span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
