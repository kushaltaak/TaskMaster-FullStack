const express = require("express");

const {
  createTask,
  getTasks,
  updateTask,
  deleteTask,
  editTask,
} = require("../controllers/taskController");

const {
  protect,
} = require("../middleware/authMiddleware");

const router = express.Router();

// Create Task
router.post(
  "/",
  protect,
  createTask
);

// Get All Tasks
router.get(
  "/",
  protect,
  getTasks
);

// Toggle Complete Task
router.put(
  "/:id",
  protect,
  updateTask
);

// Edit Task
router.put(
  "/edit/:id",
  protect,
  editTask
);

// Delete Task
router.delete(
  "/:id",
  protect,
  deleteTask
);

module.exports = router;