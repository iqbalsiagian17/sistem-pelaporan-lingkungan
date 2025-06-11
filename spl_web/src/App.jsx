import { useLocation } from "react-router-dom";
import Layout from "./layouts/Layout";
import AppRoutes from "./router/AppRoutes";
import { Blank } from "./layouts/Blank";
import { ToastContainer } from "react-toastify"; // ⬅️ import ToastContainer
import "react-toastify/dist/ReactToastify.css";  // ⬅️ import styling toast

function App() {
  const location = useLocation();
  const isAuthPath =   location.pathname === "/" || location.pathname === "/login" || location.pathname.includes("error") || location.pathname.includes("under-maintenance") || location.pathname.includes("blank");

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

      {/* ✅ Tambahkan ToastContainer agar toast bisa digunakan global */}
    </>
  );
}

export default App;
