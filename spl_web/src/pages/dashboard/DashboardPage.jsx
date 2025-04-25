import { useEffect, useState, useMemo } from "react";
import { fetchOverview } from "../../services/analyticsService";
import { getAllReports } from "../../services/reportService";
import { getAllUsers } from "../../services/userService";
import { renderDashboardChart } from "../../utils/dashboardChart";
import { renderGrowthChart } from "../../utils/growthChart";
import statusData from "../../data/statusData.json";

// Import Komponen
import WelcomeCard from "./components/WelcomeCard";
import CompletionCard from "./components/CompletionCard";
import InProgressCard from "./components/InProgressCard";
import ChartCard from "./components/ChartCard";
import TopLikedReports from "./components/TopLikedReports";
import LatestReportsTable from "./components/LatestReportsTable";
import LatestUsersTable from "./components/LatestUsersTable";
import DetailLaporanModal from "../laporan/components/DetailLaporanModal";

export const DashboardPage = () => {
  const [overview, setOverview] = useState(null);
  const [loading, setLoading] = useState(true);
  const [latestReports, setLatestReports] = useState([]);
  const [latestUsers, setLatestUsers] = useState([]);
  const [allReports, setAllReports] = useState([]);
  const [filter, setFilter] = useState("all");

  const [showDetailModal, setShowDetailModal] = useState(false);
  const [selectedReport, setSelectedReport] = useState(null);
  const [showUserDetailModal, setShowUserDetailModal] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);


  const filteredTopReports = useMemo(() => {
    if (!allReports.length) return [];
    return allReports
      .filter((report) => {
        if (filter === "completed") {
          return report.status === "completed" || report.status === "closed";
        }
        if (filter === "ongoing") {
          return report.status === "verified" || report.status === "in_progress";
        }
        return true;
      })
      .sort((a, b) => (b.total_likes || 0) - (a.total_likes || 0))
      .slice(0, 5);
  }, [allReports, filter]);

  const translateStatus = (status) => {
    return statusData.statusTranslations[status] || status;
  };
  
  const getStatusColor = (status) => {
    return statusData.statusMappings[status]?.color || "secondary";
  };
  
  const handleOpenDetailModal = (report) => {
    setSelectedReport(report);
    setShowDetailModal(true);
  };

  const handleCloseDetailModal = () => {
    setSelectedReport(null);
    setShowDetailModal(false);
  };

  const handleOpenUserDetailModal = (user) => {
    setSelectedUser(user);
    setShowUserDetailModal(true);
  };
  
  const handleCloseUserDetailModal = () => {
    setSelectedUser(null);
    setShowUserDetailModal(false);
  };

  useEffect(() => {
    const loadAnalytics = async () => {
      try {
        const data = await fetchOverview();
        const reports = await getAllReports();
        const users = await getAllUsers();

        setAllReports(reports);
        setLatestReports(reports.slice(0, 5));
        setLatestUsers(users.slice(0, 5));
        setOverview(data);
      } catch (error) {
        console.error("Failed to load analytics data:", error);
      } finally {
        setLoading(false);
      }
    };
    loadAnalytics();
  }, []);

  useEffect(() => {
    if (overview && allReports.length > 0) {
      renderDashboardChart(overview);
  
      const processedReports = allReports.filter((report) =>
        ["in_progress", "completed", "closed"].includes(report.status)
      ).length;
  
      const unprocessedReports = allReports.filter((report) =>
        ["pending", "verified"].includes(report.status)
      ).length;
  
      const totalValidReports = processedReports + unprocessedReports;
  
      const progress = totalValidReports > 0
        ? Math.round((processedReports / totalValidReports) * 100)
        : 0;
  
      renderGrowthChart(progress);
    }
  }, [overview, allReports]);
  

  if (loading) return <div>Loading...</div>;
  if (!overview) return <div>Gagal memuat data analitik.</div>;

  const { totalReports, completedReports, inProgressReports } = overview;

  return (
    <>
      <div className="row">
        <div className="col-lg-8 mb-4 order-1">
          <WelcomeCard totalReports={totalReports} />
        </div>

        <div className="col-lg-4 col-md-4 order-1">
          <div className="row">
            <div className="col-lg-6 col-md-12 col-6 mb-4">
              <CompletionCard completedReports={completedReports} completionRate={overview.completionRate} />
            </div>
            <div className="col-lg-6 col-md-12 col-6 mb-4">
              <InProgressCard inProgressReports={inProgressReports} />
            </div>
          </div>
        </div>

        <div className="col-12 col-lg-8 order-2 order-md-3 order-lg-2 mb-4">
          <ChartCard allReports={allReports} />
        </div>

        <div className="col-12 col-md-8 col-lg-4 order-3 order-md-2">
          <TopLikedReports
            filteredTopReports={filteredTopReports}
            filter={filter}
            setFilter={setFilter}
            translateStatus={translateStatus}
            getStatusColor={getStatusColor}
            handleOpenDetailModal={handleOpenDetailModal}
          />
        </div>
      </div>

      <div className="row mt-4">
        <div className="col-md-6 col-12 mb-4">
          <LatestReportsTable 
            latestReports={latestReports} 
          handleOpenDetailModal={handleOpenDetailModal} 
        />
        </div>
        <div className="col-md-6 col-12 mb-4">
          <LatestUsersTable latestUsers={latestUsers} />
        </div>
      </div>

      {/* Modal Detail */}
      <DetailLaporanModal
        show={showDetailModal}
        onHide={handleCloseDetailModal}
        report={selectedReport}
      />
    </>
  );
};
