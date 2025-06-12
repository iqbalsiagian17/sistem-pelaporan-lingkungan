import { useLocation } from "react-router-dom";
import Layout from "./layouts/Layout";
import AppRoutes from "./router/AppRoutes";
import { Blank } from "./layouts/Blank";
import { ToastContainer } from "react-toastify"; // ✅ ToastContainer
import "react-toastify/dist/ReactToastify.css";

function App() {
  const location = useLocation();
  const isAuthPath =
    location.pathname === "/" ||
    location.pathname === "/login" ||
    location.pathname.includes("error") ||
    location.pathname.includes("under-maintenance") ||
    location.pathname.includes("blank");

  return (
    <>
      {isAuthPath ? (
        <AppRoutes>
          <Blank />
        </AppRoutes>
      ) : (
        <Layout>
          <AppRoutes />
        </Layout>
      )}

      {/* ✅ Tambahkan di sini agar toast bisa digunakan di mana saja */}
      <ToastContainer position="top-center" autoClose={3000} />
    </>
  );
}

export default App;
