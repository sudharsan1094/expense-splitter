const express = require('express');
const router = express.Router();
const Expense = require('../models/Expense');

// Add an expense
router.post('/', async (req, res) => {
  try {
    const { groupId, description, amount, paidBy, splitAmong } = req.body;
    const expense = new Expense({ groupId, description, amount, paidBy, splitAmong });
    await expense.save();
    res.status(201).json(expense);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get all expenses for a group
router.get('/:groupId', async (req, res) => {
  try {
    const expenses = await Expense.find({ groupId: req.params.groupId });
    res.json(expenses);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Calculate balances for a group
router.get('/:groupId/balances', async (req, res) => {
  try {
    const expenses = await Expense.find({ groupId: req.params.groupId });

    const balances = {};

    expenses.forEach((expense) => {
      const { amount, paidBy, splitAmong } = expense;
      const share = amount / splitAmong.length;

      // Person who paid gets credited
      if (!balances[paidBy]) balances[paidBy] = 0;
      balances[paidBy] += amount;

      // Each person in splitAmong gets debited their share
      splitAmong.forEach((person) => {
        if (!balances[person]) balances[person] = 0;
        balances[person] -= share;
      });
    });

    // Round to 2 decimal places
    Object.keys(balances).forEach((person) => {
      balances[person] = parseFloat(balances[person].toFixed(2));
    });

    res.json(balances);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;