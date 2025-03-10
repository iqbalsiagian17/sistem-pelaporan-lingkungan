const getFullImageUrl = (path) => {
    if (!path) return "";
    return path.startsWith("http") ? path : `http://localhost:3000${path.startsWith("/") ? path : `/${path}`}`;
};

export default getFullImageUrl;
