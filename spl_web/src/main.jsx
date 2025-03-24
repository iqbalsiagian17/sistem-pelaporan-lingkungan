import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';
import 'react-quill/dist/quill.snow.css';
import { BrowserRouter } from 'react-router-dom';
import { UserProvider } from "./context/UserContext";
import { ReportProvider  } from './context/ReportContext';
import { AnnouncementProvider } from './context/AnnouncementContext.jsx';
import { CarouselProvider } from './context/CarouselContext.jsx';


ReactDOM.createRoot(document.getElementById("root")).render(
  <BrowserRouter>
    <UserProvider>
      <ReportProvider >
        <AnnouncementProvider>
          <CarouselProvider>
            <App />
          </CarouselProvider>
        </AnnouncementProvider>
      </ReportProvider >
    </UserProvider>
  </BrowserRouter>
);
