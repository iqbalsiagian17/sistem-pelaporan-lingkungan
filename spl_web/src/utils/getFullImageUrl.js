const getFullImageUrl = (path) => {
    if (!path) return "";
    return path.startsWith("http") ? path : `http://69.62.82.58:3000${path.startsWith("/") ? path : `/${path}`}`;
};

export default getFullImageUrl;
