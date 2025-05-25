const getFullImageUrl = (path) => {
    if (!path) return "";
    return path.startsWith("http") ? path : `https://baligebersih.site${path.startsWith("/") ? path : `/${path}`}`;
};

export default getFullImageUrl;
