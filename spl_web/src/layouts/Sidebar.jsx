import React from "react";
import { NavLink } from "react-router-dom";
import menuData from "../data/menuData.json"; // Pastikan ini mengarah ke menu yang benar

const Sidebar = () => {
    return (
        <aside id="layout-menu" className="layout-menu menu-vertical menu bg-menu-theme">
            <div className="app-brand demo d-flex align-items-center justify-content-center py-3">
                <NavLink to="/" className="app-brand-link d-flex align-items-center text-decoration-none">
                    {/* Logo dengan Shadow dan Border Radius */}
                    <img 
                        src="/assets/img/icons/brands/logo.png" 
                        alt="Logo Dinas Lingkungan Hidup" 
                        className="img-fluid rounded shadow-sm me-2" 
                        width={40}
                        height={40}
                    />

                    {/* Teks dengan Styling */}
                    <div className="text-start">
                        <span className=" demo menu-text fw-bold d-block" style={{ fontSize: "0.7rem" }}>
                            Dinas Lingkungan Hidup
                        </span>
                        <span className="text-muted fw-semibold" style={{ fontSize: "0.9rem" }}>
                            Toba
                        </span>
                    </div>
                </NavLink>
            </div>

            <div className="menu-inner-shadow"></div>

            <ul className="menu-inner py-1">
                {menuData.map((section, sectionIndex) => (
                    <React.Fragment key={`section-${sectionIndex}`}>
                        {section.header && <li className="menu-header small" key={`header-${sectionIndex}`}>{section.header}</li>}
                        {section.items.map((item, itemIndex) => (
                            <li key={`menu-${sectionIndex}-${itemIndex}`} className="menu-item">
                                <NavLink to={item.link} className="menu-link">
                                    <i className={`menu-icon ${item.icon}`}></i>
                                    <div>{item.text}</div>
                                </NavLink>
                            </li>
                        ))}
                    </React.Fragment>
                ))}
            </ul>
        </aside>
    );
};

export default Sidebar;
