import React, { useState } from "react";
import menuData from "../data/menuData.json";

const Sidebar = () => {
  const [openMenus, setOpenMenus] = useState({});

  const toggleMenu = (key) => {
    setOpenMenus((prev) => ({
      ...prev,
      [key]: !prev[key],
    }));
  };

  const handleMenuClick = (link) => {
    if (window.location.pathname === link) {
      window.location.href = link;
    } else {
      window.location.href = link;
    }
  };

  return (
    <aside id="layout-menu" className="layout-menu menu-vertical menu bg-menu-theme">
      <div className="app-brand demo d-flex align-items-center justify-content-center py-3">
        <a href="/dashboard" className="app-brand-link d-flex align-items-center text-decoration-none">
          <img src="/assets/img/logo/logo.png" alt="Logo" width={40} height={40} className="img-fluid rounded me-2" />
          <div className="text-start">
            <span className="demo menu-text fw-bold d-block" style={{ fontSize: "0.75rem" }}>
              Dinas Lingkungan Hidup
            </span>
            <span className="text-muted fw-semibold" style={{ fontSize: "0.75rem" }}>
              Toba
            </span>
          </div>
        </a>
      </div>

      <div className="menu-inner-shadow"></div>

      <ul className="menu-inner py-1 mt-3">
        {menuData.map((section, sectionIndex) => (
          <React.Fragment key={`section-${sectionIndex}`}>
            {section.header && <li className="menu-header small">{section.header}</li>}
            {section.items.map((item, itemIndex) => {
              const hasSubmenu = !!item.submenu;
              const key = `${sectionIndex}-${itemIndex}`;

              if (hasSubmenu) {
                return (
                  <li key={key} className={`menu-item ${openMenus[key] ? "open" : ""}`}>
                    <a
                      href="javascript:void(0)"
                      className="menu-link menu-toggle"
                      onClick={() => toggleMenu(key)}
                    >
                      <i className={`menu-icon ${item.icon}`}></i>
                      <div>{item.text}</div>
                    </a>
                    <ul className="menu-sub">
                      {item.submenu.map((sub, subIndex) => (
                        <li key={`submenu-${subIndex}`} className="menu-item">
                          <a
                            href={sub.link}
                            className="menu-link"
                            onClick={(e) => {
                              e.preventDefault();
                              handleMenuClick(sub.link);
                            }}
                          >
                            <div>{sub.text}</div>
                          </a>
                        </li>
                      ))}
                    </ul>
                  </li>
                );
              }

              return (
                <li key={key} className="menu-item">
                  <a
                    href={item.link}
                    onClick={(e) => {
                      e.preventDefault();
                      handleMenuClick(item.link);
                    }}
                    className="menu-link"
                  >
                    <i className={`menu-icon ${item.icon}`}></i>
                    <div>{item.text}</div>
                  </a>
                </li>
              );
            })}
          </React.Fragment>
        ))}
      </ul>
    </aside>
  );
};

export default Sidebar;
