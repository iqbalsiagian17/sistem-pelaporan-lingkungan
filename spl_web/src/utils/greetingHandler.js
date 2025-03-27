// greetingHandler.js

const getGreetingMessage = (name) => {
    const currentTime = new Date();
    const currentHour = currentTime.getHours();

    let greeting;

    if (currentHour >= 5 && currentHour < 12) {
        greeting = 'Selamat Pagi ';
    } else if (currentHour >= 12 && currentHour < 18) {
        greeting = 'Selamat Siang';
    } else {
        greeting = 'Selamat Malam';
    }

    return `Hello ${name}, ${greeting}!`;
};

export default getGreetingMessage;
