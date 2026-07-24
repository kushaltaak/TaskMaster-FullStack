const mongoose = require("mongoose");

const taskSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },

    title: {
      type: String,
      required: true,
    },

    completed: {
      type: Boolean,
      default: false,
    },

    category: {
      type: String,
      default: "Personal",
    },

    dueDate: {
      type: String,
      default: "No Date",
    },
  },
  {
    timestamps: true,
  }
);

module.exports =
  mongoose.models.Task ||
  mongoose.model("Task", taskSchema);