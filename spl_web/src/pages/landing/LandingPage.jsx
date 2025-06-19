import { useState, useEffect } from "react";
import Navbar from "./components/Navbar";
import Header from "./components/Header";
import FeaturesSection from "./components/FeaturesSection";
import DownloadSection from "./components/DownloadSection";
import Footer from "./components/Footer";

const LandingPage = () => {
  const [parameter, setParameter] = useState(null);

  useEffect(() => {
    const link = document.createElement("link");
    link.rel = "stylesheet";
    link.href = "/landing.css";
    document.head.appendChild(link);
    return () => document.head.removeChild(link);
  }, []);

  useEffect(() => {
    const fetchParameter = async () => {
      try {
        const res = await fetch("http://localhost:3000/api/parameters");
        const json = await res.json();
        setParameter(json.data);
      } catch (err) {
        console.error("❌ Gagal mengambil parameter:", err);
      }
    };
    fetchParameter();
  }, []);

  return (
    <>
      <Navbar />
      <Header parameter={parameter} />
      <FeaturesSection parameter={parameter} />
      <DownloadSection />
      <Footer />
    </>
  );
};

export default LandingPage;
