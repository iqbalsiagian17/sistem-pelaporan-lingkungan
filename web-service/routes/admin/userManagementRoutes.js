const express = require("express");
const router = express.Router();
const userManagementController = require("../../controllers/admin/user/userManagementController");
const authMiddleware = require("../../middleware/authMiddleware");
const isAdmin = require("../../middleware/adminMiddleware"); 


// ✅ Admin Only
router.get("/", authMiddleware, isAdmin, userManagementController.getAllUsers);
router.get("/:id", authMiddleware, isAdmin, userManagementController.getUserById);
router.put("/:id", authMiddleware, isAdmin, userManagementController.updateUser);
router.delete("/:id", authMiddleware, isAdmin, userManagementController.deleteUser);

router.put("/block/:id", authMiddleware, isAdmin, userManagementController.blockUser);
router.put("/unblock/:id", authMiddleware, isAdmin, userManagementController.unblockUser);


module.exports = router;
