import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  
  title: "JournalMax🗒️",
  description: "The Github Pages for JournalMax, the open-source journaling app for android",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <link rel="icon" href="./favicon.ico" sizes="any"/>
      <body>
        {children}
      </body>
    </html>
  );
}
