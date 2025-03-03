require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/authRoutes');
const userInfoRoutes = require('./routes/userInfoRoutes'); 
const path = require("path");


const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());


// Routes
app.use('/api/auth', authRoutes);
app.use('/api/user/profile', userInfoRoutes); 

// Serve static assets if in production
app.use("/uploads", express.static("uploads"));


app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
