# Retail Sales & Discount Profitability Analysis

## Business Problem
Which product categories generate strong sales but weak profit, and where should discount policies be reviewed?

## Dataset & Tools
- Dataset: Sample Superstore (public dataset from Kaggle), 10,194 sales lines
- Tools: PostgreSQL, DBeaver
- Analysis: sales, profit, profit margin, discount groups, and region

## Key Findings
- Furniture generated 754,747.74 in sales but only 19,730.02 in profit.
- Tables lost 17,753.20 overall; Bookcases lost 3,632.07.
- Furniture sales lines with discounts above 20% had negative aggregate profit.
- Tables in the East region lost 11,086.15. Of its 85 sales lines, 82 had discounts above 20% and up to 40%, with a combined loss of 11,116.89.

## Recommendation
Review pricing, costs, and discount rules for Tables in the East region first. Evaluate the profitability of discounts above 20% before repeating similar promotions.

## Limitation
These are descriptive patterns. The dataset alone does not prove that discounts caused the losses.
