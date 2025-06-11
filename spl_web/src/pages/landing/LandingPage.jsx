import React, { useEffect } from "react";
import Navbar from "./components/Navbar";
import Header from "./components/Header";
import HeroSection from "./components/HeroSection";
import FeaturesSection from "./components/FeaturesSection";
import DownloadSection from "./components/DownloadSection";
import Footer from "./components/Footer";

const LandingPage = () => {
  useEffect(() => {
    const link = document.createElement("link");
    link.rel = "stylesheet";
    link.href = "/landing.css";
    document.head.appendChild(link);
    return () => document.head.removeChild(link);
  }, []);

  return (
    <>
      <Navbar />
      <Header />
      <HeroSection />
      <FeaturesSection />
      <DownloadSection />
      <Footer />
    </>
  );
};

export default LandingPage;
