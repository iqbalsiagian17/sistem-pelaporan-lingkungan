import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App.jsx';
import 'react-quill/dist/quill.snow.css';
import "leaflet/dist/leaflet.css";
import "leaflet-draw/dist/leaflet.draw.css";
import { BrowserRouter } from 'react-router-dom';

import { UserProvider } from "./context/UserContext";
import { ReportProvider } from './context/ReportContext';
import { AnnouncementProvider } from './context/AnnouncementContext.jsx';
import { MediaCarouselProvider } from './context/MediaCarouselContext.jsx';
import { ParameterProvider } from './context/ParameterContext.jsx';
import { ModalProvider } from './context/ModalContext.jsx';
import { PostProvider } from './context/PostContext.jsx'; 
import { VillageProvider } from './context/VillageContext.jsx';

ReactDOM.createRoot(document.getElementById("root")).render(
  <BrowserRouter>
    <UserProvider>
      <ReportProvider>
        <AnnouncementProvider>
          <MediaCarouselProvider>
            <ParameterProvider>
              <ModalProvider>
                <PostProvider>
                  <VillageProvider>
                    <App />
                  </VillageProvider>
                </PostProvider>
              </ModalProvider>
            </ParameterProvider>
          </MediaCarouselProvider>
        </AnnouncementProvider>
      </ReportProvider>
    </UserProvider>
  </BrowserRouter>
);
