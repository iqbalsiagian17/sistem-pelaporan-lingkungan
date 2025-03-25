import React from "react";
import menuData from "../data/menuData.json";

const Sidebar = () => {
    const handleMenuClick = (link) => {
        if (window.location.pathname === link) {
            // Reload halaman jika sudah di halaman tersebut
            window.location.href = link;
        } else {
            // Navigasi biasa dengan reload
            window.location.href = link;
        }
    };

    return (
        <aside id="layout-menu" className="layout-menu menu-vertical menu bg-menu-theme">
            <div className="app-brand demo d-flex align-items-center justify-content-center py-3">
                <a href="/" className="app-brand-link d-flex align-items-center text-decoration-none">
                    <img 
                        src="/assets/img/logo/logo.png" 
                        alt="Logo Dinas Lingkungan Hidup" 
                        className="img-fluid rounded shadow-sm me-2" 
                        width={40}
                        height={40}
                    />
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
                        {section.items.map((item, itemIndex) => (
                            <li key={`menu-${sectionIndex}-${itemIndex}`} className="menu-item">
                                <a
                                    href={item.link}
                                    onClick={(e) => {
                                        e.preventDefault(); // Mencegah default behavior dulu
                                        handleMenuClick(item.link);
                                    }}
                                    className="menu-link"
                                >
                                    <i className={`menu-icon ${item.icon}`}></i>
                                    <div>{item.text}</div>
                                </a>
                            </li>
                        ))}
                    </React.Fragment>
                ))}
            </ul>
        </aside>
    );
};

export default Sidebar;
